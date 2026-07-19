variable "environment" {
  description = "Environment name (dev, staging, prod) - used for resource naming and tagging"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to spread subnets across"
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Whether to provision a NAT Gateway for private subnet egress. Disable in dev to save cost."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
