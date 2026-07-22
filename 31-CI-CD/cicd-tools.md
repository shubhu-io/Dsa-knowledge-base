# CI/CD Tools - Comparisons & Recommendations

## Table of Contents

1. [CI/CD Tools Overview](#cicd-tools-overview)
2. [GitHub Actions](#github-actions)
3. [GitLab CI/CD](#gitlab-cicd)
4. [Jenkins](#jenkins)
5. [CircleCI](#circleci)
6. [Azure DevOps](#azure-devops)
7. [AWS CodePipeline](#aws-codepipeline)
8. [ArgoCD](#argocd)
9. [Spinnaker](#spinnaker)
10. [Tool Comparison Matrix](#tool-comparison-matrix)
11. [Tool Selection Guide](#tool-selection-guide)

---

## CI/CD Tools Overview

### Tool Categories

```
CI/CD Tools
├── Hosted/SaaS
│   ├── GitHub Actions
│   ├── GitLab CI/CD
│   ├── CircleCI
│   ├── Travis CI
│   └── Azure DevOps
│
├── Self-Hosted
│   ├── Jenkins
│   ├── Bamboo
│   ├── TeamCity
│   └── GoCD
│
├── CD-Specific
│   ├── ArgoCD (Kubernetes)
│   ├── Spinnaker (Multi-cloud)
│   ├── Flux CD (Kubernetes)
│   └── Flux (GitOps)
│
└── Cloud-Native
    ├── AWS CodePipeline
    ├── Google Cloud Build
    ├── Azure Pipelines
    └── Bitbucket Pipelines
```

---

## GitHub Actions

### Overview

GitHub Actions is a CI/CD platform integrated into GitHub that automates build, test, and deployment workflows.

### Key Features

- Native GitHub integration
- Marketplace with 20,000+ actions
- Matrix builds
- Reusable workflows
- Environments and secrets
- Self-hosted runners

### Example Configuration

```yaml
name: CI/CD with GitHub Actions

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying..."
```

### Pricing

| Tier | Price | Includes |
|------|-------|----------|
| Free | $0 | 2,000 minutes/month |
| Team | $4/user/month | 3,000 minutes/month |
| Enterprise | $21/user/month | 50,000 minutes/month |

### Pros and Cons

| Pros | Cons |
|------|------|
| Free for public repos | Vendor lock-in |
| Large marketplace | YAML can be complex |
| Easy to get started | Limited to GitHub |
| Great documentation | Debugging can be challenging |

---

## GitLab CI/CD

### Overview

GitLab CI/CD is a built-in tool for GitLab that provides complete DevOps lifecycle support.

### Key Features

- Built into GitLab
- Auto DevOps
- Container registry
- Review apps
- Security scanning
- Multi-project pipelines

### Example Configuration

```yaml
stages:
  - build
  - test
  - deploy

variables:
  DOCKER_DRIVER: overlay2

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

test:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm test
  coverage: '/Lines\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      junit: test-results.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

deploy-staging:
  stage: deploy
  environment:
    name: staging
    url: https://staging.example.com
  script:
    - echo "Deploying to staging..."
  only:
    - develop

deploy-production:
  stage: deploy
  environment:
    name: production
    url: https://example.com
  script:
    - echo "Deploying to production..."
  when: manual
  only:
    - main
```

### Pricing

| Tier | Price | Includes |
|------|-------|----------|
| Free | $0 | 400 CI/CD minutes/month |
| Premium | $29/user/month | 10,000 minutes/month |
| Ultimate | $99/user/month | 50,000 minutes/month |

---

## Jenkins

### Overview

Jenkins is a self-hosted, open-source automation server with a rich plugin ecosystem.

### Key Features

- 1,800+ plugins
- Distributed builds
- Pipeline as Code (Jenkinsfile)
- Extensible architecture
- Active community

### Example Jenkinsfile

```groovy
pipeline {
    agent any

    tools {
        nodejs 'node-18'
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

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?'
                sh 'npm run deploy'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            mail to: 'team@example.com',
                 subject: "Build Succeeded: ${env.JOB_NAME}",
                 body: "Check: ${env.BUILD_URL}"
        }
        failure {
            mail to: 'team@example.com',
                 subject: "Build Failed: ${env.JOB_NAME}",
                 body: "Check: ${env.BUILD_URL}"
        }
    }
}
```

### Pricing

- **Open Source**: Free
- **CloudBees**: Custom pricing (Enterprise)

### Pros and Cons

| Pros | Cons |
|------|------|
| Highly customizable | Complex setup |
| Large plugin ecosystem | Requires maintenance |
| Self-hosted control | Steeper learning curve |
| No vendor lock-in | UI feels dated |

---

## CircleCI

### Overview

CircleCI is a cloud-based CI/CD platform focused on performance and developer experience.

### Key Features

- Fast build times
- Orbs (reusable packages)
- Parallelism
- Test splitting
- Docker support
- SSH debugging

### Example Configuration

```yaml
version: 2.1

orbs:
  node: circleci/node@5.0
  docker: circleci/docker@2.0

executors:
  node-executor:
    docker:
      - image: cimg/node:18.17
    working_directory: ~/project

jobs:
  build-and-test:
    executor: node-executor
    steps:
      - checkout
      - restore_cache:
          keys:
            - v1-dependencies-{{ checksum "package-lock.json" }}
            - v1-dependencies-
      - run:
          name: Install dependencies
          command: npm ci
      - save_cache:
          paths:
            - node_modules
          key: v1-dependencies-{{ checksum "package-lock.json" }}
      - run:
          name: Run tests
          command: npm test
      - store_test_results:
          path: test-results
      - store_artifacts:
          path: coverage

  deploy:
    executor: docker/docker
    steps:
      - checkout
      - setup_remote_docker
      - run:
          name: Build and push
          command: |
            docker build -t myapp:$CIRCLE_SHA1 .
            docker push myapp:$CIRCLE_SHA1

workflows:
  build-test-deploy:
    jobs:
      - build-and-test
      - deploy:
          requires:
            - build-and-test
          filters:
            branches:
              only: main
```

### Pricing

| Tier | Price | Includes |
|------|-------|----------|
| Free | $0 | 6,000 credits/month |
| Performance | $15/month | 36,000 credits/month |
| Scale | Custom | Custom credits |

---

## Azure DevOps

### Overview

Azure DevOps provides comprehensive DevOps tools including Pipelines, Boards, Repos, Artifacts, and Test Plans.

### Key Features

- Multi-language support
- Parallel jobs
- Deployment groups
- Variable groups
- Service connections
- Extensions marketplace

### Example Configuration

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'

stages:
- stage: Build
  jobs:
  - job: Build
    steps:
    - task: NodeTool@0
      inputs:
        versionSpec: '18'
    - script: |
        npm ci
        npm run build
      displayName: 'Build'

    - task: PublishPipelineArtifact@1
      inputs:
        targetPath: 'dist'
        artifact: 'webapp'

- stage: Test
  dependsOn: Build
  jobs:
  - job: Test
    steps:
    - task: NodeTool@0
      inputs:
        versionSpec: '18'
    - script: |
        npm ci
        npm run test
      displayName: 'Test'

    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/test-results.xml'

- stage: Deploy
  dependsOn: Test
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - deployment: DeployProduction
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - download: current
            artifact: 'webapp'
          - task: AzureWebApp@1
            inputs:
              azureSubscription: 'my-subscription'
              appName: 'my-app'
              package: '$(Pipeline.Workspace)/webapp'
```

### Pricing

- **Free**: 1,800 minutes/month
- **Basic**: $6/user/month
- **Visual Studio Enterprise**: Included with subscription

---

## AWS CodePipeline

### Overview

AWS CodePipeline is a fully managed continuous delivery service.

### Key Features

- AWS service integration
- Custom actions
- Cross-account deployments
- Pipeline versioning
- Execution history

### Example CloudFormation

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: CI/CD Pipeline

Resources:
  SourceStage:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: my-pipeline
      RoleArn: !GetAtt PipelineRole.Arn
      Stages:
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: ThirdParty
                Provider: GitHub
                Version: '1'
              Configuration:
                Owner: my-org
                Repo: my-repo
                Branch: main
                OAuthToken: !Ref GitHubToken
              OutputArtifacts:
                - Name: SourceOutput

        - Name: Build
          Actions:
            - Name: BuildAction
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref BuildProject
              InputArtifacts:
                - Name: SourceOutput
              OutputArtifacts:
                - Name: BuildOutput

        - Name: Deploy
          Actions:
            - Name: DeployAction
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: ECS
                Version: '1'
              Configuration:
                ClusterName: my-cluster
                ServiceName: my-service
                FileName: imagedefinitions.json
              InputArtifacts:
                - Name: BuildOutput
```

### Pricing

- **Free Tier**: First 12 months
- **Stage Execution**: $1/stage/month
- **Action Execution**: $0.0006/action

---

## ArgoCD

### Overview

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes.

### Key Features

- GitOps-based
- Multi-cluster support
- RBAC
- SSO integration
- Web UI
- CLI

### Example Application

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/my-org/my-app.git
    targetRevision: main
    path: k8s/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### Pricing

- **Open Source**: Free
- **Akuity (Managed)**: Starting at $250/month

---

## Spinnaker

### Overview

Spinnaker is an open-source multi-cloud continuous delivery platform.

### Key Features

- Multi-cloud deployments
- Blue-green and canary deployments
- Infrastructure management
- Continuous verification
- Integration with major clouds

### Example Pipeline JSON

```json
{
  "pipeline": {
    "name": "my-app",
    "stages": [
      {
        "type": "jenkins",
        "name": "Build",
        "account": "jenkins",
        "master": "my-jenkins",
        "job": "build-my-app"
      },
      {
        "type": "deploy",
        "name": "Deploy to Dev",
        "clusters": [
          {
            "name": "my-app-dev",
            "account": "my-aws-account",
            "region": "us-east-1",
            "imageProvider": {
              "type": "docker",
              "repository": "my-app",
              "tag": "${ build.number }"
            }
          }
        ]
      },
      {
        "type": "canary",
        "name": "Canary Analysis"
      }
    ]
  }
}
```

### Pricing

- **Open Source**: Free
- **Armory (Enterprise)**: Custom pricing

---

## Tool Comparison Matrix

### Feature Comparison

| Feature | GitHub Actions | GitLab CI | Jenkins | CircleCI | Azure DevOps |
|---------|---------------|-----------|---------|----------|--------------|
| Hosting | Cloud | Cloud/Self | Self | Cloud | Cloud/Self |
| Ease of Setup | Easy | Easy | Moderate | Easy | Easy |
| Marketplace | Yes | Yes | Yes | Yes | Yes |
| Docker Support | Yes | Yes | Yes | Yes | Yes |
| Parallel Execution | Yes | Yes | Yes | Yes | Yes |
| Matrix Builds | Yes | Yes | No | No | Yes |
| Self-Hosted Runners | Yes | Yes | N/A | Yes | Yes |
| Free Tier | Yes | Yes | N/A | Yes | Yes |
| Learning Curve | Low | Low | High | Low | Medium |

### Performance Comparison

| Metric | GitHub Actions | GitLab CI | Jenkins | CircleCI |
|--------|---------------|-----------|---------|----------|
| Cold Start | ~30s | ~30s | ~0s | ~15s |
| Build Speed | Fast | Fast | Depends | Fast |
| Caching | Good | Good | Good | Excellent |
| Scalability | High | High | High | High |

### Security Features

| Feature | GitHub Actions | GitLab CI | Jenkins | CircleCI |
|---------|---------------|-----------|---------|----------|
| Secret Management | Yes | Yes | Plugin | Yes |
| RBAC | Yes | Yes | Plugin | Yes |
| Audit Logs | Yes | Yes | Plugin | Yes |
| SSO/SAML | Enterprise | Premium | Plugin | Business |
| OIDC | Yes | Yes | No | Yes |

---

## Tool Selection Guide

### Decision Matrix

```
Starting Point:
│
├── Already using GitHub?
│   ├── Yes → GitHub Actions (native integration)
│   └── No ↓
│
├── Already using GitLab?
│   ├── Yes → GitLab CI/CD (native integration)
│   └── No ↓
│
├── Need maximum control/customization?
│   ├── Yes → Jenkins (self-hosted)
│   └── No ↓
│
├── Deploying to Azure?
│   ├── Yes → Azure DevOps
│   └── No ↓
│
├── Deploying to AWS?
│   ├── Yes → AWS CodePipeline
│   └── No ↓
│
├── Deploying to Kubernetes?
│   ├── Yes → ArgoCD (GitOps)
│   └── No ↓
│
├── Need fast builds?
│   ├── Yes → CircleCI
│   └── No ↓
│
└── Enterprise with multiple clouds?
    ├── Yes → Spinnaker
    └── No → GitLab CI/CD or GitHub Actions
```

### By Team Size

| Team Size | Recommended Tools |
|-----------|------------------|
| Solo Developer | GitHub Actions, GitLab CI/CD |
| Small (2-5) | GitHub Actions, CircleCI |
| Medium (5-20) | GitLab CI/CD, GitHub Actions, Azure DevOps |
| Large (20-100) | GitLab CI/CD, Jenkins, Azure DevOps |
| Enterprise (100+) | Jenkins, GitLab CI/CD, Spinnaker |

### By Use Case

| Use Case | Primary | Alternative |
|----------|---------|-------------|
| Open Source Project | GitHub Actions | GitLab CI/CD |
| Enterprise SaaS | GitLab CI/CD | Azure DevOps |
| Kubernetes Native | ArgoCD | Flux CD |
| Multi-Cloud | Spinnaker | GitLab CI/CD |
| Legacy Systems | Jenkins | Bamboo |
| Startup | GitHub Actions | CircleCI |

---

## Common Interview Questions

### Q1: How would you choose a CI/CD tool for a new project?

**Answer:**
Consider these factors:
- **Existing ecosystem**: If using GitHub, GitHub Actions is natural
- **Team expertise**: Match learning curve to team skills
- **Infrastructure**: Cloud-native vs self-hosted needs
- **Budget**: Free tiers vs enterprise features
- **Scale**: Current and projected build volumes
- **Integration needs**: Cloud providers, tools, services
- **Compliance**: Security and regulatory requirements

### Q2: What are the key differences between GitHub Actions and GitLab CI/CD?

**Answer:**
- **Integration**: GitHub Actions is native to GitHub; GitLab CI/CD is native to GitLab
- **Configuration**: GitHub Actions uses reusable actions; GitLab uses jobs/stages
- **Pricing**: Both have free tiers; GitLab's paid tiers include more DevOps features
- **Marketplace**: GitHub Actions has 20,000+ actions; GitLab has a smaller ecosystem
- **Self-hosted**: Both support it; GitLab includes it in more tiers

### Q3: When would you choose Jenkins over cloud-based solutions?

**Answer:**
- When you need complete control over infrastructure
- For highly customized build processes
- When you can't use cloud services (compliance, air-gapped environments)
- When you need to integrate with legacy systems
- When cost is a major factor and you have ops resources

### Q4: What is GitOps and which tools support it?

**Answer:**
GitOps is a methodology where Git serves as the single source of truth for infrastructure and application deployment. Tools that support GitOps include:
- ArgoCD (Kubernetes-native)
- Flux CD (Kubernetes-native)
- GitLab CI/CD (with auto-deploy)
- GitHub Actions (with custom implementation)

### Q5: How do you handle secrets management across CI/CD tools?

**Answer:**
- Use native secret management (GitHub Secrets, GitLab Variables)
- Integrate with vault solutions (HashiCorp Vault, AWS Secrets Manager)
- Use OIDC tokens for cloud provider authentication
- Implement secret rotation policies
- Audit secret access
- Never log secrets
