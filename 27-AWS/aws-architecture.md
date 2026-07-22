# AWS Architecture - Well-Architected Framework & Patterns

## Table of Contents

1. [Well-Architected Framework](#well-architected-framework)
2. [Common Architecture Patterns](#common-architecture-patterns)
3. [Reference Architectures](#reference-architectures)
4. [High Availability & Disaster Recovery](#high-availability--disaster-recovery)
5. [Security Architecture](#security-architecture)
6. [Cost-Effective Architectures](#cost-effective-architectures)
7. [Scalability Patterns](#scalability-patterns)

---

## Well-Architected Framework

### The Six Pillars

```
                    +-------------------+
                    |   Operational     |
                    |   Excellence      |
                    +--------+----------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+----------+                   +----------+--------+
|    Security      |                   |   Reliability      |
+-------+----------+                   +----------+--------+
        |                                         |
        +--------------------+--------------------+
                             |
                    +--------+----------+
                    |    Performance     |
                    |    Efficiency      |
                    +--------+----------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+----------+                   +----------+--------+
|      Cost        |                   |  Sustainability   |
|   Optimization   |                   |                   |
+------------------+                   +-------------------+
```

### Pillar 1: Operational Excellence

**Practices**:
- Infrastructure as Code (CloudFormation, CDK, Terraform)
- CI/CD pipelines (CodePipeline, CodeBuild)
- Monitoring and observability (CloudWatch, X-Ray)
- Runbooks and documentation

**Key Services**:
- AWS CloudFormation
- AWS CodePipeline
- Amazon CloudWatch
- AWS Systems Manager

**Example Architecture**:
```
Developer -> CodeCommit -> CodeBuild -> CodeDeploy -> Production
                                |
                          CloudWatch Alarms
                                |
                          SNS Notifications
```

### Pillar 2: Security

**Practices**:
- Implement identity management
- Enable infrastructure protection
- Protect data at rest and in transit
- Prepare for security events

**Key Services**:
- AWS IAM, AWS Organizations
- AWS KMS, AWS Certificate Manager
- AWS WAF, AWS Shield
- Amazon GuardDuty, AWS Security Hub

**Defense in Depth**:
```
Layer 1: Edge (CloudFront, WAF, Shield)
Layer 2: VPC (Security Groups, NACLs)
Layer 3: Compute (IAM Roles, Instance Profiles)
Layer 4: Data (KMS, S3 Bucket Policies)
Layer 5: Application (Code Signing, Secrets Manager)
Layer 6: Monitoring (CloudTrail, GuardDuty)
```

### Pillar 3: Reliability

**Practices**:
- Recover from failures automatically
- Mitigate disruptions (AZ, region)
- Test recovery procedures

**Key Services**:
- Auto Scaling Groups
- Elastic Load Balancing
- Amazon Route 53
- AWS Backup

**Architecture Pattern**:
```
Multi-AZ Architecture:

Region: us-east-1
    |
    +-- AZ-1a
    |       +-- EC2 (Web Server)
    |       +-- RDS (Primary)
    |
    +-- AZ-1b
    |       +-- EC2 (Web Server)
    |       +-- RDS (Standby)
    |
    +-- AZ-1c
    |       +-- EC2 (Web Server)
    |       +-- S3 (Data)
    |
    +-- Route 53 (DNS Failover)
    +-- CloudFront (CDN)
```

### Pillar 4: Performance Efficiency

**Practices**:
- Use compute resources efficiently
- Select optimal resource types and sizes
- Use caching and CDN
- Review and optimize regularly

**Key Services**:
- Amazon CloudFront (CDN)
- Amazon ElastiCache (Caching)
- AWS Auto Scaling
- Various EC2 instance types

### Pillar 5: Cost Optimization

**Practices**:
- Match supply with demand
- Use pricing models effectively
- Analyze and attribute spending
- Use managed services

**Key Services**:
- AWS Cost Explorer
- AWS Budgets
- AWS Trusted Advisor
- AWS Compute Optimizer

**Cost Optimization Decision Tree**:
```
Is the workload steady-state?
    |
    +-- Yes: Reserved Instances / Savings Plans
    |
    +-- No: Is it fault-tolerant?
              |
              +-- Yes: Spot Instances
              |
              +-- No: On-Demand Instances
```

### Pillar 6: Sustainability

**Practices**:
- Right-size resources
- Use managed services
- Reduce data movement
- Choose efficient hardware

---

## Common Architecture Patterns

### 1. Three-Tier Web Application

```
                    +-----------------+
                    |   Route 53      |
                    |   (DNS)         |
                    +--------+--------+
                             |
                    +--------+--------+
                    |  CloudFront     |
                    |   (CDN)         |
                    +--------+--------+
                             |
                    +--------+--------+
                    |  ALB             |
                    |  (Load Balancer) |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   EC2        |  |   EC2        |  |   EC2        |
    |  (Web Tier)  |  |  (Web Tier)  |  |  (Web Tier)  |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
            +----------------+----------------+
                             |
                    +--------+--------+
                    |  Private Subnet  |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    |   Aurora      |               |   ElastiCache    |
    |   (Database)  |               |   (Cache)        |
    +-------+------+               +---------+--------+
```

**Components**:
- **Route 53**: DNS routing and health checks
- **CloudFront**: Content caching, SSL termination
- **ALB**: Load balancing, SSL termination
- **EC2/Auto Scaling**: Web application servers
- **Aurora**: Multi-AZ relational database
- **ElastiCache**: Session storage, query caching

### 2. Serverless Web Application

```
                    +-----------------+
                    |   Route 53      |
                    +--------+--------+
                             |
                    +--------+--------+
                    |  CloudFront     |
                    +--------+--------+
                             |
                    +--------+--------+
                    |  S3 Bucket      |
                    |  (Static Site)  |
                    +--------+--------+
                             |
                    +--------+--------+
                    |  API Gateway    |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   Lambda     |  |   Lambda     |  |   Lambda     |
    |  (Function)  |  |  (Function)  |  |  (Function)  |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   DynamoDB   |  |   S3 Bucket  |  |   SQS Queue  |
    +--------------+  +--------------+  +--------------+
```

**Components**:
- **S3**: Static website hosting
- **CloudFront**: CDN and edge caching
- **API Gateway**: REST/HTTP API management
- **Lambda**: Serverless compute
- **DynamoDB**: Serverless NoSQL database
- **SQS**: Async message processing

### 3. Microservices Architecture

```
                    +-----------------+
                    |   ALB           |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| ECS Service A |    | ECS Service B |    | ECS Service C |
| (Users)      |    | (Orders)     |    | (Products)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| DynamoDB     |    | Aurora       |    | ElastiCache  |
+--------------+    +--------------+    +--------------+

        +--------------------+--------------------+
        |                                         |
+-------+------+                        +---------+--------+
| SQS/SNS      |                        | Step Functions    |
| (Messaging)  |                        | (Orchestration)  |
+--------------+                        +------------------+
```

**Best Practices**:
- API Gateway for routing
- Service discovery with Cloud Map
- Event-driven with EventBridge
- Distributed tracing with X-Ray

### 4. Data Lake Architecture

```
                    +-----------------+
                    |   Data Sources  |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| Kinesis      |    | S3 Batch      |    | DMS          |
| (Streaming)  |    | (File Import) |    | (Database)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
        +--------------------+--------------------+
                             |
                    +--------+--------+
                    |   S3 Data Lake  |
                    |  (Raw Zone)     |
                    +--------+--------+
                             |
                    +--------+--------+
                    |   AWS Glue      |
                    |   (ETL)         |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    | S3 (Processed)|               | S3 (Curated)    |
    +--------------+               +-----------------+
                             |
                    +--------+--------+
                    |   Athena        |
                    |   (Query)       |
                    +--------+--------+
                             |
                    +--------+--------+
                    | QuickSight      |
                    | (Visualization) |
                    +-----------------+
```

### 5. Event-Driven Architecture

```
    +-----------------+
    |   Event Source  |
    +--------+--------+
             |
    +--------+--------+
    |   EventBridge   |
    +--------+--------+
             |
    +--------+--------+
    |   Rules &       |
    |   Targets       |
    +--------+--------+
             |
    +--------+--------+--------+--------+
    |        |        |        |        |
+---+---+ +--+---+ +--+---+ +--+---+ +--+---+
|Lambda | | SQS  | | SNS  | | Step | | EC2  |
|       | |      | |      | | Func | |      |
+-------+ +------+ +------+ +------+ +------+
```

---

## High Availability & Disaster Recovery

### Recovery Strategies

| Strategy | RTO | RPO | Cost | Complexity |
|----------|-----|-----|------|------------|
| Backup & Restore | Hours | Hours | Low | Low |
| Pilot Light | 10s min | Minutes | Medium | Medium |
| Warm Standby | Minutes | Seconds | High | High |
| Multi-Site Active/Active | Near Zero | Near Zero | Very High | High |

### Multi-Region Architecture

```
Region: us-east-1                    Region: eu-west-1
+-----------------+                  +-----------------+
| Route 53        |                  |                 |
| (Failover)      |                  | (Standby)       |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| CloudFront      |                  | CloudFront      |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| ALB + EC2       |                  | ALB + EC2       |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| Aurora Global   |------------------| Aurora Replica  |
+-----------------+    (Replication) +-----------------+
         |                                    |
+--------+--------+                  +--------+--------+
| S3 Cross-Region |------------------| S3 Replica      |
+-----------------+   Replication    +-----------------+
```

---

## Security Architecture

### Zero Trust Model

```
1. Verify Identity
   +-- MFA
   +-- IAM Roles
   +-- Federation

2. Least Privilege
   +-- IAM Policies
   +-- Resource-based Policies
   +-- SCPs

3. Micro-segmentation
   +-- Security Groups
   +-- NACLs
   +-- VPC Endpoints

4. Encrypt Everything
   +-- KMS
   +-- TLS 1.3
   +-- S3 Encryption

5. Continuous Monitoring
   +-- CloudTrail
   +-- GuardDuty
   +-- Security Hub
```

### Network Security Architecture

```
Internet
    |
+---+---+
| WAF   | (Layer 7 filtering)
+---+---+
    |
+---+---+
|Shield | (DDoS protection)
+---+---+
    |
+---+---+
|CloudFront| (Edge security)
+---+---+
    |
+---+---+
| ALB   | (SSL termination)
+---+---+
    |
+---+---+
| Security Group | (Stateful firewall)
+---+---+
    |
+---+---+
| EC2   | (Instance)
+---+---+
    |
+---+---+
| NACL  | (Stateless, subnet level)
+---+---+
```

---

## Cost-Effective Architectures

### Pattern: Auto Scaling with Spot Instances

```
                    +-----------------+
                    |   ALB           |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+------+                         +--------+--------+
| On-Demand    |                         | Spot Fleet      |
| (Base Load)  |                         | (Burst)         |
+-------+------+                         +--------+--------+
```

**Cost Savings**:
- Base load: On-Demand or Reserved
- Burst capacity: Spot Instances (up to 90% savings)
- Auto Scaling: Scale based on demand

### Pattern: Serverless Cost Optimization

```
Traditional:                      Serverless:
+------------------+              +------------------+
| EC2 (24/7)       |              | Lambda (per req) |
| $500/month       |              | $50/month        |
+------------------+              +------------------+
| RDS (24/7)       |              | DynamoDB (per    |
| $300/month       |              | request) $50     |
+------------------+              +------------------+
| Total: $800      |              | Total: $100      |
+------------------+              +------------------+
```

### Pattern: S3 Lifecycle Management

```
Day 0-30:    S3 Standard ($0.023/GB)
Day 31-90:   S3 Standard-IA ($0.0125/GB)
Day 91-180:  S3 One Zone-IA ($0.01/GB)
Day 181-365: S3 Glacier Instant ($0.004/GB)
Day 366+:    S3 Glacier Deep Archive ($0.00099/GB)
```

---

## Scalability Patterns

### Horizontal vs Vertical Scaling

```
Vertical Scaling:          Horizontal Scaling:
+----------+              +----------+ +----------+
|          |              |          | |          |
|   Bigger |              |  Server1 | |  Server2 |
|   Server |              |          | |          |
|          |              +----------+ +----------+
+----------+              +----------+ +----------+
                          |          | |          |
                          |  Server3 | |  Server4 |
                          |          | |          |
                          +----------+ +----------+

Pros: Simple                 Pros: Near unlimited
Cons: Limited, downtime      Cons: Complex, stateless needed
```

### Auto Scaling Configuration

```
Min: 2 (Always running)
Max: 10 (Scale limit)
Desired: 3 (Current)

Scaling Policy:
+-- Target Tracking: CPU at 70%
+-- Step Scaling: Scale on alarm thresholds
+-- Scheduled: Scale at specific times
+-- Predictive: ML-based forecasting
```

---

## Reference Architecture: E-Commerce Platform

```
                        +-----------------+
                        |   Route 53      |
                        | (Weighted)      |
                        +--------+--------+
                                 |
                        +--------+--------+
                        | CloudFront      |
                        +--------+--------+
                                 |
              +------------------+------------------+
              |                  |                  |
     +--------+--------+ +------+------+ +---------+--------+
     | S3 (Static)     | | ALB         | | API Gateway      |
     +-----------------+ +------+------+ +---------+--------+
                                 |                  |
              +------------------+------------------+
              |                  |                  |
     +--------+--------+ +------+--------+ +-------+--------+
     | ECS: Web App    | | ECS: Product | | Lambda: Auth    |
     +-----------------+ | Service      | +-----------------+
              |          +------+--------+         |
     +--------+--------+ +------+--------+ +------+--------+
     | ElastiCache     | | DynamoDB     | | Cognito       |
     | (Sessions)      | | (Products)   | | (User Pool)   |
     +-----------------+ +--------------+ +---------------+
              |
     +--------+--------+
     | Aurora          |
     | (Orders, Users) |
     +-----------------+
```

**Components**:
- **Route 53**: DNS with weighted routing for A/B testing
- **CloudFront**: Static asset delivery, API caching
- **ALB**: Load balancing for web tier
- **ECS Fargate**: Containerized microservices
- **DynamoDB**: Product catalog (high read throughput)
- **Aurora**: Transactional data (ACID compliance)
- **ElastiCache**: Session management, product caching
- **Cognito**: User authentication and authorization
- **Lambda**: Background processing, auth validation
