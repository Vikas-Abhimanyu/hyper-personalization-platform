# --- Monitoring Namespace ---

resource "kubernetes_namespace" "monitoring" {

  metadata {
    name = "monitoring"
  }
}

# --- Logging Namespace ---

resource "kubernetes_namespace" "logging" {

  metadata {
    name = "logging"
  }
}

# --- External Secrets Namespace ---

resource "kubernetes_namespace" "external_secrets" {

  metadata {
    name = "external-secrets"
  }
}

# --- Velero Namespace ---

resource "kubernetes_namespace" "velero" {

  metadata {
    name = "velero"
  }
}

# --- cert-manager Namespace ---

resource "kubernetes_namespace" "cert_manager" {

  metadata {
    name = "cert-manager"
  }
}

# --- Storage Class (gp3) ---

resource "kubernetes_storage_class_v1" "gp3" {

  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = "gp3"
  }

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  allow_volume_expansion = true
}