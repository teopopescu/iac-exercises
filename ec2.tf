locals {
  name   = "complete-example-instances"
  region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = module.vpc.azs

  user_data = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  }
}


 module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = module.vpc.vpc_cidr_block
  availability_zone = "eu-west-1a"
  tags = {
    Name = "tf-example"
  }
}

#   AMI lookup

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "example_web_server" {
  ami           = data.aws_ami.ubuntu.id
  availability_zone = "eu-west-1a"
  instance_type = "t2.micro"
#   subnet_id =  element(module.vpc.private_subnets, 1)
  subnet_id =  aws_subnet.my_subnet.id
  vpc_security_group_ids      = [module.security_group.security_group_id]

#   iam_role_description=""
#   create_iam_instance_profile=""
#   iam_role_policies=""

  
  tags = {
    Name = "ExampleInstance"
  }
}

/*
Good example reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/v5.6.1/examples/complete/main.tf

*/

################################################################################
# EC2 Module - multiple instances with `for_each`
################################################################################

# locals {
#   multiple_instances = {
#     one = {
#       instance_type     = "t3.micro"
#     #   availability_zone = element(module.vpc.azs, 0)
#     #   subnet_id         = element(module.vpc.private_subnets, 0)
#       availability_zone = module.vpc.azs[0]
#       subnet_id         = module.vpc.private_subnets[1]
#       root_block_device = [
#         {
#           encrypted   = true
#           volume_type = "gp3"
#           throughput  = 200
#           volume_size = 50
#           tags = {
#             Name = "my-root-block"
#           }
#         }
#       ]
#     }
#     two = {
#       instance_type     = "t3.small"
#       availability_zone = module.vpc.azs[1]
#       subnet_id         = module.vpc.private_subnets[1]
#     #   availability_zone = module.vpc.azs[1]
#     #   subnet_id         = module.vpc.private_subnets[1]
#       root_block_device = [
#         {
#           encrypted   = true
#           volume_type = "gp2"
#           volume_size = 50
#         }
#       ]
#     }
#     three = {
#       instance_type     = "t3.medium"
#       availability_zone = module.vpc.azs[2]
#       subnet_id         = module.vpc.private_subnets[2]
#     }
#   }
# }
