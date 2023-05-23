
## aws provider 엑세스 키, 시크릿키, 지역 설정
provider "aws"{
    access_key = var.AWS_ACCKEY
    secret_key = var.AWS_SECRKEY
    region = var.AWS_REGION
}

## 테라폼에서 사용할 provider 정의
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name",  module.eks_blueprints.eks_cluster_id]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   =  module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name",  module.eks_blueprints.eks_cluster_id]
  }
}
