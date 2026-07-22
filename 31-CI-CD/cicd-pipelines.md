# CI/CD Pipelines - Design Patterns & Implementation

## Table of Contents

1. [Pipeline Architecture](#pipeline-architecture)
2. [GitHub Actions Pipelines](#github-actions-pipelines)
3. [GitLab CI/CD Pipelines](#gitlab-cicd-pipelines)
4. [Jenkins Pipelines](#jenkins-pipelines)
5. [Azure DevOps Pipelines](#azure-devops-pipelines)
6. [Advanced Pipeline Patterns](#advanced-pipeline-patterns)
7. [Pipeline Optimization](#pipeline-optimization)
8. [Multi-Environment Pipelines](#multi-environment-pipelines)

---

## Pipeline Architecture

### Basic Pipeline Structure

```
PREPARE       BUILD         TEST          DELIVER       DEPLOY
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│ Checkout│→ │ Install │→ │  Lint   │→ │ Package │→ │ Staging │
│  Setup  │  │ Compile │  │  Unit   │  │ Version │  │  Tests  │
│  Cache  │  │ Bundle  │  │  Integ  │  │  Sign   │  │  Prod   │
└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘
```

### Universal Pipeline YAML Structure

```yaml
pipeline:
  name: Application Pipeline

  trigger:
    branches:
      include: [main, develop]
    paths:
      include: ['src/**']
      exclude: ['docs/**', '*.md']

  variables:
    BUILD_CONFIGURATION: Release
    NODE_VERSION: '18'

  stages:
    - stage: Build
      jobs:
        - job: Compile
          steps:
            - script: npm ci
            - script: npm run build

    - stage: Test
      dependsOn: Build
      jobs:
        - job: UnitTests
        - job: IntegrationTests
        - job: CodeCoverage

    - stage: Deploy
      dependsOn: Test
      condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
      jobs:
        - deployment: DeployStaging
        - deployment: DeployProduction
```

---

## GitHub Actions Pipelines

### Full-Stack Application Pipeline

```yaml
name: Full-Stack CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '18'
  REGISTRY: ghcr.io

jobs:
  backend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./backend
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
      redis:
        image: redis:7
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json
      - run: npm ci
      - run: npm run lint
      - run: npm run test:unit -- --coverage
      - run: npm run test:integration
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/testdb

  frontend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./frontend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json
      - run: npm ci
      - run: npm run lint
      - run: npm run test:unit -- --coverage
      - run: npm run build

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

  deploy:
    needs: [backend, frontend, security]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - uses: actions/checkout@v4
      - run: echo "Deploying to production..."
```

### Reusable Workflow Pattern

```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      image_tag:
        required: true
        type: string
    secrets:
      AWS_ACCESS_KEY_ID:
        required: true
      AWS_SECRET_ACCESS_KEY:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - run: aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
```

---

## GitLab CI/CD Pipelines

### Complete GitLab CI Configuration

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - security
  - deploy-staging
  - deploy-production

variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE
  DOCKER_TAG: $CI_COMMIT_SHA

# Build Stage
build:
  stage: build
  image: node:18-alpine
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
      - .npm/
  script:
    - npm ci --cache .npm --prefer-offline
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 hour

# Test Stages
unit-tests:
  stage: test
  image: node:18-alpine
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
  script:
    - npm ci --cache .npm --prefer-offline
    - npm run test:unit -- --coverage
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

integration-tests:
  stage: test
  image: node:18-alpine
  services:
    - postgres:15
    - redis:7
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: postgresql://test:test@postgres:5432/testdb
  script:
    - npm ci --cache .npm --prefer-offline
    - npm run test:integration

# Security
sast:
  stage: security
  image: semgrep/semgrep:latest
  script:
    - semgrep --config=auto --sarif -o semgrep-results.sarif .
  artifacts:
    reports:
      sast: gl-sast-report.json

dependency-check:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy fs --severity HIGH,CRITICAL --exit-code 1 .

# Deploy
deploy-staging:
  stage: deploy-staging
  image: alpine:latest
  environment:
    name: staging
    url: https://staging.example.com
  script:
    - echo "Deploying to staging..."
  only:
    - develop

deploy-production:
  stage: deploy-production
  image: alpine:latest
  environment:
    name: production
    url: https://example.com
  script:
    - echo "Deploying to production..."
  when: manual
  only:
    - main
```

---

## Jenkins Pipelines

### Declarative Pipeline

```groovy
pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        REGISTRY = 'registry.example.com'
        IMAGE_NAME = "${REGISTRY}/myapp:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'npm run test:unit -- --coverage'
            }
            post {
                always {
                    junit '**/test-results/*.xml'
                    publishHTML(target: [
                        allowMissing: false,
                        keepAll: true,
                        reportDir: 'coverage/lcov-report',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }

        stage('Integration Test') {
            steps {
                sh 'docker-compose -f docker-compose.test.yml up -d'
                sh 'npm run test:integration'
                sh 'docker-compose -f docker-compose.test.yml down'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_NAME)
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${REGISTRY}", 'registry-credentials') {
                        docker.image(IMAGE_NAME).push()
                        docker.image(IMAGE_NAME).push('latest')
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh """
                    kubectl set image deployment/myapp \
                        myapp=${IMAGE_NAME} \
                        --namespace=staging
                """
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            input {
                message 'Deploy to production?'
                ok 'Yes, deploy it!'
            }
            steps {
                sh """
                    kubectl set image deployment/myapp \
                        myapp=${IMAGE_NAME} \
                        --namespace=production
                """
            }
        }
    }

    post {
        success {
            slackSend(
                color: 'good',
                message: "Build succeeded: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
        failure {
            slackSend(
                color: 'danger',
                message: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
    }
}
```

### Shared Library Pipeline

```groovy
// vars/standardPipeline.groovy
def call(Map config = [:]) {
    pipeline {
        agent any

        stages {
            stage('Checkout') {
                steps {
                    checkout scm
                }
            }

            stage('Build') {
                steps {
                    sh "${config.buildCommand ?: 'npm run build'}"
                }
            }

            stage('Test') {
                parallel {
                    stage('Unit Tests') {
                        steps {
                            sh "${config.testCommand ?: 'npm test'}"
                        }
                    }
                    stage('Lint') {
                        steps {
                            sh "${config.lintCommand ?: 'npm run lint'}"
                        }
                    }
                }
            }

            stage('Deploy') {
                when {
                    branch 'main'
                }
                steps {
                    script {
                        deployService(config)
                    }
                }
            }
        }
    }
}
```

---

## Azure DevOps Pipelines

### Multi-Stage Pipeline

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
      - develop
  paths:
    include:
      - src/*

pr:
  branches:
    include:
      - main

variables:
  buildConfiguration: 'Release'
  azureSubscription: 'my-service-connection'

stages:
- stage: Build
  displayName: 'Build Stage'
  jobs:
  - job: Build
    displayName: 'Build'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: NodeTool@0
      displayName: 'Install Node.js'
      inputs:
        versionSpec: '18.x'

    - task: Npm@1
      displayName: 'Install Dependencies'
      inputs:
        command: 'ci'

    - task: Npm@1
      displayName: 'Build'
      inputs:
        command: 'run'
        arguments: 'build'

    - task: PublishPipelineArtifact@1
      displayName: 'Publish Artifact'
      inputs:
        targetPath: 'dist'
        artifact: 'webapp'

- stage: Test
  displayName: 'Test Stage'
  dependsOn: Build
  jobs:
  - job: UnitTests
    displayName: 'Unit Tests'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: NodeTool@0
      inputs:
        versionSpec: '18.x'
    - script: npm ci
      displayName: 'Install Dependencies'
    - script: npm run test:unit
      displayName: 'Run Unit Tests'
    - task: PublishTestResults@2
      displayName: 'Publish Test Results'
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/test-results.xml'
        failTaskOnFailedTests: true

  - job: CodeCoverage
    displayName: 'Code Coverage'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: NodeTool@0
      inputs:
        versionSpec: '18.x'
    - script: npm ci && npm run test:coverage
    - task: PublishCodeCoverageResults@1
      inputs:
        codeCoverageTool: 'Cobertura'
        summaryFileLocation: '$(Agent.TempDirectory)/**/coverage.xml'

- stage: DeployStaging
  displayName: 'Deploy to Staging'
  dependsOn: Test
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - deployment: DeployStaging
    displayName: 'Deploy to Staging'
    environment: 'staging'
    strategy:
      runOnce:
        deploy:
          steps:
          - download: current
            artifact: 'webapp'
          - task: AzureWebApp@1
            displayName: 'Deploy to Azure Web App'
            inputs:
              azureSubscription: $(azureSubscription)
              appName: 'myapp-staging'
              package: '$(Pipeline.Workspace)/webapp'

- stage: DeployProduction
  displayName: 'Deploy to Production'
  dependsOn: DeployStaging
  jobs:
  - deployment: DeployProduction
    displayName: 'Deploy to Production'
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - download: current
            artifact: 'webapp'
          - task: AzureWebApp@1
            inputs:
              azureSubscription: $(azureSubscription)
              appName: 'myapp-production'
              package: '$(Pipeline.Workspace)/webapp'
```

---

## Advanced Pipeline Patterns

### Matrix Strategy

```yaml
# GitHub Actions - Test across multiple environments
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
        exclude:
          - os: windows-latest
            node-version: 16
        include:
          - os: ubuntu-latest
            node-version: 20
            experimental: true
      fail-fast: false

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
```

### Fan-Out / Fan-In Pattern

```yaml
# Parallel test execution with aggregation
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  test-unit:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      - run: npm run test:unit

  test-integration:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      - run: npm run test:integration

  test-e2e:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      - run: npm run test:e2e

  report:
    needs: [test-unit, test-integration, test-e2e]
    runs-on: ubuntu-latest
    steps:
      - run: echo "All tests passed!"
```

### Conditional Deployment

```yaml
# Deploy based on file changes
jobs:
  changes:
    runs-on: ubuntu-latest
    outputs:
      backend: ${{ steps.filter.outputs.backend }}
      frontend: ${{ steps.filter.outputs.frontend }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v2
        id: filter
        with:
          filters: |
            backend:
              - 'backend/**'
            frontend:
              - 'frontend/**'

  deploy-backend:
    needs: changes
    if: needs.changes.outputs.backend == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying backend..."

  deploy-frontend:
    needs: changes
    if: needs.changes.outputs.frontend == 'true'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying frontend..."
```

### Self-Healing Pipeline

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests with retry
        uses: nick-fields/retry@v2
        with:
          timeout_minutes: 10
          max_attempts: 3
          retry_wait_seconds: 30
          command: npm run test

  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy with rollback
        uses: actions/github-script@v6
        with:
          script: |
            const { execSync } = require('child_process');
            try {
              execSync('npm run deploy', { stdio: 'inherit' });
            } catch (error) {
              console.log('Deployment failed, rolling back...');
              execSync('npm run rollback', { stdio: 'inherit' });
              throw error;
            }
```

---

## Pipeline Optimization

### Caching Strategies

```yaml
# GitHub Actions - Advanced caching
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Cache npm dependencies
      - uses: actions/cache@v3
        id: npm-cache
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-

      # Cache Docker layers
      - uses: docker/build-push-action@v4
        with:
          context: .
          push: false
          tags: myapp:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      # Cache Gradle (for Java projects)
      - uses: actions/cache@v3
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
          key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
          restore-keys: |
            ${{ runner.os }}-gradle-
```

### Parallel Execution

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - run: npm run lint

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - run: npm run typecheck

  test-unit:
    runs-on: ubuntu-latest
    steps:
      - run: npm run test:unit

  test-integration:
    runs-on: ubuntu-latest
    services:
      postgres: { image: postgres:15 }
    steps:
      - run: npm run test:integration

  # All above run in parallel, then aggregate
  all-checks:
    needs: [lint, typecheck, test-unit, test-integration]
    runs-on: ubuntu-latest
    steps:
      - run: echo "All checks passed!"
```

### Pipeline Metrics Collection

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      build_time: ${{ steps.timer.outputs.time }}
    steps:
      - name: Start timer
        id: timer-start
        run: echo "start=$(date +%s)" >> $GITHUB_OUTPUT

      - run: npm ci && npm run build

      - name: End timer
        id: timer-end
        run: echo "end=$(date +%s)" >> $GITHUB_OUTPUT

      - name: Calculate duration
        id: timer
        run: |
          duration=$((${{ steps.timer-end.outputs.end }} - ${{ steps.timer-start.outputs.start }}))
          echo "time=$duration" >> $GITHUB_OUTPUT
          echo "Build took ${duration}s"

  report-metrics:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Send metrics to Datadog
        run: |
          curl -X POST "https://api.datadoghq.com/api/v2/series" \
            -H "Content-Type: application/json" \
            -d "{\"series\":[{\"metric\":\"ci.build_duration\",\"points\":[[$(date +%s),${{ needs.build.outputs.build_time }}]],\"type\":\"gauge\"}]}"
```

---

## Multi-Environment Pipelines

### Environment Promotion Pipeline

```yaml
name: Environment Promotion

on:
  push:
    branches: [main]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    outputs:
      image_tag: ${{ steps.meta.outputs.tag }}
    steps:
      - uses: actions/checkout@v4
      - name: Build and push
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker push myapp:${{ github.sha }}

  deploy-dev:
    needs: build-and-test
    environment:
      name: development
      url: https://dev.example.com
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to development..."

  test-dev:
    needs: deploy-dev
    runs-on: ubuntu-latest
    steps:
      - run: echo "Running smoke tests on dev..."

  deploy-staging:
    needs: test-dev
    environment:
      name: staging
      url: https://staging.example.com
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to staging..."

  test-staging:
    needs: deploy-staging
    runs-on: ubuntu-latest
    steps:
      - run: echo "Running integration tests on staging..."

  deploy-production:
    needs: test-staging
    environment:
      name: production
      url: https://example.com
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to production..."
```

### Environment Configuration

```yaml
# Environment-specific configurations
environments:
  development:
    variables:
      LOG_LEVEL: debug
      API_URL: https://dev-api.example.com
      DB_HOST: dev-db.example.com
    approval: false

  staging:
    variables:
      LOG_LEVEL: info
      API_URL: https://staging-api.example.com
      DB_HOST: staging-db.example.com
    approval: false

  production:
    variables:
      LOG_LEVEL: warn
      API_URL: https://api.example.com
      DB_HOST: prod-db.example.com
    approval: true
    approvers:
      - lead-dev
      - devops-team
```

---

## Common Interview Questions

### Q1: What is the difference between a pipeline and a workflow?

**Answer:**
A pipeline is a series of automated steps that build, test, and deploy code. A workflow is a broader concept that can include multiple pipelines, manual gates, and orchestration logic. In GitHub Actions, a workflow is the complete YAML file that defines when and how jobs run, while each job can be thought of as a mini-pipeline.

### Q2: How do you handle secrets in CI/CD pipelines?

**Answer:**
- Use built-in secret management (GitHub Secrets, GitLab Variables, Azure Key Vault)
- Never hardcode secrets in pipeline files
- Use encrypted environment variables
- Rotate secrets regularly
- Use OIDC tokens for cloud provider authentication instead of long-lived credentials
- Audit secret access

### Q3: What is pipeline as code and why is it important?

**Answer:**
Pipeline as Code means defining CI/CD pipeline configuration in version-controlled files (like YAML). Benefits include:
- Version control for pipeline changes
- Code review for pipeline modifications
- Reproducible pipelines
- Self-documenting
- Easy to share and reuse

### Q4: How do you optimize CI/CD pipeline performance?

**Answer:**
- Implement proper caching strategies
- Run independent jobs in parallel
- Use incremental builds
- Optimize Docker layer caching
- Reduce unnecessary file transfers
- Use matrix builds for multi-platform testing
- Implement test splitting

### Q5: What are the best practices for CI/CD pipeline security?

**Answer:**
- Scan for vulnerabilities in dependencies
- Use signed commits and verified builds
- Implement least privilege access
- Audit pipeline activities
- Use secret management properly
- Implement branch protection rules
- Use SAST/DAST scanning tools
