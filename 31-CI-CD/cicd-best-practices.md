# CI/CD Best Practices

## Table of Contents

1. [Core Principles](#core-principles)
2. [Pipeline Design Best Practices](#pipeline-design-best-practices)
3. [Version Control Best Practices](#version-control-best-practices)
4. [Build Best Practices](#build-best-practices)
5. [Testing Best Practices](#testing-best-practices)
6. [Deployment Best Practices](#deployment-best-practices)
7. [Security Best Practices](#security-best-practices)
8. [Monitoring Best Practices](#monitoring-best-practices)
9. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
10. [Team Culture](#team-culture)

---

## Core Principles

### The Four Pillars of CI/CD

```
1. FAST FEEDBACK
   └── Know immediately when something breaks

2. AUTOMATION
   └── Eliminate manual, error-prone steps

3. VISIBILITY
   └── Everyone can see pipeline status

4. CONTINUOUS IMPROVEMENT
   └── Regularly refine your processes
```

### Key Metrics to Track

| Metric | Target | Description |
|--------|--------|-------------|
| Lead Time | < 1 hour | Commit to production |
| Deployment Frequency | Daily | How often you deploy |
| Change Failure Rate | < 5% | Failed deployments |
| MTTR | < 1 hour | Recovery time |

---

## Pipeline Design Best Practices

### 1. Keep Pipelines Fast

```yaml
# Good: Parallel execution
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]
  test-unit:
    runs-on: ubuntu-latest
    steps: [...]
  test-integration:
    runs-on: ubuntu-latest
    steps: [...]
  # All three run in parallel

# Bad: Sequential execution
jobs:
  build:
    steps: [...]
  lint:
    needs: build  # Unnecessary dependency
    steps: [...]
  test:
    needs: lint  # Unnecessary dependency
    steps: [...]
```

### 2. Fail Fast

```yaml
# Order stages by speed (fastest first)
stages:
  - name: lint          # Seconds
  - name: typecheck     # Seconds
  - name: unit-tests    # Minutes
  - name: integration   # Minutes
  - name: e2e          # Minutes
  - name: build        # Minutes
  - name: deploy       # Minutes
```

### 3. Use Caching Aggressively

```yaml
# Cache dependencies
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-

# Cache Docker layers
- uses: docker/build-push-action@v4
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### 4. Make Pipelines Idempotent

```yaml
# Good: Clean state before running
steps:
  - run: rm -rf node_modules
  - run: npm ci
  - run: npm test

# Bad: Assuming clean state
steps:
  - run: npm install  # May use stale cache
  - run: npm test
```

### 5. Use Pipeline as Code

```
✅ Store pipeline config in version control
✅ Review pipeline changes in pull requests
✅ Test pipeline changes before merging
✅ Document pipeline decisions
```

---

## Version Control Best Practices

### Branch Strategy

```
# Trunk-Based Development (Recommended for CI/CD)

main ───●──●──●──●──●──●──●──●──●──►
         \  |  /  \  |  /
          short    short
          lived    lived
          branches branches

Rules:
- Short-lived branches (< 1 day)
- Small, focused changes
- Frequent merges to main
- Feature flags for incomplete work
```

### Commit Practices

```bash
# Good: Small, atomic commits
git commit -m "feat: add user registration endpoint"
git commit -m "test: add unit tests for registration"
git commit -m "docs: update API documentation"
git commit -m "fix: validate email format in registration"

# Bad: Large, unfocused commits
git commit -m "update user module and fix bugs"
git commit -m "WIP"
```

### Pull Request Guidelines

```yaml
# PR Template
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No hardcoded secrets
```

---

## Build Best Practices

### Reproducible Builds

```dockerfile
# Pin versions for reproducibility
FROM node:18.17.0-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Use multi-stage builds
FROM node:18.17.0-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Build Optimization

```yaml
# Parallel builds
jobs:
  build-backend:
    runs-on: ubuntu-latest
    steps:
      - run: cd backend && npm run build

  build-frontend:
    runs-on: ubuntu-latest
    steps:
      - run: cd frontend && npm run build

  build-docs:
    runs-on: ubuntu-latest
    steps:
      - run: npm run build:docs
  # All three run in parallel
```

### Dependency Management

```yaml
# Dependabot configuration
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    reviewers:
      - "team-leads"
    labels:
      - "dependencies"
      - "automated"

  - package-ecosystem: "docker"
    directory: "/"
    schedule:
      interval: "weekly"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

---

## Testing Best Practices

### Test Pyramid

```
         /\
        /  \         E2E Tests (10%)
       /    \        - Critical user journeys
      /──────\       - Slow, expensive
     /        \      Integration Tests (20%)
    /          \     - API tests
   /────────────\    - Service interactions
  /              \   Unit Tests (70%)
 /                \  - Business logic
/──────────────────\ - Fast, cheap
```

### Test Configuration

```yaml
# Test stages
test_stages:
  unit:
    command: npm run test:unit
    coverage_threshold: 80
    timeout: 5m

  integration:
    command: npm run test:integration
    services: [postgres, redis]
    timeout: 15m

  e2e:
    command: npm run test:e2e
    browsers: [chrome]
    timeout: 30m
```

### Flaky Test Management

```yaml
# Mark and retry flaky tests
jobs:
  test:
    steps:
      - name: Run tests with retry
        uses: nick-fields/retry@v2
        with:
          timeout_minutes: 10
          max_attempts: 3
          retry_wait_seconds: 30
          command: npm run test

      - name: Report flaky tests
        if: failure()
        run: |
          echo "Tests failed after retries - possible flaky tests"
          # Log to tracking system
```

### Code Coverage

```yaml
# Coverage configuration
coverage:
  status:
    project:
      default:
        target: 80%
        threshold: 2%
    patch:
      default:
        target: 90%

# Coverage reporting
- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage/lcov.info
    flags: unittests
```

---

## Deployment Best Practices

### Blue-Green Deployment

```yaml
# Kubernetes blue-green deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
  labels:
    app: myapp
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: blue
  template:
    metadata:
      labels:
        app: myapp
        version: blue
    spec:
      containers:
      - name: app
        image: myapp:blue
        ports:
        - containerPort: 8080
---
# Service switches traffic between blue and green
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
    version: blue  # Change to green for deployment
  ports:
  - port: 80
    targetPort: 8080
```

### Canary Deployment

```yaml
# Istio canary configuration
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: myapp
spec:
  hosts:
  - myapp
  http:
  - route:
    - destination:
        host: myapp
        subset: stable
      weight: 90
    - destination:
        host: myapp
        subset: canary
      weight: 10
```

### Deployment Checklist

```yaml
deploy_checklist:
  pre_deployment:
    - All tests passing
    - Code reviewed and approved
    - Security scans completed
    - Database migrations tested
    - Rollback plan documented

  deployment:
    - Deploy to staging first
    - Run smoke tests
    - Monitor error rates
    - Check performance metrics
    - Gradual traffic increase

  post_deployment:
    - Verify health checks
    - Monitor logs
    - Check user feedback
    - Update documentation
    - Notify stakeholders
```

---

## Security Best Practices

### Secret Management

```yaml
# Good: Use secret management
steps:
  - name: Deploy
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    run: aws s3 sync dist/ s3://my-bucket/

# Bad: Never do this
# - run: echo "key=abc123" >> .env
# - run: export API_KEY=secret123
```

### Security Scanning

```yaml
# SAST (Static Application Security Testing)
sast:
  rules:
    - pattern: eval()
      severity: high
    - pattern: exec()
      severity: medium

# DAST (Dynamic Application Security Testing)
dast:
  target: https://staging.example.com
  rules:
    - name: XSS
    - name: SQL Injection
    - name: CSRF

# Dependency scanning
dependency_scan:
  tool: snyk
  severity_threshold: high
  auto_fix: false  # Review fixes first
```

### Signed Commits

```yaml
# Require signed commits
- name: Verify commit signature
  run: |
    git verify-commit ${{ github.sha }}
    if [ $? -ne 0 ]; then
      echo "Commit signature verification failed"
      exit 1
    fi
```

---

## Monitoring Best Practices

### Pipeline Metrics

```yaml
# Metrics to track
metrics:
  pipeline:
    - lead_time: Time from commit to production
    - deployment_frequency: Deploys per day
    - change_failure_rate: Failed deploys %
    - mean_time_to_recovery: Recovery time

  build:
    - build_duration: Total build time
    - build_success_rate: Successful builds %
    - test_coverage: Code coverage %
    - flaky_test_rate: Flaky tests %

  quality:
    - code_quality_score: Linting results
    - technical_debt: Time to fix issues
    - vulnerability_count: Security issues
```

### Alerting

```yaml
# Alerting rules
alerts:
  - name: PipelineFailed
    condition: pipeline.status == 'failed'
    severity: critical
    notification: slack, email

  - name: BuildDurationHigh
    condition: pipeline.duration > 30m
    severity: warning
    notification: slack

  - name: TestCoverageLow
    condition: coverage < 70%
    severity: warning
    notification: slack
```

---

## Anti-Patterns to Avoid

### 1. Snowflake Pipelines

```yaml
# Bad: Different pipelines for each environment
deploy-staging:
  script: ./deploy.sh staging

deploy-production:
  script: ./deploy-prod.sh production  # Different script!

# Good: Same pipeline, different config
deploy:
  strategy: canary
  environment: ${{ matrix.env }}
```

### 2. Manual Steps in Automated Pipeline

```yaml
# Bad: Manual intervention required
steps:
  - name: Deploy to production
    run: |
      echo "Deploying to production..."
      # Requires manual approval in UI

# Good: Automated with proper gates
steps:
  - name: Deploy to production
    environment: production  # Uses environment protection rules
    run: echo "Deploying to production..."
```

### 3. Long-Running Pipelines

```yaml
# Bad: Sequential jobs that could be parallel
jobs:
  build:
    steps: [...]
  lint:
    needs: build  # Unnecessary dependency
    steps: [...]
  test:
    needs: lint  # Unnecessary dependency
    steps: [...]

# Good: Parallel execution
jobs:
  build:
    steps: [...]
  lint:
    steps: [...]  # No dependency
  test:
    steps: [...]  # No dependency
  deploy:
    needs: [build, lint, test]  # Only deploy needs all
```

### 4. Ignoring Test Flakiness

```yaml
# Bad: Skipping flaky tests
- run: npm test -- --skip-flaky

# Good: Track and fix flaky tests
- run: npm run test
  continue-on-error: true  # Allow pipeline to continue
- name: Track flaky tests
  if: failure()
  run: |
    # Log flaky test to tracking system
    echo "Flaky test detected, logging to tracking system"
```

### 5. Hardcoded Values

```yaml
# Bad: Hardcoded values
steps:
  - run: docker build -t myapp:1.0.0 .
  - run: kubectl set image deployment/myapp myapp=myapp:1.0.0

# Good: Dynamic values
steps:
  - run: docker build -t myapp:${{ github.sha }} .
  - run: kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
```

---

## Team Culture

### CI/CD Maturity Model

```
Level 1: Basic
├── Manual builds
├── Manual testing
├── Manual deployment
└── No automation

Level 2: Intermediate
├── Automated builds
├── Basic test automation
├── Manual deployment
└── Some CI practices

Level 3: Advanced
├── Full CI/CD pipeline
├── Comprehensive testing
├── Automated deployment
├── Infrastructure as Code
└── Monitoring and alerting

Level 4: Elite
├── Trunk-based development
├── Continuous deployment
├── Full observability
├── Automated rollbacks
└── Chaos engineering
```

### DevOps Culture Practices

```yaml
practices:
  collaboration:
    - Shared responsibility for pipelines
    - Cross-functional teams
    - Blameless post-mortems
    - Regular retrospectives

  automation:
    - Everything that can be automated, should be
    - Pipeline as code
    - Infrastructure as code
    - Test automation

  measurement:
    - Track key metrics
    - Regular performance reviews
    - Data-driven decisions
    - Continuous improvement

  sharing:
    - Documentation
    - Knowledge sharing sessions
    - Internal tech talks
    - Open communication
```

### Getting Started Checklist

```yaml
getting_started:
  week_1:
    - Set up version control
    - Choose CI/CD tool
    - Create basic pipeline
    - Automate builds

  week_2:
    - Add unit tests
    - Set up test automation
    - Configure caching
    - Optimize build times

  week_3:
    - Add integration tests
    - Set up staging environment
    - Configure deployments
    - Add security scanning

  week_4:
    - Add E2E tests
    - Set up monitoring
    - Configure alerts
    - Document processes
```

---

## Common Interview Questions

### Q1: What are the most important CI/CD best practices?

**Answer:**
1. Keep pipelines fast and provide quick feedback
2. Automate everything possible
3. Use version control for all configurations
4. Implement comprehensive testing
5. Monitor and measure pipeline performance
6. Treat pipeline failures seriously
7. Continuously improve processes
8. Document decisions and processes

### Q2: How do you handle database migrations in CI/CD?

**Answer:**
- Version control all migrations
- Test migrations in CI pipeline
- Use backward-compatible migrations
- Separate schema changes from data changes
- Test rollback procedures
- Use feature flags for schema changes
- Coordinate with team on migration timing

### Q3: What is the difference between continuous delivery and continuous deployment?

**Answer:**
Continuous delivery ensures code is always in a deployable state with manual approval for production. Continuous deployment automatically deploys every change that passes all tests. Start with continuous delivery and move to deployment as confidence grows.

### Q4: How do you handle secrets in CI/CD?

**Answer:**
- Use built-in secret management tools
- Never hardcode secrets in code or configs
- Use OIDC for cloud provider authentication
- Rotate secrets regularly
- Audit secret access
- Use environment-specific secrets
- Implement least privilege access

### Q5: What are common CI/CD anti-patterns?

**Answer:**
- Snowflake pipelines (different per environment)
- Manual steps in automated pipelines
- Long-running pipelines
- Ignoring test flakiness
- Hardcoded values
- Not monitoring pipeline health
- Skipping security scans
- Blaming individuals for failures
