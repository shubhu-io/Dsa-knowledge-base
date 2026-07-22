# Web Development

## Overview

Web development encompasses building and maintaining websites and web applications. It spans frontend (client-side), backend (server-side), and full-stack development, involving a wide ecosystem of frameworks, databases, and protocols.

## Key Concepts

### Frontend vs Backend vs Full-Stack

| Aspect | Frontend | Backend | Full-Stack |
|--------|----------|---------|------------|
| **Runs On** | Client browser | Server | Both |
| **Languages** | HTML, CSS, JS | Python, Java, Go, Node.js | All of the above |
| **Frameworks** | React, Vue, Angular | Django, Spring Boot, Express | Combines both |
| **Concerns** | UI/UX, responsiveness | Logic, data, security | End-to-end |

### HTTP Methods

| Method | Purpose | Idempotent | Safe |
|--------|---------|------------|------|
| GET | Retrieve resource | Yes | Yes |
| POST | Create resource | No | No |
| PUT | Replace resource | Yes | No |
| PATCH | Partial update | No | No |
| DELETE | Remove resource | Yes | No |

## Frontend Frameworks Comparison

| Feature | React | Vue | Angular |
|---------|-------|-----|---------|
| **Type** | Library | Framework | Framework |
| **Language** | JavaScript/JSX | JavaScript/Template | TypeScript |
| **Learning Curve** | Moderate | Easy | Steep |
| **Bundle Size** | ~40KB | ~33KB | ~143KB |
| **State Management** | Redux/Zustand | Pinia/Vuex | NgRx/Services |
| **SSR Support** | Next.js | Nuxt.js | Angular Universal |
| **Best For** | Large teams, flexibility | Small-medium apps | Enterprise apps |

### React Component Example

```jsx
import { useState, useEffect, useMemo } from 'react';

function UserList({ searchTerm }) {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchUsers() {
      try {
        const res = await fetch('/api/users');
        const data = await res.json();
        setUsers(data);
      } catch (err) {
        console.error('Failed to fetch users:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchUsers();
  }, []);

  const filteredUsers = useMemo(() =>
    users.filter(u =>
      u.name.toLowerCase().includes(searchTerm.toLowerCase())
    ),
    [users, searchTerm]
  );

  if (loading) return <div className="spinner" />;

  return (
    <ul className="user-list">
      {filteredUsers.map(user => (
        <li key={user.id}>
          <span>{user.name}</span>
          <span>{user.email}</span>
        </li>
      ))}
    </ul>
  );
}

export default UserList;
```

## Backend Frameworks Comparison

| Feature | Node.js/Express | Django | Spring Boot |
|---------|-----------------|--------|-------------|
| **Language** | JavaScript | Python | Java |
| **Type** | Unopinionated | Opinionated | Opinionated |
| **ORM** | Prisma/Sequelize | Django ORM | JPA/Hibernate |
| **Template Engine** | EJS/Pug | Django Templates | Thymeleaf |
| **Best For** | Real-time apps | Rapid development | Enterprise systems |

### Express.js REST API

```javascript
const express = require('express');
const { body, validationResult } = require('express-validator');
const app = express();

app.use(express.json());

const posts = [];
let nextId = 1;

// GET all posts with filtering
app.get('/api/posts', (req, res) => {
  const { author, limit = 10, offset = 0 } = req.query;
  let result = posts;
  if (author) {
    result = result.filter(p => p.author === author);
  }
  res.json({
    data: result.slice(Number(offset), Number(offset) + Number(limit)),
    total: result.length
  });
});

// POST create post with validation
app.post('/api/posts', [
  body('title').trim().isLength({ min: 3, max: 200 }),
  body('content').trim().isLength({ min: 10 }),
  body('author').trim().notEmpty()
], (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const post = { id: nextId++, ...req.body, createdAt: new Date() };
  posts.push(post);
  res.status(201).json(post);
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

## API Design Patterns

### REST vs GraphQL vs gRPC

| Feature | REST | GraphQL | gRPC |
|---------|------|---------|------|
| **Protocol** | HTTP/1.1 | HTTP | HTTP/2 |
| **Data Format** | JSON | JSON | Protobuf |
| **Schema** | OpenAPI (optional) | Strongly typed | Proto files |
| **Over-fetching** | Common | Rare | Rare |
| **Learning Curve** | Low | Medium | High |
| **Best For** | CRUD APIs | Complex queries | Microservices |

### GraphQL Schema Example

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  createdAt: DateTime!
}

type Query {
  users(limit: Int, offset: Int): [User!]!
  post(id: ID!): Post
}

type Mutation {
  createPost(title: String!, content: String!, authorId: ID!): Post!
  deletePost(id: ID!): Boolean!
}
```

## Database Choices

| Database | Type | Best For | Scaling |
|----------|------|----------|---------|
| PostgreSQL | Relational | Complex queries, ACID | Vertical + read replicas |
| MongoDB | Document | Flexible schemas, rapid dev | Horizontal (sharding) |
| Redis | Key-Value | Caching, sessions | Cluster mode |
| Elasticsearch | Search | Full-text search | Horizontal |

## Common Interview Questions

1. **What is CORS and how do you handle it?** Cross-Origin Resource Sharing restricts cross-origin requests; handled via server headers (`Access-Control-Allow-Origin`) or proxy.

2. **Explain the virtual DOM in React.** A lightweight copy of the real DOM that enables efficient diffing and batched updates for better performance.

3. **What are HTTP status codes?** 2xx (success), 3xx (redirect), 4xx (client error), 5xx (server error).

4. **How does WebSocket differ from HTTP?** WebSocket provides persistent, full-duplex communication; HTTP is request-response based.

5. **What is server-side rendering (SSR) and why use it?** Rendering HTML on the server before sending to client; improves SEO, initial load time, and social sharing.

## See Also

- [[DevOps-Cloud]]
- [[Cheat-Sheets]]
- [[Resources]]

> Full content: [32-Frontend](../32-Frontend/), [33-Backend](../33-Backend/), [34-Full-Stack](../34-Full-Stack/)
