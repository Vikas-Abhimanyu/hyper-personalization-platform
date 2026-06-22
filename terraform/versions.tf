terraform {

  required_version = ">= 1.11.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.6"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}