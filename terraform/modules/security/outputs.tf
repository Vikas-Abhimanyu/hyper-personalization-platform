output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_security_group.eks_cluster.id
}

output "eks_node_security_group_id" {
  description = "EKS worker nodes security group ID"
  value       = aws_security_group.eks_nodes.id
}

output "database_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.database.id
}

output "redis_security_group_id" {
  description = "ElastiCache security group ID"
  value       = aws_security_group.redis.id
}

output "jenkins_master_security_group_id" {
  description = "Jenkins master security group ID"
  value       = aws_security_group.jenkins_master.id
}

output "jenkins_worker_security_group_id" {
  description = "Jenkins worker security group ID"
  value       = aws_security_group.jenkins_worker.id
}