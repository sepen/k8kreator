#!/usr/bin/env bash

k8kreator-tools-install-k3d() {
    local k3d_version=$1
    local k3d_url="https://github.com/k3d-io/k3d/releases/download/v${k3d_version}"
    local system_uname=($(uname -m -s))
    
    local system_os=
    case ${system_uname[0]} in
        Linux) system_os="linux" ;;
        Darwin) system_os="darwin" ;;
    esac

    local system_arch=
    case ${system_uname[1]} in
        x86_64|amd64) system_arch="amd64" ;;
        aarch64|arm64) system_arch="arm64" ;;
    esac

    k3d_url="${k3d_url}/k3d-${system_os}-${system_arch}"

    if [ ! -f ${K8KREATOR_HOME}/bin/k3d-${k3d_version} ]; then
        k8kreator-check-deps "curl" "chmod"
        k8kreator-msg-info "Installing k3d ${k3d_version}"
        curl -s -L -o ${K8KREATOR_HOME}/bin/k3d-${k3d_version} ${k3d_url}
        chmod +x ${K8KREATOR_HOME}/bin/k3d-${k3d_version}
    fi
}

k8kreator-tools-select-k3d() {
    local k3d_version=$1
    k8kreator-check-deps "rm" "ln"
    rm -f ${K8KREATOR_HOME}/bin/k3d
    ln -sf k3d-${k3d_version} ${K8KREATOR_HOME}/bin/k3d
}

# End of file
