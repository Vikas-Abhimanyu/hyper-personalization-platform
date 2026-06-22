# --- AWS Provider ---

provider "aws" {

  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# --- Kubernetes Provider ---

provider "kubernetes" {

  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--region",
      var.aws_region,
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}

# --- Helm Provider ---

provider "helm" {

  kubernetes {

    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      args = [
        "eks",
        "get-token",
        "--region",
        var.aws_region,
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}