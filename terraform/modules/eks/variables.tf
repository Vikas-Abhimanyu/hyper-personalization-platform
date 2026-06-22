variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_sg_id" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "desired_node_count" {
  type = number
}

variable "min_node_count" {
  type = number
}

variable "max_node_count" {
  type = number
}

variable "node_instance_type" {
  type = string
}

variable "capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "name_prefix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}