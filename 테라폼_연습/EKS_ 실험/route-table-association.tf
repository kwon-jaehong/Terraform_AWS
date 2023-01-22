
## 라우팅 테이블과 서브넷 연결
resource "aws_route_table_association" "eks_public1" {
  subnet_id = aws_subnet.eks_public_1.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

resource "aws_route_table_association" "eks_public2" {
  subnet_id = aws_subnet.eks_public_2.id
  route_table_id = aws_route_table.eks_public_route_table.id
}
resource "aws_route_table_association" "eks_private1" {
  subnet_id = aws_subnet.eks_private_1.id
  route_table_id = aws_route_table.eks_private1_route_table.id
}
resource "aws_route_table_association" "eks_private2" {
  subnet_id = aws_subnet.eks_private_2.id
  route_table_id = aws_route_table.eks_private2_route_table.id
}

