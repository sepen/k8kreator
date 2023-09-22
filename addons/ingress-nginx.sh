#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-ingress-nginx() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-ingress-nginx $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-ingress-nginx $@
}

k8kreator-addons-update-ingress-nginx() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-ingress-nginx $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} upgrade ingress-nginx ingress-nginx ${HELM_COMMAND_OPTS} \
    --repo https://kubernetes.github.io/ingress-nginx \
    --version ${addon_version} \
    --create-namespace --namespace ingress-nginx \
    --install --atomic --cleanup-on-fail \
    -f ${K8KREATOR_SRCDIR}/addons/ingress-nginx/values.yaml
}

k8kreator-addons-uninstall-ingress-nginx() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-ingress-nginx $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} uninstall ingress-nginx \
    --namespace ingress-nginx
}

# End of file
