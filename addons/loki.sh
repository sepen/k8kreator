#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-loki() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-loki $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-loki $@
}

k8kreator-addons-update-loki() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-loki"
  local addon_version=$1
  ${HELM_COMMAND} upgrade loki loki \
    --repo https://grafana.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_SRCDIR}/addons/loki/values.yaml \
    --set "ingress.hosts={loki.${K8KREATOR_TARGET}}" \
    --set "gateway.ingress.hosts[0].host=gateway.loki.${K8KREATOR_TARGET}"
}

k8kreator-addons-uninstall-loki() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-loki"
  local addon_version=$1
  ${HELM_COMMAND} uninstall loki \
    --namespace monitoring
}

# End of file
