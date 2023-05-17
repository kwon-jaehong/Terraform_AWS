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
    default = "chunjae_ocr"
}

variable "KUBE_VERSION" {
    type = string
    default = "1.24"
}

variable "PATH_HELM_VALUE" {
    type = string
    default = "../k8s/helm"
}


variable "PATH_NEURON_PLUGIN" {
    type = string
    default = "../k8s/neuron-device-plugin"
}

variable "PATH_ETC" {
    type = string
    default = "../k8s/etc_intsall"
}

variable "PATH_HPA" {
    type = string
    default = "../k8s/hpa"
}
