# data "aws_ip_ranges" "kor_ec2" {
#     ## 리전 서울에서 EC2 서비스만 필터링
#     regions = ["ap-northeast-2"]
#     services = ["ec2"]
# }

# resource "aws_security_group" "from_kor_ec2" {
#     name = "from_kor_ec2"

#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         ## CIDR 블록을 데이터 소스에서 가져옴
#         cidr_blocks = "${data.aws_ip_ranges.kor_ec2.cidr_blocks}"
#     }
#     tags =  {
#         CreteDate = "${data.aws_ip_ranges.kor_ec2.create_date}"
#         SyncToken = "${data.aws_ip_ranges.kor_ec2.sync_token}"
#     }
# }
