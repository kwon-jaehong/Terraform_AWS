
resource "aws_route_table" "eks_public_route_table" {
  ## 라우팅 테이블 생성과 동시에 vpc 연결
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # 인터넷 게이트 웨이 연결
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  # A map of tags to assign to the resource.
  tags = {
    Name = "eks_public"
  }
}
