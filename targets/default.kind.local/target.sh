#!/usr/bin/env bash

export K8KREATOR_TOOLS=("kind=0.20.0" "kubectl=1.27.4" "helm=3.12.3")

k8kreator-cluster-create-target() {
    local name=${K8KREATOR_TARGET}
    local config=${K8KREATOR_HOME}/src/targets/${K8KREATOR_TARGET}/cluster.yaml
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Creating cluster $name"
    kind create cluster --name=$name --config=$config
}

k8kreator-cluster-delete-target() {
    local name=${K8KREATOR_TARGET}
    k8kreator-check-deps "kind"
    k8kreator-msg-info "Deleting cluster $name"
    kind delete clusters $name
}

# End of file