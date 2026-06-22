# --- Hosted Zone ---

resource "aws_route53_zone" "this" {

  name = var.domain_name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-hosted-zone"
    }
  )
}

# --- Optional Root Alias Record ---

resource "aws_route53_record" "root" {

  count = var.create_root_record ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}