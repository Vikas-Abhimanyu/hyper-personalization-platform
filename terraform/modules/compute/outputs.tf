output "jenkins_master_instance_id" {
  description = "Jenkins master instance ID"
  value       = aws_instance.jenkins_master.id
}

output "jenkins_master_private_ip" {
  description = "Jenkins master private IP"
  value       = aws_instance.jenkins_master.private_ip
}

output "jenkins_master_public_ip" {
  description = "Jenkins master public IP"
  value       = aws_instance.jenkins_master.public_ip
}
