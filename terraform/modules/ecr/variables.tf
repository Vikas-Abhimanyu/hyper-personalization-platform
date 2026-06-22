variable "repository_names" {

  description = "ECR repositories"

  type = list(string)
}

variable "common_tags" {

  description = "Common tags"

  type = map(string)
}