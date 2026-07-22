# Docker Guide

## Overview

Docker is a platform for developing, shipping, and running applications in lightweight, portable containers.

## Files

| File | Description |
|------|-------------|
| `docker-guide.md` | Comprehensive Docker guide |

## Quick Start

```bash
# Build image
docker build -t myapp .

# Run container
docker run -p 3000:3000 myapp

# List containers
docker ps

# Stop container
docker stop container_id
```

## Key Benefits

- **Consistency**: Works the same everywhere
- **Isolation**: Containers are isolated
- **Portability**: Run anywhere Docker is installed
- **Efficiency**: Lightweight compared to VMs