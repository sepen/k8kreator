#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-kube-prometheus-stack() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-kube-prometheus-stack $@ (${K8KREATOR_TARGET})"
  k8kreator-addons-update-kube-prometheus-stack $@
}

k8kreator-addons-update-kube-prometheus-stack() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-kube-prometheus-stack"
  local addon_version=$1
  ${HELM_COMMAND} upgrade kube-prometheus-stack kube-prometheus-stack \
    --repo https://prometheus-community.github.io/helm-charts \
    --version ${addon_version} \
    --create-namespace --namespace monitoring \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/kube-prometheus-stack/values.yaml \
    --set "grafana.ingress.hosts[0]=grafana.${K8KREATOR_TARGET}" \
    --set "prometheus.ingress.hosts[0]=prometheus.${K8KREATOR_TARGET}" \
    --set "alertmanager.ingress.hosts[0]=alertmanager.${K8KREATOR_TARGET}"
}

k8kreator-addons-uninstall-kube-prometheus-stack() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-kube-prometheus-stack"
  local addon_version=$1
  ${HELM_COMMAND} uninstall kube-prometheus-stack \
    --namespace monitoring
}

# End of file
