#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-tempo() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-tempo $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-tempo $@
}

k8kreator-addons-update-tempo() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-tempo"
  local addon_version=$1
  ${HELM_COMMAND} upgrade tempo tempo \
    --repo https://grafana.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/tempo/values.yaml  
}

k8kreator-addons-uninstall-tempo() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-tempo"
  local addon_version=$1
  ${HELM_COMMAND} uninstall tempo \
    --namespace monitoring
}

# End of file
