# k8kreator

**k8kreator** is a lightweight wrapper to setup up and manage Kubernetes clusters

The idea behind **k8kreator** is to be able to create clusters with different Kubernetes engines and have a homogeneous way to install and maintain cluster components. It was primarily designed for testing Kubernetes itself, but may be used for local development or CI (you can use it in production but it's not what it's designed for, so do it at your own risk).

At this moment **k8kreator** supports the following Kubernetes engines:
* [kind]. A tool for running local Kubernetes clusters using Docker container “nodes”.
* [k3d]. A lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) in docker.
* [minikube]. A tool for running a local Kubernetes cluster, focusing on making it easy to learn and develop for Kubernetes.

[kind]: https://kind.sigs.k8s.io/
[k3d]: https://k3d.io/
[minikube]: https://minikube.sigs.k8s.io/

Each cluster in **k8kreator** can be identified as a _target_ which is defined as follows: `<name>.<engine>.<environment>`. Each _target_ has its own configuration for the kubernetes engine and a set of _components_ to install in the cluster. These _components_ may vary from one _target_ to another and may have different configuration depending on the Kubernetes engine.

**k8kreator** provides the following _default_ targets:
* `default.kind.local`
* `default.k3d.local`
* `default.minukube.local`

The cluster _components_ that come in the default targets are the following:
* [metrics-server]. It collects resource metrics from Kubelets and exposes them in Kubernetes apiserver through Metrics API.
* [metallb].  A load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.
* [ingress-nginx]. An Ingress controller for Kubernetes using Nginx as a reverse proxy and load balancer.

[metrics-server]: https://github.com/kubernetes-sigs/metrics-server/
[metallb]: https://metallb.universe.tf/
[ingress-nginx]: https://github.com/kubernetes/ingress-nginx/

In addition to targets above you can add your own custom _target_. To create it you can use _default_ targets as a template and remove or add components as needed.
