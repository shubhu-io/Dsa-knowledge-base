# Terraform Commands Reference

## Core Workflow Commands

### terraform init

Initialize a new or existing Terraform working directory. Downloads providers and modules.

```bash
terraform init

# With upgrade
terraform init -upgrade

# Specify backend config
terraform init -backend-config="bucket=my-state-bucket"

# Reconfigure backend
terraform init -reconfigure
```

### terraform plan

Preview changes before applying. Shows what will be created, modified, or destroyed.

```bash
terraform plan

# Save plan to file
terraform plan -out=tfplan

# Target specific resources
terraform plan -target=aws_instance.web

# Variable values
terraform plan -var="region=us-west-2"
terraform plan -var-file="prod.tfvars"

# Destroy plan
terraform plan -destroy
```

### terraform apply

Apply changes to infrastructure.

```bash
terraform apply

# Apply saved plan
terraform apply tfplan

# Auto-approve (CI/CD)
terraform apply -auto-approve

# Target specific resources
terraform apply -target=aws_instance.web

# With variables
terraform apply -var="instance_type=t3.large"
```

### terraform destroy

Destroy all resources managed by Terraform.

```bash
terraform destroy

# Target specific resources
terraform destroy -target=aws_instance.web

# Auto-approve
terraform destroy -auto-approve
```

## State Management Commands

| Command | Description |
|---------|-------------|
| `terraform state list` | List all resources in state |
| `terraform state show <resource>` | Show resource details |
| `terraform state mv <src> <dst>` | Move/rename resource |
| `terraform state rm <resource>` | Remove from state |
| `terraform state pull` | Pull state to stdout |
| `terraform state push <file>` | Push state from file |

```bash
# List all managed resources
terraform state list

# Show details of a resource
terraform state show aws_instance.web

# Rename a resource in state
terraform state mv aws_instance.web aws_instance.web_server

# Remove resource from state (keep actual resource)
terraform state rm aws_instance.old_resource

# Import existing resource into state
terraform import aws_instance.web i-1234567890abcdef0
terraform import 'aws_s3_bucket.data["logs"]' my-logs-bucket
```

## Formatting and Validation

```bash
# Format HCL files
terraform fmt

# Format recursively
terraform fmt -recursive

# Check without modifying
terraform fmt -check

# Validate configuration
terraform validate

# JSON format
terraform fmt -json
```

## Output Commands

```bash
# Show all outputs
terraform output

# Show specific output
terraform output instance_ip

# JSON output
terraform output -json

# Raw output (for scripting)
terraform output -raw instance_ip
```

## Workspace Commands

Workspaces manage multiple state files for the same configuration.

```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new staging

# Switch workspace
terraform workspace select production

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete old-env
```

```hcl
# Use workspace name in configuration
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "production" ? "t3.medium" : "t3.micro"
  tags = {
    Environment = terraform.workspace
  }
}
```

## Provider and Module Commands

```bash
# Upgrade providers
terraform init -upgrade

# Lock provider versions
terraform providers lock

# List provider dependencies
terraform providers

# Download modules
terraform get

# Update modules
terraform get -update
```

## Import and Move

```bash
# Import existing resource
terraform import aws_instance.web i-1234567890abcdef0

# Import with ID mapping
terraform import 'aws_s3_bucket.data["logs"]' my-logs-bucket

# Move resource in configuration
terraform state mv aws_instance.old aws_instance.new

# Move to different module
terraform state mv aws_instance.web module.compute.aws_instance.web

# Replace resource (force recreation)
terraform apply -replace=aws_instance.web
```

## Graph and Show

```bash
# Generate dependency graph
terraform graph > graph.dot

# Visualize graph (requires Graphviz)
terraform graph | dot -Tpng > graph.png

# Show current state
terraform show

# Show as JSON
terraform show -json
```

## Complete Command Reference

| Command | Description | Common Flags |
|---------|-------------|--------------|
| `init` | Initialize directory | `-upgrade`, `-reconfigure` |
| `plan` | Preview changes | `-out`, `-target`, `-var`, `-destroy` |
| `apply` | Apply changes | `-auto-approve`, `-target`, `-parallelism` |
| `destroy` | Destroy resources | `-auto-approve`, `-target` |
| `fmt` | Format files | `-recursive`, `-check`, `-diff` |
| `validate` | Validate config | |
| `output` | Show outputs | `-json`, `-raw` |
| `state list` | List resources | |
| `state show` | Resource details | |
| `state mv` | Move resource | |
| `state rm` | Remove from state | |
| `import` | Import resource | |
| `workspace list` | List workspaces | |
| `workspace new` | Create workspace | |
| `workspace select` | Switch workspace | |
| `graph` | Dependency graph | |
| `providers` | List providers | |
| `refresh` | Update state file | `-target` |

## Scripting Examples

### Deploy to Multiple Environments

```bash
#!/bin/bash
ENV=$1

terraform workspace select $ENV
terraform apply -var-file="${ENV}.tfvars" -auto-approve
```

### Plan and Apply in CI/CD

```bash
#!/bin/bash
terraform init
terraform validate
terraform fmt -check
terraform plan -out=tfplan -no-color
terraform apply tfplan -auto-approve
```

### Cleanup Script

```bash
#!/bin/bash
terraform state list | grep -v 'keep_resource' | while read resource; do
    terraform state rm "$resource"
done
```
