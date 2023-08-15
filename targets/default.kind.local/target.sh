#!/usr/bin/env bash

export K8KREATOR_TOOLS=("kind=0.20.0" "kubectl=1.27.4" "helm=3.12.3")

k8kreator-cluster-create-target() {
    local name=${K8KREATOR_TARGET}
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Creating cluster $1"
    kind create cluster --name=$name --config=cluster.yaml
}

k8kreator-cluster-delete-target() {
    local name=${K8KREATOR_TARGET}
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Deleting cluster $1"
    kind delete clusters $1
}

# End of file