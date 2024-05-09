output "domain_name" {
  value = var.domain_name
}

output "sub_domain_name" {
  value = var.alternative_domain_name
}

output "certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}

