# Terraform Guide

## What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool by HashiCorp for provisioning and managing cloud infrastructure.

## Key Concepts

### Providers
Plugins that interact with cloud platforms.
```hcl
provider "aws" {
  region = "us-east-1"
}
```

### Resources
Infrastructure components.
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer"
  }
}
```

### Variables
Input parameters.
```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

### Outputs
Return values.
```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

## Terraform Workflow

1. **Write**: Define infrastructure in HCL
2. **Plan**: Preview changes
3. **Apply**: Make changes
4. **Destroy**: Clean up resources

```bash
terraform init      # Initialize
terraform plan      # Preview
terraform apply     # Apply changes
terraform destroy   # Destroy resources
```

## State Management

Terraform tracks resource state in `terraform.tfstate`.

### Remote State
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Modules

Reusable infrastructure components.
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
}
```

## Best Practices

1. Use remote state storage
2. Implement state locking
3. Use modules for reusability
4. Version your providers
5. Use workspaces for environments
6. Keep sensitive data in variables
7. Use terraform fmt and validate

## Common Resources

### AWS
```hcl
# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# S3 Bucket
resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

### Azure
```hcl
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "my-resources"
  location = "East US"
}

# Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                = "my-vm"
  resource_group_name = azurerm_resource_group.main.name
}
```

### GCP
```hcl
# Compute Instance
resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
}
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize working directory |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy resources |
| `terraform fmt` | Format configuration |
| `terraform validate` | Validate configuration |
| `terraform state list` | List resources in state |
| `terraform import` | Import existing resource |

## Interview Questions

1. What is Terraform state?
2. How does Terraform handle secrets?
3. What are modules in Terraform?
4. How to manage multi-environment deployments?
5. What is the difference between terraform apply and terraform plan?