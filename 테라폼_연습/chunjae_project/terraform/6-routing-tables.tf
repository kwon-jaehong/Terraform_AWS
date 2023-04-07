
resource "aws_route_table" "eks_public_route_table" {
  ## 라우팅 테이블 생성과 동시에 vpc 연결
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # 인터넷 게이트 웨이 연결
    gateway_id = aws_internet_gateway.eks_igw.id
    # 이 라우팅 테이블은 모든 트래픽을 인터넷 게이트웨이로 보내도록 구성됩니다
  }

  tags = {
    Name = "eks_public"
  }
}


resource "aws_route_table" "eks_private1_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    
    ## NAT 게이트 웨이로 연결
    nat_gateway_id = aws_nat_gateway.gw1.id

     # 이 라우팅 테이블은 모든 트래픽을 NAT 게이트웨이로 보내도록 구성됩니다
  }
  tags = {
    Name = "private1"
  }
}

resource "aws_route_table" "eks_private2_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    ## NAT 게이트 웨이로 연결
    nat_gateway_id = aws_nat_gateway.gw2.id
    # 이 라우팅 테이블은 모든 트래픽을 NAT 게이트웨이로 보내도록 구성됩니다
  }
  tags = {
    Name = "private2"
  }
}

