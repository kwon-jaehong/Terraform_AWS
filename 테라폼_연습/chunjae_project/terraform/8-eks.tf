

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.25.0"

  cluster_name    = var.EKS_NAME
  cluster_version = var.KUBE_VERSION
  enable_irsa     = true

  map_roles = [
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
    ,
    {
      rolearn  = aws_iam_role.chunjae_ocr_service_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
    
  ]
  
  vpc_id = aws_vpc.eks_vpc.id

  public_subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]
  private_subnet_ids = [
    aws_subnet.eks_private_1.id,
    aws_subnet.eks_private_2.id
  ]

  ## 클라우드와치 로깅 X
  cluster_enabled_log_types = []


}

