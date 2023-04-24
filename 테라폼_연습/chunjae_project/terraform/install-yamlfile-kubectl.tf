provider "kubectl" {
  host                   = aws_eks_cluster.chunjae_ocr.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.chunjae_ocr.certificate_authority[0].data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.chunjae_ocr.id]
    command     = "aws"
  }

}

## argocd 네임스페이스 생성
resource "kubectl_manifest" "argocd_namespace_create" {
  yaml_body = <<-EOF
apiVersion: v1
kind: Namespace
metadata:
  name: argocd
EOF

depends_on = [aws_eks_node_group.admin_node_group]

}


# argocd 설치
data "kubectl_file_documents" "argo_install" {
  content = file("${var.PATH_ETC}/argocd_install.yaml")
}
resource "kubectl_manifest" "argo_install" {
    override_namespace = "argocd"
    for_each  = data.kubectl_file_documents.argo_install.manifests
    yaml_body = each.value
    depends_on = [
        kubectl_manifest.argocd_namespace_create
    ]
}



## 뉴런 스케줄러 설치
data "kubectl_file_documents" "neuron_device_plugin_rbac" {
  content = file("${var.PATH_NEURON_PLUGIN}/k8s-neuron-device-plugin-rbac.yaml")
}
resource "kubectl_manifest" "neuron_device_plugin_rbac" {
    for_each  = data.kubectl_file_documents.neuron_device_plugin_rbac.manifests
    yaml_body = each.value

    depends_on = [
      aws_eks_node_group.admin_node_group
    ]
}

data "kubectl_file_documents" "neuron_device_plugin" {
  content = file("${var.PATH_NEURON_PLUGIN}/k8s-neuron-device-plugin.yaml")
}
resource "kubectl_manifest" "neuron_device_plugin" {
    for_each  = data.kubectl_file_documents.neuron_device_plugin.manifests
    yaml_body = each.value
    depends_on = [
      kubectl_manifest.neuron_device_plugin_rbac
    ]
}

data "kubectl_file_documents" "neuron_device_scheduler" {
  content = file("${var.PATH_NEURON_PLUGIN}/k8s-neuron-scheduler-eks.yaml")
}
resource "kubectl_manifest" "neuron_device_scheduler" {
    for_each  = data.kubectl_file_documents.neuron_device_scheduler.manifests
    yaml_body = each.value
    depends_on = [
      kubectl_manifest.neuron_device_plugin
    ]
}

data "kubectl_file_documents" "neuron_my_scheduler" {
  content = file("${var.PATH_NEURON_PLUGIN}/my-scheduler.yaml")
}
resource "kubectl_manifest" "neuron_my_scheduler" {
    for_each  = data.kubectl_file_documents.neuron_my_scheduler.manifests
    yaml_body = each.value
    depends_on = [
      kubectl_manifest.neuron_device_plugin
    ]
}
## 뉴런 스케줄러 설치끝







## 로그 수집기 flunedtd 설치 시작
data "kubectl_file_documents" "flunedtd_map" {
  content = file("${var.PATH_ETC}/flunedtd-map.yaml")
}

## 로그 수집기 flunedtd config맵 설정
resource "kubectl_manifest" "flunedtd_map" {
    for_each  = data.kubectl_file_documents.flunedtd_map.manifests
    yaml_body = each.value
    depends_on = [
      helm_release.elasticsearch
    ]
}


data "kubectl_file_documents" "flunedtd_ds" {
  content = file("${var.PATH_ETC}/flunedtd-ds.yaml")
}
## 로그 수집기 flunedtd config맵 배포
resource "kubectl_manifest" "flunedtd_ds" {
    for_each  = data.kubectl_file_documents.flunedtd_ds.manifests
    yaml_body = each.value
    depends_on = [
      kubectl_manifest.flunedtd_map
    ]
}
## 로그 수집기 flunedtd 설치끝






# 카펜터 프로비저너 설치
data "kubectl_file_documents" "karpenter_provisioner" {
  content = file("${var.PATH_HPA}/karpenter_provisioner.yaml")
}
resource "kubectl_manifest" "karpenter_provisioner" {
    for_each  = data.kubectl_file_documents.karpenter_provisioner.manifests
    yaml_body = each.value
    depends_on = [
      kubectl_manifest.neuron_my_scheduler
    ]
}



# ## istio용 프로메테우스
# data "kubectl_file_documents" "istio_prometheus" {
#   content = file("${var.PATH_ETC}/istio-prometheus.yaml")
# }
# resource "kubectl_manifest" "istio_prometheus" {
#     for_each  = data.kubectl_file_documents.istio_prometheus.manifests
#     yaml_body = each.value
#     depends_on = [
#       helm_release.istio_gateway
#     ]
# }

# ## istio- kiali
# data "kubectl_file_documents" "istio_kiali" {
#   content = file("${var.PATH_ETC}/istio-kiali.yaml")
# }
# resource "kubectl_manifest" "istio_kiali" {
#     for_each  = data.kubectl_file_documents.istio_kiali.manifests
#     yaml_body = each.value
#     depends_on = [
#       helm_release.istio_gateway
#     ]
# }





## application 네임스페이스 생성
resource "kubectl_manifest" "application_namespace_create" {
  yaml_body = <<-EOF
apiVersion: v1
kind: Namespace
metadata:
  name: application
  labels:
    istio-injection: enabled
EOF
}



## messagesys 네임스페이스 생성
resource "kubectl_manifest" "messagesys_namespace_create" {
  yaml_body = <<-EOF
apiVersion: v1
kind: Namespace
metadata:
  name: messagesys
  labels:
    istio-injection: enabled
EOF
}



## 레빗mq 클러스터 배포
data "kubectl_file_documents" "rabbitmq" {
  content = file("${var.PATH_ETC}/rabbitmq.yaml")
}
resource "kubectl_manifest" "rabbitmq" {
    for_each  = data.kubectl_file_documents.rabbitmq.manifests
    yaml_body = each.value

    ## 나중에 이스티오 추가 해줘야할듯
    depends_on = [
      helm_release.rabbitmq-cluster-operator
    ]
}





## api 게이트웨이 설치
data "kubectl_file_documents" "api_gateway" {
  content = file("${var.PATH_ETC}/api-gateway.yaml")
}
resource "kubectl_manifest" "api_gateway" {
    for_each  = data.kubectl_file_documents.api_gateway.manifests
    yaml_body = each.value

    ## 나중에 이스티오 추가 해줘야할듯
    depends_on = [
      kubectl_manifest.rabbitmq,
      helm_release.redis,
      helm_release.istio_gateway
    ]
}





