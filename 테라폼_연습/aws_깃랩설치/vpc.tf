
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames ="true"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "gitlab_public" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = "true"
  
  ## 사용 존
  availability_zone = "${var.AWS_REGION}a"

  tags = {
    Name = "gitlab_public"
  }

  ## vpc 만들어 지고 설정
  depends_on = [
    aws_vpc.main_vpc
  ]
}

## 인터넷 게이트 웨이 선언
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

## 라우팅 테이블 선언
resource "aws_route_table" "gitlab_public_rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "gitlab_public_rtb"
  }
}

## 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "gitlab_subnet_a_association" {
  subnet_id = aws_subnet.gitlab_public.id
  route_table_id = aws_route_table.gitlab_public_rtb.id
}