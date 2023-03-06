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
}


# argocd 설치
data "kubectl_file_documents" "argo_install" {
  content = file("../k8s/etc_intsall/argocd_install.yaml")
}
resource "kubectl_manifest" "argo_install" {
    override_namespace = "argocd"
    for_each  = data.kubectl_file_documents.argo_install.manifests
    yaml_body = each.value
    depends_on = [
        kubectl_manifest.argocd_namespace_create
    ]
}



# https://stackoverflow.com/questions/54094575/how-to-run-kubectl-apply-commands-in-terraform
## 뉴런 스케줄러 설치
data "kubectl_file_documents" "neuron_device_plugin_rbac" {
  content = file("../k8s/neuron-device-plugin/k8s-neuron-device-plugin-rbac.yaml")
}
resource "kubectl_manifest" "neuron_device_plugin_rbac" {
    for_each  = data.kubectl_file_documents.neuron_device_plugin_rbac.manifests
    yaml_body = each.value
}

data "kubectl_file_documents" "neuron_device_plugin" {
  content = file("../k8s/neuron-device-plugin/k8s-neuron-device-plugin.yaml")
}
resource "kubectl_manifest" "neuron_device_plugin" {
    for_each  = data.kubectl_file_documents.neuron_device_plugin.manifests
    yaml_body = each.value
}

data "kubectl_file_documents" "neuron_device_scheduler" {
  content = file("../k8s/neuron-device-plugin/k8s-neuron-scheduler-eks.yaml")
}
resource "kubectl_manifest" "neuron_device_scheduler" {
    for_each  = data.kubectl_file_documents.neuron_device_scheduler.manifests
    yaml_body = each.value
}

data "kubectl_file_documents" "neuron_my_scheduler" {
  content = file("../k8s/neuron-device-plugin/my-scheduler.yaml")
}
resource "kubectl_manifest" "neuron_my_scheduler" {
    for_each  = data.kubectl_file_documents.neuron_my_scheduler.manifests
    yaml_body = each.value
}
## 뉴런 스케줄러 설치끝












