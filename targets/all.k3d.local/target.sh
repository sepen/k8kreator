#!/usr/bin/env bash

K3D_COMMAND=$(k8kreator-get-tool-command "k3d")

k8kreator-cluster-create-target() {
  k8kreator-check-deps ${K3D_COMMAND}
  ${K3D_COMMAND} cluster create ${K8KREATOR_TARGET} \
    --config ${K8KREATOR_SRCDIR}/targets/${K8KREATOR_TARGET}/cluster.yaml
}

k8kreator-cluster-delete-target() {
  k8kreator-check-deps ${K3D_COMMAND}
  ${K3D_COMMAND} cluster delete ${K8KREATOR_TARGET}
}

# End of file