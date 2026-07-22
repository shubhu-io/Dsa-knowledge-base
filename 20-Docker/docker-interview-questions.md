# Docker Interview Questions

## Fundamentals

### 1. What is Docker and how is it different from a virtual machine?

**Answer:**
Docker containers share the host OS kernel, while VMs each run a full guest OS.

```
┌─────────────── VM ───────────────┐  ┌─────────── Docker ────────────┐
│  ┌─────┐ ┌─────┐ ┌─────┐       │  │  ┌─────┐ ┌─────┐ ┌─────┐    │
│  │App A│ │App B│ │App C│       │  │  │App A│ │App B│ │App C│    │
│  ├─────┤ ├─────┤ ├─────┤       │  │  ├─────┤ ├─────┤ ├─────┤    │
│  │Bins │ │Bins │ │Bins │       │  │  │Bins │ │Bins │ │Bins │    │
│  ├─────┤ ├─────┤ ├─────┤       │  │  └─────┘ └─────┘ └─────┘    │
│  │Guest│ │Guest│ │Guest│       │  │  ┌─────────────────────────┐  │
│  │ OS  │ │ OS  │ │ OS  │       │  │  │    Docker Engine        │  │
│  └─────┘ └─────┘ └─────┘       │  │  └─────────────────────────┘  │
│  ┌─────────────────────────┐   │  │  ┌─────────────────────────┐  │
│  │      Hypervisor         │   │  │  │      Host OS Kernel     │  │
│  └─────────────────────────┘   │  │  └─────────────────────────┘  │
│  ┌─────────────────────────┐   │  │  ┌─────────────────────────┐  │
│  │       Host OS           │   │  │  │      Hardware           │  │
│  └─────────────────────────┘   │  │  └─────────────────────────┘  │
└────────────────────────────────┘  └────────────────────────────────┘
```

| Feature | Docker | Virtual Machine |
|---------|--------|-----------------|
| OS | Shares host kernel | Full guest OS |
| Size | MBs | GBs |
| Startup | Seconds | Minutes |
| Isolation | Process-level | Hardware-level |
| Performance | Near-native | Overhead |

---

### 2. What is the difference between an image and a container?

**Answer:**
- **Image**: Read-only template with layers, stored in registry. Like a class.
- **Container**: Running instance of an image. Like an object.

```bash
# Create image from Dockerfile
docker build -t myapp:1.0 .

# Run container from image
docker run -d myapp:1.0

# Multiple containers from same image
docker run -d myapp:1.0
docker run -d myapp:1.0
```

---

### 3. Explain Docker image layers and why they matter.

**Answer:**
Each Dockerfile instruction creates a layer. Layers are cached and shared between images.

```dockerfile
FROM node:18-alpine          # Layer 1 (shared with other node images)
RUN apk add --no-cache curl  # Layer 2 (cached if unchanged)
COPY package*.json ./        # Layer 3
RUN npm ci                   # Layer 4
COPY . .                     # Layer 5 (changes most often)
```

Benefits: faster builds (cache), smaller pulls (only changed layers), storage efficiency.

---

### 4. What is a multi-stage build?

**Answer:**
Multiple `FROM` statements in a Dockerfile, allowing you to copy artifacts from one stage to another, excluding build tools from the final image.

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go build -o server

FROM alpine:3.19
COPY --from=builder /app/server /server
CMD ["/server"]
```

Final image is ~10MB instead of ~800MB with the Go toolchain.

---

### 5. What is the difference between COPY and ADD?

**Answer:**
- `COPY`: Simple file copy
- `ADD`: Auto-extracts tar files, supports URLs

**Best practice**: Use `COPY` unless you need tar extraction.

---

## Intermediate

### 6. How does Docker networking work?

**Answer:**
Docker creates virtual networks. Containers on the same network communicate via DNS.

```bash
docker network create mynet
docker run -d --name web --network mynet nginx
docker run -it --network mynet alpine ping web  # Works
```

Bridge (default, single host), host (shared host network), overlay (multi-host), none (isolated).

---

### 7. What are Docker volumes and why use them?

**Answer:**
Volumes persist data beyond container lifecycle and are managed by Docker.

```bash
# Named volume
docker volume create mydata
docker run -v mydata:/app/data postgres

# Bind mount
docker run -v /host/path:/container/path nginx

