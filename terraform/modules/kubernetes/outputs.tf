# --- Monitoring ---

output "monitoring_namespace" {
  description = "Monitoring namespace"
  value       = "monitoring"
}

# --- Logging ---

output "logging_namespace" {
  description = "Logging namespace"
  value       = "logging"
}

# --- External Secrets ---

output "external_secrets_namespace" {
  description = "External Secrets namespace"
  value       = "external-secrets"
}

# --- Velero ---

output "velero_namespace" {
  description = "Velero namespace"
  value       = "velero"
}

# --- Cert Manager ---

output "cert_manager_namespace" {
  description = "Cert Manager namespace"
  value       = "cert-manager"
}