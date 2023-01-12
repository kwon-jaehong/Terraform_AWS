## 키생성
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# aws 키페어에 퍼블릭키 등록
resource "aws_key_pair" "mykey" {
  key_name   = "aws_key"
  public_key = tls_private_key.pk.public_key_openssh
}

# 키.pem 파일을 생성하고 로컬에 다운로드.
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.mykey.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}


resource "aws_instance" "gitlab_server_instance" {
    ## ami는 ec2를 생성할때 사용할 이미지
    ami = var.ami_id
    instance_type = var.git_server_instance_type
    
    subnet_id = "${aws_subnet.gitlab_public.id}"
    vpc_security_group_ids = ["${aws_security_group.gitlab_security_group.id}"]  
    key_name = "${aws_key_pair.mykey.key_name}"

    root_block_device {
    volume_type           = "gp2"
    volume_size           = "30"
    }

    ## 루트 권한으로 실행 및 권한 주기
    provisioner "remote-exec" {
        inline = [
            "echo 접속 확인",
        ]
    }

    # connetion의 기본값은 ssh이다.
    connection {
        user = "ubuntu"
        private_key = "${file("${aws_key_pair.mykey.key_name}.pem")}"
        host = self.public_ip
    }
    
    tags = {
        Name = "gitlab_server"
    }
}

## 러너 인스턴스 선언
resource "aws_instance" "gitlab_runner_instance" {
    count = 2
    ## ami는 ec2를 생성할때 사용할 이미지
    ami = var.ami_id
    instance_type = var.git_runner_instance_type    
    subnet_id = "${aws_subnet.gitlab_public.id}"
    vpc_security_group_ids = ["${aws_security_group.gitlab_security_group.id}"]  
    key_name = "${aws_key_pair.mykey.key_name}"

    ## 루트 권한으로 실행 및 권한 주기
    provisioner "remote-exec" {
        inline = [
            "echo 접속 확인",
        ]
    }

    # connetion의 기본값은 ssh이다.
    connection {
        user = "ubuntu"
        private_key = "${file("${aws_key_pair.mykey.key_name}.pem")}"
        host = self.public_ip
    }
    
    tags = {
        Name = "gitlab_runner-${count.index+1}"
    }
}














# # example1은 고유값이므로 중복되지 않는다. 하나의 리소스 유형에 같은 이름을(example1) 가질수 없다
# resource "aws_instance" "example" {
#     ## ami는 ec2를 생성할때 사용할 이미지
#     ami = "ami-003bb1772f36a39a3"
#     instance_type = var.git_instance_type
#     ## 현폴더에서 mykey파일을 연결 파일로 사용
#     key_name = "${aws_key_pair.mykey.key_name}"

#     ## 소프트웨어 설치나 환경 설정 파일을 선언 및 복사
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
