variable "name_prefix" {

  description = "Resource naming prefix"

  type = string
}

variable "common_tags" {

  description = "Common tags"

  type = map(string)
}