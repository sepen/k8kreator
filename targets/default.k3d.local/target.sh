#!/usr/bin/env bash

K3D_COMMAND=$(k8kreator-get-tool-command "k3d")

k8kreator-cluster-create-target() {
  k8kreator-check-deps ${K3D_COMMAND}
  k8kreator-msg-info "Creating cluster $name"
  ${K3D_COMMAND} cluster create ${K8KREATOR_TARGET} \
    --config ${K8KREATOR_HOME}/targets/${K8KREATOR_TARGET}/cluster.yaml

k8kreator-cluster-delete-target() {
  k8kreator-check-deps ${K3D_COMMAND}
  k8kreator-msg-info "Deleting cluster ${K8KREATOR_TARGET}"
  ${K3D_COMMAND} cluster delete ${K8KREATOR_TARGET}
}

# End of file
