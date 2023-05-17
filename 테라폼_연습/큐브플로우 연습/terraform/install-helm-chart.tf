provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.test_eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.test_eks.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.test_eks.id]
      command     = "aws"
    }
  }
}


## 엘라스틱 서치 설치
resource "helm_release" "elasticsearch" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.6.0"
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
  version    = "7.6.0"
  values = ["${file("${var.PATH_HELM_VALUE}/kibana-chart-value.yaml")}"]
  depends_on = [aws_eks_node_group.admin_node_group,
  helm_release.elasticsearch
  ]
}


