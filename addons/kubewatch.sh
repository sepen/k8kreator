#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-kubewatch() {
  k8kreator-msg-debug "Running function k8kreator-addons-install-kubewatch"
  k8kreator-addons-update-kubewatch $@
}

k8kreator-addons-update-kubewatch() {
  k8kreator-msg-debug "Running function k8kreator-addons-update-kubewatch"
  local addon_version=$1
  ${HELM_COMMAND} upgrade kubewatch kubewatch \
    --repo https://robusta-charts.storage.googleapis.com \
    --version ${addon_version} \
    --create-namespace --namespace kubewatch \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/kubewatch/values.yaml
}

k8kreator-addons-uninstall-kubewatch() {
  k8kreator-msg-debug "Running function k8kreator-addons-uninstall-kubewatch"
  local addon_version=$1
  ${HELM_COMMAND} uninstall kubewatch \
    --namespace kubewatch
}

# End of file
