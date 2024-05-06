#!/usr/bin/env bash

KIND_COMMAND=$(k8kreator-get-tool-command "kind")

k8kreator-cluster-create-target() {
  k8kreator-check-deps ${KIND_COMMAND}
  ${KIND_COMMAND} create cluster \
    --name=${K8KREATOR_TARGET} \
    --config=${K8KREATOR_TARGETSDIR}/${K8KREATOR_TARGET}/cluster.yaml
}

k8kreator-cluster-delete-target() {
  k8kreator-check-deps ${KIND_COMMAND}
  ${KIND_COMMAND} delete clusters ${K8KREATOR_TARGET}
}

# End of file
