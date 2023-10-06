#!/usr/bin/env bash

export K8KREATOR_TOOLS=("kind=0.20.0" "kubectl=1.27.4" "helm=3.12.3")

export K8KREATOR_ADDONS=(
    "metrics-server=3.11.0"
    "metallb=0.13.4"
    "ingress-nginx=4.0.17"
    "kubernetes-dashboard=7.0.0-alpha1"
    "jenkins=4.6.6"
)

# End of file
