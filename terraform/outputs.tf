# -----------------------------
# EC2 Instance Outputs
# -----------------------------
output "instance_id" {
  value = aws_instance.ubuntu_nginx.id
}

output "instance_private_dns" {
  value = aws_instance.ubuntu_nginx.private_dns
}

output "instance_private_ip" {
  value = aws_instance.ubuntu_nginx.private_ip
}

output "instance_public_dns" {
  value = aws_instance.ubuntu_nginx.public_dns
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_nginx.public_ip
}

output "instance_availability_zone" {
  value = aws_instance.ubuntu_nginx.availability_zone
}

output "instance_tags" {
  value = aws_instance.ubuntu_nginx.tags
}

# -----------------------------
# Security Group Outputs
# -----------------------------
output "security_group_id" {
  value = aws_security_group.nginx_sg.id
}

output "security_group_name" {
  value = aws_security_group.nginx_sg.name
}

output "security_group_vpc_id" {
  value = aws_security_group.nginx_sg.vpc_id
}

output "security_group_ingress_ports" {
  value = [for rule in aws_security_group.nginx_sg.ingress : rule.from_port]
}

output "security_group_egress_ports" {
  value = [for rule in aws_security_group.nginx_sg.egress : rule.from_port]
}

# -----------------------------
# Elastic IP Outputs
# -----------------------------
output "eip_public_ip" {
  value = aws_eip.my_permanent_ip.public_ip
}

output "eip_allocation_id" {
  value = aws_eip.my_permanent_ip.id
}

output "eip_associated_instance" {
  value = aws_eip.my_permanent_ip.instance
}

# -----------------------------
# VPC Outputs
# -----------------------------
data "aws_vpc" "default" {
  default = true
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "vpc_cidr_block" {
  value = data.aws_vpc.default.cidr_block
}

# Get default Security Group for VPC
data "aws_security_group" "default_sg" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

output "vpc_default_security_group_id" {
  value = data.aws_security_group.default_sg.id
}
