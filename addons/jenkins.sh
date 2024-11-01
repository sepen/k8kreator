#!/usr/bin/env bash

HELM_COMMAND=$(k8kreator-get-tool-command "helm")

k8kreator-addons-install-jenkins() {
  k8kreator-addons-update-jenkins $@
}

k8kreator-addons-update-jenkins() {
  local addon_version=$1
  ${HELM_COMMAND} upgrade jenkins jenkins \
    --repo https://charts.jenkins.io \
    --version ${addon_version} \
    --create-namespace --namespace jenkins \
    --install --atomic --cleanup-on-fail \
    --values ${K8KREATOR_ADDONSDIR}/jenkins/values.yaml \
    --set controller.ingress.hostName="jenkins.${K8KREATOR_TARGET}"
}

k8kreator-addons-uninstall-jenkins() {
  local addon_version=$1
  ${HELM_COMMAND} uninstall jenkins \
    --namespace jenkins
}

# End of file
