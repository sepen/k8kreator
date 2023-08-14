#!/usr/bin/env bash

export K8KREATOR_TOOLS=("kind=0.20.0" "kubectl=1.27.4" "helm=3.12.3")

k8kreator-cluster-install-target() {
    local name=$1 config=$2
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Creating cluster $1"
    kind create cluster --name=$name --config=$config
}

k8kreator-cluster-delete-target() {
    local name=$1
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Deleting cluster $1"
    kind delete clusters $1
}

# End of file