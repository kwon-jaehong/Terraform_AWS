
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames ="true"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "gitlab-public" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.AWS_REGION}a"

  tags = {
    Name = "gitlab-public"
  }

  ## vpc 만들어 지고 설정
  depends_on = [
    aws_vpc.main_vpc
  ]
}

## vpc생성하면 디폴트로 인터넷 게이트웨이 생성됨
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main_vpc.id
  
#   depends_on = [
#     aws_vpc.main_vpc
#   ]
# }
