variable "cluster_name" {
type = string
}

variable "vpc_cidr" {
type = string
}

variable "azs" {
type = list(string)

validation {
condition     = length(var.azs) >= 2
error_message = "At least two AZs are required."
}
}

variable "public_subnet_cidrs" {
type = list(string)
}

variable "private_subnet_cidrs" {
type = list(string)
}

variable "nat_gateway_count" {
type = number
}

variable "name_prefix" {
type = string
}

variable "common_tags" {
type = map(string)
}
