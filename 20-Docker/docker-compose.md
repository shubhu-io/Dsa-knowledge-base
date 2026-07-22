# Docker Compose

## Overview

Docker Compose is a tool for defining and running multi-container Docker applications using a YAML configuration file.

## Architecture

```
┌─────────────────────────────────────────────────┐
│              Docker Compose Stack                │
├─────────────────────────────────────────────────┤
│                                                 │
│  docker-compose.yml                             │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐          │
│  │  web     │ │  api    │ │  db     │          │
│  │ :3000   │◄┤ :8080  ├─┤ :5432  │          │
│  │ nginx   │ │ node    │ │ postgres│          │
│  └────┬────┘ └────┬────┘ └────┬────┘          │
│       │           │           │                 │
│  ┌────▼───────────▼───────────▼────┐           │
│  │        app-network (bridge)      │           │
│  └──────────────────────────────────┘           │
│                                                 │
│  ┌──────────────────────────────────┐           │
│  │     volumes (persistent data)    │           │
│  └──────────────────────────────────┘           │
└─────────────────────────────────────────────────┘
```

## Compose File Format (v3)

```yaml
# docker-compose.yml
version: '3.9'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        NODE_ENV: production
    ports:
      - "80:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    env_file:
      - .env
    depends_on:
      db:
        condition: service_healthy
    networks:
      - frontend
      - backend
    volumes:
      - ./public:/app/public:ro
      - uploads:/app/uploads
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"

  api:
    image: myapi:latest
    ports:
      - "8080:8080"
    environment:
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
    networks:
      - backend
    restart: always

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  postgres_data:
  redis_data:
  uploads:
```

## Commands Reference

### Service Management

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Start services in background |
| `docker compose down` | Stop and remove services |
| `docker compose up --build` | Rebuild and start |
| `docker compose restart` | Restart all services |
| `docker compose stop` | Stop services (keep containers) |
| `docker compose start` | Start stopped services |

### Monitoring

| Command | Description |
|---------|-------------|
| `docker compose ps` | List running services |
| `docker compose logs` | View all logs |
| `docker compose logs -f api` | Follow API logs |
| `docker compose top` | Display running processes |
| `docker compose images` | List images used |

### Scaling

| Command | Description |
|---------|-------------|
| `docker compose up --scale api=3` | Scale API to 3 instances |
| `docker compose run api npm test` | Run one-off command |

### Building

| Command | Description |
|---------|-------------|
| `docker compose build` | Build all services |
| `docker compose build --no-cache` | Rebuild without cache |
| `docker compose pull` | Pull latest images |
| `docker compose push` | Push images to registry |

## Multi-Environment Configuration

### Override Files

```yaml
# docker-compose.yml (base)
services:
  web:
    build: .
    environment:
      - NODE_ENV=development

# docker-compose.prod.yml (production override)
services:
  web:
    image: myapp:production
    environment:
      - NODE_ENV=production
    restart: always
    logging:
      driver: json-file
```

```bash
# Development
docker compose up

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Environment Variables

```bash
# .env file
POSTGRES_USER=admin
POSTGRES_PASSWORD=secret
POSTGRES_DB=myapp
REDIS_URL=redis://redis:6379
API_PORT=8080
```

```yaml
# Use in compose file
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
```

## Profiles

Run specific groups of services:

```yaml
services:
  web:
    build: .
    profiles:
      - production

  debug:
    image: busybox
    profiles:
      - debug

  monitoring:
    image: prometheus
    profiles:
      - production
      - monitoring
```

```bash
# Only start production services
docker compose --profile production up

# Start production + monitoring
docker compose --profile production --profile monitoring up
```

## Networking

```yaml
services:
  web:
    networks:
      app-net:
        aliases:
          - web.local
        ipv4_address: 172.28.0.10

networks:
  app-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
```

## Complete Example: Full-Stack App

```yaml
version: '3.9'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - frontend
      - api
    networks:
      - frontend

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    networks:
      - frontend

  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    environment:
      DATABASE_URL: postgres://${DB_USER}:${DB_PASS}@postgres:5432/${DB_NAME}
      REDIS_URL: redis://redis:6379
      JWT_SECRET: ${JWT_SECRET}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - frontend
      - backend
    deploy:
      replicas: 2

  worker:
    build:
      context: ./api
      dockerfile: Dockerfile
    command: python worker.py
    depends_on:
      - redis
    networks:
      - backend

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASS}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
    networks:
      - backend

  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASS}
    volumes:
      - redisdata:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
    networks:
      - backend

networks:
  frontend:
  backend:
    internal: true

volumes:
  pgdata:
  redisdata:
```

## Troubleshooting

```bash
# Validate compose file
docker compose config

# View resolved configuration
docker compose config --services

# Check container resource usage
docker stats $(docker compose ps -q)

# Remove stopped containers and orphan networks
docker compose down --remove-orphans

# Full cleanup (including volumes)
docker compose down -v --rmi all

# Debug networking
docker network inspect <network_name>
```
