# Cloud Computing Interview Questions

## Fundamentals

### 1. What is cloud computing and what are its main characteristics?

**Answer:**
Cloud computing is the on-demand delivery of computing resources (servers, storage, databases, networking, software) over the internet with pay-as-you-go pricing.

Five essential characteristics (NIST definition):
1. **On-demand self-service** - Provision resources without human interaction
2. **Broad network access** - Available over the network from any device
3. **Resource pooling** - Multi-tenant resource sharing
4. **Rapid elasticity** - Scale up/down quickly
5. **Measured service** - Pay only for what you use

---

### 2. What are the differences between IaaS, PaaS, and SaaS?

| Model | You Manage | Provider Manages | Example |
|-------|-----------|-----------------|---------|
| IaaS | OS, Apps, Data | Hardware, Network | AWS EC2 |
| PaaS | Apps, Data | Everything else | Heroku |
| SaaS | Nothing (usage) | Everything | Gmail |

```
Control:  IaaS > PaaS > SaaS
Overhead: IaaS > PaaS > SaaS
Flexibility: IaaS > PaaS > SaaS
```

---

### 3. What is the difference between horizontal and vertical scaling?

**Answer:**

```
Vertical Scaling (Scale Up):
┌──────────┐     ┌──────────────┐
│  Small   │ ──► │    Large     │
│  Server  │     │    Server    │
└──────────┘     └──────────────┘

Horizontal Scaling (Scale Out):
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
│Server│ │Server│ │Server│ │Server│
└──────┘ └──────┘ └──────┘ └──────┘
```

| Aspect | Vertical | Horizontal |
|--------|----------|------------|
| Downtime | May require restart | Zero downtime |
| Cost | Expensive at high end | Linear cost increase |
| Limits | Hardware limits | Practically unlimited |
| Complexity | Simple | Load balancing needed |

---

### 4. What is high availability and how is it achieved?

**Answer:**
High availability (HA) ensures a system remains operational for a high percentage of time (e.g., 99.99% = 8.76 hours downtime/year).

**Achieved through:**
- Redundancy across multiple AZs/regions
- Load balancing
- Auto-scaling
- Health checks and auto-recovery
- Database replication
- CDN for static content

**SLA Tiers:**
| Availability | Downtime/Year |
|-------------|---------------|
| 99.9% | 8.76 hours |
| 99.95% | 4.38 hours |
| 99.99% | 52.6 minutes |
| 99.999% | 5.26 minutes |

---

### 5. What is a VPC and why is it important?

**Answer:**
A Virtual Private Cloud (VPC) is an isolated network within a cloud provider where you define IP ranges, subnets, route tables, and network gateways.

```
┌─────────────────── VPC (10.0.0.0/16) ─────────────────┐
│                                                         │
│  ┌─── Public Subnet ───┐  ┌─── Private Subnet ───┐   │
│  │  10.0.1.0/24        │  │  10.0.2.0/24         │   │
│  │                      │  │                      │   │
│  │  ┌──────┐ ┌──────┐ │  │  ┌──────┐ ┌──────┐ │   │
│  │  │ Web  │ │  LB  │ │  │  │ App  │ │  DB  │ │   │
│  │  └──────┘ └──────┘ │  │  └──────┘ └──────┘ │   │
│  └──────────┬──────────┘  └──────────┬──────────┘   │
│             │                        │               │
│  ┌──────────▼────────────────────────▼──────────┐   │
│  │            Internet Gateway / NAT            │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

Importance: Network isolation, security boundaries, IP management, compliance.

---

## Intermediate

### 6. What is the difference between S3 and EBS?

| Feature | S3 | EBS |
|---------|-----|-----|
| Type | Object storage | Block storage |
| Access | HTTP/REST API | Mounted as disk |
| Use case | Static files, backups | Database volumes, OS |
| Durability | 99.999999999% | 99.999% |
| Scale | Unlimited | Up to 64 TB |
| Performance | High throughput | Low latency |

---

### 7. What is serverless computing and what are its advantages?

**Answer:**
Serverless computing runs code without managing servers. The provider handles provisioning, scaling, and maintenance.

**Advantages:**
- No server management
- Automatic scaling (to zero)
- Pay per execution
- High availability built-in
- Faster time to market

**Disadvantages:**
- Cold start latency
- Vendor lock-in
- Debugging difficulty
- Execution time limits
- Stateless by design

```python
# AWS Lambda example
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': f'Hello from serverless!'
    }
```

---

### 8. What is a CDN and when should you use one?

**Answer:**
A Content Delivery Network caches content at edge locations worldwide, closer to users.

```
Without CDN:                    With CDN:
User (Tokyo)                    User (Tokyo)
    │                               │
    ▼                               ▼
