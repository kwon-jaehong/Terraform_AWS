resource "aws_security_group" "gitlab_security_group" {
    name = "gitlab_security_group"
    description = "gitlab vpc security_group config"
    
    vpc_id = "${aws_vpc.main_vpc.id}"
    ## 모든 주소 22포트 접속 허용
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ## 모든 주소 80포트 허용
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        ## 모든 주소 22포트 접속 허용
        cidr_blocks = ["0.0.0.0/0"]
    }
    ## 모든 주소 443포트 허용
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
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
        Name = "gitlab_security_group"
    }

    ## vpc 만들어 지고 설정
    depends_on = [
    aws_vpc.main_vpc
  ]
}
