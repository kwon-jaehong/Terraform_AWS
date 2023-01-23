
## 퍼블릭 1과 프라이빗1 연결할 nat 생성
resource "aws_nat_gateway" "gw1" {
  # nat 게이트웨이를 엘라스틱 아이피랑 연동
  allocation_id = aws_eip.nat1.id
  subnet_id = aws_subnet.eks_public_1.id
  tags = {
    Name = "NAT 1"
  }
}

resource "aws_nat_gateway" "gw2" {
  # The Allocation ID of the Elastic IP address for the gateway.
  allocation_id = aws_eip.nat2.id

  # The Subnet ID of the subnet in which to place the gateway.
  subnet_id = aws_subnet.eks_public_2.id

  # A map of tags to assign to the resource.
  tags = {
    Name = "NAT 2"
  }
}