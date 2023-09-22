#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")
KUBECTL_COMMAND=$(k8kreator-get-tool-command "kubectl")

pre-install() {
  k8kreator-check-deps "sed"
  # If you are using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode.
  ${KUBECTL_COMMAND} get configmap kube-proxy -n kube-system -o yaml \
  | sed -e 's/strictARP: false/strictARP: true/' \
  | ${KUBECTL_COMMAND} apply -f - -n kube-system
}

post-install() {
  # MetalLB requires a pool of IP addresses in order to be able to take ownership of the ingress-nginx Service.
  # This pool can be defined through IPAddressPool objects in the same namespace as the MetalLB controller.
  # This pool of IPs must be dedicated to MetalLB's use, you can't reuse the Kubernetes node IPs or IPs handed out by a DHCP server.
  ${KUBECTL_COMMAND} apply -f ${K8KREATOR_SRCDIR}/addons/metallb/${K8KREATOR_TARGET}/ip-address-pool.yaml
  ${KUBECTL_COMMAND} delete pods,services --all -n metallb-system
  sleep 5
}

k8kreator-addons-install-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-metallb $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  pre-install
  ${HELM_COMMAND} install metallb metallb \
    --repo https://kubernetes-sigs.github.io/metallb \
    --version ${addon_version} \
    --create-namespace --namespace kube-system \
    -f ${K8KREATOR_SRCDIR}/addons/metallb/values.yaml
  post-install
}

k8kreator-addons-update-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-metallb $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  pre-install
  ${HELM_COMMAND} upgrade metallb metallb \
    --repo https://kubernetes-sigs.github.io/metallb \
    --version ${addon_version} \
    --create-namespace --namespace kube-system \
    --atomic --cleanup-on-fail \
    -f ${K8KREATOR_SRCDIR}/addons/metallb/values.yaml
  post-install
}

k8kreator-addons-uninstall-metallb() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-metallb $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} uninstall metallb \
    --namespace kube-system
}

# End of file
