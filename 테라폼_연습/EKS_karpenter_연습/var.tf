variable "AWS_ACCKEY" {
    type = string
}
variable "AWS_SECRKEY" {
    type = string
}
variable "AWS_REGION" {
    type = string
}

variable "cluster_name" {
    type = string
    default = "demo"
}

variable "KUBE_VERSION" {
    type = string
    default = "1.22"
}