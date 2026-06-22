resource "aws_wafv2_web_acl" "this" {

  count = var.enable_waf ? 1 : 0

  name  = "${var.name_prefix}-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf"
    sampled_requests_enabled   = true
  }

  # --- AWS Common Rules ---

  rule {

    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {

      managed_rule_group_statement {
        vendor_name = "AWS"
        name         = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRules"
      sampled_requests_enabled   = true
    }
  }

  # --- Known Bad Inputs ---

  rule {

    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {

      managed_rule_group_statement {
        vendor_name = "AWS"
        name         = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  # --- SQL Injection Protection ---

  rule {

    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {

      managed_rule_group_statement {
        vendor_name = "AWS"
        name         = "AWSManagedRulesSQLiRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLi"
      sampled_requests_enabled   = true
    }
  }

  # --- Rate Limiting ---

  rule {

    name     = "RateLimit"
    priority = 100

    action {
      block {}
    }

    statement {

      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-waf"
    }
  )
}

# --- Associate WAF with ALB ---

resource "aws_wafv2_web_acl_association" "this" {

  count = var.enable_waf ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this[0].arn
}