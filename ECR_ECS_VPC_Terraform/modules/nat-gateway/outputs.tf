output "eip_association_info" {
  value = aws_eip.eip_nat_gateway_az1.association_id
}