US Server ──► Response        Edge (Tokyo) ──► Response
(200ms delay)                  (20ms delay)
```

**Use when:**
- Serving static content (images, CSS, JS)
- Global user base
- High traffic spikes
- Streaming media

---

### 9. What are security groups and network ACLs?

| Feature | Security Groups | Network ACLs |
|---------|----------------|--------------|
| Level | Instance-level | Subnet-level |
| State | Stateful | Stateless |
| Rules | Allow only | Allow + Deny |
| Scope | All rules evaluated | Rules in order |
| Default | Allow all outbound | Deny all inbound |

```hcl
# Security Group (Terraform)
resource "aws_security_group" "web" {
  name = "web-sg"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

### 10. What is auto-scaling and how does it work?

**Answer:**
Auto-scaling automatically adjusts the number of compute resources based on demand.

```
Load ──► Metric ──► Policy ──► Scaling Action
CPU 70%            Add 2 instances
CPU 30%            Remove 1 instance
Queue depth > 100  Add 3 instances
```

```hcl
# AWS Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  min_size         = 2
  max_size         = 10
  desired_capacity = 3

  target_group_arns = [aws_lb_target_group.web.arn]

  scaling_policy {
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 70.0
    }
  }
}
```

---

### 11. What is the CAP theorem?

**Answer:**
A distributed system can provide only two of three guarantees:

```
       Consistency
          /\
         /  \
        /    \
       /      \
Availability ── Partition Tolerance
```

| System | CP | AP | CA |
|--------|----|----|-----|
| PostgreSQL | CP | | CA |
| Cassandra | | AP | |
| MongoDB | CP | | |
| DynamoDB | Configurable | | |

Most distributed systems choose AP or CP since partition tolerance is required.

---

## Advanced

### 12. Design a highly available web application architecture.

```
┌─────────────────────────────────────────────────────┐
│                    Route 53 (DNS)                    │
│                  (latency-based)                     │
└────────┬──────────────────────┬─────────────────────┘
         │                      │
    ┌────▼─────┐          ┌────▼─────┐
    │  Region  │          │  Region  │
    │  (US-E)  │          │  (EU-W)  │
    └────┬─────┘          └────┬─────┘
         │                      │
    ┌────▼──────────┐     ┌────▼──────────┐
    │  CloudFront   │     │  CloudFront   │
    │  (CDN)        │     │  (CDN)        │
    └────┬──────────┘     └────┬──────────┘
         │                      │
    ┌────▼─────┐          ┌────▼─────┐
    │   ALB    │          │   ALB    │
    └────┬─────┘          └────┬─────┘
         │                      │
    ┌────▼──────────────────┐   │
    │  Auto Scaling Group   │   │
    │  ┌──────┐ ┌──────┐   │   │
    │  │ EC2  │ │ EC2  │   │   │
    │  └──────┘ └──────┘   │   │
    └────────┬──────────────┘   │
             │                  │
    ┌────────▼──────────────┐   │
    │  RDS Multi-AZ         │   │
    │  (Primary + Standby)  │   │
    └───────────────────────┘   │
                                │
    Cross-Region Read Replicas──┘
```

---

### 13. How do you handle data consistency in a distributed system?

**Strategies:**
1. **Strong consistency**: Synchronous replication (higher latency)
2. **Eventual consistency**: Async replication (better performance)
3. **CQRS**: Separate read/write models
4. **Saga pattern**: Distributed transactions via events
5. **Two-phase commit**: Atomic distributed transactions (rare)

---

### 14. What is Infrastructure as Code and what are the benefits?

**Answer:**
IaC manages infrastructure through machine-readable configuration files instead of manual processes.

**Benefits:**
- Version controlled infrastructure
- Reproducible environments
- Faster provisioning
- Consistent configurations
- Automated testing
- Documentation as code

```hcl
# Terraform IaC example
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

---

### 15. What is the shared responsibility model?

```
┌─────────────────────────────────────────────┐
│           Shared Responsibility              │
│                                              │
│  SaaS:  ┌─────────────────────────────┐    │
│         │  Provider: Everything       │    │
│         │  Customer: Data, Users      │    │
│         └─────────────────────────────┘    │
│                                              │
│  PaaS:  ┌─────────────────────────────┐    │
│         │  Provider: Platform + OS    │    │
│         │  Customer: Apps + Data      │    │
│         └─────────────────────────────┘    │
│                                              │
│  IaaS:  ┌─────────────────────────────┐    │
│         │  Provider: Hardware + Virt  │    │
│         │  Customer: OS + Apps + Data │    │
│         └─────────────────────────────┘    │
│                                              │
│  On-Prem:                                   │
│         │  Customer: Everything       │    │
│         └─────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

---

### 16. How do you optimize cloud costs?

1. **Right-size instances** - Match instance type to workload
2. **Reserved instances** - Commit for 1-3 years (30-70% savings)
3. **Spot instances** - Use for fault-tolerant workloads (70-90% savings)
4. **Auto-scaling** - Scale down during low traffic
5. **Storage tiering** - Move infrequently accessed data to cheaper tiers
6. **Delete unused resources** - Orphaned EBS, idle ELBs
7. **Use managed services** - Reduce operational costs
8. **Tag everything** - Enable cost allocation and accountability
9. **Set budget alerts** - Catch overspending early
10. **Review regularly** - Monthly cost optimization reviews

---

### 17. What is a disaster recovery strategy?

| Strategy | RPO | RTO | Cost | Complexity |
|----------|-----|-----|------|------------|
| Backup & Restore | Hours | Hours | Low | Low |
| Pilot Light | Minutes | 10s of min | Medium | Medium |
| Warm Standby | Seconds | Minutes | High | High |
| Multi-Site Active | 0 | 0 | Very High | Very High |

- **RPO** (Recovery Point Objective): How much data you can afford to lose
- **RTO** (Recovery Time Objective): How quickly you need to recover
