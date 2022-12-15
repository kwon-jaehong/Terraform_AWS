variable "instance_username" {
    type = string
    default ="ubuntu"
}
# ssh-keygen -f mykey 으로 폴더에 키 생성
variable "path_to_private_key" {
    type = string
    default ="mykey"
}
variable "path_to_public_key" {
    type = string
    default ="mykey.pub"
}
