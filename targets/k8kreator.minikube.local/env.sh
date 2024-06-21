#!/usr/bin/env bash

export K8KREATOR_TOOLS=("minikube=1.33.1" "kubectl=1.30.0" "helm=3.15.2")

export K8KREATOR_ADDONS=(
    "metrics-server=3.12.1"
    "metallb=0.14.5"
    "ingress-nginx=4.10.1"
    "kubernetes-dashboard=7.3.2"
    "kubewatch=3.3.10"
    "jenkins=5.2.2"
    "prometheus=25.20.1"
    "grafana=7.3.9"
    "promtail=6.15.5"
    "loki=6.6.3"
)

# End of file
