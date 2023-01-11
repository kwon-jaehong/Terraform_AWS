variable "ami_id" {
    type = string
    default ="ami-071c33e7823c066b5"
}
variable "git_server_instance_type" {
    type = string
    # https://aws.amazon.com/ko/premiumsupport/knowledge-center/ec2-instance-types-disabled-at-launch/
    # 인스턴스 유형 A1, T4g, M6g, C6g 및 R6g는 AWS Graviton 프로세서를 사용합니다. AWS Graviton 프로세서는 x86_64(AMD64) 대신 aarch64(ARM64) 아키텍처를 사용합니다.
    # default ="t4g.medium"
    
    default ="t3.medium"
}



# ssh-keygen -f mykey 으로 폴더에 키 생성
variable "path_to_private_key" {
    type = string
    default ="key_file/mykey"
}
variable "path_to_public_key" {
    type = string
    default ="key_file/mykey.pub"
}
variable "gitlab_setup_script" {
    type = string
    default ="script/git_setup.sh"
}


variable "AWS_ACCKEY" {
    type = string
}
variable "AWS_SECRKEY" {
    type = string
}
variable "AWS_REGION" {
    type = string
}
