variable "perfil" {
    default = "default"
}

variable "region" {
    default = "us-east-1"
}

variable "vpc" {

    default = "vpc-0d73eea04c26a6b44"

}

variable "ami" {

    default = "ami-0cff7528ff583bf9a"

}

variable "subPrivateA" {
    default = "10.0.2.0/24"
}
variable "subPrivateB" {
    default = "10.0.3.0/24"
}

variable "subPublicB" {
    default = "10.0.1.0/24"
}
variable "subPublicA" {
    default = "10.0.0.0/24"
}

variable "instance_count" {
    default = "2"
}

variable "dnsSupport" {
    default = true
}

variable "EKSClusterName" {
    default = "bitbeat-eks-cluster"
}

variable "WNName" {
    default = "bitbeatWN"
}

/*
variable "arn_RoleEKS" ´{
    default = "arn:aws:iam::128364418855:role/LabRole"
}
*/