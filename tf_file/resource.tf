provider "aws"{

}

<<<<<<< HEAD
variable "AWS_REGION" {
    type = string
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
    ami = var.AMIS[var.AWS_REGION]
    instance_type = "t2.micro"
}
resource "aws_instance" "example2" {
    ami = var.AMIS[var.AWS_REGION]
    instance_type = "t2.small"
}
resource "aws_instance" "example3" {
=======
variable "AWS_REGION"{
    type = string
}

resource "aws_instance" "example" {
>>>>>>> a3c277fb0af518d7d89888bd52ced3ebf82f73f1
    ami = var.AMIS[var.AWS_REGION]
    instance_type = "t2.micro"
}
