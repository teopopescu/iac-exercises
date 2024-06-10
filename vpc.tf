locals {
  network_acls = {

    default_inbound = [
      {
        rule_no    = 100
        action     = "deny"
        from_port  = 3389
        to_port    = 3389
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
      },

      {
        rule_no    = 101
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      }

    ]

    default_outbound = [

      {
        rule_no    = 100
        action     = "allow"
        from_port  = 0
        to_port    = 0
        protocol   = "-1"
        cidr_block = "0.0.0.0/0"
      }
    ]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["private*"]  # Adjust the filter based on your tags
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["public*"]  # Adjust the filter based on your tags
  }
}

output "private_subnets" {
  value = data.aws_subnets.private.ids
}

output "public_subnets" {
  value = data.aws_subnets.public.ids
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
#   cidr = var.cidr

  azs             = var.availability_zones
  private_subnets = data.aws_subnets.private.ids
  public_subnets  =data.aws_subnets.public.ids
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  enable_nat_gateway      = true
#   single_nat_gateway      = true
  enable_vpn_gateway      = false
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false



  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "example" {
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}
