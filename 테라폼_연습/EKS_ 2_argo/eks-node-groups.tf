
# Create IAM role for EKS Node Group
# EKS 노드 그룹에 대한 IAM 역할 생성
# EKS 클러스터 생성했던 롤과는 성격이 다름
# EKS는 다수의 노드 그룹을 만들수 있기 때문에, 생성때마다 권한을 줘야함
resource "aws_iam_role" "chunjae_ocr_service_role" {
  # The name of the role
  name = "chunjae_ocr_service_role"

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

## 위에서 생성한 IAM 유저를 등록 (EKS 노드그룹 관리를 위해)
resource "aws_iam_role_policy_attachment" "amazon_eks_ocr_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # The role the policy should be applied to
  role = aws_iam_role.chunjae_ocr_service_role.name
}

## EKS에서 사용할 CNI (아마존은 쿠버네티스 - EKS 사용시 CNI를 자동적으로 설치해줌 -> 서브넷과 연동되어 IP 할당을 위해)
resource "aws_iam_role_policy_attachment" "amazon_eks_ocr_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.chunjae_ocr_service_role.name
}

## ECR 컨테이너 읽을 용도의 정책 연결
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # The role the policy should be applied to
  role = aws_iam_role.chunjae_ocr_service_role.name
}

## 프로메테우스,엘라스틱 서치등 관리프로그램을 설치할 노드 그룹
resource "aws_eks_node_group" "admin_node_group" {
  cluster_name = aws_eks_cluster.chunjae_ocr.name
  node_group_name = "admin_node_group"
  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]
  scaling_config {
    desired_size = 3
    max_size = 6
    min_size = 2
  }
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 30
  force_update_version = false
  instance_types = ["t3.medium"]
  labels = {
    role = "admin_role"
  }
  version = "1.21"
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

# ## api 게이트웨이 자원을 가질 노드 그룹
# resource "aws_eks_node_group" "apigateway_node_group" {
#   cluster_name = aws_eks_cluster.chunjae_ocr.name
#   node_group_name = "apigateway_node_group"
#   node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

#   subnet_ids = [
#     aws_subnet.eks_public_1.id,
#     aws_subnet.eks_public_2.id
#   ]
#   scaling_config {
#     desired_size = 2
#     max_size = 6
#     min_size = 2
#   }
#   ami_type = "AL2_x86_64"
#   capacity_type = "ON_DEMAND"
#   disk_size = 20
#   force_update_version = false
#   instance_types = ["t3.small"]
#   labels = {
#     role = "apigateway_role"
#   }
#   version = "1.21"
#   depends_on = [
#     aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
#     aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
#     aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
#   ]
# }

## 뉴런코어(GPU 탑재 노드그룹 생성)
resource "aws_eks_node_group" "inf_node_group" {

  ## 클러스터 네임
  cluster_name = aws_eks_cluster.chunjae_ocr.name

  # 노드그룹 이름 지정
  node_group_name = "inf_node_group"

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  # EKS 노드 그룹에 대한 권한 및 정책 연결
  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn


  # Identifiers of EC2 Subnets to associate with the EKS Node Group. 
  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME 
  # (where CLUSTER_NAME is replaced with the name of the EKS Cluster).

  # EKS 노드 그룹과 연결할 EC2 서브넷의 식별자입니다.
  # 이 서브넷에는 다음 리소스 태그가 있어야 합니다. kubernetes.io/cluster/CLUSTER_NAME
  # (여기서 CLUSTER_NAME은 EKS 클러스터의 이름으로 대체됨).
  ## 프라이빗 존을 쓰지만... nat게이트 웨이를 통해 퍼블릭하게 운영 가능
  # subnet_ids = [
  #   aws_subnet.eks_private_1.id,
  #   aws_subnet.eks_private_2.id
  # ]
  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]

  # Configuration block with scaling settings
  # 스케일링 설정이 있는 구성 블록
  scaling_config {
    # Desired number of worker nodes.
    desired_size = 1

    # Maximum number of worker nodes.
    max_size = 5

    # Minimum number of worker nodes.
    min_size = 1
  }

  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64_GPU"
  # ami_type = "AL2_x86_64"

  # Type of capacity associated with the EKS Node Group. 
  # Valid values: ON_DEMAND, SPOT
  capacity_type = "ON_DEMAND"

  # Disk size in GiB for worker nodes
  # 작업자 노드의 디스크 크기(GiB)
  disk_size = 30

  # Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  # 포드 중단 예산 문제로 인해 기존 포드를 비울 수 없는 경우 버전 업데이트를 강제합니다.
  force_update_version = false

  # List of instance types associated with the EKS Node Group
  # EKS 노드 그룹과 연결된 인스턴스 유형 목록
  instance_types = ["inf1.xlarge"]
  # instance_types = ["t3.medium"]

  # Kubernetes 레이블의 키-값 맵입니다. EKS API로 적용된 레이블만 이 인수로 관리됩니다. EKS 노드 그룹에 적용된 다른 Kubernetes 레이블은 관리되지 않습니다.
  labels = {
    role = "chunjae_ocr_service_role"
  }

  # Kubernetes version
  version = "1.21"

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # EKS 노드 그룹 처리 전에 IAM 역할 권한이 생성되고 삭제되었는지 확인합니다.
  # 그렇지 않으면 EKS가 EC2 인스턴스 및 탄력적 네트워크 인터페이스를 제대로 삭제할 수 없습니다.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}