# AWS Interview Questions - Comprehensive Guide

## Table of Contents

1. [Fundamental Questions](#fundamental-questions)
2. [Compute Questions](#compute-questions)
3. [Storage Questions](#storage-questions)
4. [Database Questions](#database-questions)
5. [Networking Questions](#networking-questions)
6. [Security Questions](#security-questions)
7. [Architecture Questions](#architecture-questions)
8. [Cost Optimization Questions](#cost-optimization-questions)
9. [Scenario-Based Questions](#scenario-based-questions)
10. [Hands-On Lab Questions](#hands-on-lab-questions)

---

## Fundamental Questions

### Q1: What is the difference between AWS, Azure, and GCP?

**Answer**:
| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Launch | 2006 | 2010 | 2008 |
| Market Share | 32% | 23% | 10% |
| Strengths | Broadest services | Enterprise/AD integration | AI/ML, Analytics |
| Free Tier | 12 months + always free | 12 months + always free | 90 days + always free |
| Pricing | Per-second billing | Per-minute billing | Per-second billing |

### Q2: Explain the AWS Shared Responsibility Model

**Answer**:
```
Customer Responsibility ("Security IN the Cloud"):
- Data classification and encryption
- Operating system patching
- Network and firewall configuration
- Client-side encryption
- Server-side encryption
- Platform and application management

AWS Responsibility ("Security OF the Cloud"):
- Physical security of data centers
- Hardware and software infrastructure
- Network infrastructure
- Hypervisor layer
- Global infrastructure
```

### Q3: What is an AWS Region vs Availability Zone vs Edge Location?

**Answer**:
- **Region**: Geographic area with 2-6 AZs (e.g., us-east-1)
- **Availability Zone**: Isolated data center within a region
- **Edge Location**: CDN endpoint for CloudFront (400+ locations)

### Q4: What are the different EC2 pricing models?

**Answer**:
1. **On-Demand**: Pay per second, no commitment
2. **Reserved**: 1-3 year commitment, up to 75% savings
3. **Spot**: Up to 90% off, can be interrupted
4. **Dedicated**: Single-tenant hardware, compliance requirements
5. **Savings Plans**: Flexible pricing commitment

### Q5: What is the AWS CLI and how do you configure it?

**Answer**:
```bash
# Install
pip install awscli

# Configure
aws configure
# Enter Access Key, Secret Key, Region, Output format

# Verify
aws sts get-caller-identity
```

---

## Compute Questions

### Q6: When would you use Lambda vs EC2?

**Answer**:
| Factor | Lambda | EC2 |
|--------|--------|-----|
| Use Case | Event-driven, short tasks | Long-running, persistent |
| Max Duration | 15 minutes | Unlimited |
| Scaling | Automatic | Manual/Auto Scaling |
| Management | Serverless | Full control |
| Cost | Per invocation | Per second |
| Best For | APIs, file processing | Databases, legacy apps |

### Q7: What is the difference between ECS, EKS, and Fargate?

**Answer**:
```
ECS: AWS-native container orchestration
    +-- EC2 Launch Type (manage instances)
    +-- Fargate Launch Type (serverless)

EKS: Managed Kubernetes
    +-- EC2 worker nodes
    +-- Fargate pods

Fargate: Serverless compute for containers
    +-- No instance management
    +-- Pay per vCPU/memory
```

### Q8: How does Auto Scaling work?

**Answer**:
```
Components:
- Launch Template/Configuration: What to launch
- Auto Scaling Group: Where and how many
- Scaling Policies: When to scale

Scaling Types:
1. Target Tracking: Maintain metric at target (e.g., CPU at 50%)
2. Step Scaling: Scale based on CloudWatch alarms
3. Scheduled: Scale at specific times
4. Predictive: ML-based forecasting
```

### Q9: What are EC2 Instance Types and when to use each?

**Answer**:
| Type | Use Case | Example |
|------|----------|---------|
| General Purpose | Web servers, dev environments | t3, m5 |
| Compute Optimized | Batch processing, gaming | c5, c6g |
| Memory Optimized | In-memory databases, real-time | r5, x1e |
| Storage Optimized | NoSQL, data warehousing | i3, d2 |
| Accelerated | ML, graphics, HPC | p4, g4, inf1 |

### Q10: What is the difference between Horizontal and Vertical Scaling?

**Answer**:
- **Vertical (Scale Up)**: Increase instance size (e.g., t3.medium to t3.xlarge)
- **Horizontal (Scale Out)**: Add more instances (e.g., 2 to 10 instances)

**Trade-offs**:
- Vertical: Simpler, but limited and requires downtime
- Horizontal: More complex, but virtually unlimited

---

## Storage Questions

### Q11: What are the S3 Storage Classes?

**Answer**:
| Class | Access Frequency | Retrieval Time | Use Case |
|-------|------------------|----------------|----------|
| S3 Standard | Frequent | Immediate | Active data |
| S3 Intelligent | Unknown/changing | Immediate | Variable workloads |
| S3 Standard-IA | Infrequent | Immediate | Backups, disaster recovery |
| S3 One Zone-IA | Non-critical | Immediate | Recreatable data |
| S3 Glacier | Archive | Minutes-hours | Compliance archives |
| S3 Glacier Deep Archive | Rarely accessed | Hours | Regulatory data |

### Q12: What is the difference between EBS, EFS, and S3?

**Answer**:
| Feature | EBS | EFS | S3 |
|---------|-----|-----|-----|
| Type | Block | File | Object |
| Access | Single EC2 | Multiple EC2 | HTTP/API |
| Capacity | 1GB-64TB | Auto-scaling | Unlimited |
| Use Case | Database storage | Shared files | Static content |
| Performance | SSD/HDD | Auto-scaling | Unlimited |

### Q13: How do you secure an S3 bucket?

**Answer**:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyPublicAccess",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::bucket/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
```

**Best Practices**:
1. Block public access by default
2. Enable versioning
3. Enable encryption (SSE-S3 or SSE-KMS)
4. Use bucket policies with least privilege
5. Enable access logging
6. Use VPC endpoints for private access

### Q14: What is S3 Versioning and why is it important?

**Answer**:
- Keeps multiple versions of objects
- Protects against accidental deletion
- Enables rollbacks
- Required for lifecycle policies

### Q15: Explain S3 Lifecycle Policies

**Answer**:
```json
{
    "Rules": [
        {
            "ID": "MoveToGlacier",
            "Transitions": [
                {
                    "Days": 90,
                    "StorageClass": "GLACIER"
                }
            ],
            "Expiration": {
                "Days": 365
            }
        }
    ]
}
```

---

## Database Questions

### Q16: When to use RDS vs DynamoDB vs Aurora?

**Answer**:
| Feature | RDS | DynamoDB | Aurora |
|---------|-----|----------|--------|
| Type | Relational | NoSQL | Relational |
| Scale | Vertical | Horizontal | Horizontal |
| Latency | Milliseconds | Single-digit ms | Milliseconds |
| Use Case | Traditional apps | High-scale apps | High-performance SQL |
| Pricing | Instance hours | Request units | Instance hours |
| Max Size | 64 TB | Unlimited | 128 TB |

### Q17: What is DynamoDB Capacity Mode?

**Answer**:
- **Provisioned**: Define read/write capacity, pay for reserved
- **On-Demand**: Pay per request, auto-scales

**When to Use**:
- Provisioned: Predictable workloads, cost optimization
- On-Demand: Spiky workloads, development/testing

### Q18: How do you optimize RDS performance?

**Answer**:
1. Right-size instance and storage
2. Use read replicas for read-heavy workloads
3. Enable Multi-AZ for failover
4. Use connection pooling (RDS Proxy)
5. Optimize queries and indexes
6. Enable Performance Insights
7. Use appropriate instance type

### Q19: What is Aurora Serverless?

**Answer**:
- Auto-scales capacity based on application needs
- Pay per ACU (Aurora Capacity Unit) per second
- Scales to zero when idle
- Great for development, testing, and variable workloads

### Q20: What is ElastiCache and when to use it?

**Answer**:
- In-memory caching (Redis or Memcached)
- Use Cases:
  - Session storage
  - Database query caching
  - Real-time analytics
  - Gaming leaderboards
  - Geospatial applications

---

## Networking Questions

### Q21: What is a VPC and its components?

**Answer**:
```
VPC Components:
- Subnets (Public/Private)
- Route Tables
- Internet Gateway
- NAT Gateway
- Security Groups (Stateful)
- NACLs (Stateless)
- VPC Peering
- Transit Gateway
- VPC Endpoints
```

### Q22: What is the difference between Security Groups and NACLs?

**Answer**:
| Feature | Security Groups | NACLs |
|---------|-----------------|-------|
| Level | Instance | Subnet |
| State | Stateful | Stateless |
| Rules | Allow only | Allow and Deny |
| Default | Allow all outbound | Deny all inbound |
| Evaluation | All rules | Rules in order |

### Q23: What is VPC Peering?

**Answer**:
- Connect two VPCs privately
- Can peer within same or different regions
- Cannot overlap CIDR ranges
- Traffic stays on AWS backbone
- Not transitive (must peer A-B, B-C, A-C)

### Q24: What is a NAT Gateway?

**Answer**:
- Allows instances in private subnets to access internet
- Outbound only (no inbound from internet)
- Managed service (high availability within AZ)
- Charges based on data processed

### Q25: What is Route 53 and its routing policies?

**Answer**:
| Policy | Use Case |
|--------|----------|
| Simple | Single resource |
| Weighted | A/B testing, load distribution |
| Latency | Lowest latency routing |
| Failover | Disaster recovery |
| Geolocation | Location-based routing |
| Multivalue | Return multiple healthy endpoints |

---

## Security Questions

### Q26: What is IAM and its best practices?

**Answer**:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-bucket/*"
        }
    ]
}
```

**Best Practices**:
1. Never use root account
2. Enable MFA on all users
3. Use IAM roles for EC2/Lambda
4. Apply least privilege principle
5. Rotate credentials regularly
6. Use IAM Access Analyzer

### Q27: What is KMS and when to use it?

**Answer**:
- Managed encryption key service
- Use Cases:
  - S3 bucket encryption
  - EBS volume encryption
  - RDS encryption
  - Lambda environment variables
  - Custom key policies

### Q28: What is AWS Shield?

**Answer**:
- DDoS protection service
- **Standard**: Free, automatic protection
- **Advanced**: Paid, 24/7 support, cost protection

### Q29: How do you protect against SQL injection in AWS?

**Answer**:
1. Use WAF (Web Application Firewall)
2. Parameterized queries in code
3. Input validation
4. Least privilege database permissions
5. Regular security assessments

### Q30: What is AWS Organizations and SCPs?

**Answer**:
- **Organizations**: Manage multiple AWS accounts
- **SCP**: Service Control Policies - guardrails for accounts
- Use Cases:
  - Centralized billing
  - Account governance
  - Compliance enforcement

---

## Architecture Questions

### Q31: Design a highly available web application

**Answer**:
```
Architecture:
- Multi-AZ deployment
- Auto Scaling Groups
- Elastic Load Balancing
- Route 53 with health checks
- CloudFront for CDN
- RDS Multi-AZ or Aurora

Components:
1. Route 53 (DNS, failover)
2. CloudFront (CDN, SSL)
3. ALB (Load balancing)
4. EC2/Auto Scaling (Web tier)
5. RDS/Aurora (Database)
6. ElastiCache (Caching)
```

### Q32: How would you migrate an on-premises database to AWS?

**Answer**:
```
Options:
1. AWS DMS (Database Migration Service)
   - Homogeneous: MySQL to Aurora MySQL
   - Heterogeneous: Oracle to Aurora PostgreSQL

2. AWS Snowball
   - Large datasets (TB-PB)

3. Native Export/Import
   - mysqldump, pg_dump

Steps:
1. Assess source database
2. Create target (RDS/Aurora)
3. Configure DMS replication
4. Test and validate
5. Cutover
```

### Q33: Design a serverless API

**Answer**:
```
Architecture:
Client -> CloudFront -> API Gateway -> Lambda -> DynamoDB

Benefits:
- No servers to manage
- Auto-scaling
- Pay per request
- High availability

Components:
- CloudFront: CDN, SSL
- API Gateway: REST API management
- Lambda: Compute
- DynamoDB: NoSQL database
- Cognito: Authentication
```

### Q34: How do you handle disaster recovery in AWS?

**Answer**:
```
Strategies (by RTO/RPO):

1. Backup & Restore (Hours)
   - S3 backups, EBS snapshots
   - RTO: Hours, RPO: Hours

2. Pilot Light (Minutes)
   - Core services running
   - Scale up on failover
   - RTO: 10s min, RPO: Minutes

3. Warm Standby (Minutes)
   - Full stack running smaller
   - Scale up on failover
   - RTO: Minutes, RPO: Seconds

4. Multi-Site Active/Active (Near Zero)
   - Full stack in multiple regions
   - Route 53 failover
   - RTO: Near zero, RPO: Near zero
```

### Q35: What is a Well-Architected Review?

**Answer**:
- Evaluate architecture against 6 pillars
- Identify improvement areas
- AWS Well-Architected Tool
- Best practices for cloud design

---

## Cost Optimization Questions

### Q36: How do you reduce AWS costs?

**Answer**:
```
Strategies:
1. Right-sizing (Trusted Advisor)
2. Reserved Instances (up to 75% savings)
3. Spot Instances (up to 90% savings)
4. Savings Plans (flexible pricing)
5. S3 Lifecycle policies
6. Stop unused resources
7. Use managed services
8. Monitor with Cost Explorer
```

### Q37: What is AWS Cost Explorer?

**Answer**:
- Visualize and forecast costs
- Filter by service, region, tag
- Identify cost drivers
- Forecast future spending
- RI recommendations

### Q38: What are Savings Plans?

**Answer**:
- **Compute Savings Plans**: Flexible across EC2, Fargate, Lambda
- **EC2 Instance Savings Plans**: Specific instance family, region
- **SageMaker Savings Plans**: ML workloads
- Commitment: 1 or 3 years
- Savings: Up to 72%

### Q39: How do you set up billing alerts?

**Answer**:
```bash
# Create budget
aws budgets create-budget \
    --account-id 123456789012 \
    --budget '{
        "BudgetName": "Monthly Budget",
        "BudgetLimit": {
            "Amount": "1000",
            "Unit": "USD"
        },
        "TimeUnit": "MONTHLY",
        "BudgetType": "COST"
    }'
```

### Q40: What is the AWS Free Tier?

**Answer**:
- **Always Free**: Lambda (1M requests), DynamoDB (25GB), S3 (5GB)
- **12 Months Free**: EC2 (750 hrs), RDS (750 hrs), S3 (5GB)
- **Trials**: Short-term trials for specific services

---

## Scenario-Based Questions

### Q41: Your website is slow. How do you diagnose and fix it?

**Answer**:
```
Diagnosis:
1. CloudWatch metrics (CPU, memory, network)
2. ALB metrics (latency, HTTP codes)
3. RDS Performance Insights
4. X-Ray tracing

Fixes:
1. Enable CloudFront caching
2. Add ElastiCache
3. Right-size instances
4. Optimize database queries
5. Enable compression
6. Use read replicas
```

### Q42: You need to process 1TB of data daily. Which services?

**Answer**:
```
Options:
1. EMR (Hadoop/Spark) - Complex processing
2. AWS Glue (Serverless ETL)
3. Athena + S3 (SQL queries)
4. Lambda (Small chunks)
5. Kinesis (Real-time streaming)

Architecture:
S3 (Data Lake) -> Glue (ETL) -> Redshift (Analytics) -> QuickSight (BI)
```

### Q43: How do you handle sudden traffic spikes?

**Answer**:
```
Immediate:
1. Auto Scaling with Target Tracking
2. CloudFront for static content
3. ElastiCache for database load

Long-term:
1. Implement CDN caching
2. Database read replicas
3. Queue-based architecture (SQS)
4. Static content on S3
```

### Q44: Your application needs to be PCI DSS compliant. How?

**Answer**:
```
Requirements:
1. Network segmentation (VPC)
2. Encryption at rest (KMS)
3. Encryption in transit (TLS)
4. Access controls (IAM)
5. Logging (CloudTrail, CloudWatch)
6. Regular assessments (Inspector)

Services:
- VPC, Security Groups, NACLs
- KMS, ACM
- IAM, Organizations
- CloudTrail, Config
```

### Q45: How do you monitor a distributed microservices application?

**Answer**:
```
Monitoring Stack:
1. CloudWatch: Metrics, Logs, Alarms
2. X-Ray: Distributed tracing
3. CloudTrail: API auditing
4. GuardDuty: Threat detection

Best Practices:
- Centralized logging (CloudWatch Logs)
- Service maps (X-Ray)
- Custom dashboards
- Automated alerts
```

---

## Hands-On Lab Questions

### Q46: Deploy a static website to S3 and CloudFront

**Answer**:
```bash
# Create bucket
aws s3 mb s3://my-website --region us-east-1

# Enable static hosting
aws s3 website s3://my-website \
    --index-document index.html \
    --error-document error.html

# Upload files
aws s3 sync ./website s3://my-website

# Create CloudFront distribution
aws cloudfront create-distribution \
    --origin-domain-name my-website.s3.amazonaws.com
```

### Q47: Set up a CI/CD pipeline with CodePipeline

**Answer**:
```
Components:
1. CodeCommit: Source repository
2. CodeBuild: Build and test
3. CodeDeploy: Deploy to EC2/ECS
4. CodePipeline: Orchestrate stages

Stages:
Source -> Build -> Test -> Deploy to Staging -> Approve -> Deploy to Production
```

### Q48: Create a Lambda function triggered by S3

**Answer**:
```python
# Lambda function
import json
import boto3

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        s3 = boto3.client('s3')
        response = s3.get_object(Bucket=bucket, Key=key)
        
        # Process the file
        return {
            'statusCode': 200,
            'body': json.dumps(f'Processed {key}')
        }
```

### Q49: Implement auto-scaling for an EC2 fleet

**Answer**:
```bash
# Create launch template
aws ec2 create-launch-template \
    --launch-template-name my-template \
    --launch-template-data '{
        "ImageId": "ami-0c55b159cbfafe1f0",
        "InstanceType": "t2.micro",
        "KeyName": "my-key"
    }'

# Create Auto Scaling group
aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name my-asg \
    --launch-template LaunchTemplateName=my-template \
    --min-size 2 \
    --max-size 10 \
    --desired-capacity 2 \
    --vpc-zone-identifier "subnet-12345678"
```

### Q50: Set up CloudWatch alarms for an application

**Answer**:
```bash
# CPU alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "High-CPU" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --alarm-actions "arn:aws:sns:us-east-1:123456789012:my-topic"

# Unhealthy host alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "UnhealthyHosts" \
    --metric-name UnHealthyHostCount \
    --namespace AWS/ApplicationELB \
    --statistic Average \
    --period 60 \
    --threshold 1 \
    --comparison-operator GreaterThanOrEqualToThreshold
```

---

## Additional Resources

### Practice Labs
- AWS Skill Builder
- AWS Well-Architected Labs
- A Cloud Guru Labs
- Cloud Academy

### Certification Paths
1. Cloud Practitioner (CLF-C02)
2. Solutions Architect Associate (SAA-C03)
3. Developer Associate (DVA-C02)
4. SysOps Administrator Associate (SOA-C02)
5. Solutions Architect Professional (SAP-C02)
6. DevOps Engineer Professional (DOP-C02)

### Key Services to Know
- **Compute**: EC2, Lambda, ECS, EKS
- **Storage**: S3, EBS, EFS
- **Database**: RDS, Aurora, DynamoDB
- **Networking**: VPC, Route 53, CloudFront
- **Security**: IAM, KMS, WAF
- **Monitoring**: CloudWatch, X-Ray, CloudTrail
