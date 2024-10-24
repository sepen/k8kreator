#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")
KUBECTL_COMMAND=$(k8kreator-get-tool-command "kubectl")

pre-install() {
  k8kreator-check-deps "sed"
  # If you are using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode.
  if ${KUBECTL_COMMAND} get configmap kube-proxy -n kube-system >/dev/null 2>&1; then
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
  local base_ip_addr="172.18.0.1"
  case ${K8KREATOR_ENGINE} in
    kind)
      k8kreator-check-deps "docker" "sed"
      base_ip_addr=$(docker network inspect kind -f '{{range .IPAM.Config}}{{.Gateway}} {{end}}' 2>/dev/null | tr ' ' '\n' | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
      ;;
    k3d)
      k8kreator-check-deps "docker" "sed"
      base_ip_addr=$(docker network inspect k3d-${K8KREATOR_TARGET} -f '{{range .IPAM.Config}}{{.Gateway}} {{end}}' 2>/dev/null | tr ' ' '\n' | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
      ;;
    minikube)
      minikube_command=$(k8kreator-get-tool-command "minikube")
      base_ip_addr=$(${minikube_command} ip 2>/dev/null)
      ;;
  esac

  # We use a static range of IP addresses
  ingress_first_addr=$(echo "${base_ip_addr%.*}.2")
  ingress_last_addr=$(echo "${base_ip_addr%.*}.255")
  k8kreator-msg-debug "MetalLB ingress address range: $ingress_first_addr-$ingress_last_addr"

  # Delete previous resources
  ${KUBECTL_COMMAND} delete ipaddresspools.metallb.io,l2advertisements.metallb.io --all -n metallb-system

  # Configure metallb ingress address range
  cat << __YAML__ | ${KUBECTL_COMMAND} apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - $ingress_first_addr-$ingress_last_addr
  autoAssign: true
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
spec:
  ipAddressPools:
  - default-pool
__YAML__

  # After creating the previous objects, MetalLB takes ownership of one of the IP addresses in the pool and updates
  # the *loadBalancer* IP field of the `ingress-nginx` Service accordingly.
  ${KUBECTL_COMMAND} delete pods,services --all -n metallb-system
  # Give enough time to new pods
  for pod in \
    $(${KUBECTL_COMMAND} get po -n metallb-system -l 'app.kubernetes.io/component=controller' -o name) \
    $(${KUBECTL_COMMAND} get po -n metallb-system -l 'app.kubernetes.io/component=speaker' -o name); do
    k8kreator-msg-debug "Waiting for ${pod} to be ready"
    ${KUBECTL_COMMAND} wait -n metallb-system --for=condition=Ready ${pod} --timeout=60s
  done

  # Check ingress-nginx service of type LoadBalancer
  case $(${KUBECTL_COMMAND} get svc -n ingress-nginx ingress-nginx-controller -o "jsonpath={.spec.type}" 2>/dev/null) in
    "LoadBalancer")
      k8kreator-msg-info "IMPORTANT: An ingress-nginx service of type LoadBalancer has been detected."
      k8kreator-msg-info "You may need to update this service for metallb changes to work properly."
      ;;
  esac
}

k8kreator-addons-install-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-metallb"
  # Helm install and upgrade are bassically the same. It just require some helm flags like -i
  k8kreator-addons-update-metallb $@
}

k8kreator-addons-update-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-metallb"
  local addon_version=$1
  pre-install
  ${HELM_COMMAND} upgrade metallb metallb \
    --repo https://metallb.github.io/metallb \
    --version ${addon_version} \
    --create-namespace --namespace metallb-system \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/metallb/values.yaml
  post-install
}

k8kreator-addons-uninstall-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-metallb"
  local addon_version=$1
  ${HELM_COMMAND} uninstall metallb \
    --namespace metallb-system
}

# End of file
