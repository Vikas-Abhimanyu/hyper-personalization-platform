variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Jenkins instances"
  type        = string
}

variable "master_instance_type" {
  description = "Jenkins master instance type"
  type        = string
}

variable "worker_instance_type" {
  description = "Jenkins worker instance type"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet for Jenkins servers"
  type        = string
}

variable "jenkins_master_sg_id" {
  description = "Jenkins master security group ID"
  type        = string
}

variable "jenkins_worker_sg_id" {
  description = "Jenkins worker security group ID"
  type        = string
}

variable "jenkins_master_instance_profile" {
  description = "Instance profile for Jenkins master"
  type        = string
}

variable "jenkins_worker_instance_profile" {
  description = "Instance profile for Jenkins worker"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "jenkins_worker_instance_type" {

  description = "Jenkins worker EC2 type"

  type = string

  default = "t3.large"
}

variable "private_subnet_ids" {

  description = "Private subnets for Jenkins workers"

  type = list(string)
}

