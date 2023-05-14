
#### 라우팅 테이블과 서브넷 연결


## 퍼블릭 서브넷과 퍼블릭 라우팅 테이블과 연결
resource "aws_route_table_association" "test_eks_public1" {
  subnet_id = aws_subnet.test_eks_public_1.id
  route_table_id = aws_route_table.test_eks_public_route_table.id
}
resource "aws_route_table_association" "test_eks_public2" {
  subnet_id = aws_subnet.test_eks_public_2.id
  route_table_id = aws_route_table.test_eks_public_route_table.id
}


## 프라이빗 서브넷과 프라이빗 라우팅 테이블과 연결
resource "aws_route_table_association" "test_eks_private1" {
  subnet_id = aws_subnet.test_eks_private_1.id
  route_table_id = aws_route_table.test_eks_private1_route_table.id
}
resource "aws_route_table_association" "test_eks_private2" {
  subnet_id = aws_subnet.test_eks_private_2.id
  route_table_id = aws_route_table.test_eks_private2_route_table.id
}

