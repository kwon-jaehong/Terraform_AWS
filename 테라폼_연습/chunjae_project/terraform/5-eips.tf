
# 엘라스틱 ip(고정 ip) 생성
## 프라이빗존과 퍼블릭을 연결할 NAT 게이트웨이에 적용하기 위함
resource "aws_eip" "nat1" {
  # EIP may require IGW to exist prior to association. 
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.eks_igw]
}

resource "aws_eip" "nat2" {
# EIP는 IGW가 연결되기 전에 존재하도록 요구할 수 있습니다.
   # depends_on을 사용하여 IGW에 대한 명시적 종속성을 설정합니다.
  depends_on = [aws_internet_gateway.eks_igw]
}


# ## nlb용 eip 2개 생성
# resource "aws_eip" "nlb-ip-1" {
#   depends_on = [aws_internet_gateway.eks_igw]
#   # lifecycle {
#   #  prevent_destroy = true
#   # }
# }

# resource "aws_eip" "nlb-ip-2" {
#   depends_on = [aws_internet_gateway.eks_igw]
#   # lifecycle {
#   #  prevent_destroy = true
#   # }
# }