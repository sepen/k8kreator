#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-prometheus() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-prometheus $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-prometheus $@
}

k8kreator-addons-update-prometheus() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-prometheus"
  local addon_version=$1
  ${HELM_COMMAND} upgrade prometheus prometheus \
    --repo https://prometheus-community.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_SRCDIR}/addons/prometheus/values.yaml \
    --set "server.ingress.hosts={prometheus.${K8KREATOR_TARGET}}" \
    --set "alertmanager.ingress.hosts[0].host=alertmanager.${K8KREATOR_TARGET}" \
    --set "alertmanager.ingress.hosts[0].paths[0].path=/" \
    --set "alertmanager.ingress.hosts[0].paths[0].pathType=ImplementationSpecific"
}

k8kreator-addons-uninstall-prometheus() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-prometheus"
  local addon_version=$1
  ${HELM_COMMAND} uninstall prometheus \
    --namespace monitoring
}

# End of file
