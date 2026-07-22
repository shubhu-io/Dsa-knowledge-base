# CI/CD Complete Guide

## Table of Contents

1. [What is CI/CD?](#what-is-cicd)
2. [The CI/CD Pipeline](#the-cicd-pipeline)
3. [Continuous Integration](#continuous-integration)
4. [Continuous Delivery vs Continuous Deployment](#continuous-delivery-vs-continuous-deployment)
5. [Pipeline Stages Deep Dive](#pipeline-stages-deep-dive)
6. [Version Control Strategies](#version-control-strategies)
7. [Build Automation](#build-automation)
8. [Test Automation](#test-automation)
9. [Deployment Strategies](#deployment-strategies)
10. [Infrastructure as Code](#infrastructure-as-code)
11. [Security in CI/CD](#security-in-cicd)
12. [Monitoring and Observability](#monitoring-and-observability)

---

## What is CI/CD?

CI/CD stands for Continuous Integration, Continuous Delivery, and Continuous Deployment. It represents a set of practices that automate the movement of applications through the development lifecycle.

### The Evolution

```
Traditional:     Manual Code → Manual Build → Manual Test → Manual Deploy
     ↓
Agile:           Code → Sprint → Release (periodic)
     ↓
CI/CD:           Code → Auto Build → Auto Test → Auto Deploy (continuous)
```

### Why CI/CD Matters

| Benefit | Impact |
|---------|--------|
| Faster Feedback | Developers know within minutes if code breaks |
| Reduced Risk | Small changes are easier to debug and roll back |
| Higher Quality | Automated tests catch bugs before production |
| Developer Productivity | Less time on manual processes |
| Consistency | Eliminates "works on my machine" problems |

---

## The CI/CD Pipeline

### Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     CI/CD PIPELINE                         │
├──────────┬──────────┬──────────┬──────────┬────────────────┤
│  SOURCE   │  BUILD   │  TEST    │  DELIVER │   DEPLOY      │
├──────────┼──────────┼──────────┼──────────┼────────────────┤
│ Git Push │ Compile  │ Unit     │ Artifact │ Staging        │
│ PR Merge │ Install  │ Integra- │ Version  │ Production     │
│ Webhook  │ Lint     │ tion     │ Scan     │ Canary         │
│ Schedule │ SAST     │ E2E      │ Package  │ Blue-Green     │
│ Tag      │ Build    │ Perf     │ Sign     │ Rolling        │
└──────────┴──────────┴──────────┴──────────┴────────────────┘
```

### Pipeline as Code

```yaml
# Example: GitHub Actions Pipeline
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '18'
  REGISTRY: ghcr.io

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test -- --coverage

      - name: Build application
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v4
        with:
          name: build-output
          path: dist/

      - name: Deploy to production
        run: echo "Deploying to production..."
```

---

## Continuous Integration

### Principles of CI

1. **Maintain a Single Source Repository**
   - All code in version control
   - Frequent commits (at least daily)

2. **Automate the Build**
   - One command to build the system
   - Build should be reproducible

3. **Make the Build Self-Testing**
   - Automated test suite
   - Tests run on every commit

4. **Every Commit Should Build on an Integration Machine**
   - Dedicated CI server
   - Fast feedback loop

5. **Keep the Build Fast**
   - Target < 10 minutes
   - Parallelize where possible

6. **Test in a Clone of the Production Environment**
   - Consistent environments
   - Use containers for parity

7. **Make It Easy to Get the Latest Deliverables**
   - Accessible artifacts
   - Clear versioning

### CI Best Practices

```bash
# Good: Small, focused commits
git commit -m "fix: resolve null pointer in user service"
git commit -m "feat: add email validation"
git commit -m "test: add unit tests for payment module"

# Bad: Large, unfocused commits
git commit -m "fixed stuff and added features"
git commit -m "WIP"
```

### Feature Branch Workflow

```
main ─────────────────────────────────────────────►
  │                                                 ▲
  ├── develop ──────────────────────────────────────┤
  │   │        │        │        │                  │
  │   ├── feat-1 ──────┤        │                  │
  │   │   (PR #1) ─────┘        │                  │
  │   │                          ├── feat-2 ───────┤
  │   │                          │   (PR #2) ──────┘
  │   │                          │
```

---

## Continuous Delivery vs Continuous Deployment

### Continuous Delivery

- Every change is **potentially** deployable
- Deployment to production requires **manual approval**
- Safer for organizations new to CD

```
Code → Build → Test → Stage → [Manual Approval] → Production
```

### Continuous Deployment

- Every change that passes all stages is **automatically** deployed
- No human intervention
- Requires high confidence in testing

```
Code → Build → Test → Stage → Production (automatic)
```

### Decision Matrix

| Factor | Continuous Delivery | Continuous Deployment |
|--------|--------------------|-----------------------|
| Risk tolerance | Lower | Higher |
| Test coverage | Good | Excellent |
| Team experience | Moderate | Advanced |
| Regulatory requirements | May require approval | Full automation OK |
| Customer impact | Controlled | Real-time |
| Rollback frequency | Manual | Automated |

---

## Pipeline Stages Deep Dive

### Stage 1: Source

```yaml
# Branch protection rules
branch_protection:
  main:
    required_reviews: 2
    status_checks:
      - build
      - test
      - security-scan
    enforce_admins: true
    restrictions:
      teams: ["core-team"]
```

### Stage 2: Build

```dockerfile
# Multi-stage Docker build for CI
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Stage 3: Test

```yaml
# Test stages configuration
test_stages:
  unit_tests:
    command: "npm run test:unit"
    coverage_threshold: 80
    timeout: 5m

  integration_tests:
    command: "npm run test:integration"
    services:
      - postgres:15
      - redis:7
    timeout: 15m

  e2e_tests:
    command: "npm run test:e2e"
    browsers: [chrome, firefox]
    timeout: 30m

  performance_tests:
    command: "k6 run load-test.js"
    thresholds:
      http_req_duration: ["p(95)<500"]
    timeout: 10m
```

### Stage 4: Security Scanning

```yaml
# Security scan configuration
security_scans:
  sast:
    tool: "semgrep"
    config: ".semgrep.yml"
    fail_on: "high"

  dependency_scan:
    tool: "snyk"
    severity_threshold: "high"
    auto_fix: false

  container_scan:
    tool: "trivy"
    severity: "CRITICAL,HIGH"

  secret_scan:
    tool: "gitleaks"
    config: ".gitleaks.toml"
```

### Stage 5: Deploy

```yaml
# Deployment configuration
deploy:
  staging:
    environment: staging
    strategy: rolling
    health_check:
      url: /health
      interval: 30s
      timeout: 10s
      retries: 3

  production:
    environment: production
    strategy: canary
    canary_percentage: 10
    canary_duration: 30m
    auto_promote: true
    auto_rollback: true
    health_check:
      url: /health
      interval: 15s
      timeout: 5s
      retries: 5
```

---

## Version Control Strategies

### Git Flow

```
main ──────────────────────────────────────────────────►
  │                                                    ▲
  ├── release/1.0 ──────────────────────►              │
  │                                          │         │
  ├── develop ──────────────────────────────┤         │
  │   │         │         │                 │         │
  │   ├── feature/login ──┤                 │         │
  │   ├── feature/pay ────┤                 │         │
  │   │                   ├── hotfix/bug ───┘─────────┤
  │   │                   │                           │
```

### GitHub Flow (Simplified)

```
main ──────●────────●────────●─────────────►
            \      / \      / \
             \    /   \    /   \
              ●──●     ●──●     ●──●
           feature  feature  feature
```

### Trunk-Based Development

```
main ───●──●──●──●──●──●──●──●──●──●──►
         \  |  /  \  |  /  \  |  /
          short    short    short
         lived    lived    lived
         branch   branch   branch
```

### Comparison

| Strategy | Complexity | Release Frequency | Best For |
|----------|-----------|-------------------|----------|
| Git Flow | High | Scheduled | Enterprise, Mobile |
| GitHub Flow | Low | Continuous | Web Apps, SaaS |
| Trunk-Based | Medium | Continuous | Mature teams |

---

## Build Automation

### Build Tools by Language

```yaml
# JavaScript/TypeScript
javascript:
  package_manager: npm/yarn/pnpm
  build_command: "npm run build"
  tools: [webpack, vite, esbuild, rollup]

# Python
python:
  package_manager: pip/poetry/pipenv
  build_command: "python -m build"
  tools: [setuptools, poetry, flit]

# Java
java:
  package_manager: maven/gradle
  build_command: "mvn clean package"
  tools: [maven, gradle]

# Go
go:
  package_manager: go modules
  build_command: "go build"
  tools: [go build]

# Rust
rust:
  package_manager: cargo
  build_command: "cargo build --release"
  tools: [cargo]
```

### Build Optimization

```yaml
# Caching strategies
caching:
  npm:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-

  docker:
    type: registry
    image: myapp-builder
    cache-from: type=registry,ref=myapp-builder:latest

  artifacts:
    paths: |
      node_modules/
      .next/cache/
    key: ${{ runner.os }}-${{ hashFiles('**/lockfiles') }}
```

---

## Test Automation

### Test Pyramid

```
         /\
        /  \         E2E Tests
       /    \        (Few, Slow, Expensive)
      /──────\
     /        \      Integration Tests
    /          \     (Some, Moderate Speed)
   /────────────\
  /              \   Unit Tests
 /                \  (Many, Fast, Cheap)
/──────────────────\
```

### Test Configuration Example

```javascript
// jest.config.js - CI-optimized configuration
module.exports = {
  projects: [
    {
      displayName: 'unit',
      testMatch: ['<rootDir>/src/**/*.test.unit.js'],
      coverageThreshold: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
    {
      displayName: 'integration',
      testMatch: ['<rootDir>/src/**/*.test.integration.js'],
      globalSetup: './tests/setup.js',
      globalTeardown: './tests/teardown.js',
    },
  ],
  reporters: [
    'default',
    ['jest-junit', { outputDirectory: 'test-results' }],
  ],
};
```

---

## Deployment Strategies

### Blue-Green Deployment

```
Load Balancer
     │
     ▼
┌─────────┐     ┌─────────┐
│  Blue   │     │  Green  │
│ (Live)  │     │ (New)   │
└─────────┘     └─────────┘
     │               │
     └───────┬───────┘
             │
        ┌────▼────┐
        │   DB    │
        └─────────┘

Traffic: 100% Blue → 100% Green
Rollback: Switch back to Blue
```

### Canary Deployment

```
Load Balancer
     │
     ├────── 90% ──────► Blue (Current)
     │
     └────── 10% ──────► Green (Canary)

Monitor metrics for canary...
If healthy → Gradually increase to 100%
If issues → Route 100% back to Blue
```

### Rolling Deployment

```
Step 1: [Blue][Blue][Blue][Blue] → 100% Blue
Step 2: [Blue][Blue][Blue][Green] → 75% Blue
Step 3: [Blue][Blue][Green][Green] → 50% Blue
Step 4: [Blue][Green][Green][Green] → 25% Blue
Step 5: [Green][Green][Green][Green] → 100% Green
```

### Strategy Comparison

| Strategy | Downtime | Rollback Speed | Resource Cost | Complexity |
|----------|----------|---------------|---------------|------------|
| Recreate | Yes | Slow | Low | Low |
| Rolling | No | Medium | Low | Medium |
| Blue-Green | No | Instant | High | Medium |
| Canary | No | Fast | Medium | High |

---

## Infrastructure as Code

### IaC Tools Comparison

```yaml
# Terraform (HCL)
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}

# AWS CloudFormation (YAML)
Resources:
  WebServer:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0c55b159cbfafe1f0
      InstanceType: t2.micro
      Tags:
        - Key: Name
          Value: web-server

# Pulumi (TypeScript)
const server = new aws.ec2.Instance("web-server", {
  ami: "ami-0c55b159cbfafe1f0",
  instanceType: "t2.micro",
  tags: {
    Name: "web-server",
  },
});
```

### IaC Best Practices

1. **Version Control Everything**
   - Store all IaC in Git
   - Use meaningful commit messages

2. **Use Modules/Components**
   - Reusable infrastructure components
   - DRY principle applies

3. **Environment Parity**
   - Same IaC for all environments
   - Parameterize differences

4. **State Management**
   - Remote state storage
   - State locking
   - Regular backups

5. **Testing**
   - Validate before apply
   - Use planning/dry-run modes
   - Automated drift detection

---

## Security in CI/CD

### DevSecOps Pipeline

```
Code → SAST → Build → DAST → Deploy → Monitor
  │      │      │      │       │        │
  │      │      │      │       │        └── Runtime Protection
  │      │      │      │       └── Container Scanning
  │      │      │      └── Dynamic Testing
  │      │      └── Dependency Scanning
  │      └── Static Analysis
  └── Secret Detection
```

### Secret Management

```yaml
# GitHub Actions - Using Secrets
steps:
  - name: Deploy
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    run: |
      aws s3 sync dist/ s3://my-bucket/

# Never do this!
# - run: echo "password=${{ secrets.DB_PASSWORD }}" >> .env
```

### Security Scanning Configuration

```yaml
# .github/workflows/security.yml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

      - name: Run Trivy
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'
```

---

## Monitoring and Observability

### CI/CD Metrics to Track

```yaml
# Pipeline metrics
metrics:
  pipeline:
    - lead_time: "Time from commit to production"
    - deployment_frequency: "Deployments per day"
    - change_failure_rate: "Failed deployments %"
    - mean_time_to_recovery: "Recovery time from failures"

  build:
    - build_duration: "Total build time"
    - build_success_rate: "Successful builds %"
    - test_coverage: "Code coverage %"
    - flaky_test_rate: "Flaky tests %"

  quality:
    - code_quality_score: "SonarQube rating"
    - technical_debt: "Time to fix issues"
    - vulnerability_count: "Security issues found"
```

### Alerting Configuration

```yaml
# alerting-rules.yml
groups:
  - name: cicd_alerts
    rules:
      - alert: PipelineFailed
        expr: ci_pipeline_status{status="failed"} > 0
        for: 0m
        labels:
          severity: critical
        annotations:
          summary: "CI Pipeline Failed"

      - alert: BuildDurationHigh
        expr: ci_build_duration_seconds > 600
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Build taking too long"
```

---

## Common Interview Questions

### Q1: What is the difference between Continuous Delivery and Continuous Deployment?

**Answer:**
Continuous Delivery ensures code is always in a deployable state, but deployment to production requires manual approval. Continuous Deployment goes further by automatically deploying every change that passes all pipeline stages to production without human intervention.

### Q2: How would you handle a broken build?

**Answer:**
1. Stop all other work until the build is fixed
2. Identify the failing test or check
3. Fix the issue immediately
4. If can't fix quickly, revert the change
5. Add tests to prevent similar issues
6. Analyze root cause to improve process

### Q3: What are the key metrics for measuring CI/CD effectiveness?

**Answer:**
- **Lead Time**: Time from commit to production (target: < 1 hour)
- **Deployment Frequency**: How often you deploy (target: multiple times per day)
- **Change Failure Rate**: Percentage of deployments causing failures (target: < 5%)
- **Mean Time to Recovery**: Time to recover from failures (target: < 1 hour)

### Q4: How do you secure a CI/CD pipeline?

**Answer:**
- Use secret management tools (never hardcode secrets)
- Implement least privilege access
- Scan code for vulnerabilities (SAST/DAST)
- Sign artifacts and verify integrity
- Audit pipeline activities
- Use dedicated CI/CD runners
- Regular security assessments

### Q5: What is Infrastructure as Code and why is it important for CI/CD?

**Answer:**
Infrastructure as Code (IaC) manages infrastructure through machine-readable configuration files. It's important for CI/CD because it enables:
- Reproducible environments
- Version-controlled infrastructure
- Automated environment provisioning
- Consistency across environments
- Quick disaster recovery

---

## Additional Resources

- [The Twelve-Factor App](https://12factor.net/)
- [Continuous Delivery by Jez Humble](https://continuousdelivery.com/)
- [DevOps Handbook](https://itrevolution.com/the-devops-handbook/)
- [Google SRE Book](https://sre.google/sre-book/table-of-contents/)
