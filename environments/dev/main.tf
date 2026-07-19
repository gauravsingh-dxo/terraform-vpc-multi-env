module "vpc" {
  source = "../../modules/vpc"

  environment        = "dev"
  cidr_block         = "10.1.0.0/16"
  az_count           = 2
  enable_nat_gateway = false # no NAT in dev - private subnets don't need internet egress, saves ~$32/mo

  tags = {
    Owner = "platform-team"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
