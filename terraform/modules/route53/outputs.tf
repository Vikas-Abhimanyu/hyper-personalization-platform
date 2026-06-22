output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.this.zone_id
}

output "hosted_zone_name" {
  description = "Route53 hosted zone name"
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "Route53 name servers"
  value       = aws_route53_zone.this.name_servers
}