# Docker Networking

## Overview

Docker networking enables containers to communicate with each other, the host, and external networks. Understanding networking is essential for multi-container architectures.

## Network Drivers

```
┌─────────────────────────────────────────────────────────┐
│                   Docker Network Types                   │
├──────────┬──────────┬──────────┬───────────────────────┤
│  bridge  │  host    │  overlay │  none                 │
│          │          │          │                       │
│ Default  │ Shares   │ Multi-   │ No networking         │
│ for      │ host     │ host     │                       │
│ single   │ network  │ cluster  │ Isolated container    │
│ host     │ stack    │ (Swarm)  │                       │
│          │          │          │                       │
│ ┌─┐ ┌─┐ │ ┌─┐ ┌─┐  │ ┌─┐ ┌─┐ │                       │
│ │C│ │C│ │ │C│ │C│  │ │C│ │C│ │                       │
│ └┬┘ └┬┘ │ └┬┘ └┬┘  │ └┬┘ └┬┘ │                       │
│ ┌▼───▼┐ │ ┌▼───▼┐  │ ┌▼───▼┐ │                       │
│ │bridge│ │ │host │  │ │overlay│ │                       │
│ └─────┘ │ └─────┘  │ └─────┘ │                       │
└──────────┴──────────┴──────────┴───────────────────────┘
```

## Bridge Network (Default)

Containers on the same bridge network can communicate via DNS names.

```bash
# Default bridge (automatic)
docker run -d --name web nginx
docker run -d --name api myapi

# Custom bridge (recommended - has DNS resolution)
docker network create my-network
docker run -d --name web --network my-network nginx
docker run -d --name api --network my-network myapi

# api container can reach web at "http://web:80"
```

```yaml
# docker-compose.yml
services:
  web:
    image: nginx
    networks:
      - app-net

  api:
    image: myapi
    networks:
      - app-net

networks:
  app-net:
    driver: bridge
```

## Host Network

Container shares the host's network stack directly. No port mapping needed.

```bash
docker run --network host nginx
# Nginx binds directly to host ports 80/443
```

```yaml
services:
  nginx:
    image: nginx
    network_mode: host
```

**Use cases**: High-performance networking, when port mapping overhead matters.

## Overlay Network

For multi-host communication in Docker Swarm or Kubernetes.

```bash
# Initialize swarm
docker swarm init

# Create overlay network
docker network create --driver overlay --attachable my-overlay

# Services on different hosts can communicate
docker service create --name web --network my-overlay nginx
docker service create --name api --network my-overlay myapi
```

## None Network

Completely isolated container with no network access.

```bash
docker run --network none alpine
# No network interfaces except loopback
```

## Network Commands

| Command | Description |
|---------|-------------|
| `docker network ls` | List all networks |
| `docker network create mynet` | Create a network |
| `docker network rm mynet` | Remove a network |
| `docker network inspect mynet` | View network details |
| `docker network connect mynet container` | Attach container |
| `docker network disconnect mynet container` | Detach container |
| `docker network prune` | Remove unused networks |

## DNS Resolution

Custom bridge networks provide automatic DNS resolution by container name.

```bash
# Create network
docker network create app-net

# Start containers
docker run -d --name database --network app-net postgres:16
docker run -d --name api --network app-net myapi

# Inside 'api' container:
# ping database    -> resolves to database's IP
# curl http://database:5432  -> connects to PostgreSQL
```

```
┌──────────────────────────────────────────┐
│              app-net (bridge)            │
│                                          │
│  ┌──────────┐         ┌──────────┐      │
│  │   api    │  DNS    │ database │      │
│  │ 172.18.0.2├───────►│172.18.0.3│      │
│  └──────────┘ resolve └──────────┘      │
│       │                    │             │
│       └────────┬───────────┘             │
│                │                         │
│         ┌──────▼──────┐                  │
│         │ Docker DNS  │                  │
│         │  127.0.0.11 │                  │
│         └─────────────┘                  │
└──────────────────────────────────────────┘
```

## Port Mapping

```bash
# Host:Container
docker run -p 8080:80 nginx        # Map host 8080 to container 80

# Bind to specific interface
docker run -p 127.0.0.1:8080:80 nginx

# Map UDP ports
docker run -p 53:53/udp dns-server

# Map multiple ports
docker run -p 80:80 -p 443:443 nginx

# Random host port
docker run -p 80 nginx
```

## Static IP Assignment

```bash
docker network create --subnet=172.20.0.0/16 my-net

docker run --network my-net --ip 172.20.0.10 --name fixed nginx
```

```yaml
services:
  api:
    image: myapi
    networks:
      app-net:
        ipv4_address: 172.28.0.10
        aliases:
          - api.local

networks:
  app-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
```

## Multi-Network Isolation

Separate frontend and backend traffic for security.

```yaml
services:
  nginx:
    image: nginx
    networks:
      - frontend
    ports:
      - "80:80"

  api:
    image: myapi
    networks:
      - frontend
      - backend

  db:
    image: postgres
    networks:
      - backend  # Only accessible from backend

networks:
  frontend:
  backend:
    internal: true  # No external access
```

```
Internet
    │
    ▼
┌──────────┐
│  nginx   │──── frontend network
└──────────┘
    │
    ▼
┌──────────┐
│   api    │──── frontend + backend networks
└──────────┘
    │
    ▼ (backend only)
┌──────────┐
│    db    │──── backend network (internal)
└──────────┘
```

## Troubleshooting

```bash
# Check container network settings
docker inspect --format '{{json .NetworkSettings.Networks}}' container | jq

# Test DNS resolution from inside container
docker exec -it container nslookup other-container

# Check connectivity
docker exec -it container ping other-container

# View network connections
docker exec -it container netstat -tlnp

# Inspect network
docker network inspect bridge

# Reset networking
docker network disconnect bridge container
docker network connect bridge container
```

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Can't resolve DNS | Using default bridge | Use custom bridge network |
| Port conflict | Host port already in use | Map to different host port |
| Container unreachable | Different networks | Connect to same network |
| Slow performance | Bridge overhead | Use host network |
| No internet access | DNS misconfigured | Check `/etc/resolv.conf` |
