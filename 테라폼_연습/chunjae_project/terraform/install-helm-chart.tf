
## 프로메테우스-stack  (프로메테우스 + 그라파나)
resource "helm_release" "prometheus_stack" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  # version    = "19.3.0"
  version    = "45.25.0"
  values = ["${file("${var.PATH_HELM_VALUE}/prometheus-stack-chart-value.yaml")}"]
  # timeout = 7200
  depends_on = [aws_eks_node_group.prometheus_node_group]
}


## 프로메테우스 어댑터 설치
resource "helm_release" "prometheus_adapter" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "prometheus-adapter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-adapter"
  version    = "2.13.0"
  values = ["${file("${var.PATH_HELM_VALUE}/prometheus-adapter-chart-value.yaml")}"]
  depends_on = [aws_eks_node_group.admin_node_group]
}

## 엘라스틱 서치 설치
resource "helm_release" "elasticsearch" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  # version    = "7.6.0"
  values = ["${file("${var.PATH_HELM_VALUE}/elasticsearch-chart-value.yaml")}"]
  depends_on = [aws_eks_node_group.admin_node_group]
}

## 키바나 설치
resource "helm_release" "kibana" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  # version    = "7.6.0"
  values = ["${file("${var.PATH_HELM_VALUE}/kibana-chart-value.yaml")}"]
  depends_on = [aws_eks_node_group.admin_node_group,
  helm_release.elasticsearch
  ]
}



## istio 설치 시작
resource "helm_release" "istio_base" {
  name = "my-istio-base-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1"

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }
  depends_on = [
    aws_eks_node_group.admin_node_group
  ]
}
resource "helm_release" "istiod" {
  name = "my-istiod-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1"
  values = ["${file("${var.PATH_HELM_VALUE}/istiod-chart-value.yaml")}"]


  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_gateway" {
  name = "gateway"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  create_namespace = true
  version          = "1.17.1"
  values = ["${file("${var.PATH_HELM_VALUE}/istio-gateway-chart-value.yaml")}"]

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}
## istio 설치 끝



## RabbitMQ 클러스터 오퍼레이터 설치
resource "helm_release" "rabbitmq-cluster-operator" {
  name = "rabbitmq"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "rabbitmq-cluster-operator"
  namespace        = "messagesys"
  create_namespace = true
  version          = "3.2.7"
  values = ["${file("${var.PATH_HELM_VALUE}/rabbitmq-cluster-operator-chart-value.yaml")}"]

  depends_on = [aws_eks_node_group.message_sys,
                kubectl_manifest.messagesys_namespace_create,
                helm_release.istio_gateway]
}


## redis 설치
resource "helm_release" "redis" {
  name = "redis"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "redis"
  namespace        = "messagesys"
  create_namespace = true
  version          = "17.8.6"
  values = ["${file("${var.PATH_HELM_VALUE}/redis-chart-value.yaml")}"]

  depends_on = [aws_eks_node_group.message_sys,
                kubectl_manifest.messagesys_namespace_create,
                helm_release.istio_gateway]
}