output "web_acl_id" {
  description = "AWS WAF Web ACL ID"

  value = var.enable_waf ? aws_wafv2_web_acl.this[0].id : null
}

output "web_acl_arn" {
  description = "AWS WAF Web ACL ARN"

  value = var.enable_waf ? aws_wafv2_web_acl.this[0].arn : null
}

output "web_acl_name" {
  description = "AWS WAF Web ACL name"

  value = var.enable_waf ? aws_wafv2_web_acl.this[0].name : null
}