#!/usr/bin/env bash

k8kreator-tools-install-k3d() {
  local k3d_version=$1
  local k3d_url="https://github.com/k3d-io/k3d/releases/download/v${k3d_version}"

  local system_os=$(k8kreator-get-system-os)
  local system_arch=$(k8kreator-get-system-arch)

  k3d_url="${k3d_url}/k3d-${system_os}-${system_arch}"

  if [ ! -f ${K8KREATOR_BINDIR}/k3d-${k3d_version} ]; then
    k8kreator-check-deps "curl" "chmod"
    curl -s -L -o ${K8KREATOR_BINDIR}/k3d-${k3d_version} ${k3d_url}
    chmod +x ${K8KREATOR_BINDIR}/k3d-${k3d_version}
  fi
}

k8kreator-tools-select-k3d() {
  local k3d_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/k3d
  ln -sf k3d-${k3d_version} ${K8KREATOR_BINDIR}/k3d
}

k8kreator-tools-uninstall-k3d() {
  local k3d_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/k3d-${k3d_version}
}

# End of file
