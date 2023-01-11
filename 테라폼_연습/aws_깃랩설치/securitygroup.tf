resource "aws_security_group" "gitlab_security_group" {
    name = "gitlab_allow-ssh"
    description = "gitlab vpc security_group config"
    
    vpc_id = "${aws_vpc.main_vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        ## 모든 주소 22포트 접속 허용
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        ## 포트 0은 모든 포트 허용
        from_port = 0
        to_port = 0
        ## -1은 모든 프로토콜
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow-ssh"
    }

    ## vpc 만들어 지고 설정
    depends_on = [
    aws_vpc.main_vpc
  ]
}
