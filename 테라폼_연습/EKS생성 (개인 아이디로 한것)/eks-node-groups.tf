
# Create IAM role for EKS Node Group
# EKS 노드 그룹에 대한 IAM 역할 생성
resource "aws_iam_role" "nodes_general" {
  # The name of the role
  name = "eks-node-group-general"

  # The policy that grants an entity permission to assume the role.
  # 엔터티에 역할을 맡을 수 있는 권한을 부여하는 정책입니다.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  # The ARN of the policy you want to apply.
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKSWorkerNodePolicy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  # The ARN of the policy you want to apply.
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEKS_CNI_Policy
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  # The ARN of the policy you want to apply.
  # https://github.com/SummitRoute/aws_managed_policies/blob/master/policies/AmazonEC2ContainerRegistryReadOnly
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}


resource "aws_eks_node_group" "nodes_general" {
  # Name of the EKS Cluster.
  cluster_name = aws_eks_cluster.eks.name

  # Name of the EKS Node Group.
  node_group_name = "nodes-general"

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  # EKS 노드 그룹에 대한 권한을 제공하는 IAM 역할의 Amazon 리소스 이름(ARN).
  node_role_arn = aws_iam_role.nodes_general.arn


  # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME 
  # (where CLUSTER_NAME is replaced with the name of the EKS Cluster).

  # EKS 노드 그룹과 연결할 EC2 서브넷의 식별자입니다.
  # 이 서브넷에는 다음 리소스 태그가 있어야 합니다. kubernetes.io/cluster/CLUSTER_NAME
  # (여기서 CLUSTER_NAME은 EKS 클러스터의 이름으로 대체됨).
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # Configuration block with scaling settings
  # 스케일링 설정이 있는 구성 블록
  scaling_config {
    # Desired number of worker nodes.
    desired_size = 2

    # Maximum number of worker nodes.
    max_size = 5

    # Minimum number of worker nodes.
    min_size = 2
  }

  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64"

  # Type of capacity associated with the EKS Node Group. 
  # Valid values: ON_DEMAND, SPOT
  capacity_type = "ON_DEMAND"

  # Disk size in GiB for worker nodes
  # 작업자 노드의 디스크 크기(GiB)
  disk_size = 10

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  # 포드 중단 예산 문제로 인해 기존 포드를 비울 수 없는 경우 버전 업데이트를 강제합니다.
  force_update_version = false

  # List of instance types associated with the EKS Node Group
  # EKS 노드 그룹과 연결된 인스턴스 유형 목록
  instance_types = ["t3.small"]

  labels = {
    role = "nodes-general"
  }

  # Kubernetes version
  version = "1.21"

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # EKS 노드 그룹 처리 전에 IAM 역할 권한이 생성되고 삭제되었는지 확인합니다.
  # 그렇지 않으면 EKS가 EC2 인스턴스 및 탄력적 네트워크 인터페이스를 제대로 삭제할 수 없습니다.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}