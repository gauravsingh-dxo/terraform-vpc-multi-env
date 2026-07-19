module "vpc" {
  source = "../../modules/vpc"

  environment        = "staging"
  cidr_block         = "10.2.0.0/16"
  az_count           = 2
  enable_nat_gateway = true

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
