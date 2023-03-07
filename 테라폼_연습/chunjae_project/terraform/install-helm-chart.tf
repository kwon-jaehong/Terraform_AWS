provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.chunjae_ocr.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.chunjae_ocr.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.chunjae_ocr.id]
      command     = "aws"
    }
  }
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "0.16.3"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.chunjae_ocr.id
  }

  set {
    name  = "clusterEndpoint"
    value = aws_eks_cluster.chunjae_ocr.endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  ## 생성 삭제하는데 2시간까지 기다림
  timeout = 7200

  depends_on = [aws_eks_node_group.admin_node_group,aws_eks_node_group.apigateway_node_group]
  
}


##################################


resource "helm_release" "prometheus_stack" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "19.3.0"
  values = ["${file("${var.PATH_HELM_VALUE}/prometheus-stack-chart-value.yaml")}"]
  timeout = 7200
  depends_on = [aws_eks_node_group.admin_node_group,aws_eks_node_group.apigateway_node_group]
}


resource "helm_release" "prometheus_adapter" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "prometheus-adapter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-adapter"
  version    = "2.13.0"
  values = ["${file("${var.PATH_HELM_VALUE}/prometheus-adapter-chart-value.yaml")}"]
  timeout = 7200
  depends_on = [aws_eks_node_group.admin_node_group,aws_eks_node_group.apigateway_node_group]
}

resource "helm_release" "elasticsearch" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = "7.6.0"
  values = ["${file("${var.PATH_HELM_VALUE}/elasticsearch-chart-value.yaml")}"]
  timeout = 7200
  depends_on = [aws_eks_node_group.admin_node_group,aws_eks_node_group.apigateway_node_group]
}

resource "helm_release" "kibana" {
  namespace        = "elasticsearch"
  create_namespace = true

  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  version    = "7.6.0"
  values = ["${file("${var.PATH_HELM_VALUE}/kibana-chart-value.yaml")}"]
  timeout = 7200
  depends_on = [aws_eks_node_group.admin_node_group,aws_eks_node_group.apigateway_node_group]
}