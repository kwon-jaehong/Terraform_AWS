# ## aws 키 페어 생성 후, 파일로 키페어를 가르킴
# resource "aws_key_pair" "mykey"{
#     key_name = "mykey"
#     public_key = "${file("${var.path_to_public_key}")}"
# }

# # example1은 고유값이므로 중복되지 않는다. 하나의 리소스 유형에 같은 이름을(example1) 가질수 없다
# resource "aws_instance" "example" {
#     ## ami는 ec2를 생성할때 사용할 이미지
#     ami = "ami-003bb1772f36a39a3"
#     instance_type = "t2.micro"
#     ## 현폴더에서 mykey파일을 연결 파일로 사용
#     key_name = "${aws_key_pair.mykey.key_name}"

#     ## 소프트웨어 설치나 환경 설정 파일을 선언
#     provisioner "file" {
#     source = "script.sh"
#     destination = "/tmp/script.sh"
#     }
    
#     ## 루트 권한으로 실행 및 권한 주기
#     provisioner "remote-exec" {
#         inline = [
#             "sudo chmod +x /tmp/script.sh",
#             "sudo /tmp/script.sh",
#         ]
#     }
    
#     ## 생성된인스턴스에 접근
#     # connetion의 기본값은 ssh이다.
#     connection {
#         user = "${var.instance_username}"
#         private_key = "${file("${var.path_to_private_key}")}"
#         host = self.public_ip
#     }
# }
