# DevOps Practices - Industry Best Practices & Methods

## Table of Contents

1. [Agile Methodologies](#agile-methodologies)
2. [Continuous Integration](#continuous-integration)
3. [Continuous Delivery/Deployment](#continuous-deliverydeployment)
4. [Infrastructure as Code](#infrastructure-as-code)
5. [GitOps](#gitops)
6. [Site Reliability Engineering (SRE)](#site-reliability-engineering-sre)
7. [DevSecOps](#devsecops)
8. [Platform Engineering](#platform-engineering)
9. [Chaos Engineering](#chaos-engineering)
10. [FinOps](#finops)

---

## Agile Methodologies

### Scrum Framework

```
Product Backlog
    |
    v
Sprint Planning
    |
    v
+-------------------+
| Sprint (2-4 weeks)|
|   Daily Standups   |
|   Development      |
|   Testing          |
+-------------------+
    |
    v
Sprint Review
    |
    v
Sprint Retrospective
    |
    v
Increment (Potentially Shippable)
```

**Roles**:
- **Product Owner**: Prioritizes backlog
- **Scrum Master**: Facilitates process
- **Development Team**: Delivers increment

**Ceremonies**:
- Sprint Planning
- Daily Standup
- Sprint Review
- Sprint Retrospective

### Kanban

```
Backlog | To Do | In Progress | Review | Done
   |      |        |           |        |
   v      v        v           v        v
  [ ]    [ ]      [ ]         [ ]      [ ]
  [ ]    [ ]      [ ]         [ ]      [ ]
  [ ]    [ ]                  [ ]      [ ]
```

**Practices**:
- Visualize workflow
- Limit Work in Progress (WIP)
- Manage flow
- Make policies explicit
- Implement feedback loops

### SAFe (Scaled Agile Framework)

```
Portfolio Level
    |
    v
Program Level (ART)
    |
    v
Team Level
    |
    v
Essential, Large Solution, Portfolio
```

---

## Continuous Integration

### Best Practices

1. **Commit Frequently**: Multiple times per day
2. **Automated Build**: Every commit triggers build
3. **Automated Tests**: Run on every build
4. **Fail Fast**: Quick feedback
5. **Keep Builds Fast**: Under 10 minutes
6. **Fix Broken Builds Immediately**: Never leave broken

### CI Pipeline Stages

```
Code Commit
    |
    v
Compile/Build
    |
    v
Unit Tests
    |
    v
Integration Tests
    |
    v
Code Quality Analysis
    |
    v
Security Scanning
    |
    v
Artifact Creation
```

### CI Metrics

| Metric | Target |
|--------|--------|
| Build Duration | < 10 minutes |
| Build Success Rate | > 95% |
| Test Coverage | > 80% |
| Time to Feedback | < 5 minutes |
| Failed Build Resolution | < 30 minutes |

---

## Continuous Delivery/Deployment

### CD Pipeline

```
CI Pipeline
    |
    v
Deploy to Staging
    |
    v
Automated Tests (Integration, E2E)
    |
    v
Performance Tests
    |
    v
Security Tests
    |
    v
Approval Gate (Manual/Auto)
    |
    v
Deploy to Production
    |
    v
Smoke Tests
    |
    v
Monitoring
```

### Deployment Strategies

**Blue/Green Deployment**:
```
Current (Blue):  [v1.0] <--- Traffic
New (Green):     [v2.0] <--- No traffic

Switch:          [v1.0] <--- No traffic (backup)
                 [v2.0] <--- Traffic

Rollback:        [v1.0] <--- Traffic
                 [v2.0] <--- No traffic
```

**Canary Deployment**:
```
Phase 1: [v1.0] (95%)  +  [v2.0] (5%)
Phase 2: [v1.0] (90%)  +  [v2.0] (10%)
Phase 3: [v1.0] (75%)  +  [v2.0] (25%)
Phase 4: [v1.0] (50%)  +  [v2.0] (50%)
Phase 5: [v2.0] (100%)
```

**Rolling Update**:
```
Initial:    [v1.0] [v1.0] [v1.0] [v1.0]
Step 1:     [v2.0] [v1.0] [v1.0] [v1.0]
Step 2:     [v2.0] [v2.0] [v1.0] [v1.0]
Step 3:     [v2.0] [v2.0] [v2.0] [v1.0]
Complete:   [v2.0] [v2.0] [v2.0] [v2.0]
```

**Feature Flags**:
```javascript
// Code example
if (featureFlags.isEnabled('new-checkout')) {
    // New checkout flow
    return newCheckout();
} else {
    // Old checkout flow
    return oldCheckout();
}
```

### CD Metrics

| Metric | Target |
|--------|--------|
| Deployment Frequency | Multiple per day |
| Lead Time for Changes | < 1 hour |
| Change Failure Rate | < 5% |
| Mean Time to Recovery | < 1 hour |

---

## Infrastructure as Code

### IaC Best Practices

1. **Version Control**: All IaC in Git
2. **Modular Design**: Reusable modules
3. **Idempotency**: Same result on repeated runs
4. **Immutable Infrastructure**: Replace, don't patch
5. **Plan Before Apply**: Review changes
6. **State Management**: Secure and remote state
7. **Testing**: Validate before deployment

### Terraform Best Practices

```
Project Structure:
├── modules/
│   ├── vpc/
│   ├── compute/
│   └── database/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
├── main.tf
├── variables.tf
└── outputs.tf
```

**State Management**:
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
```

### Configuration Drift Detection

```bash
# Terraform
terraform plan  # Detect drift

# Ansible
ansible-playbook playbook.yml --check  # Dry run

# CloudFormation
aws cloudformation detect-stack-resource-drift
```

---

## GitOps

### Principles

1. **Declarative**: System state declared in Git
2. **Versioned**: All changes in Git history
3. **Automated**: Changes applied automatically
4. **Self-healing**: Auto-remediation

### GitOps Workflow

```
Developer -> Git Push -> CI Pipeline -> Build Artifacts
                                      |
                                      v
                              Git Repository
                                      |
                                      v
                              GitOps Controller
                                      |
                                      v
                              Kubernetes Cluster
```

### ArgoCD Workflow

```
Git Repo (desired state)
    |
    v
ArgoCD watches for changes
    |
    v
Compare desired vs actual state
    |
    v
Apply changes to cluster
    |
    v
Report status back to Git
```

### GitOps Tools

| Tool | Type | Features |
|------|------|----------|
| ArgoCD | CD | Kubernetes-native, UI |
| Flux | CD | Lightweight, GitOps toolkit |
| Helm | Package | Charts, releases |
| Kustomize | Config | Overlay-based |

### Flux Example

```yaml
# flux-system/gotk-components.yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: my-app
spec:
  interval: 1m
  url: https://github.com/user/repo
  ref:
    branch: main
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: my-app
spec:
  interval: 10m
  path: ./k8s
  sourceRef:
    kind: GitRepository
    name: my-app
```

---

## Site Reliability Engineering (SRE)

### Core Concepts

1. **Service Level Indicators (SLIs)**
   - Latency
   - Traffic
   - Errors
   - Saturation

2. **Service Level Objectives (SLOs)**
   - 99.9% availability
   - < 200ms latency (p99)
   - < 0.1% error rate

3. **Error Budgets**
   - Allowed downtime: 43 minutes/month (99.9%)
   - If exceeded: Freeze deployments

### SRE Practices

| Practice | Description |
|----------|-------------|
| Toil Reduction | Automate repetitive tasks |
| Capacity Planning | Forecast resource needs |
| Incident Management | Respond to outages |
| Postmortems | Learn from failures |
| Change Management | Risk-based deployment |

### Incident Response Process

```
1. Detection
   +-- Monitoring alerts
   +-- User reports
   +-- Synthetic checks

2. Triage
   +-- Severity assessment
   +-- Impact analysis
   +-- Team assembly

3. Mitigation
   +-- Rollback
   +-- Feature flags
   +-- Scaling

4. Resolution
   +-- Root cause fix
   +-- Verification
   +-- Monitoring

5. Postmortem
   +-- Timeline
   +-- Root cause
   +-- Action items
   +-- Lessons learned
```

### Error Budget Policy

```
SLO: 99.9% availability (43.8 min/month budget)

Month 1: Used 30 min (68% of budget) -> Continue normal development
Month 2: Used 50 min (114% of budget) -> Freeze non-critical changes
Month 3: Used 10 min (23% of budget) -> Resume normal development
```

---

## DevSecOps

### Security Shift Left

```
Traditional: Dev -> SecOps (Security at end)
DevSecOps: Dev + Sec + Ops (Security throughout)

+-- Plan: Threat modeling
+-- Code: SAST, secret scanning
+-- Build: Container scanning, SCA
+-- Test: DAST, penetration testing
+-- Release: Compliance checks
+-- Deploy: Runtime protection
+-- Operate: Monitoring, response
```

### Security Pipeline

```
Code Commit
    |
    v
Secret Scanning (GitLeaks, TruffleHog)
    |
    v
SAST (SonarQube, Checkmarx)
    |
    v
SCA (Snyk, OWASP Dependency-Check)
    |
    v
Container Scanning (Trivy, Snyk)
    |
    v
DAST (OWASP ZAP, Burp Suite)
    |
    v
Compliance Check (Open Policy Agent)
    |
    v
Deploy
    |
    v
Runtime Protection (Falco, Twistlock)
```

### DevSecOps Tools

| Category | Tools |
|----------|-------|
| SAST | SonarQube, Checkmarx, Fortify |
| SCA | Snyk, OWASP Dep-Check, Black Duck |
| DAST | OWASP ZAP, Burp Suite |
| Container | Trivy, Clair, Anchore |
| Secrets | GitLeaks, TruffleHog, Vault |
| IaC | Checkov, tfsec, Terrascan |
| Runtime | Falco, Twistlock, Aqua |

---

## Platform Engineering

### What is Platform Engineering?

Building internal developer platforms that provide self-service capabilities for developers.

### Platform Components

```
+-------------------+
| Developer Portal  | (Backstage, Port)
+-------------------+
         |
+-------------------+
| Self-Service      | (Templates, Workflows)
+-------------------+
         |
+-------------------+
| Platform APIs     | (Service Catalog)
+-------------------+
         |
+-------------------+
| Infrastructure    | (Kubernetes, Cloud)
+-------------------+
```

### Platform Engineering vs DevOps

| Aspect | DevOps | Platform Engineering |
|--------|--------|---------------------|
| Focus | Culture & practices | Internal tools |
| Goal | Break silos | Self-service |
| Output | Pipelines | Platform |
| Users | Everyone | Developers |

### Backstage

- **Type**: Developer Portal
- **Use Case**: Service catalog, documentation
- **Features**: Plugins, templates, scorecards
- **Adoption**: Spotify, Netflix, American Airlines

---

## Chaos Engineering

### Principles

1. **Build Hypothesis**: Define steady state
2. **Introduce Real-World Events**: Failures
3. **Observe Difference**: Monitor impact
4. **Fix Problems**: Improve resilience

### Chaos Experiments

```
Hypothesis: Our system can handle AZ failure

Experiment:
1. Define steady state (response time < 200ms)
2. Terminate instances in one AZ
3. Monitor response time
4. Observe: Does traffic shift to other AZs?
5. Conclusion: System is resilient (or not)
```

### Chaos Tools

| Tool | Type | Use Case |
|------|------|----------|
| Chaos Monkey | Netflix | Random instance termination |
| Litmus | Kubernetes | K8s chaos experiments |
| Gremlin | SaaS | Enterprise chaos platform |
| ToxiProxy | Network | Network fault injection |
| Chaos Toolkit | Framework | Define experiments |

### Chaos Experiments Example

```yaml
# chaos-experiment.yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosEngine
metadata:
  name: pod-delete
spec:
  appinfo:
    appns: default
    applabel: app=my-app
    appkind: deployment
  chaosServiceAccount: pod-delete-sa
  experiments:
    - name: pod-delete
      spec:
        components:
          env:
            - name: TOTAL_CHAOS_DURATION
              value: '30'
            - name: CHAOS_INTERVAL
              value: '10'
```

---

## FinOps

### FinOps Principles

1. **Collaboration**: Finance, Engineering, Business
2. **Ownership**: Teams own their cloud costs
3. **Centralized Team**: FinOps team enables others
4. **Real-time Decisions**: Data-driven cost decisions
5. **Value-Driven**: Optimize for value, not just cost

### FinOps Framework

```
Inform
+-- Allocate costs to teams/services
+-- Showback/chargeback reports
+-- Benchmarking

Optimize
+-- Right-sizing
+-- Reserved instances
+-- Spot/preemptible
+-- Storage optimization

Operate
+-- Budgets and alerts
+-- Cost anomalies
+-- Continuous improvement
```

### FinOps Metrics

| Metric | Description |
|--------|-------------|
| Cost per Transaction | Cost per business transaction |
| Cost per Customer | Cost per active customer |
| Cost per Feature | Cost per feature delivered |
| Waste Percentage | Percentage of unused resources |

---

## Best Practices Summary

### Top 10 DevOps Practices

1. **Version Control Everything**
   - Code, infrastructure, documentation, configs

2. **Automate Testing**
   - Unit, integration, E2E, performance

3. **Implement CI/CD**
   - Fast feedback, frequent deployments

4. **Use Infrastructure as Code**
   - Reproducible, version-controlled environments

5. **Monitor Everything**
   - Metrics, logs, traces

6. **Practice Blameless Postmortems**
   - Learn from failures, not blame

7. **Automate Toil**
   - Eliminate repetitive manual work

8. **Shift Left Security**
   - Security early in development

9. **Use Feature Flags**
   - Decouple deployment from release

10. **Continuously Improve**
    - Retrospectives, metrics, feedback loops

---

## Next Steps

1. Review [DevOps Tools](devops-tools.md) for specific tooling
2. Practice with [Interview Questions](devops-interview-questions.md)
3. Build a complete CI/CD pipeline project
4. Pursue CKA (Certified Kubernetes Administrator)
5. Implement GitOps workflow
