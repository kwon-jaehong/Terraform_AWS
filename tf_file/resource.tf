
## 외부파일에서 변수를 가져오기 위해 미리 변수를 선언해줘야함
variable "AWS_ACCKEY" {
    type = string
}
variable "AWS_SECRKEY" {
    type = string
}
variable "AWS_REGION" {
    type = string
}

provider "aws"{
    access_key = var.AWS_ACCKEY
    secret_key = var.AWS_SECRKEY
    region = var.AWS_REGION
}


variable "AMIS" {
    type = map(string)
    default = {
        ap-northeast-2 = "my ami"
    }
    # 디폴트 출력은 var.AMIS[var.AWS_REGION]으로 출력
}

## example1은 고유값이므로 중복되지 않는다.
## 하나의 리소스 유형에 같은 이름을 가질수 없다
resource "aws_instance" "example1" {
    ## ami는 ec2를 생성할때 사용할 이미지
    ami = "ami-003bb1772f36a39a3"
    instance_type = "t2.micro"
}
resource "aws_instance" "example2" {
    ami = "ami-003bb1772f36a39a3"
    instance_type = "t2.micro"
}
