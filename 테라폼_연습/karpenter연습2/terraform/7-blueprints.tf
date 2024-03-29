module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.25.0"

  cluster_name    = "demo"
  cluster_version = var.KUBE_VERSION
  enable_irsa     = true

  # create_cluster_security_group = false
  # create_node_security_group = false

  map_roles = [
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
    # ,
    # {
    #   rolearn  = aws_iam_role.developer.arn
    #   username = "developer"
    #   groups   = ["reader"]
    # },
  ]

  # fargate_profiles = {
  #   staging = {
  #     fargate_profile_name = "staging"
  #     # subnet_ids = [
  #     #   aws_subnet.private_us_east_1a.id,
  #     #   aws_subnet.private_us_east_1b.id
  #     # ]
  #     subnet_ids = module.vpc.private_subnets
  #     fargate_profile_namespaces = [
  #       { namespace = "staging" }
  #     ]
  #   }
  # }

  # vpc_id = aws_vpc.main.id
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnets

  # managed_node_groups = {
  #   role = {
  #     capacity_type   = "ON_DEMAND"
  #     node_group_name = "general"
  #     instance_types  = ["t3.medium"]
  #     desired_size    = "2"
  #     max_size        = "10"
  #     min_size        = "2"
  #   }
  # }
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
  }
}
