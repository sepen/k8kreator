#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-kubernetes-dashboard() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-kubernetes-dashboard $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-kubernetes-dashboard $@
}

k8kreator-addons-update-kubernetes-dashboard() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-kubernetes-dashboard $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} upgrade kubernetes-dashboard kubernetes-dashboard \
    --repo https://kubernetes.github.io/dashboard/ \
    --version ${addon_version} \
    --create-namespace --namespace kubernetes-dashboard \
    --install --atomic --cleanup-on-fail \
    -f ${K8KREATOR_SRCDIR}/addons/kubernetes-dashboard/values.yaml
}

k8kreator-addons-uninstall-kubernetes-dashboard() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-kubernetes-dashboard $@ (${K8KREATOR_TARGET})"
  local addon_version=$1
  ${HELM_COMMAND} uninstall kubernetes-dashboard \
    --namespace kubernetes-dashboard
}

# End of file
