#!/usr/bin/env bash

export K8KREATOR_COMMON_TOOLS=(
  "stern=1.31.0"
  "k9s=0.32.5"
)

export K8KREATOR_COMMON_ADDONS=(
  "metrics-server=3.12.1"
  "metallb=0.14.8"
  "ingress-nginx=4.11.2"
  "kubernetes-dashboard=7.6.1"
  "kubewatch=3.5.0"
  "jenkins=5.7.1"
  "kube-prometheus-stack=65.3.1"
  "promtail=6.16.6"
  "loki=6.16.0"
  "tempo=1.10.3"
  "localstack=0.6.16"
)