# Full-Stack Projects

## Table of Contents

1. [Beginner Projects](#beginner-projects)
2. [Intermediate Projects](#intermediate-projects)
3. [Advanced Projects](#advanced-projects)
4. [Portfolio Projects](#portfolio-projects)
5. [Project Implementation Guide](#project-implementation-guide)

---

## Beginner Projects

### 1. Personal Portfolio Website

**Tech Stack**: HTML, CSS, JavaScript

**Features**:
- Responsive design
- About section
- Project showcase
- Contact form
- Dark/light mode

**Implementation**:
```html
<!-- index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Portfolio</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo">JD</div>
        <ul class="nav-links">
            <li><a href="#home">Home</a></li>
            <li><a href="#about">About</a></li>
            <li><a href="#projects">Projects</a></li>
            <li><a href="#contact">Contact</a></li>
        </ul>
    </nav>

    <section id="home" class="hero">
        <h1>John Doe</h1>
        <p>Full-Stack Developer</p>
        <a href="#projects" class="cta">View My Work</a>
    </section>

    <section id="projects" class="projects">
        <h2>Projects</h2>
        <div class="project-grid">
            <div class="project-card">
                <img src="project1.jpg" alt="Project 1">
                <h3>E-commerce App</h3>
                <p>Full-stack e-commerce platform</p>
                <a href="#">View Project</a>
            </div>
        </div>
    </section>
</body>
</html>
```

---

### 2. Weather Dashboard

**Tech Stack**: HTML, CSS, JavaScript, Weather API

**Features**:
- Current weather display
- 5-day forecast
- Location search
- Weather icons
- Temperature units toggle

**API Integration**:
```javascript
// app.js
const API_KEY = 'your-api-key';
const BASE_URL = 'https://api.openweathermap.org/data/2.5';

async function getWeather(city) {
    try {
        const response = await fetch(
            `${BASE_URL}/weather?q=${city}&appid=${API_KEY}&units=metric`
        );
        const data = await response.json();
        displayWeather(data);
    } catch (error) {
        console.error('Error fetching weather:', error);
    }
}

async function getForecast(city) {
    try {
        const response = await fetch(
            `${BASE_URL}/forecast?q=${city}&appid=${API_KEY}&units=metric`
        );
        const data = await response.json();
        displayForecast(data.list);
    } catch (error) {
        console.error('Error fetching forecast:', error);
    }
}

function displayWeather(data) {
    const weatherHTML = `
        <div class="current-weather">
            <h2>${data.name}</h2>
            <img src="https://openweathermap.org/img/wn/${data.weather[0].icon}@2x.png" alt="weather icon">
            <p class="temperature">${Math.round(data.main.temp)}°C</p>
            <p class="description">${data.weather[0].description}</p>
        </div>
    `;
    document.getElementById('weather').innerHTML = weatherHTML;
}
```

---

### 3. Todo Application

**Tech Stack**: React, localStorage

**Features**:
- Add, edit, delete todos
- Mark as complete
- Filter (all, active, completed)
- Local storage persistence
- Drag and drop reordering

**Implementation**:
```jsx
// TodoApp.jsx
import React, { useState, useEffect } from 'react';

function TodoApp() {
    const [todos, setTodos] = useState([]);
    const [input, setInput] = useState('');
    const [filter, setFilter] = useState('all');

    useEffect(() => {
        const saved = localStorage.getItem('todos');
        if (saved) {
            setTodos(JSON.parse(saved));
        }
    }, []);

    useEffect(() => {
        localStorage.setItem('todos', JSON.stringify(todos));
    }, [todos]);

    const addTodo = (e) => {
        e.preventDefault();
        if (!input.trim()) return;

        setTodos([...todos, {
            id: Date.now(),
            text: input,
            completed: false
        }]);
        setInput('');
    };

    const toggleTodo = (id) => {
        setTodos(todos.map(todo =>
            todo.id === id ? { ...todo, completed: !todo.completed } : todo
        ));
    };

    const deleteTodo = (id) => {
        setTodos(todos.filter(todo => todo.id !== id));
    };

    const filteredTodos = todos.filter(todo => {
        if (filter === 'active') return !todo.completed;
        if (filter === 'completed') return todo.completed;
        return true;
    });

    return (
        <div className="todo-app">
            <h1>Todo List</h1>
            <form onSubmit={addTodo}>
                <input
                    type="text"
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    placeholder="Add a new todo..."
                />
                <button type="submit">Add</button>
            </form>

            <div className="filters">
                <button onClick={() => setFilter('all')}>All</button>
                <button onClick={() => setFilter('active')}>Active</button>
                <button onClick={() => setFilter('completed')}>Completed</button>
            </div>

            <ul className="todo-list">
                {filteredTodos.map(todo => (
                    <li key={todo.id} className={todo.completed ? 'completed' : ''}>
                        <input
                            type="checkbox"
                            checked={todo.completed}
                            onChange={() => toggleTodo(todo.id)}
                        />
                        <span>{todo.text}</span>
                        <button onClick={() => deleteTodo(todo.id)}>Delete</button>
                    </li>
                ))}
            </ul>
        </div>
    );
}

export default TodoApp;
```

---

## Intermediate Projects

### 4. E-Commerce Platform

**Tech Stack**: React, Node.js, PostgreSQL, Stripe

**Features**:
- Product catalog with search/filter
- Shopping cart
- User authentication
- Checkout with Stripe
- Order history
- Admin dashboard

**Database Schema**:
```sql
-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    image_url VARCHAR(500),
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'pending',
    total DECIMAL(10, 2) NOT NULL,
    stripe_payment_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    product_id UUID REFERENCES products(id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);
```

**API Routes**:
```javascript
// routes/products.js
router.get('/products', async (req, res) => {
    const { category, search, sort, page = 1, limit = 20 } = req.query;
    let query = 'SELECT * FROM products WHERE 1=1';
    const params = [];

    if (category) {
        query += ' AND category = $' + (params.length + 1);
        params.push(category);
    }

    if (search) {
        query += ' AND (name ILIKE $' + (params.length + 1) + ' OR description ILIKE $' + (params.length + 1) + ')';
        params.push(`%${search}%`);
    }

    if (sort) {
        query += ' ORDER BY ' + (sort === 'price_asc' ? 'price ASC' : 'price DESC');
    } else {
        query += ' ORDER BY created_at DESC';
    }

    const offset = (page - 1) * limit;
    query += ` LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const result = await db.query(query, params);
    res.json(result.rows);
});
```

---

### 5. Social Media Dashboard

**Tech Stack**: React, Node.js, MongoDB, WebSockets

**Features**:
- User profiles
- Posts with likes/comments
- Real-time notifications
- Follow/unfollow users
- News feed algorithm
- Direct messaging

**Data Models**:
```javascript
// models/User.js
const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    avatar: String,
    bio: String,
    followers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    following: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    createdAt: { type: Date, default: Date.now }
});

// models/Post.js
const postSchema = new mongoose.Schema({
    author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    content: { type: String, required: true },
    image: String,
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    comments: [{
        author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
        content: String,
        createdAt: { type: Date, default: Date.now }
    }],
    createdAt: { type: Date, default: Date.now }
});
```

---

### 6. Project Management Tool

**Tech Stack**: React, Node.js, PostgreSQL, Redis

**Features**:
- Projects and tasks
- Kanban board
- Team collaboration
- Time tracking
- File attachments
- Activity log

**Database Schema**:
```sql
-- Projects
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id UUID REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES projects(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'todo',
    priority VARCHAR(20) DEFAULT 'medium',
    assignee_id UUID REFERENCES users(id),
    due_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Task comments
CREATE TABLE task_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES tasks(id),
    user_id UUID REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Advanced Projects

### 7. Real-Time Chat Application

**Tech Stack**: React, Node.js, Socket.io, Redis, PostgreSQL

**Features**:
- One-on-one messaging
- Group chats
- File sharing
- Online status
- Message history
- Typing indicators

**WebSocket Implementation**:
```javascript
// server/socket.js
const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');

const io = new Server(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        credentials: true
    }
});

// Authentication middleware
io.use((socket, next) => {
    const token = socket.handshake.auth.token;
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        socket.userId = decoded.id;
        next();
    } catch (err) {
        next(new Error('Authentication error'));
    }
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.userId);

    // Join user's rooms
    socket.on('join-rooms', async (rooms) => {
        rooms.forEach(room => socket.join(room));
    });

    // Handle new message
    socket.on('send-message', async (data) => {
        const { roomId, content, type = 'text' } = data;

        // Save to database
        const message = await Message.create({
            roomId,
            senderId: socket.userId,
            content,
            type
        });

        // Broadcast to room
        io.to(roomId).emit('new-message', message);
    });

    // Handle typing indicator
    socket.on('typing', (roomId) => {
        socket.to(roomId).emit('user-typing', {
            userId: socket.userId,
            roomId
        });
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.userId);
    });
});
```

---

### 8. Video Streaming Platform

**Tech Stack**: React, Node.js, FFmpeg, AWS S3, PostgreSQL

**Features**:
- Video upload and processing
- Adaptive streaming (HLS)
- Comments and likes
- Subscriptions
- Watch history
- Recommendations

**Video Processing**:
```javascript
// services/videoProcessor.js
const ffmpeg = require('fluent-ffmpeg');
const AWS = require('aws-sdk');

class VideoProcessor {
    constructor() {
        this.s3 = new AWS.S3();
    }

    async processVideo(videoId, inputPath) {
        const outputDir = `/tmp/${videoId}`;

        // Create different quality versions
        const qualities = [
            { name: '360p', resolution: '640x360', bitrate: '800k' },
            { name: '480p', resolution: '854x480', bitrate: '1400k' },
            { name: '720p', resolution: '1280x720', bitrate: '2800k' },
            { name: '1080p', resolution: '1920x1080', bitrate: '5000k' }
        ];

        for (const quality of qualities) {
            await this.encodeVideo(inputPath, outputDir, quality);
        }

        // Generate HLS playlist
        await this.generateHLS(outputDir);

        // Upload to S3
        await this.uploadToS3(outputDir, videoId);
    }

    encodeVideo(input, output, quality) {
        return new Promise((resolve, reject) => {
            ffmpeg(input)
                .output(`${output}/${quality.name}.mp4`)
                .videoCodec('libx264')
                .size(quality.resolution)
                .videoBitrate(quality.bitrate)
                .audioCodec('aac')
                .on('end', resolve)
                .on('error', reject)
                .run();
        });
    }
}
```

---

### 9. Learning Management System

**Tech Stack**: React, Node.js, PostgreSQL, Redis, WebSockets

**Features**:
- Course creation and management
- Video lessons
- Quizzes and assessments
- Progress tracking
- Certificates
- Live sessions

**Database Schema**:
```sql
-- Courses
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructor_id UUID REFERENCES users(id),
    price DECIMAL(10, 2),
    thumbnail VARCHAR(500),
    published BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Lessons
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES courses(id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    video_url VARCHAR(500),
    duration INTEGER, -- in seconds
    order_index INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    course_id UUID REFERENCES courses(id),
    progress DECIMAL(5, 2) DEFAULT 0,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    UNIQUE(user_id, course_id)
);

-- Quiz attempts
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    lesson_id UUID REFERENCES lessons(id),
    score DECIMAL(5, 2),
    answers JSONB,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## Portfolio Projects

### Recommended Portfolio Projects

| Project | Difficulty | Skills Demonstrated |
|---------|------------|---------------------|
| E-commerce Platform | Advanced | Full CRUD, Auth, Payments |
| Social Media App | Advanced | Real-time, Complex data |
| Project Management | Advanced | Complex UI, Collaboration |
| Blog with CMS | Intermediate | Content management |
| Weather Dashboard | Beginner | API integration |
| Portfolio Website | Beginner | HTML/CSS/JS |

### Project Showcase Tips

```markdown
## Project Documentation Template

### Project Name
Brief description of what the project does.

### Live Demo
[https://your-project.vercel.app](https://your-project.vercel.app)

### Repository
[https://github.com/username/project](https://github.com/username/project)

### Tech Stack
- Frontend: React, TypeScript, Tailwind CSS
- Backend: Node.js, Express
- Database: PostgreSQL, Redis
- Deployment: Vercel, Railway

### Features
- Feature 1
- Feature 2
- Feature 3

### Architecture
Brief description of the architecture.

### Getting Started
1. Clone the repository
2. Install dependencies
3. Set up environment variables
4. Run the development server

### Screenshots
[Screenshots here]
```

---

## Project Implementation Guide

### Development Workflow

```
1. Planning
   ├── Define requirements
   ├── Create wireframes
   ├── Design database schema
   └── Plan API endpoints

2. Setup
   ├── Initialize project
   ├── Set up version control
   ├── Configure linting/formatting
   └── Set up CI/CD

3. Backend
   ├── Database setup
   ├── API routes
   ├── Authentication
   └── Business logic

4. Frontend
   ├── Component structure
   ├── State management
   ├── API integration
   └── UI/UX

5. Testing
   ├── Unit tests
   ├── Integration tests
   └── E2E tests

6. Deployment
   ├── Environment setup
   ├── Database migration
   ├── Deploy to cloud
   └── Monitor and maintain
```

### Git Commit Convention

```bash
# Format: type(scope): description

# Examples:
feat(auth): add JWT authentication
fix(orders): resolve checkout bug
docs(readme): update installation guide
style(css): fix responsive layout
refactor(api): optimize database queries
test(users): add unit tests
chore(deps): update dependencies
```

### README Template

```markdown
# Project Name

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)]()

## Overview
Brief description of the project.

## Features
- Feature 1
- Feature 2

## Tech Stack
| Layer | Technology |
|-------|------------|
| Frontend | React, TypeScript |
| Backend | Node.js, Express |
| Database | PostgreSQL |

## Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL 15+

### Installation
```bash
git clone https://github.com/username/project.git
cd project
npm install
```

### Environment Variables
```env
DATABASE_URL=postgresql://localhost:5432/mydb
JWT_SECRET=your-secret
```

### Running
```bash
npm run dev
```

## API Documentation
[Link to API docs]

## License
MIT
```

---

## Common Interview Questions

### Q1: How do you approach building a full-stack project?

**Answer:**
1. **Plan**: Define requirements, design architecture
2. **Setup**: Initialize project, configure tools
3. **Backend**: Database, API, authentication
4. **Frontend**: Components, state, API calls
5. **Test**: Unit, integration, E2E tests
6. **Deploy**: CI/CD, cloud hosting
7. **Monitor**: Logging, error tracking

### Q2: How do you handle state in a complex application?

**Answer:**
- **Local state**: UI-specific (form inputs, modals)
- **Global state**: App-wide (user auth, theme)
- **Server state**: API data (TanStack Query)
- **URL state**: Navigation (React Router)

### Q3: How do you optimize application performance?

**Answer:**
- **Frontend**: Code splitting, lazy loading, memoization
- **Backend**: Caching, query optimization, connection pooling
- **Database**: Indexing, read replicas, query analysis
- **Network**: CDN, compression, HTTP/2

### Q4: How do you ensure code quality?

**Answer:**
- ESLint and Prettier for code style
- TypeScript for type safety
- Unit tests for business logic
- Integration tests for APIs
- Code reviews for team standards
- CI/CD for automated checks

### Q5: How do you handle errors in a full-stack application?

**Answer:**
- **Frontend**: Error boundaries, toast notifications
- **Backend**: Centralized error handler, logging
- **Database**: Transaction rollback, retry logic
- **Monitoring**: Sentry, error tracking
- **Communication**: User-friendly error messages
