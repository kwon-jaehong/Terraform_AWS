
# vpc와 연결해줄 인터넷 게이트 웨이 생성
# 인터넷 게이트웨이 없으면, aws vpc와 통신 못함
resource "aws_internet_gateway" "eks_igw" {

  # vpc_id를 통해, 생성과 동시에 연결
  vpc_id = aws_vpc.eks_vpc.id

  # vpc_id 연결 안해도... 테라폼 aws_internet_gateway_attachment로도 연결 가능

  tags = {
    Name = "eks_vpc_igw"
  }
}