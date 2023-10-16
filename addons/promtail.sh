#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-promtail() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-promtail $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-promtail $@
}

k8kreator-addons-update-promtail() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-promtail"
  local addon_version=$1
  ${HELM_COMMAND} upgrade promtail promtail \
    --repo https://grafana.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_SRCDIR}/addons/promtail/values.yaml  
}

k8kreator-addons-uninstall-promtail() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-promtail"
  local addon_version=$1
  ${HELM_COMMAND} uninstall promtail \
    --namespace monitoring
}

# End of file
