#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")
KUBECTL_COMMAND=$(k8kreator-get-tool-command "kubectl")

pre-install() {
  k8kreator-check-deps "sed"
  # If you are using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode.
  if ${KUBECTL_COMMAND} get configmap kube-proxy -n kube-system 2>/dev/null; then
    ${KUBECTL_COMMAND} get configmap kube-proxy -n kube-system -o yaml \
    | sed -e 's/strictARP: false/strictARP: true/' \
    | ${KUBECTL_COMMAND} apply -f - -n kube-system
  fi
}

post-install() {
  # MetalLB requires a pool of IP addresses in order to be able to take ownership of the ingress-nginx Service.
  # This pool can be defined through IPAddressPool objects in the same namespace as the MetalLB controller.
  # This pool of IPs must be dedicated to MetalLB's use, you can't reuse the Kubernetes node IPs or IPs handed out by a DHCP server.

  # Determine load balancer ingress range depending on the engine in use
  case ${K8KREATOR_ENGINE} in
    kind)
      k8kreator-check-deps "docker" "sed"
      base_ip_addr=$(docker network inspect -f '{{range .IPAM.Config}}{{.Subnet}} {{end}}' kind 2>/dev/null | sed 's|/.*||g')
      ;;
    k3d)
      k8kreator-check-deps "docker" "sed"
      base_ip_addr=$(docker network inspect -f '{{range .IPAM.Config}}{{.Subnet}} {{end}}' k3d-${K8KREATOR_TARGET} 2>/dev/null | sed 's|/.*||g')
      ;;
    minikube)
      minikube_command=$(k8kreator-get-tool-command "minikube")
      base_ip_addr=$(${minikube_command} ip 2>/dev/null)
      ;;
  esac

  # We use a static range of 50 address (from .100 to .150)
  ingress_first_addr=$(echo "${base_ip_addr%.*}.100")
  ingress_last_addr=$(echo "${base_ip_addr%.*}.150")
  k8kreator-msg-debug "MetalLB ingress address range: $ingress_first_addr-$ingress_last_addr"

  # Configure metallb ingress address range
  cat << __YAML__ | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $ingress_first_addr-$ingress_last_addr
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default
__YAML__

  # After creating the previous objects, MetalLB takes ownership of one of the IP addresses in the pool and updates
  # the *loadBalancer* IP field of the `ingress-nginx` Service accordingly.
  ${KUBECTL_COMMAND} delete pods,services --all -n metallb-system
  sleep 5
}

k8kreator-addons-install-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-metallb $@ (${K8KREATOR_TARGET})"
  # Helm install and upgrade are bassically the same. It just require some helm flags like -i
  k8kreator-addons-update-metallb $@
}

k8kreator-addons-update-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-metallb $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  pre-install
  ${HELM_COMMAND} upgrade metallb metallb \
    --repo https://metallb.github.io/metallb \
    --version ${addon_version} \
    --create-namespace --namespace metallb-system \
    --install --atomic --cleanup-on-fail \
    -f ${K8KREATOR_SRCDIR}/addons/metallb/values.yaml
  post-install
}

k8kreator-addons-uninstall-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-metallb $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} uninstall metallb \
    --namespace metallb-system
}

# End of file
