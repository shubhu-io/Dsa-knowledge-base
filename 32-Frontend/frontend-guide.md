# Frontend Development Complete Guide

## Table of Contents

1. [HTML5 Fundamentals](#html5-fundamentals)
2. [CSS3 & Modern Layout](#css3--modern-layout)
3. [JavaScript ES6+](#javascript-es6)
4. [TypeScript](#typescript)
5. [Component Architecture](#component-architecture)
6. [State Management](#state-management)
7. [Routing](#routing)
8. [API Integration](#api-integration)
9. [Authentication](#authentication)
10. [Responsive Design](#responsive-design)
11. [Accessibility](#accessibility)
12. [Testing](#testing)

---

## HTML5 Fundamentals

### Semantic HTML

```html
<!-- Good: Semantic structure -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title</title>
</head>
<body>
    <header>
        <nav aria-label="Main navigation">
            <ul>
                <li><a href="#home">Home</a></li>
                <li><a href="#about">About</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <article>
            <h1>Main Heading</h1>
            <section aria-labelledby="section1">
                <h2 id="section1">Section Title</h2>
                <p>Content here...</p>
            </section>
        </article>
        <aside aria-label="Related content">
            <h2>Related</h2>
        </aside>
    </main>

    <footer>
        <p>&copy; 2024 Company Name</p>
    </footer>
</body>
</html>
```

### Forms and Validation

```html
<form id="contact-form" novalidate>
    <div class="form-group">
        <label for="name">Name <span aria-hidden="true">*</span></label>
        <input
            type="text"
            id="name"
            name="name"
            required
            aria-required="true"
            aria-describedby="name-error"
            autocomplete="name"
        >
        <span id="name-error" class="error" role="alert"></span>
    </div>

    <div class="form-group">
        <label for="email">Email <span aria-hidden="true">*</span></label>
        <input
            type="email"
            id="email"
            name="email"
            required
            aria-required="true"
            aria-describedby="email-error"
            autocomplete="email"
        >
        <span id="email-error" class="error" role="alert"></span>
    </div>

    <button type="submit">Submit</button>
</form>
```

---

## CSS3 & Modern Layout

### Flexbox Patterns

```css
/* Centering */
.center-flex {
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Holy Grail Layout */
.holy-grail {
    display: flex;
    min-height: 100vh;
}
.holy-grail > header,
.holy-grail > footer {
    flex: 0 0 100%;
}
.holy-grail > main {
    flex: 1;
    display: flex;
}
.holy-grail > aside {
    flex: 0 0 200px;
}
.holy-grail > article {
    flex: 1;
}

/* Card Grid */
.card-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
}
.card {
    flex: 1 1 300px;
}
```

### CSS Grid Patterns

```css
/* Responsive Grid */
.auto-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1rem;
}

/* Dashboard Layout */
.dashboard {
    display: grid;
    grid-template-columns: 250px 1fr;
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
        "sidebar header"
        "sidebar main"
        "sidebar footer";
    min-height: 100vh;
}
.dashboard > header { grid-area: header; }
.dashboard > aside { grid-area: sidebar; }
.dashboard > main { grid-area: main; }
.dashboard > footer { grid-area: footer; }

/* Responsive without media queries */
.responsive-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
    gap: 1rem;
}
```

### Modern CSS Features

```css
/* Custom Properties */
:root {
    --primary-color: #3b82f6;
    --spacing-unit: 0.5rem;
    --border-radius: 0.5rem;
}

.button {
    background: var(--primary-color);
    padding: calc(var(--spacing-unit) * 2);
    border-radius: var(--border-radius);
}

/* Container Queries */
.card-container {
    container-type: inline-size;
}

@container (min-width: 400px) {
    .card {
        display: grid;
        grid-template-columns: 200px 1fr;
    }
}

/* Subgrid */
.parent-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 2rem;
}
.child {
    display: grid;
    grid-template-columns: subgrid;
    grid-row: span 3;
}
```

---

## JavaScript ES6+

### Modern Syntax

```javascript
// Destructuring
const { name, age, ...rest } = user;
const [first, second, ...others] = array;

// Arrow Functions
const multiply = (a, b) => a * b;
const fetchData = async (url) => {
    const response = await fetch(url);
    return response.json();
};

// Template Literals
const greeting = `Hello, ${name}! You are ${age} years old.`;
const html = `
    <div class="user">
        <h2>${name}</h2>
        <p>${email}</p>
    </div>
`;

// Optional Chaining
const city = user?.address?.city ?? 'Unknown';

// Nullish Coalescing
const value = null ?? 'default'; // 'default'
const value2 = 0 ?? 'default'; // 0

// Array Methods
const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);
const sum = numbers.reduce((acc, n) => acc + n, 0);
```

### Async/Await Patterns

```javascript
// Basic async/await
async function fetchUser(id) {
    try {
        const response = await fetch(`/api/users/${id}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('Failed to fetch user:', error);
        throw error;
    }
}

// Parallel requests
async function fetchDashboardData() {
    const [users, posts, comments] = await Promise.all([
        fetchUsers(),
        fetchPosts(),
        fetchComments()
    ]);
    return { users, posts, comments };
}

// Error handling with async iteration
async function processItems(items) {
    for (const item of items) {
        try {
            await processItem(item);
        } catch (error) {
            console.error(`Failed to process ${item.id}:`, error);
        }
    }
}
```

### Module Pattern

```javascript
// ES Modules
// math.js
export const add = (a, b) => a + b;
export const subtract = (a, b) => a - b;
export default class Calculator { }

// app.js
import Calculator, { add, subtract } from './math.js';

// Dynamic imports
async function loadFeature() {
    const { Feature } = await import('./features/Feature.js');
    return new Feature();
}
```

---

## TypeScript

### Basic Types

```typescript
// Primitive types
let name: string = 'John';
let age: number = 30;
let isActive: boolean = true;
let items: string[] = ['a', 'b', 'c'];

// Object types
interface User {
    id: number;
    name: string;
    email: string;
    role?: 'admin' | 'user' | 'guest';
    createdAt: Date;
}

// Function types
function greet(user: User): string {
    return `Hello, ${user.name}`;
}

// Generics
function identity<T>(arg: T): T {
    return arg;
}

// Union types
type Status = 'idle' | 'loading' | 'success' | 'error';

// Utility types
type PartialUser = Partial<User>;
type UserPreview = Pick<User, 'id' | 'name'>;
type CreateUser = Omit<User, 'id' | 'createdAt'>;
```

### Advanced TypeScript

```typescript
// Mapped types
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
};

// Conditional types
type IsString<T> = T extends string ? true : false;

// Template literal types
type HTTPMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';
type APIRoute = `/api/${string}`;

// Decorators (experimental)
function Log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
    const original = descriptor.value;
    descriptor.value = function (...args: any[]) {
        console.log(`Calling ${propertyKey} with`, args);
        return original.apply(this, args);
    };
}

// Type guards
function isString(value: unknown): value is string {
    return typeof value === 'string';
}
```

---

## Component Architecture

### React Component Patterns

```typescript
// Functional Component with hooks
import React, { useState, useEffect, useCallback, useMemo } from 'react';

interface UserListProps {
    filter?: string;
    onSelect: (user: User) => void;
}

const UserList: React.FC<UserListProps> = ({ filter, onSelect }) => {
    const [users, setUsers] = useState<User[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchUsers(filter).then(setUsers).finally(() => setLoading(false));
    }, [filter]);

    const filteredUsers = useMemo(() => {
        return users.filter(user =>
            user.name.toLowerCase().includes((filter ?? '').toLowerCase())
        );
    }, [users, filter]);

    const handleSelect = useCallback((user: User) => {
        onSelect(user);
    }, [onSelect]);

    if (loading) return <Spinner />;

    return (
        <ul>
            {filteredUsers.map(user => (
                <UserListItem
                    key={user.id}
                    user={user}
                    onSelect={handleSelect}
                />
            ))}
        </ul>
    );
};
```

### Custom Hooks

```typescript
// useLocalStorage hook
function useLocalStorage<T>(key: string, initialValue: T) {
    const [storedValue, setStoredValue] = useState<T>(() => {
        try {
            const item = window.localStorage.getItem(key);
            return item ? JSON.parse(item) : initialValue;
        } catch {
            return initialValue;
        }
    });

    const setValue = (value: T | ((val: T) => T)) => {
        const valueToStore = value instanceof Function
            ? value(storedValue)
            : value;
        setStoredValue(valueToStore);
        window.localStorage.setItem(key, JSON.stringify(valueToStore));
    };

    return [storedValue, setValue] as const;
}

// useDebounce hook
function useDebounce<T>(value: T, delay: number): T {
    const [debouncedValue, setDebouncedValue] = useState(value);

    useEffect(() => {
        const handler = setTimeout(() => {
            setDebouncedValue(value);
        }, delay);

        return () => clearTimeout(handler);
    }, [value, delay]);

    return debouncedValue;
}

// useFetch hook
function useFetch<T>(url: string) {
    const [data, setData] = useState<T | null>(null);
    const [error, setError] = useState<Error | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const controller = new AbortController();

        fetch(url, { signal: controller.signal })
            .then(res => res.json())
            .then(setData)
            .catch(setError)
            .finally(() => setLoading(false));

        return () => controller.abort();
    }, [url]);

    return { data, error, loading };
}
```

---

## State Management

### Redux Toolkit

```typescript
import { createSlice, createAsyncThunk, configureStore } from '@reduxjs/toolkit';

// Async thunk
export const fetchUsers = createAsyncThunk(
    'users/fetchUsers',
    async (_, { rejectWithValue }) => {
        try {
            const response = await fetch('/api/users');
            if (!response.ok) throw new Error('Failed to fetch');
            return await response.json();
        } catch (error) {
            return rejectWithValue(error.message);
        }
    }
);

// Slice
const usersSlice = createSlice({
    name: 'users',
    initialState: {
        items: [],
        loading: false,
        error: null
    },
    reducers: {
        addUser: (state, action) => {
            state.items.push(action.payload);
        },
        removeUser: (state, action) => {
            state.items = state.items.filter(u => u.id !== action.payload);
        }
    },
    extraReducers: (builder) => {
        builder
            .addCase(fetchUsers.pending, (state) => {
                state.loading = true;
                state.error = null;
            })
            .addCase(fetchUsers.fulfilled, (state, action) => {
                state.loading = false;
                state.items = action.payload;
            })
            .addCase(fetchUsers.rejected, (state, action) => {
                state.loading = false;
                state.error = action.payload;
            });
    }
});

// Store
const store = configureStore({
    reducer: {
        users: usersSlice.reducer
    }
});

export const { addUser, removeUser } = usersSlice.actions;
export default store;
```

### Zustand (Simpler Alternative)

```typescript
import create from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface AppState {
    count: number;
    increment: () => void;
    decrement: () => void;
    reset: () => void;
}

const useStore = create<AppState>()(
    devtools(
        persist(
            (set) => ({
                count: 0,
                increment: () => set((state) => ({ count: state.count + 1 })),
                decrement: () => set((state) => ({ count: state.count - 1 })),
                reset: () => set({ count: 0 })
            }),
            { name: 'app-store' }
        )
    )
);

export default useStore;
```

---

## Routing

### React Router v6

```typescript
import { BrowserRouter, Routes, Route, Link, Navigate } from 'react-router-dom';

function App() {
    return (
        <BrowserRouter>
            <nav>
                <Link to="/">Home</Link>
                <Link to="/users">Users</Link>
                <Link to="/dashboard">Dashboard</Link>
            </nav>

            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/users" element={<Users />} />
                <Route path="/users/:id" element={<UserDetail />} />
                <Route
                    path="/dashboard"
                    element={
                        <ProtectedRoute>
                            <Dashboard />
                        </ProtectedRoute>
                    }
                />
                <Route path="/404" element={<NotFound />} />
                <Route path="*" element={<Navigate to="/404" replace />} />
            </Routes>
        </BrowserRouter>
    );
}

// Protected Route Component
function ProtectedRoute({ children }: { children: React.ReactNode }) {
    const { isAuthenticated } = useAuth();

    if (!isAuthenticated) {
        return <Navigate to="/login" replace />;
    }

    return <>{children}</>;
}
```

---

## API Integration

### Axios Setup

```typescript
import axios, { AxiosError, InternalAxiosRequestConfig } from 'axios';

const api = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json'
    }
});

// Request interceptor
api.interceptors.request.use(
    (config: InternalAxiosRequestConfig) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
    (response) => response.data,
    (error: AxiosError) => {
        if (error.response?.status === 401) {
            localStorage.removeItem('token');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

// API functions
export const userAPI = {
    getAll: () => api.get('/users'),
    getById: (id: number) => api.get(`/users/${id}`),
    create: (data: CreateUser) => api.post('/users', data),
    update: (id: number, data: PartialUser) => api.put(`/users/${id}`, data),
    delete: (id: number) => api.delete(`/users/${id}`)
};
```

---

## Responsive Design

### Mobile-First CSS

```css
/* Base styles (mobile) */
.container {
    padding: 1rem;
    max-width: 100%;
}

/* Tablet */
@media (min-width: 768px) {
    .container {
        padding: 2rem;
        max-width: 720px;
        margin: 0 auto;
    }
}

/* Desktop */
@media (min-width: 1024px) {
    .container {
        max-width: 960px;
    }
}

/* Large Desktop */
@media (min-width: 1280px) {
    .container {
        max-width: 1200px;
    }
}
```

### Responsive Typography

```css
/* Fluid typography with clamp() */
html {
    font-size: clamp(14px, 1vw + 12px, 18px);
}

h1 {
    font-size: clamp(1.5rem, 5vw, 3rem);
    line-height: 1.2;
}

h2 {
    font-size: clamp(1.25rem, 4vw, 2.25rem);
    line-height: 1.3;
}
```

---

## Accessibility

### ARIA Patterns

```html
<!-- Modal Dialog -->
<div
    role="dialog"
    aria-modal="true"
    aria-labelledby="dialog-title"
    aria-describedby="dialog-desc"
>
    <h2 id="dialog-title">Confirm Action</h2>
    <p id="dialog-desc">Are you sure you want to proceed?</p>
    <button type="button" aria-label="Close dialog">×</button>
</div>

<!-- Accordion -->
<div class="accordion">
    <h3>
        <button
            aria-expanded="false"
            aria-controls="panel-1"
            id="header-1"
        >
            Section 1
        </button>
    </h3>
    <div
        id="panel-1"
        role="region"
        aria-labelledby="header-1"
        hidden
    >
        Content for section 1
    </div>
</div>

<!-- Live Region for Dynamic Updates -->
<div
    role="status"
    aria-live="polite"
    aria-atomic="true"
>
    Loading...
</div>
```

---

## Testing

### React Testing Library

```typescript
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import App from './App';

const server = setupServer(
    rest.get('/api/users', (req, res, ctx) => {
        return res(
            ctx.json([
                { id: 1, name: 'John Doe' },
                { id: 2, name: 'Jane Smith' }
            ])
        );
    })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('App', () => {
    it('renders user list after loading', async () => {
        render(<App />);

        expect(screen.getByText('Loading...')).toBeInTheDocument();

        await waitFor(() => {
            expect(screen.getByText('John Doe')).toBeInTheDocument();
            expect(screen.getByText('Jane Smith')).toBeInTheDocument();
        });
    });

    it('handles user selection', async () => {
        const user = userEvent.setup();
        render(<App />);

        await waitFor(() => {
            expect(screen.getByText('John Doe')).toBeInTheDocument();
        });

        await user.click(screen.getByText('John Doe'));

        expect(screen.getByText('Selected: John Doe')).toBeInTheDocument();
    });

    it('handles API error', async () => {
        server.use(
            rest.get('/api/users', (req, res, ctx) => {
                return res(ctx.status(500));
            })
        );

        render(<App />);

        await waitFor(() => {
            expect(screen.getByText('Failed to load users')).toBeInTheDocument();
        });
    });
});
```

---

## Common Interview Questions

### Q1: What is the Virtual DOM and how does it work?

**Answer:**
The Virtual DOM is a lightweight JavaScript representation of the actual DOM. When state changes, a new Virtual DOM tree is created, compared with the previous one (diffing), and only the necessary updates are applied to the real DOM (reconciliation). This is more efficient than directly manipulating the DOM.

### Q2: Explain the difference between CSS Grid and Flexbox.

**Answer:**
- **Flexbox**: One-dimensional layout (row OR column). Best for components and small-scale layouts.
- **CSS Grid**: Two-dimensional layout (rows AND columns). Best for page layouts and complex designs.
- Use Flexbox for alignment within a component, Grid for overall page structure.

### Q3: What is hydration in SSR?

**Answer:**
Hydration is the process where the client-side JavaScript takes over the server-rendered HTML. The server sends fully rendered HTML for fast initial load, then the client-side React/Vue code attaches event listeners and makes the page interactive.

### Q4: What are Web Components?

**Answer:**
Web Components are a set of web platform APIs that allow you to create reusable custom elements with encapsulated functionality. They include Custom Elements, Shadow DOM, HTML Templates, and ES Modules. They work across frameworks.

### Q5: How do you optimize bundle size?

**Answer:**
- Code splitting with dynamic imports
- Tree shaking unused code
- Lazy loading routes and components
- Analyzing bundle with tools like webpack-bundle-analyzer
- Using CDN for libraries
- Compressing assets
- Using modern image formats (WebP, AVIF)
