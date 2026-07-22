# Docker Guide

## What is Docker?

Docker is a platform for developing, shipping, and running applications in containers.

## Key Concepts

### Images
- Read-only templates for creating containers
- Built from Dockerfiles
- Stored in registries (Docker Hub)

### Containers
- Running instances of images
- Isolated environments
- Portable across systems

### Dockerfile
```dockerfile
FROM node:14
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Commands

| Command | Description |
|---------|-------------|
| `docker build -t name .` | Build image |
| `docker run -p 3000:3000 name` | Run container |
| `docker ps` | List running containers |
| `docker stop container_id` | Stop container |
| `docker images` | List images |
| `docker rmi image_id` | Remove image |
| `docker exec -it container_id bash` | Shell into container |

## Docker Compose

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: password
```

## Best Practices

1. Use multi-stage builds
2. Minimize layers
3. Use .dockerignore
4. Don't run as root
5. Use specific image tags