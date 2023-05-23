

# Creates Karpenter native node termination handler resources and IAM instance profile
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "19.10.0"

  cluster_name           = module.eks_blueprints.eks_cluster_id
  irsa_oidc_provider_arn = module.eks_blueprints.eks_oidc_provider_arn
  create_irsa            = false # IRSA will be created by the kubernetes-addons module
}



module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.25.0"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # EKS Add-ons
  enable_amazon_eks_aws_ebs_csi_driver = true


  enable_karpenter = true
  karpenter_helm_config = {
    name       = "karpenter"
    chart      = "karpenter"
    repository = "oci://public.ecr.aws/karpenter"
    version    = "v0.27.0"
    namespace  = "karpenter"
    set =  [{
      name  = "nodeSelector.eks\\.amazonaws\\.com/nodegroup"
      value = "admin_node_group"
  }]
  }

  depends_on = [ aws_eks_node_group.admin_node_group ]
}


resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
---
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  ttlSecondsAfterEmpty: 300 # 아무런 워커노드 없을때 6분까지 대기하다가 삭제 
  ttlSecondsUntilExpired: 18000 #노드 5시간뒤 삭제
  limits:
    resources:
      cpu: 100 # limit to 100 CPU cores
  requirements:
    # Include general purpose instance families
    - key: karpenter.k8s.aws/instance-family
      operator: In
      values: ["inf1"]
    - key: "karpenter.sh/capacity-type" # If not included, the webhook for the AWS cloud provider will default to on-demand
      operator: In
      values: ["spot"]
    # Exclude small instance sizes
    - key: karpenter.k8s.aws/instance-size
      operator: In
      values: ["xlarge"]
  providerRef:
    name: default
YAML

  depends_on = [module.kubernetes_addons]
}

resource "kubectl_manifest" "karpenter_template" {
  yaml_body = <<-YAML
---
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
    name: default
spec:
  subnetSelector:
    "kubernetes.io/cluster/${module.eks_blueprints.eks_cluster_id}": "owned"
  securityGroupSelector:
    "Name": "eks-*"
  instanceProfile: ${module.karpenter.instance_profile_name}
  tags:
    "kubernetes.io/cluster/${module.eks_blueprints.eks_cluster_id}": "owned"
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 40Gi
        volumeType: gp2
        deleteOnTermination: true

YAML

  depends_on = [module.kubernetes_addons]
}