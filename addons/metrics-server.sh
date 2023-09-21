#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")
HELM_COMMAND_OPTS="--atomic --cleanup-on-fail"

k8kreator-addons-install-metrics-server() {
  local addon_version=$1
  ${HELM_COMMAND} install metrics-server metrics-server ${HELM_COMMAND_OPTS} \
    --repo https://kubernetes-sigs.github.io/metrics-server \
    --version ${addon_version} \
    --create-namespace --namespace kube-system \
    -f ${K8KREATOR_HOME}/src/addons/metrics-server/values.yaml
}

k8kreator-addons-update-metrics-server() {
  local addon_version=$1
  ${HELM_COMMAND} upgrade metrics-server metrics-server ${HELM_COMMAND_OPTS} \
    --repo https://kubernetes-sigs.github.io/metrics-server \
    --version ${addon_version} \
    --create-namespace --namespace kube-system \
    -f ${K8KREATOR_HOME}/src/addons/metrics-server/values.yaml
}

k8kreator-addons-uninstall-metrics-server() {
  local addon_version=$1
  ${HELM_COMMAND} uninstall metrics-server metrics-server \
    --namespace kube-system
}

# End of file