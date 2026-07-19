module "vpc" {
  source = "../../modules/vpc"

  environment        = "prod"
  cidr_block         = "10.3.0.0/16"
  az_count           = 3
  enable_nat_gateway = true

  tags = {
    Owner      = "platform-team"
    CostCenter = "prod-infra"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
