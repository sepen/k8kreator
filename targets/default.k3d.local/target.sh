#!/usr/bin/env bash

export K8KREATOR_TOOLS=("k3d=5.6.0" "kubectl=1.28.1" "helm=3.12.3")

k8kreator-cluster-create-target() {
    local name=${K8KREATOR_TARGET}
    local config=${K8KREATOR_HOME}/src/targets/${K8KREATOR_TARGET}/cluster.yaml
    local k3d_version=${K8KREATOR_TOOLS[0]##*=}
    k8kreator-check-deps "k3d"
    k8kreator-msg-info "Creating cluster $name"
    k3d-${k3d_version} cluster create $name --config $config
  }

k8kreator-cluster-delete-target() {
    local name=${K8KREATOR_TARGET}
    k8kreator-check-deps "k3d"
    k8kreator-msg-info "Deleting cluster $name"
    k3d-${k3d_version} cluster delete $name
}

# End of file
