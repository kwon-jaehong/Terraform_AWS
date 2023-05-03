
# EKS 노드 그룹에 대한 IAM 역할 생성
# EKS 클러스터 생성했던 롤과는 성격이 다름
# EKS는 다수의 노드 그룹을 만들수 있기 때문에, 생성때마다 권한을 줘야함
resource "aws_iam_role" "chunjae_ocr_service_role" {
  # The name of the role
  name = "chunjae_ocr_service_role"

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
  role = aws_iam_role.chunjae_ocr_service_role.name
}



## EKS에서 사용할 CNI (아마존은 쿠버네티스 - EKS 사용시 CNI를 자동적으로 설치해줌 -> 서브넷과 연동되어 IP 할당을 위해)
resource "aws_iam_role_policy_attachment" "amazon_eks_ocr_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.chunjae_ocr_service_role.name
}


## EKS에서 -> ECR 컨테이너 읽을 용도의 역할을 선언하고 연결
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.chunjae_ocr_service_role.name
}


## 엘라스틱 서치등 관리 프로그램을 설치할 노드 그룹 선언
resource "aws_eks_node_group" "admin_node_group" {
  ## EKS 클러스터 이름으로 노드 그룹 연결
  cluster_name = aws_eks_cluster.chunjae_ocr.name
  
  ## 노드 그룹 이름
  node_group_name = "admin_node_group"

  ## 노드 그룹에 적용할 역활 연결 (위에 선언했음)
  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

  ## 노드가 생성될 서브넷 지정
  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]

  ## 컴퓨터 사이즈 설정 (대수)
  scaling_config {
    desired_size = 4
    max_size = 10
    min_size = 4
  }

  ## 아마존 이미지 타입
  ami_type = "AL2_x86_64"

  ## 용량 타입 
  ## ON_DEMAND = 지정된 장비를 계속씀 (비쌈)
  ## SPOT = 언제 꺼질지 모르는 장비를 잠깐 빌려씀 (매우 쌈) 
  capacity_type = "ON_DEMAND"

  ## 컴퓨터 disk 사이즈
  disk_size = 12

  ## 쿠버네티스 버젼 자동 업데이트 안함
  force_update_version = false
  
  ## 노드그룹에 적용할 쿠버네티스 버젼
  version = var.KUBE_VERSION

  ## ec2 인스턴스 타입
  instance_types = ["t3.medium"]  
  # instance_types = ["t3.large"]
  
  labels = {
    role = "admin_role"
  }
  
  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  ## ec2 인스턴스에 접속할 수 있는 ssh key
  remote_access {
    ec2_ssh_key = "test"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}



## 프로메테우스를 관리할 노드 그룹, (램 많이 잡아먹음)
resource "aws_eks_node_group" "prometheus_node_group" {
  cluster_name = aws_eks_cluster.chunjae_ocr.name
  node_group_name = "prometheus_node_group"
  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]

  scaling_config {
    desired_size = 1
    max_size = 5
    min_size = 1
  }

  ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 12

  force_update_version = false

  instance_types = ["t3.large"]

  labels = {
    role = "prometheus_role"
  }
  version = var.KUBE_VERSION

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  remote_access {
    ec2_ssh_key = "test"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}



## rabbitmq, redis 설치할 노드
resource "aws_eks_node_group" "message_sys" {

  cluster_name = aws_eks_cluster.chunjae_ocr.name

  node_group_name = "message_sys_node_group"

  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]

  scaling_config {
    desired_size = 3
    max_size = 10
    min_size = 3
  }

  ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 15

  force_update_version = false

  instance_types = ["t3.medium"]

  labels = {
    role = "message_sys_role"
  }

  version = var.KUBE_VERSION

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  remote_access {
    ec2_ssh_key = "test"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}


## api 게이트웨이 전용 노드 그룹
resource "aws_eks_node_group" "apigateway_node_group" {

  cluster_name = aws_eks_cluster.chunjae_ocr.name

  node_group_name = "apigateway_node_group"

  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn

  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size = 15
    min_size = 2
  }

  ami_type = "AL2_x86_64"

  capacity_type = "ON_DEMAND"

  disk_size = 12

  force_update_version = false

  instance_types = ["t3.medium"]

  labels = {
    role = "apigateway_role"
  }

  version = var.KUBE_VERSION

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  remote_access {
    ec2_ssh_key = "test"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

## aws neuron 코어를 사용할  노드그룹 생성
resource "aws_eks_node_group" "inf_node_group" {

  ## 클러스터 네임
  cluster_name = aws_eks_cluster.chunjae_ocr.name
  
  # 노드그룹 이름 지정
  node_group_name = "inf_node_group"

  # Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  # EKS 노드 그룹에 대한 권한 및 정책 연결
  node_role_arn = aws_iam_role.chunjae_ocr_service_role.arn


  # subnet_ids = [
  #   aws_subnet.eks_private_1.id,
  #   aws_subnet.eks_private_2.id
  # ]
  subnet_ids = [
    aws_subnet.eks_public_1.id,
    aws_subnet.eks_public_2.id
  ]


  # 스케일링 설정이 있는 구성 블록
  scaling_config {
    desired_size = 2
    max_size = 8
    min_size = 2
  }

  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = "AL2_x86_64_GPU"

  capacity_type = "ON_DEMAND"


  # 작업자 노드의 디스크 크기(GiB)
  disk_size = 35


  # 포드 중단 예산 문제로 인해 기존 포드를 비울 수 없는 경우 버전 업데이트를 강제합니다.
  force_update_version = false


  # EKS 노드 그룹과 연결된 인스턴스 유형 목록
  ## yolo 처음 불러올때 메모리 오류 때문에 2xlarge써봄 -> yolo 이미지 사이즈 960 안쓸거면 xlarge로 충분
  # instance_types = ["inf1.xlarge"]
  instance_types = ["inf1.2xlarge"]

  # Kubernetes 레이블의 키-값 맵입니다. EKS API로 적용된 레이블만 이 인수로 관리됩니다. EKS 노드 그룹에 적용된 다른 Kubernetes 레이블은 관리되지 않습니다.
  labels = {
    role = "chunjae_ocr_service_role"
  }


  version = var.KUBE_VERSION

  timeouts {
    create = "1h"
    update = "1h"
    delete = "1h"
  }

  remote_access {
    ec2_ssh_key = "test"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}