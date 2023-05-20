
## 엘라스틱 서치 설치
resource "helm_release" "elasticsearch" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  # version    = "7.6.0"
  values = ["${file("../k8s/elasticsearch-chart-value.yaml")}"]
}

## 키바나 설치
resource "helm_release" "kibana" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  # version    = "7.6.0"
  depends_on = [
    helm_release.elasticsearch
  ]
}


