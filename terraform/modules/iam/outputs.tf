output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "EKS node role ARN"
  value       = aws_iam_role.eks_nodes.arn
}

output "jenkins_master_instance_profile" {
  description = "Jenkins master instance profile"
  value       = aws_iam_instance_profile.jenkins_master.name
}

output "jenkins_worker_instance_profile" {
  description = "Jenkins worker instance profile"
  value       = aws_iam_instance_profile.jenkins_worker.name
}

output "terraform_execution_role_arn" {
  description = "Terraform execution role ARN"
  value       = aws_iam_role.terraform_execution.arn
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.project_key.arn
}

output "alb_ingress_irsa_role_arn" {
  description = "ALB Ingress Controller IRSA role ARN"
  value       = aws_iam_role.alb_ingress_irsa.arn
}

output "cluster_autoscaler_irsa_role_arn" {
  description = "Cluster Autoscaler IRSA role ARN"
  value       = aws_iam_role.cluster_autoscaler_irsa.arn
}

output "external_secrets_irsa_role_arn" {
  description = "External Secrets Operator IRSA role ARN"
  value       = aws_iam_role.external_secrets_irsa.arn
}

output "velero_irsa_role_arn" {
  description = "Velero IRSA role ARN"
  value       = aws_iam_role.velero_irsa.arn
}
