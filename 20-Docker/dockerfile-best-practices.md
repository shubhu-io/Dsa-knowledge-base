# Dockerfile Best Practices

## Overview

Writing efficient Dockerfiles is critical for building small, secure, and fast container images. This guide covers production-grade best practices.

## Architecture

```
┌─────────────────────────────────────────────┐
│              Dockerfile Pipeline            │
├─────────────────────────────────────────────┤
│  Base Image  ──►  Dependencies  ──►  App   │
│  (minimal)        (cached layers)   (copy)  │
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  alpine   │  │ npm install│ │ COPY src │  │
│  │  ~5MB     │  │ (cached)  │  │ (final)  │  │
│  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────┘
```

## 1. Use Multi-Stage Builds

Multi-stage builds reduce final image size dramatically by separating build-time and run-time dependencies.

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
USER appuser
CMD ["node", "dist/index.js"]
```

## 2. Choose Minimal Base Images

| Base Image | Size | Use Case |
|-----------|------|----------|
| `alpine` | ~5MB | General purpose, smallest |
| `slim` (Debian) | ~80MB | Need glibc compatibility |
| `distroless` | ~20MB | No shell, maximum security |
| `ubuntu` | ~77MB | Full OS needed |
| `node:18` | ~900MB | Only for building, not runtime |

```dockerfile
# Bad - large image
FROM node:18

# Good - minimal image
FROM node:18-alpine

# Better - distroless for production
FROM gcr.io/distroless/nodejs18-debian12
```

## 3. Optimize Layer Caching

Docker caches layers. Order instructions from least to most frequently changing.

```dockerfile
# Bad - rebuilds npm install on every code change
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm ci

# Good - npm install cached until package.json changes
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
```

## 4. Use .dockerignore

Exclude unnecessary files from the build context.

```dockerignore
# Version control
.git
.gitignore

# Dependencies
node_modules
vendor

# Build artifacts
dist
build
*.log

# IDE
.vscode
.idea

# OS files
.DS_Store
Thumbs.db

# Docker
Dockerfile
docker-compose*.yml
.dockerignore

# Secrets
.env
.env.*
*.pem
*.key
```

## 5. Don't Run as Root

```dockerfile
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to non-root user
USER appuser

# Or use numeric UID
USER 1001
```

## 6. Pin Package Versions

```dockerfile
# Bad - unpredictable builds
RUN apt-get update && apt-get install -y curl

# Good - pinned versions
RUN apt-get update && apt-get install -y \
    curl=7.88.1-10+deb12u5 \
    && rm -rf /var/lib/apt/lists/*

# For Alpine
RUN apk add --no-cache curl=8.5.0-r0
```

## 7. Combine RUN Commands

Reduce layers by chaining commands and cleaning up in the same layer.

```dockerfile
# Bad - multiple layers, leaves cache behind
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get clean

# Good - single layer, cleaned up
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

## 8. Use COPY Over ADD

```dockerfile
# ADD has auto-extraction and URL fetching (avoid unless needed)
ADD app.tar.gz /app

# COPY is explicit and preferred
COPY app/ /app/
```

## 9. Leverage BuildKit

BuildKit provides faster builds, better caching, and secret mounting.

```dockerfile
# syntax=docker/dockerfile:1

# Mount secrets without persisting in image layers
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci --production

# Mount SSH for git dependencies
RUN --mount=type=ssh \
    git clone git@github.com:private/repo.git
```

```bash
# Enable BuildKit
DOCKER_BUILDKIT=1 docker build .

# Or use buildx
docker buildx build --load -t myapp .
```

## 10. Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1
```

## Dockerfile Templates

### Python Application

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
RUN useradd -r appuser
COPY --from=builder /install /usr/local
COPY . .
USER appuser
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0"]
```

### Go Application

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./cmd/server

FROM scratch
COPY --from=builder /server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
```

### Java Spring Boot

```dockerfile
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app
COPY gradle/ gradle/
COPY gradlew .
COPY build.gradle .
RUN ./gradlew dependencies --no-daemon
COPY src/ src/
RUN ./gradlew bootJar --no-daemon

FROM eclipse-temurin:21-jre-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
COPY --from=builder /app/build/libs/*.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

## Security Scanning

```bash
# Scan image for vulnerabilities
docker scout cves myapp:latest

# Trivy scanner
trivy image myapp:latest

# Check for secrets in image layers
docker history myapp:latest --no-trunc
```

## Quick Reference

| Practice | Impact |
|----------|--------|
| Multi-stage builds | -60-90% image size |
| Alpine base | -80% vs Debian |
| Layer caching | -50% build time |
| .dockerignore | -30% context size |
| Non-root user | Security hardening |
| Pinned versions | Reproducible builds |
| Health checks | Runtime monitoring |

## Common Mistakes

1. Using `latest` tag for base images
2. Installing unnecessary packages
3. Running as root
4. Not cleaning up package manager cache
5. Copying everything instead of using `.dockerignore`
6. Not using multi-stage builds for compiled languages
7. Storing secrets in image layers
8. Not pinning dependency versions
