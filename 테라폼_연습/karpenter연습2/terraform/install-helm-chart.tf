
provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }
}



# ## 엘라스틱 서치 설치
# resource "helm_release" "elasticsearch" {
#   namespace        = "elasticsearch"
#   create_namespace = true

#   name       = "elasticsearch"
#   repository = "https://helm.elastic.co"
#   chart      = "elasticsearch"
#   # version    = "7.6.0"
#   values = ["${file("../k8s/elasticsearch-chart-value.yaml")}"]
# }

# ## 키바나 설치
# resource "helm_release" "kibana" {
#   namespace        = "elasticsearch"
#   create_namespace = true

#   name       = "kibana"
#   repository = "https://helm.elastic.co"
#   chart      = "kibana"
#   # version    = "7.6.0"
#   depends_on = [
#     helm_release.elasticsearch
#   ]
# }



## 프로메테우스-stack  (프로메테우스 + 그라파나)
resource "helm_release" "prometheus_stack" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.25.0"
  values = ["${file("../k8s/prometheus-stack-chart-value.yaml")}"]
  # timeout = 7200
  depends_on = [aws_eks_node_group.admin_node_group]
}
# helm install stack prometheus-community/kube-prometheus-stack