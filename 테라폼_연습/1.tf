#기본적인 변수 선언
variable "myvar" {
  type        = string
  default     = "안녕하세요"
  description = "description"
}

## dict형태 변수 선언
variable "mymap1" {
  type        = map(string)
  default     = {mykey = "my value",mykey2 = "my value2"}
  # terraform console 명령어
  # var.mymap1['mykey']
}

## list형태 변수 선언
variable "mylist" {
  type        = list(string)
  default     = ["my value","my value2"]
  # terraform console 명령어
  # var.mylist[0]
  #  element(var.mylist,1) 형태로도 가능함
  # slice(var.mylist,0,1) 슬라이싱도 가능
}


variable "a-string" {
    type = string
}
variable "a-numer" {
    type = number
}
variable "true-or-false"{
    type = bool
}
