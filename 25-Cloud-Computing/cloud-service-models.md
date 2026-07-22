# Cloud Service Models

## Overview

Cloud computing is delivered through three primary service models, each offering different levels of control, flexibility, and management responsibility.

## Service Model Comparison

```
┌─────────────────────────────────────────────────────────┐
│                   Control & Flexibility                  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              IaaS                                │   │
│  │  You manage: OS, Runtime, Apps, Data            │   │
│  │  Provider:    Hardware, Network, Virtualization  │   │
│  │  Examples:    AWS EC2, Azure VMs, GCP Compute   │   │
│  ├─────────────────────────────────────────────────┤   │
│  │              PaaS                                │   │
│  │  You manage: Apps, Data                          │   │
│  │  Provider:    Everything else                    │   │
│  │  Examples:    Heroku, Google App Engine          │   │
│  ├─────────────────────────────────────────────────┤   │
│  │              SaaS                                │   │
│  │  You manage: Nothing (just use it)              │   │
│  │  Provider:    Everything                         │   │
│  │  Examples:    Gmail, Salesforce, Slack           │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ◄── More control          Less control ──►             │
│  ◄── More responsibility   Less responsibility ──►     │
└─────────────────────────────────────────────────────────┘
```

## IaaS (Infrastructure as a Service)

You rent virtual machines and infrastructure. You manage everything from the OS up.

### What Provider Manages
- Physical hardware
- Networking infrastructure
- Storage systems
- Virtualization layer
- Data center power/cooling

### What You Manage
- Operating system
- Runtime and middleware
- Applications
- Data
- Security patches

### Examples by Provider

| Provider | Compute | Storage | Networking |
|----------|---------|---------|------------|
| AWS | EC2, Lightsail | EBS, S3, EFS | VPC, ELB |
| Azure | Virtual Machines | Blob, Disk, Files | VNet, Load Balancer |
| GCP | Compute Engine | Persistent Disk, GCS | VPC, Cloud Load Balancing |

### When to Use IaaS
- Full control over OS needed
- Custom software requirements
- Compliance requiring specific configurations
- Lift-and-shift migrations
- Development/testing environments

### Code Example (AWS EC2 with Terraform)

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"

  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public.id

  tags = {
    Name = "web-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
  EOF
}
```

## PaaS (Platform as a Service)

You deploy applications without managing underlying infrastructure. The platform handles OS, runtime, and scaling.

### What Provider Manages
- Hardware and networking
- Operating system
- Runtime and middleware
- Auto-scaling infrastructure

### What You Manage
- Application code
- Data
- Application configuration

### Examples by Provider

| Provider | PaaS Service | Use Case |
|----------|-------------|----------|
| AWS | Elastic Beanstalk, ECS, Lambda | Web apps, containers, serverless |
| Azure | App Service, Azure Functions | Web apps, serverless |
| GCP | App Engine, Cloud Run | Web apps, containers |

### When to Use PaaS
- Rapid development and deployment
- Team without infrastructure expertise
- Microservices and serverless architectures
- Focus on code, not infrastructure

### Code Example (AWS Elastic Beanstalk)

```yaml
# .ebextensions/python.config
option_settings:
  aws:elasticbeanstalk:application:environment:
    DATABASE_URL: postgres://db.example.com/mydb
    REDIS_URL: redis://cache.example.com:6379
  aws:elasticbeanstalk:container:python:
    WSGIPath: application:app
  aws:autoscaling:asg:
    MinSize: 2
    MaxSize: 10
```

## SaaS (Software as a Service)

Ready-to-use software delivered over the internet. No infrastructure or application management.

### What Provider Manages
- Everything (infrastructure, application, data storage)
- Updates and patches
- Security and compliance
- Availability and performance

### What You Manage
- User accounts and access
- Data input and configuration
- Integration with other services

### Examples

| Category | Services |
|----------|----------|
| Email | Gmail, Outlook 365 |
| CRM | Salesforce, HubSpot |
| Collaboration | Slack, Microsoft Teams |
| Storage | Dropbox, Google Drive |
| Analytics | Google Analytics, Mixpanel |
| CI/CD | GitHub Actions, CircleCI |

### When to Use SaaS
- Standard business functions
- Quick adoption without development
- Reducing operational overhead
- Teams without technical resources

## FaaS (Function as a Service) - Serverless

An extension of PaaS focused on individual functions triggered by events.

```
┌─────────────────────────────────────────┐
│            Serverless Flow               │
│                                          │
│  Event ──► Function ──► Response         │
│                                          │
│  HTTP Request ──► process_request() ──►  │
│  S3 Upload   ──► resize_image()    ──►  │
│  DB Change   ──► sync_data()       ──►  │
│  Schedule    ──► cron_job()        ──►  │
│                                          │
│  Pay per invocation, auto-scales to 0    │
└─────────────────────────────────────────┘
```

| Provider | Service | Language Support |
|----------|---------|-----------------|
| AWS | Lambda | Node.js, Python, Go, Java, Rust |
| Azure | Azure Functions | C#, Java, JS, Python, PowerShell |
| GCP | Cloud Functions | Node.js, Python, Go, Java |

### Code Example (AWS Lambda)

```python
import json

def lambda_handler(event, context):
    """Handle API Gateway request."""
    name = event.get('queryStringParameters', {}).get('name', 'World')

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': f'Hello, {name}!'
        })
    }
```

## Decision Matrix

| Factor | IaaS | PaaS | SaaS | FaaS |
|--------|------|------|------|------|
| Control | High | Medium | Low | Low |
| Management effort | High | Medium | Low | Low |
| Scalability | Manual/config | Auto | Built-in | Auto |
| Cost model | Pay for resources | Pay for platform | Pay per user | Pay per call |
| Customization | Full | Limited | Config only | Function only |
| Speed to market | Slow | Fast | Fastest | Fast |
| Team skills needed | High | Medium | Low | Medium |

## CaaS (Containers as a Service)

A middle ground between IaaS and PaaS, managing container orchestration.

| Provider | Service |
|----------|---------|
| AWS | ECS, EKS |
| Azure | AKS |
| GCP | GKE |

```yaml
# AWS ECS Task Definition
{
  "family": "myapp",
  "networkMode": "awsvpc",
  "containerDefinitions": [
    {
      "name": "web",
      "image": "myapp:latest",
      "portMappings": [
        { "containerPort": 8080, "protocol": "tcp" }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
}
```

## Best Practices

1. **Start with SaaS** for standard tools (email, CRM, CI/CD)
2. **Use PaaS** for application development focus
3. **Use IaaS** when you need full OS control
4. **Use FaaS** for event-driven, variable workloads
5. **Use CaaS** for containerized microservices
6. Consider **multi-cloud** strategy to avoid vendor lock-in
7. Evaluate **data residency** and compliance requirements
8. Factor in **total cost of ownership**, not just service price
