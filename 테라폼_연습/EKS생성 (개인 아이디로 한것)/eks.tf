
resource "aws_iam_role" "eks_cluster" {
  # The name of the role
  name = "eks-cluster"

  # The policy that grants an entity permission to assume the role.
  # Used to access AWS resources that you might not normally have access to.
  # The role that Amazon EKS will use to create AWS resources for Kubernetes clusters
  # 엔터티에 역할을 맡을 수 있는 권한을 부여하는 정책입니다.
  # 일반적으로 액세스할 수 없는 AWS 리소스에 액세스하는 데 사용됩니다.
  # Amazon EKS가 Kubernetes 클러스터용 AWS 리소스를 생성하는 데 사용할 역할
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  # 적용하려는 정책의 ARN
  # The ARN of the policy you want to apply
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSClusterPolicy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # The role the policy should be applied to
  # 정책이 적용되어야 하는 역할
  role = aws_iam_role.eks_cluster.name
}


resource "aws_eks_cluster" "eks" {
  # Name of the cluster.
  name = "eks"

  # The Amazon Resource Name (ARN) of the IAM role that provides permissions for 
  # the Kubernetes control plane to make calls to AWS API operations on your behalf
  role_arn = aws_iam_role.eks_cluster.arn

  # Desired Kubernetes master version
  version = "1.21"

  vpc_config {
    # Indicates whether or not the Amazon EKS private API server endpoint is enabled
    # Amazon EKS 프라이빗 API 서버 엔드포인트가 활성화되었는지 여부를 나타냅니다.
    endpoint_private_access = false

    # Indicates whether or not the Amazon EKS public API server endpoint is enabled
    # Amazon EKS 퍼블릭 API 서버 엔드포인트가 활성화되었는지 여부를 나타냅니다.
    endpoint_public_access = true

    # Must be in at least two different availability zones
    # 적어도 두 개의 서로 다른 가용 영역에 있어야 합니다.
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  # EKS 클러스터 처리 전에 IAM 역할 권한이 생성되고 삭제되었는지 확인합니다.
  # 그렇지 않으면 EKS가 보안 그룹과 같은 EKS 관리 EC2 인프라를 제대로 삭제할 수 없습니다.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}