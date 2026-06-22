variable "cluster_name" {}
variable "kafka_version" { default = "3.7.0" }
variable "number_of_broker_nodes" { default = 3 }
variable "instance_type" { default = "kafka.m7g.large" }
variable "volume_size" { default = 1000 }
variable "private_subnet_ids" { type = list(string) }
variable "security_group_id" {}
variable "kms_key_arn" {}
variable "cloudwatch_log_group" {}
variable "common_tags" { type = map(string) }