# Docker Compose
services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

Named volumes are preferred for production; bind mounts for development.

---

### 8. How do you reduce Docker image size?

**Answer:**
1. Use multi-stage builds
2. Choose minimal base images (alpine, distroless)
3. Use `.dockerignore`
4. Combine RUN commands and clean caches
5. Remove unnecessary files

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
```

---

### 9. What is Docker BuildKit?

**Answer:**
BuildKit is the modern build engine for Docker with parallel builds, better caching, and secret mounting.

```bash
DOCKER_BUILDKIT=1 docker build .

# Secret mounting (not persisted in layers)
RUN --mount=type=secret,id=api_key cat /run/secrets/api_key
```

---

### 10. How do you handle secrets in Docker?

**Answer:**
Never hardcode secrets in images or Dockerfiles.

```bash
# Docker secrets (Swarm)
docker secret create db_pass password.txt

# BuildKit secrets
RUN --mount=type=secret,id=db_pass \
    DB_PASS=$(cat /run/secrets/db_pass)

# Runtime environment
docker run -e DB_PASS=secret myapp

# Docker Compose
services:
  api:
    secrets:
      - db_password
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

---

## Advanced

### 11. What is the difference between docker-compose up, run, and start?

| Command | Creates containers | Starts stopped containers |
|---------|-------------------|--------------------------|
| `up` | Yes | Yes |
| `run` | Yes (one-off) | No |
| `start` | No | Yes |

---

### 12. How do you debug a container that keeps crashing?

```bash
# View logs
docker logs container_name

# Check exit code
docker inspect container_name --format='{{.State.ExitCode}}'

# Run with shell override
docker run -it --entrypoint sh myimage

# Check resource limits
docker stats container_name

# Inspect environment
docker inspect container_name --format='{{json .Config.Env}}'
```

---

### 13. Explain Docker cache invalidation and how to optimize it.

**Answer:**
Docker caches layers. A change invalidates that layer and all subsequent layers.

```dockerfile
# BAD: Code change invalidates npm install cache
COPY . .
RUN npm ci

# GOOD: package.json changes less frequently
COPY package*.json ./
RUN npm ci
COPY . .
```

Use `--no-cache` to force rebuild: `docker build --no-cache -t myapp .`

---

### 14. What is the difference between docker system prune and docker volume prune?

| Command | Removes |
|---------|---------|
| `docker system prune` | Stopped containers, unused networks, dangling images, build cache |
| `docker volume prune` | Unused volumes |
| `docker image prune` | Dangling images |
| `docker container prune` | Stopped containers |

`docker system prune -a --volumes` removes everything.

---

### 15. How do you implement health checks in Docker?

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1
```

```yaml
services:
  api:
    image: myapi
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 30s
```

```bash
# Check health status
docker inspect --format='{{json .State.Health}}' container
```

---

## Scenario-Based

### 16. Your container can't connect to another container. How do you troubleshoot?

1. Verify both are on the same network: `docker network inspect`
2. Check DNS resolution: `docker exec -it c1 ping c2`
3. Check firewall/iptables rules
4. Verify the service inside is listening on `0.0.0.0`, not `127.0.0.1`
5. Check container logs for errors

---

### 17. How do you run a Docker container in production?

1. Use specific image tags, never `:latest`
2. Set resource limits (CPU, memory)
3. Use health checks
4. Don't run as root
5. Use Docker Compose or orchestration
6. Implement logging
7. Use secrets management
8. Set restart policy (`unless-stopped` or `always`)

---

### 18. Design a multi-container application architecture.

```
┌─────────────────────────────────────────────┐
│                Production Stack             │
│                                             │
│  ┌─────────┐    ┌─────────┐    ┌────────┐ │
│  │  nginx   │───►│  api    │───►│  db    │ │
│  │ (reverse │    │ (app)   │    │(postgres)│
│  │  proxy)  │    └────┬────┘    └────────┘ │
│  └─────────┘         │                     │
│                      ▼                     │
│               ┌──────────┐                 │
│               │  redis   │                 │
│               │ (cache)  │                 │
│               └──────────┘                 │
│                                             │
│  Volumes: pgdata, redis_data                │
│  Networks: frontend (nginx-api)             │
│            backend (api-db-redis)           │
└─────────────────────────────────────────────┘
```
