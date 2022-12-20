
variable "azs" {
  description = "사용가능한 존에 서브넷을 적용할 영역"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}


resource "aws_subnet" "public_1" {
  # vpc id 가져옴
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.0.0/18"

  # The AZ for the subnet.
  availability_zone = "${var.azs[0]}"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "public-${var.azs[0]}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "public_2" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.64.0/18"

  # The AZ for the subnet.
  availability_zone = "${var.azs[1]}"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        =  "public-${var.azs[1]}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "private_1" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.128.0/18"

  # The AZ for the subnet.
  availability_zone = "${var.azs[0]}"

  # A map of tags to assign to the resource.
  tags = {
    Name                              = "private-${var.azs[0]}"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private_2" {
  # The VPC ID
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = "192.168.192.0/18"

  # The AZ for the subnet.
  availability_zone = "${var.azs[1]}"

  # A map of tags to assign to the resource.
  tags = {
    Name                              = "private-${var.azs[1]}"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}