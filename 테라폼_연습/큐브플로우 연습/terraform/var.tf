variable "AWS_ACCKEY" {
    type = string
}
variable "AWS_SECRKEY" {
    type = string
}
variable "AWS_REGION" {
    type = string
}

variable "EKS_NAME" {
    type = string
    default = "test_eks"
}

variable "KUBE_VERSION" {
    type = string
    default = "1.25"
}
