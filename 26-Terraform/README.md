# Terraform

This section covers Terraform, an Infrastructure as Code (IaC) tool for provisioning and managing cloud infrastructure.

## Topics Covered

### Core Concepts
- Providers (AWS, Azure, GCP)
- Resources and data sources
- Variables and outputs
- State management
- Modules for reusability

### Workflow
1. `terraform init` - Initialize
2. `terraform plan` - Preview changes
3. `terraform apply` - Apply changes
4. `terraform destroy` - Clean up

### Best Practices
- Remote state storage
- State locking
- Module versioning
- Workspaces for environments
- Sensitive data handling

## Files

| File | Description |
|------|-------------|
| `terraform-guide.md` | Comprehensive Terraform guide |

## Example Usage

```hcl
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer"
  }
}

# S3 bucket
resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
}
```