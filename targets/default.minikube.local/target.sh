#!/usr/bin/env bash

export K8KREATOR_TOOLS=("minikube=1.31.2" "kubectl=1.28.1" "helm=3.12.3")

echo ${K8KREATOR_TOOLS[1]##*=}

k8kreator-cluster-create-target() {
    local name=${K8KREATOR_TARGET}
    local config=${K8KREATOR_HOME}/src/targets/${K8KREATOR_TARGET}/cluster.yaml
    local kversion=${K8KREATOR_TOOLS[1]##*=}
    k8kreator-check-deps "minikube"
    k8kreator-msg-info "Creating cluster $name"
    minikube start --kubernetes-version="v${kversion}" --dns-domain="${name}" --keep-context=true
}

k8kreator-cluster-delete-target() {
    local name=${K8KREATOR_TARGET}
    k8kreator-check-deps "minikube"
    k8kreator-msg-info "Deleting cluster $name"
    minikube delete
}

# End of file
