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
