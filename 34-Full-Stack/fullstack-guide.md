# Full-Stack Development Complete Guide

## Table of Contents

1. [Full-Stack Overview](#full-stack-overview)
2. [Setting Up Your Environment](#setting-up-your-environment)
3. [Frontend Development](#frontend-development)
4. [Backend Development](#backend-development)
5. [Database Integration](#database-integration)
6. [Authentication](#authentication)
7. [API Integration](#api-integration)
8. [Testing](#testing)
9. [Deployment](#deployment)
10. [Best Practices](#best-practices)

---

## Full-Stack Overview

### What is Full-Stack Development?

Full-stack development involves working on both the client-side (frontend) and server-side (backend) of web applications.

```
┌─────────────────────────────────────────────────────────────┐
│                    FULL-STACK ARCHITECTURE                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │   Browser   │    │   Server    │    │  Database   │    │
│  │             │    │             │    │             │    │
│  │  React/Vue  │◄──▶│   Node.js   │◄──▶│ PostgreSQL  │    │
│  │  TypeScript │    │   Express   │    │   Redis     │    │
│  │  CSS/Tailwind│   │   REST API  │    │             │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    │
│                                                             │
│  ◄── Frontend ──►  ◄── Backend ──►   ◄── Database ──►     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Technology Choices

| Layer | Options | Recommended |
|-------|---------|-------------|
| Frontend | React, Vue, Angular | React + TypeScript |
| Backend | Node.js, Python, Go | Node.js + Express |
| Database | PostgreSQL, MongoDB | PostgreSQL |
| ORM | Prisma, TypeORM, Sequelize | Prisma |
| Auth | JWT, OAuth, Session | JWT + OAuth |

---

## Setting Up Your Environment

### Project Structure

```
my-fullstack-app/
├── client/                  # Frontend (React)
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── store/
│   │   ├── types/
│   │   └── App.tsx
│   ├── public/
│   ├── package.json
│   └── tsconfig.json
│
├── server/                  # Backend (Node.js)
│   ├── src/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── utils/
│   │   └── index.ts
│   ├── prisma/
│   │   └── schema.prisma
│   ├── package.json
│   └── tsconfig.json
│
├── docker-compose.yml
├── .env.example
└── README.md
```

### Docker Setup

```yaml
# docker-compose.yml
version: '3.8'

services:
  client:
    build: ./client
    ports:
      - "3000:3000"
    volumes:
      - ./client:/app
      - /app/node_modules
    environment:
      - REACT_APP_API_URL=http://localhost:5000

  server:
    build: ./server
    ports:
      - "5000:5000"
    volumes:
      - ./server:/app
      - /app/node_modules
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=your-secret-key
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

---

## Frontend Development

### React + TypeScript Setup

```typescript
// src/types/index.ts
export interface User {
    id: string;
    name: string;
    email: string;
    role: 'user' | 'admin';
    createdAt: string;
}

export interface Product {
    id: string;
    name: string;
    description: string;
    price: number;
    category: string;
    inStock: boolean;
}

export interface ApiResponse<T> {
    data: T;
    status: 'success' | 'error';
    message?: string;
}

// src/services/api.ts
import axios, { AxiosInstance } from 'axios';

class ApiService {
    private client: AxiosInstance;

    constructor() {
        this.client = axios.create({
            baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5000/api',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        this.client.interceptors.request.use((config) => {
            const token = localStorage.getItem('token');
            if (token) {
                config.headers.Authorization = `Bearer ${token}`;
            }
            return config;
        });

        this.client.interceptors.response.use(
            (response) => response,
            (error) => {
                if (error.response?.status === 401) {
                    localStorage.removeItem('token');
                    window.location.href = '/login';
                }
                return Promise.reject(error);
            }
        );
    }

    async get<T>(url: string): Promise<T> {
        const response = await this.client.get<T>(url);
        return response.data;
    }

    async post<T>(url: string, data: unknown): Promise<T> {
        const response = await this.client.post<T>(url, data);
        return response.data;
    }

    async put<T>(url: string, data: unknown): Promise<T> {
        const response = await this.client.put<T>(url, data);
        return response.data;
    }

    async delete<T>(url: string): Promise<T> {
        const response = await this.client.delete<T>(url);
        return response.data;
    }
}

export const api = new ApiService();

// src/hooks/useApi.ts
import { useState, useEffect } from 'react';

export function useApi<T>(url: string) {
    const [data, setData] = useState<T | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        const controller = new AbortController();

        fetch(url, { signal: controller.signal })
            .then((res) => res.json())
            .then(setData)
            .catch(setError)
            .finally(() => setLoading(false));

        return () => controller.abort();
    }, [url]);

    return { data, loading, error };
}
```

### Component Example

```tsx
// src/components/UserProfile.tsx
import React from 'react';
import { User } from '../types';

interface UserProfileProps {
    user: User;
    onEdit: (user: User) => void;
    onDelete: (userId: string) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({
    user,
    onEdit,
    onDelete
}) => {
    return (
        <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex items-center space-x-4">
                <div className="w-16 h-16 bg-gray-300 rounded-full flex items-center justify-center">
                    <span className="text-2xl font-bold text-gray-600">
                        {user.name.charAt(0)}
                    </span>
                </div>
                <div>
                    <h2 className="text-xl font-semibold">{user.name}</h2>
                    <p className="text-gray-600">{user.email}</p>
                    <span className="inline-block px-2 py-1 text-sm rounded-full bg-blue-100 text-blue-800">
                        {user.role}
                    </span>
                </div>
            </div>
            <div className="mt-4 flex space-x-2">
                <button
                    onClick={() => onEdit(user)}
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
                >
                    Edit
                </button>
                <button
                    onClick={() => onDelete(user.id)}
                    className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
                >
                    Delete
                </button>
            </div>
        </div>
    );
};
```

---

## Backend Development

### Express + TypeScript Setup

```typescript
// src/index.ts
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { PrismaClient } from '@prisma/client';
import userRoutes from './routes/users';
import authRoutes from './routes/auth';
import { errorHandler } from './middleware/errorHandler';
import { authenticate } from './middleware/auth';

const app = express();
const prisma = new PrismaClient();

// Middleware
app.use(helmet());
app.use(cors({
    origin: process.env.CLIENT_URL || 'http://localhost:3000',
    credentials: true
}));
app.use(morgan('combined'));
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', authenticate, userRoutes);

// Health check
app.get('/health', async (req, res) => {
    try {
        await prisma.$queryRaw`SELECT 1`;
        res.json({ status: 'healthy', timestamp: new Date().toISOString() });
    } catch (error) {
        res.status(503).json({ status: 'unhealthy', error: 'Database connection failed' });
    }
});

// Error handling
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// src/routes/users.ts
import { Router, Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { asyncHandler } from '../utils/asyncHandler';
import { NotFoundError, ValidationError } from '../utils/errors';

const router = Router();
const prisma = new PrismaClient();

router.get('/', asyncHandler(async (req: Request, res: Response) => {
    const { page = 1, limit = 20, search } = req.query;
    const skip = (Number(page) - 1) * Number(limit);

    const where = search ? {
        OR: [
            { name: { contains: String(search), mode: 'insensitive' } },
            { email: { contains: String(search), mode: 'insensitive' } }
        ]
    } : {};

    const [users, total] = await Promise.all([
        prisma.user.findMany({
            where,
            skip,
            take: Number(limit),
            select: {
                id: true,
                name: true,
                email: true,
                role: true,
                createdAt: true
            },
            orderBy: { createdAt: 'desc' }
        }),
        prisma.user.count({ where })
    ]);

    res.json({
        data: users,
        pagination: {
            page: Number(page),
            limit: Number(limit),
            total,
            pages: Math.ceil(total / Number(limit))
        }
    });
}));

router.get('/:id', asyncHandler(async (req: Request, res: Response) => {
    const user = await prisma.user.findUnique({
        where: { id: req.params.id },
        select: {
            id: true,
            name: true,
            email: true,
            role: true,
            createdAt: true,
            posts: true
        }
    });

    if (!user) {
        throw new NotFoundError('User');
    }

    res.json(user);
}));

router.post('/', asyncHandler(async (req: Request, res: Response) => {
    const { name, email, password, role } = req.body;

    if (!name || !email || !password) {
        throw new ValidationError('Name, email, and password are required');
    }

    const existingUser = await prisma.user.findUnique({
        where: { email }
    });

    if (existingUser) {
        throw new ValidationError('Email already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
        data: {
            name,
            email,
            password: hashedPassword,
            role: role || 'user'
        },
        select: {
            id: true,
            name: true,
            email: true,
            role: true,
            createdAt: true
        }
    });

    res.status(201).json(user);
}));

export default router;
```

---

## Database Integration

### Prisma Schema

```prisma
// prisma/schema.prisma
generator client {
    provider = "prisma-client-js"
}

datasource db {
    provider = "postgresql"
    url      = env("DATABASE_URL")
}

model User {
    id        String   @id @default(uuid())
    email     String   @unique
    name      String
    password  String
    role      Role     @default(user)
    posts     Post[]
    comments  Comment[]
    createdAt DateTime @default(now())
    updatedAt DateTime @updatedAt

    @@map("users")
}

model Post {
    id        String    @id @default(uuid())
    title     String
    content   String
    published Boolean   @default(false)
    author    User      @relation(fields: [authorId], references: [id])
    authorId  String
    comments  Comment[]
    tags      Tag[]
    createdAt DateTime  @default(now())
    updatedAt DateTime  @updatedAt

    @@map("posts")
}

model Comment {
    id        String   @id @default(uuid())
    content   String
    post      Post     @relation(fields: [postId], references: [id])
    postId    String
    author    User     @relation(fields: [authorId], references: [id])
    authorId  String
    createdAt DateTime @default(now())

    @@map("comments")
}

model Tag {
    id    String @id @default(uuid())
    name  String @unique
    posts Post[]

    @@map("tags")
}

enum Role {
    user
    admin
}
```

### Database Operations

```typescript
// src/services/userService.ts
import { PrismaClient, User } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

export class UserService {
    async findById(id: string): Promise<User | null> {
        return prisma.user.findUnique({
            where: { id },
            select: {
                id: true,
                name: true,
                email: true,
                role: true,
                createdAt: true
            }
        });
    }

    async findByEmail(email: string): Promise<User | null> {
        return prisma.user.findUnique({
            where: { email }
        });
    }

    async create(data: CreateUserInput): Promise<User> {
        const hashedPassword = await bcrypt.hash(data.password, 10);

        return prisma.user.create({
            data: {
                ...data,
                password: hashedPassword
            },
            select: {
                id: true,
                name: true,
                email: true,
                role: true,
                createdAt: true
            }
        });
    }

    async update(id: string, data: UpdateUserInput): Promise<User> {
        return prisma.user.update({
            where: { id },
            data,
            select: {
                id: true,
                name: true,
                email: true,
                role: true,
                updatedAt: true
            }
        });
    }

    async delete(id: string): Promise<void> {
        await prisma.user.delete({ where: { id } });
    }

    async getUserWithPosts(id: string) {
        return prisma.user.findUnique({
            where: { id },
            include: {
                posts: {
                    where: { published: true },
                    orderBy: { createdAt: 'desc' }
                }
            }
        });
    }
}
```

---

## Authentication

### JWT Implementation

```typescript
// src/middleware/auth.ts
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { UnauthorizedError } from '../utils/errors';

export interface AuthRequest extends Request {
    user?: {
        id: string;
        email: string;
        role: string;
    };
}

export const authenticate = (
    req: AuthRequest,
    res: Response,
    next: NextFunction
) => {
    const authHeader = req.headers.authorization;
    const token = authHeader?.split(' ')[1];

    if (!token) {
        throw new UnauthorizedError('No token provided');
    }

    try {
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET || 'default-secret'
        ) as { id: string; email: string; role: string };

        req.user = decoded;
        next();
    } catch (error) {
        throw new UnauthorizedError('Invalid token');
    }
};

export const authorize = (...roles: string[]) => {
    return (req: AuthRequest, res: Response, next: NextFunction) => {
        if (!req.user) {
            throw new UnauthorizedError('Not authenticated');
        }

        if (!roles.includes(req.user.role)) {
            throw new UnauthorizedError('Insufficient permissions');
        }

        next();
    };
};

// src/routes/auth.ts
import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { asyncHandler } from '../utils/asyncHandler';
import { UserService } from '../services/userService';
import { ValidationError, UnauthorizedError } from '../utils/errors';

const router = Router();
const userService = new UserService();

router.post('/register', asyncHandler(async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        throw new ValidationError('Name, email, and password are required');
    }

    const existingUser = await userService.findByEmail(email);
    if (existingUser) {
        throw new ValidationError('Email already exists');
    }

    const user = await userService.create({ name, email, password });

    const token = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'default-secret',
        { expiresIn: '24h' }
    );

    res.status(201).json({ user, token });
}));

router.post('/login', asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        throw new ValidationError('Email and password are required');
    }

    const user = await userService.findByEmail(email);
    if (!user) {
        throw new UnauthorizedError('Invalid credentials');
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
        throw new UnauthorizedError('Invalid credentials');
    }

    const token = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'default-secret',
        { expiresIn: '24h' }
    );

    res.json({
        user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
        },
        token
    });
}));

export default router;
```

---

## Testing

### Frontend Testing

```typescript
// src/components/__tests__/UserProfile.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { UserProfile } from '../UserProfile';
import { User } from '../../types';

const mockUser: User = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    role: 'user',
    createdAt: '2024-01-01T00:00:00Z'
};

describe('UserProfile', () => {
    it('renders user information', () => {
        render(
            <UserProfile
                user={mockUser}
                onEdit={() => {}}
                onDelete={() => {}}
            />
        );

        expect(screen.getByText('John Doe')).toBeInTheDocument();
        expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });

    it('calls onEdit when edit button is clicked', () => {
        const handleEdit = jest.fn();
        render(
            <UserProfile
                user={mockUser}
                onEdit={handleEdit}
                onDelete={() => {}}
            />
        );

        fireEvent.click(screen.getByText('Edit'));
        expect(handleEdit).toHaveBeenCalledWith(mockUser);
    });

    it('calls onDelete when delete button is clicked', () => {
        const handleDelete = jest.fn();
        render(
            <UserProfile
                user={mockUser}
                onEdit={() => {}}
                onDelete={handleDelete}
            />
        );

        fireEvent.click(screen.getByText('Delete'));
        expect(handleDelete).toHaveBeenCalledWith('1');
    });
});
```

### Backend Testing

```typescript
// src/__tests__/users.test.ts
import request from 'supertest';
import app from '../index';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

describe('User API', () => {
    beforeAll(async () => {
        await prisma.user.deleteMany();
    });

    afterAll(async () => {
        await prisma.$disconnect();
    });

    describe('POST /api/users', () => {
        it('should create a new user', async () => {
            const res = await request(app)
                .post('/api/users')
                .send({
                    name: 'Test User',
                    email: 'test@example.com',
                    password: 'password123'
                })
                .expect(201);

            expect(res.body).toHaveProperty('id');
            expect(res.body.name).toBe('Test User');
            expect(res.body.email).toBe('test@example.com');
        });

        it('should return 400 for invalid data', async () => {
            await request(app)
                .post('/api/users')
                .send({
                    name: '',
                    email: 'invalid-email'
                })
                .expect(400);
        });
    });

    describe('GET /api/users', () => {
        it('should return list of users', async () => {
            const res = await request(app)
                .get('/api/users')
                .expect(200);

            expect(Array.isArray(res.body.data)).toBe(true);
        });
    });
});
```

---

## Deployment

### Vercel Deployment

```json
// vercel.json
{
    "version": 2,
    "builds": [
        {
            "src": "client/package.json",
            "use": "@vercel/node",
            "config": {
                "maxDuration": 30
            }
        },
        {
            "src": "server/package.json",
            "use": "@vercel/node"
        }
    ],
    "routes": [
        {
            "src": "/api/(.*)",
            "dest": "server/api/$1"
        },
        {
            "src": "/(.*)",
            "dest": "client/$1"
        }
    ]
}
```

### AWS Deployment

```yaml
# appspec.yml (AWS CodeDeploy)
version: 0.0
os: linux
files:
  - source: /
    destination: /var/www/app
hooks:
  BeforeInstall:
    - location: scripts/before_install.sh
      timeout: 300
  AfterInstall:
    - location: scripts/after_install.sh
      timeout: 300
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
```

---

## Best Practices

### Code Organization

```
✅ Feature-based structure
✅ Shared types between frontend/backend
✅ Consistent naming conventions
✅ Separation of concerns
✅ DRY (Don't Repeat Yourself)

❌ God files (huge single files)
❌ Circular dependencies
❌ Tight coupling between layers
❌ Inconsistent naming
❌ Code duplication
```

### Security Checklist

```
✅ Environment variables for secrets
✅ Input validation on all endpoints
✅ SQL injection prevention (parameterized queries)
✅ XSS prevention (output encoding)
✅ CSRF protection
✅ Rate limiting
✅ HTTPS everywhere
✅ Security headers (Helmet)
✅ Authentication middleware
✅ Authorization checks
```

### Performance Checklist

```
✅ Code splitting (frontend)
✅ Lazy loading routes
✅ Image optimization
✅ Caching strategies (Redis, CDN)
✅ Database indexing
✅ Connection pooling
✅ Compression (gzip/brotli)
✅ Minification
✅ CDN for static assets
```

---

## Common Interview Questions

### Q1: How do you handle state management in a full-stack application?

**Answer:**
- **Frontend**: React Context, Redux, Zustand for UI state
- **Backend**: Database for persistent state, Redis for session/cache
- **Synchronization**: WebSockets for real-time, polling for periodic updates

### Q2: How do you handle authentication across the stack?

**Answer:**
1. User logs in → Server validates credentials
2. Server generates JWT token
3. Token stored in httpOnly cookie or localStorage
4. Client sends token with each request
5. Server validates token and attaches user to request
6. Middleware checks authorization

### Q3: How do you optimize a full-stack application?

**Answer:**
- **Frontend**: Code splitting, lazy loading, caching
- **Backend**: Query optimization, connection pooling, caching
- **Database**: Indexing, query analysis, read replicas
- **Infrastructure**: CDN, load balancing, auto-scaling

### Q4: How do you handle errors in a full-stack application?

**Answer:**
- **Frontend**: Error boundaries, global error handler
- **Backend**: Centralized error handler middleware
- **Database**: Transaction rollback, retry logic
- **Logging**: Structured logging with request IDs
- **Monitoring**: Error tracking (Sentry), alerting

### Q5: What is your approach to API design?

**Answer:**
- RESTful conventions (nouns, HTTP methods, status codes)
- Consistent response format
- Versioning from day one
- Pagination and filtering
- Comprehensive documentation (OpenAPI)
- Rate limiting and authentication
