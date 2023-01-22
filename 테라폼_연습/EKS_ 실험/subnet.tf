
## 공식 AWS 문서에서는 EKS를 구성할때 최소한 2개의 서브넷, 가용영역을 지정하라고 명시되어있다.
## 나는 그냥 퍼블릭 서브넷으로만 구성하려고 한다.

# 태그관련
## https://velog.io/@ausg/eks-k8s-elb

resource "aws_subnet" "eks_public_1" {
  # 생성된 서브넷과 연결할 vpc id 가져옴
  vpc_id = aws_vpc.eks_vpc.id

  # 사이더블럭 범위
  cidr_block = "192.168.0.0/18"

  # The AZ for the subnet.
  # 가용 영역 지정
  availability_zone = "${var.AWS_REGION}a"

  # 퍼블릭 서브넷이므로 서버 등을 띄울 때 자동으로 퍼블릭 IP가 할당되도록 map_public_ip_on_launch true 지ㅓㅈㅇ
  map_public_ip_on_launch = true


  # A map of tags to assign to the resource.
  # 리소스에 할당할 태그 맵입니다.
  tags = {
    Name                        = "public-${var.AWS_REGION}a"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "eks_public_2" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "192.168.64.0/18"
  availability_zone = "${var.AWS_REGION}c"
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        =  "public-${var.AWS_REGION}c"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "eks_private_1" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "192.168.128.0/18"
  availability_zone = "${var.AWS_REGION}a"
  tags = {
    Name                              = "private-${var.AWS_REGION}a"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "eks_private_2" {
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block = "192.168.192.0/18"
  availability_zone = "${var.AWS_REGION}c"
  tags = {
    Name                              = "private-${var.AWS_REGION}c"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}