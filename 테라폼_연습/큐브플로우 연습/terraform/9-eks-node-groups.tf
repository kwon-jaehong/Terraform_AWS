
# EKS 노드 그룹에 대한 IAM 역할 생성
# EKS 클러스터 생성했던 롤과는 성격이 다름
# EKS는 다수의 노드 그룹을 만들수 있기 때문에, 생성때마다 권한을 줘야함
resource "aws_iam_role" "test_eks_service_role" {
  # The name of the role
  name = "test_eks_service_role"

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
resource "aws_iam_role_policy_attachment" "test_eks_ocr_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.test_eks_service_role.name
}



## EKS에서 사용할 CNI (아마존은 쿠버네티스 - EKS 사용시 CNI를 자동적으로 설치해줌 -> 서브넷과 연동되어 IP 할당을 위해)
resource "aws_iam_role_policy_attachment" "test_eks_ocr_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.test_eks_service_role.name
}


## EKS에서 -> ECR 컨테이너 읽을 용도의 역할을 선언하고 연결
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.test_eks_service_role.name
}




## 엘라스틱 서치등 관리 프로그램을 설치할 노드 그룹 선언
resource "aws_eks_node_group" "admin_node_group" {
  ## EKS 클러스터 이름으로 노드 그룹 연결
  cluster_name = aws_eks_cluster.test_eks.name
  
  ## 노드 그룹 이름
  node_group_name = "admin_node_group"

  ## 노드 그룹에 적용할 역활 연결 (위에 선언했음)
  node_role_arn = aws_iam_role.test_eks_service_role.arn

  ## 노드가 생성될 서브넷 지정
  subnet_ids = [
    aws_subnet.test_eks_public_1.id,
    aws_subnet.test_eks_public_2.id
  ]

  ## 컴퓨터 사이즈 설정 (대수)
  scaling_config {
    desired_size = 1
    max_size = 10
    min_size = 1
  }

  ## 아마존 이미지 타입
  ami_type = "AL2_x86_64"

  ## 용량 타입 
  ## ON_DEMAND = 지정된 장비를 계속씀 (비쌈)
  ## SPOT = 언제 꺼질지 모르는 장비를 잠깐 빌려씀 (매우 쌈) 
  capacity_type = "ON_DEMAND"

  ## 컴퓨터 disk 사이즈
  disk_size = 100

  ## 쿠버네티스 버젼 자동 업데이트 안함
  force_update_version = false
  
  ## 노드그룹에 적용할 쿠버네티스 버젼
  version = var.KUBE_VERSION

  ## ec2 인스턴스 타입
  instance_types = ["t3.xlarge"]  
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
    aws_iam_role_policy_attachment.test_eks_ocr_worker_node_policy,
    aws_iam_role_policy_attachment.test_eks_ocr_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}

