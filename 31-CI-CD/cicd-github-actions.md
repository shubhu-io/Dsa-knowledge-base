# GitHub Actions CI/CD Guide

This document covers setting up CI/CD pipelines using GitHub Actions.

## What is GitHub Actions?

GitHub Actions is a CI/CD platform that automates build, test, and deployment workflows directly from GitHub repositories.

## Basic Workflow Structure

### Workflow File Location
```
.github/workflows/ci.yml
```

### Basic YAML Structure
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test
        
      - name: Build
        run: npm run build
```

## Common Workflow Examples

### Node.js Application
```yaml
name: Node.js CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [14.x, 16.x, 18.x]
        
    steps:
      - uses: actions/checkout@v3
      
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          
      - run: npm ci
      - run: npm test
      - run: npm run build
```

### Python Application
```yaml
name: Python CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        python-version: [3.8, 3.9, 3.10]
        
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
          
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          
      - name: Run tests
        run: pytest
        
      - name: Run linting
        run: |
          pip install flake8
          flake8 .
```

### Docker Build and Push
```yaml
name: Docker CI/CD

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  docker:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
        
      - name: Login to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
          
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: user/app:latest
```

## Environment Variables and Secrets

### Using Environment Variables
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    env:
      NODE_ENV: production
      API_URL: https://api.example.com
      
    steps:
      - run: echo "Building for $NODE_ENV"
```

### Using Secrets
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 sync ./dist s3://my-bucket
```

## Caching Dependencies

### Node.js Caching
```yaml
steps:
  - uses: actions/setup-node@v3
    with:
      node-version: '16'
      cache: 'npm'
      
  - run: npm ci
```

### Python Caching
```yaml
steps:
  - uses: actions/setup-python@v4
    with:
      python-version: '3.10'
      cache: 'pip'
      
  - run: pip install -r requirements.txt
```

## Matrix Builds

### Testing Multiple Versions
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [14.x, 16.x, 18.x]
        os: [ubuntu-latest, windows-latest]
        
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
```

## Conditional Workflows

### Run on Specific Conditions
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - name: Deploy to production
        run: echo "Deploying..."
```

## Reusable Workflows

### Creating Reusable Workflows
```yaml
# .github/workflows/reusable-build.yml
name: Reusable Build

on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ inputs.node-version }}
      - run: npm ci
      - run: npm test
```

### Using Reusable Workflows
```yaml
jobs:
  build:
    uses: ./.github/workflows/reusable-build.yml
    with:
      node-version: '16'
```

## Deployment Strategies

### Blue-Green Deployment
```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: |
          # Deploy to green environment
          kubectl apply -f k8s/green/
          
      - name: Switch traffic
        run: |
          # Switch load balancer to green
          kubectl patch service my-app -p '{"spec":{"selector":{"color":"green"}}}'
          
      - name: Cleanup blue
        run: |
          # Delete old blue environment
          kubectl delete -f k8s/blue/
```

### Canary Deployment
```yaml
jobs:
  canary:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy canary (10%)
        run: |
          kubectl apply -f k8s/canary.yaml
          
      - name: Monitor metrics
        run: |
          # Check error rates for 5 minutes
          sleep 300
          
      - name: Promote to full
        if: success()
        run: |
          kubectl apply -f k8s/production.yaml
```

## Notifications

### Slack Notifications
```yaml
jobs:
  notify:
    runs-on: ubuntu-latest
    if: always()
    
    steps:
      - name: Slack Notification
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          fields: repo,message,commit,author
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Best Practices

### Workflow Organization
1. Keep workflows simple and focused
2. Use reusable workflows for common patterns
3. Document workflow purpose and steps
4. Use meaningful job and step names

### Security
1. Use GitHub secrets for sensitive data
2. Limit permissions with GITHUB_TOKEN
3. Review third-party actions before using
4. Avoid logging sensitive information

### Performance
1. Cache dependencies
2. Use matrix builds for parallel testing
3. Run jobs in parallel when possible
4. Use self-hosted runners for large builds

### Maintenance
1. Regularly update action versions
2. Monitor workflow run times
3. Clean up unused workflows
4. Review and optimize regularly

## Troubleshooting

### Common Issues
1. **Permission denied**: Check repository secrets and permissions
2. **Timeout errors**: Increase timeout-minutes or optimize workflow
3. **Dependency issues**: Verify package manager and versions
4. **Environment problems**: Check runner image and tools

### Debugging
```yaml
# Enable debug logging
env:
  ACTIONS_STEP_DEBUG: true
  
# Use tmate for interactive debugging
- uses: mxschmitt/action-tmate@v3
```

## See Also

- [[cicd-guide]]
- [[cicd-pipelines]]
- [[cicd-tools]]
- [[cicd-best-practices]]
