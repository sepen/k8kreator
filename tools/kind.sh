#!/usr/bin/env bash

k8kreator-tools-install-kind() {
  local kind_version=$1
  local kind_url="https://github.com/kubernetes-sigs/kind/releases/download/v${kind_version}"

  local system_os=$(k8kreator-get-system-os)
  local system_arch=$(k8kreator-get-system-arch)

  kind_url="${kind_url}/kind-${system_os}-${system_arch}"

  if [ ! -f ${K8KREATOR_BINDIR}/kind-${kind_version} ]; then
    k8kreator-check-deps "curl" "chmod"
    curl -s -L -o ${K8KREATOR_BINDIR}/kind-${kind_version} ${kind_url}
    chmod +x ${K8KREATOR_BINDIR}/kind-${kind_version}
  fi
}

k8kreator-tools-select-kind() {
  local kind_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/kind
  ln -sf kind-${kind_version} ${K8KREATOR_BINDIR}/kind
}

k8kreator-tools-uninstall-kind() {
  local kind_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/kind-${kind_version}
}

# End of file
