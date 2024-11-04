#!/usr/bin/env bash

k8kreator-tools-install-k9s() {
  local k9s_version=$1
  local k9s_url="https://github.com/derailed/k9s/releases/download"

  local system_os=$(k8kreator-get-system-os | sed -e 's|linux|Linux|' -e 's|darwin|Darwin|')
  local system_arch=$(k8kreator-get-system-arch)

  k9s_url="${k9s_url}/v${k9s_version}/k9s_${system_os}_${system_arch}.tar.gz"

  if [ ! -f ${K8KREATOR_BINDIR}/k9s-${k9s_version} ]; then
    k8kreator-check-deps "curl" "mkdir" "tar" "cp" "chmod" "rm"
    curl -s -L -o ${K8KREATOR_TMPDIR}/k9s-${k9s_version}.tar.gz ${k9s_url}
    mkdir -p ${K8KREATOR_TMPDIR}/k9s-${k9s_version}
    tar -C ${K8KREATOR_TMPDIR}/k9s-${k9s_version} -xf ${K8KREATOR_TMPDIR}/k9s-${k9s_version}.tar.gz
    cp ${K8KREATOR_TMPDIR}/k9s-${k9s_version}/k9s ${K8KREATOR_BINDIR}/k9s-${k9s_version}
    chmod +x ${K8KREATOR_BINDIR}/k9s-${k9s_version}
    rm -rf ${K8KREATOR_TMPDIR}/k9s-${k9s_version}
  fi
}

k8kreator-tools-select-k9s() {
  local k9s_version=$1
  k8kreator-check-deps "rm" "ln"
  rm -f ${K8KREATOR_BINDIR}/k9s
  ln -sf k9s-${k9s_version} ${K8KREATOR_BINDIR}/k9s
}

k8kreator-tools-uninstall-k9s() {
  local k9s_version=$1
  k8kreator-check-deps "rm"
  rm -f ${K8KREATOR_BINDIR}/k9s-${k9s_version}
}

# End of file
