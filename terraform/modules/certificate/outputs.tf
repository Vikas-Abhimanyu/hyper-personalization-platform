output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = aws_acm_certificate.this.arn
}

output "certificate_domain_name" {
  description = "Primary certificate domain"
  value       = aws_acm_certificate.this.domain_name
}