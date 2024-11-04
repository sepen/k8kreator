#!/usr/bin/env bash

k8kreator-tools-install-stern() {
  local stern_version=$1
  local stern_url="https://github.com/stern/stern/releases/download"

  local system_os=$(k8kreator-get-system-os)
  local system_arch=$(k8kreator-get-system-arch)

  stern_url="${stern_url}/v${stern_version}/stern_${stern_version}_${system_os}_${system_arch}.tar.gz"

  if [ ! -f ${K8KREATOR_BINDIR}/stern-${stern_version} ]; then
    k8kreator-check-deps "curl" "mkdir" "tar" "cp" "chmod" "rm"
    curl -s -L -o ${K8KREATOR_TMPDIR}/stern-${stern_version}.tar.gz ${stern_url}
    mkdir -p ${K8KREATOR_TMPDIR}/stern-${stern_version}
    tar -C ${K8KREATOR_TMPDIR}/stern-${stern_version} -xf ${K8KREATOR_TMPDIR}/stern-${stern_version}.tar.gz
    cp ${K8KREATOR_TMPDIR}/stern-${stern_version}/stern ${K8KREATOR_BINDIR}/stern-${stern_version}
    chmod +x ${K8KREATOR_BINDIR}/stern-${stern_version}
    rm -rf ${K8KREATOR_TMPDIR}/stern-${stern_version}
  fi
}

k8kreator-tools-select-stern() {
  local stern_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/stern
  ln -sf stern-${stern_version} ${K8KREATOR_BINDIR}/stern
}

k8kreator-tools-uninstall-stern() {
  local stern_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/stern-${stern_version}
}

# End of file
