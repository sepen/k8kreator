#!/usr/bin/env bash

export K8KREATOR_TOOLS=("minikube=1.31.2" "kubectl=1.28.1" "helm=3.12.3")

k8kreator-cluster-create-target() {
  local name=${K8KREATOR_TARGET}
  local config=${K8KREATOR_HOME}/src/targets/${K8KREATOR_TARGET}/cluster.yaml
  local minikube_version=${K8KREATOR_TOOLS[0]##*=}
  k8kreator-check-deps "minikube-${minikube_version}"
  k8kreator-msg-info "Creating cluster $name"
  minikube-${minikube_version} start \
    --kubernetes-version="v1.26.8" \
    --dns-domain="${name}" \
    --keep-context=true
}

k8kreator-cluster-delete-target() {
  local name=${K8KREATOR_TARGET}
  k8kreator-check-deps "minikube-${minikube_version}"
  k8kreator-msg-info "Deleting cluster $name"
  minikube-${minikube_version} delete
}

# End of file
