#!/usr/bin/env bash

MINIKUBE_COMMAND=$(k8kreator-get-tool-command "minikube")
KUBERNETES_VERSION="v1.30.0"

k8kreator-cluster-create-target() {
  k8kreator-check-deps ${MINIKUBE_COMMAND}
  ${MINIKUBE_COMMAND} start \
    --kubernetes-version="${KUBERNETES_VERSION}" \
    --dns-domain="${K8KREATOR_TARGET}" \
    --extra-config="kubelet.cluster-domain=${K8KREATOR_TARGET}" \
    --keep-context=false
}

k8kreator-cluster-delete-target() {
  k8kreator-check-deps ${MINIKUBE_COMMAND}
  ${MINIKUBE_COMMAND} delete
}

# End of file
