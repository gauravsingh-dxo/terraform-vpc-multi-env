# terraform-vpc-multi-env

A reusable Terraform VPC module deployed independently across dev, staging, and prod using a modules + environment-directories structure — instead of copy-pasted `.tf` files or Terraform workspaces sharing one backend.

## What this demonstrates

- Writing a reusable module (`modules/vpc`) that contains zero environment-specific values
- Isolating state per environment via separate S3 backend keys + DynamoDB locking
- Using `count` and `dynamic` blocks to conditionally provision resources (e.g. skipping the NAT Gateway in dev to cut cost)
- Consistent tagging strategy applied through a `locals` block instead of repeated per-resource tags
- Environments that differ in real, meaningful ways (AZ count, NAT gateway, CIDR ranges) rather than superficial workspace variables

## Architecture

```
                     ┌─────────────────────┐
                     │   modules/vpc/       │
                     │   (no hardcoded env) │
                     └──────────┬───────────┘
                                │
            ┌───────────────────┼───────────────────┐
            │                   │                   │
  environments/dev     environments/staging   environments/prod
  10.1.0.0/16, 2 AZ     10.2.0.0/16, 2 AZ      10.3.0.0/16, 3 AZ
  no NAT gateway        NAT gateway             NAT gateway
  own S3 state key       own S3 state key        own S3 state key
```

Each environment is a separate root module with its own backend, so a `terraform apply` in dev can never touch prod state — there's no shared workspace where a wrong `terraform workspace select` silently applies against the wrong environment.

## Prerequisites

- Terraform >= 1.7
- An AWS account with permissions to create VPCs, subnets, NAT gateways, and route tables
- An existing S3 bucket + DynamoDB table for remote state (see `backend.tf` in each environment — replace `your-company-tfstate` with your actual bucket)

## Usage

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

Repeat in `environments/staging` or `environments/prod` as needed — each is fully independent.

## Design decisions

**Why directories instead of Terraform workspaces?** Workspaces share the same `.tf` code and the same backend configuration by default. That's fine until dev and prod need genuinely different resources — at which point you end up with `count = terraform.workspace == "prod" ? 1 : 0` conditionals scattered through the code, which is harder to read than three explicit environment directories.

**Why is `enable_nat_gateway` a variable instead of hardcoded per environment?** It's still set explicitly per environment (`false` in dev, `true` in staging/prod), but exposing it as a module variable means a future environment (e.g. a QA environment that does need internet egress) can opt in without a module change.

**What I'd add before this touches real production traffic:** VPC flow logs, a `terraform-docs`-generated variables/outputs table, and moving the backend bucket name into a `-backend-config` flag passed at `init` time so it's not hardcoded per environment file.
