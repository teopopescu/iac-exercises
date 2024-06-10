# ########################## General ##########################
region           = "us-west-2"
vpc_id           = "vpc-08862080241664926"
vpc_name         = "test-vpc"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
# environment      = "test"

# ########################## Network ##########################
cidr             = "10.0.0.0/16"
# public_subnets   = ["172.30.0.0/24", "172.30.1.0/24", "172.30.2.0/24"]
# private_subnets  = ["172.30.3.0/24", "172.30.4.0/24", "172.30.5.0/24"]
# database_subnets = ["172.30.6.0/24", "172.30.7.0/24", "172.30.8.0/24"]


# ########################## Tags ##########################
default_tags = {
  Terraform   = "true"
  Environment = "test-environment"
  Deployment = "test"
  Owner = "Teo"
}

# ######################## EKS ##############################
# desired_capacity = "1" 
# max_capacity     = "1" 
# min_capacity     = "1" 
# instance_types   = ["c5.4xlarge"]

# ########################## Secrets ##########################
# secrets = {
#   "Environment" = "test"
# }
