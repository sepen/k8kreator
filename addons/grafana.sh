#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-grafana() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-grafana $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-grafana $@
}

k8kreator-addons-update-grafana() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-grafana"
  local addon_version=$1
  ${HELM_COMMAND} upgrade grafana grafana \
    --repo https://grafana.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/grafana/values.yaml \
    --set "ingress.hosts={grafana.${K8KREATOR_TARGET}}"
}

k8kreator-addons-uninstall-grafana() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-grafana"
  local addon_version=$1
  ${HELM_COMMAND} uninstall grafana \
    --namespace monitoring
}

# End of file
