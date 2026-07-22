# Terraform Best Practices

## Project Structure

```
infrastructure/
  environments/
    dev/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf
    staging/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf
    prod/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf
  modules/
    vpc/
      main.tf
      variables.tf
      outputs.tf
    ec2/
      main.tf
      variables.tf
      outputs.tf
    rds/
      main.tf
      variables.tf
      outputs.tf
  .terraform.lock.hcl
  backend.tf
```

## 1. Remote State Management

Never use local state in production. Always store state remotely with locking.

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

```hcl
# Azure backend
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

# GCS backend
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "prod/networking"
  }
}
```

## 2. Separate State by Component

```
s3://terraform-state/
  dev/
    networking/terraform.tfstate
    compute/terraform.tfstate
    database/terraform.tfstate
  prod/
    networking/terraform.tfstate
    compute/terraform.tfstate
    database/terraform.tfstate
```

Benefits: Blast radius isolation, parallel work, independent locking.

## 3. Use Workspaces for Environments

```hcl
# terraform.tfvars per workspace
# dev.tfvars
instance_type = "t3.micro"
min_size      = 1
max_size      = 2

# prod.tfvars
instance_type = "t3.large"
min_size      = 3
max_size      = 10
```

```bash
terraform workspace new dev
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

## 4. Module Versioning

Always pin module and provider versions.

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
}
```

## 5. Use terraform fmt and validate

Run in CI/CD and pre-commit hooks.

```bash
# Format
terraform fmt -recursive -check

# Validate
terraform validate

# TFLint for additional linting
tflint --config .tflint.hcl
```

### Pre-commit Hook

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint
      - id: terraform_docs
```

## 6. Sensitive Data Handling

Never hardcode secrets in .tf files.

```hcl
# Bad - hardcoded secret
resource "aws_db_instance" "main" {
  password = "supersecret123"
}

# Good - variable with sensitive flag
variable "db_password" {
  type      = string
  sensitive = true
}

# Better - use AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "main" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}
```

Add to .gitignore:
```
*.tfvars
*.tfstate
*.tfstate.backup
.terraform/
```

## 7. Tagging Strategy

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
    Team        = var.team
  }
}

resource "aws_instance" "web" {
  tags = merge(local.common_tags, {
    Name = "web-server"
    Role = "frontend"
  })
}
```

## 8. Use Data Sources for Existing Resources

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_vpc" "existing" {
  tags = {
    Name = "production-vpc"
  }
}
```

## 9. Use locals for Computed Values

```hcl
locals {
  name_prefix = "${var.environment}-${var.project}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
  })

  subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 1),
    cidrsubnet(var.vpc_cidr, 8, 2),
    cidrsubnet(var.vpc_cidr, 8, 3),
  ]
}
```

## 10. Lifecycle Rules

Control resource creation and destruction behavior.

```hcl
resource "aws_db_instance" "main" {
  identifier = "production-db"

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion

    create_before_destroy = true  # Create new before destroying old

    ignore_changes = [
      tags["LastModified"],  # Ignore tag changes
    ]

    replace_triggered_by = [
      aws_security_group.database,
    ]
  }
}
```

## 11. Use Dynamic Blocks

Avoid repetition for repeated nested blocks.

```hcl
variable "ingress_rules" {
  default = [
    { port = 80,  cidr = "0.0.0.0/0", desc = "HTTP" },
    { port = 443, cidr = "0.0.0.0/0", desc = "HTTPS" },
    { port = 22,  cidr = "10.0.0.0/8", desc = "SSH" },
  ]
}

resource "aws_security_group" "web" {
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr]
      description = ingress.value.desc
    }
  }
}
```

## 12. Plan Before Apply

Always review the plan, especially in production.

```bash
terraform plan -out=tfplan
# Review the plan carefully
terraform apply tfplan
```

## 13. Use -target Sparingly

Targeting is for debugging, not regular workflow.

```bash
# Good - debugging a specific resource
terraform apply -target=aws_instance.web

# Bad - using targets to avoid dealing with all changes
# Fix the root cause instead
```

## 14. Documentation

Generate docs automatically.

```bash
# Using terraform-docs
terraform-docs markdown table ./modules/vpc > ./modules/vpc/README.md
```

## CI/CD Pipeline

```yaml
# .github/workflows/terraform.yml
name: Terraform
on: [push, pull_request]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.7.0"

      - name: Terraform Init
        run: terraform init

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -no-color

      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

## Quick Reference Checklist

```
[x] Remote state with encryption
[x] State separated by component
[x] Provider/module versions pinned
[x] terraform fmt in CI
[x] terraform validate in CI
[x] No hardcoded secrets
[x] Consistent tagging
[x] Lifecycle rules for critical resources
[x] Plan reviewed before apply
[x] .gitignore for state and tfvars
[x] Documentation generated
[x] Pre-commit hooks configured
```

## Common Anti-Patterns

| Anti-Pattern | Solution |
|-------------|----------|
| Local state in production | Use remote backend |
| Hardcoded values | Use variables and tfvars |
| No version pinning | Pin all providers and modules |
| Monolithic state file | Split by component |
| Manual `terraform apply` in prod | Use CI/CD with plan review |
| Ignoring `terraform fmt` | Add to pre-commit and CI |
| Storing secrets in tfvars | Use secrets manager |
| Using `-target` regularly | Fix root cause of issues |
| No documentation | Use terraform-docs |
| Skipping `terraform plan` | Always plan before apply |
