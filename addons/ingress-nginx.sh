#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

pre-install() {
  # TODO: check if addons dep is installed (e.g: k8kreator-addons-isinst "metallb")
  k8kreator-msg-info "IMPORTANT: addon metallb is a dependency for ingress-nginx"
  k8kreator-msg-info "This is so because ingress-nginx service of type LoadBalancer"
}

k8kreator-addons-install-ingress-nginx() {
  k8kreator-addons-update-ingress-nginx $@
}

k8kreator-addons-update-ingress-nginx() {
  local addon_version=$1
  pre-install
  ${HELM_COMMAND} upgrade ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --version ${addon_version} \
    --create-namespace --namespace ingress-nginx \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/ingress-nginx/values.yaml
}

k8kreator-addons-uninstall-ingress-nginx() {
  local addon_version=$1
  ${HELM_COMMAND} uninstall ingress-nginx \
    --namespace ingress-nginx
}

# End of file
