# Frontend Frameworks - Comparisons & Deep Dives

## Table of Contents

1. [Framework Overview](#framework-overview)
2. [React](#react)
3. [Vue.js](#vuejs)
4. [Angular](#angular)
5. [Svelte](#svelte)
6. [Next.js](#nextjs)
7. [Comparison Matrix](#comparison-matrix)
8. [Choosing a Framework](#choosing-a-framework)
9. [Meta-Frameworks](#meta-frameworks)

---

## Framework Overview

```
Frontend Frameworks 2024
├── Component-Based
│   ├── React (Meta)
│   ├── Vue.js (Community)
│   ├── Angular (Google)
│   └── Svelte (Rich Harris)
│
├── Meta-Frameworks
│   ├── Next.js (React)
│   ├── Nuxt.js (Vue)
│   ├── Angular Universal (Angular)
│   └── SvelteKit (Svelte)
│
└── Lightweight
    ├── Alpine.js
    ├── Petite-Vue
    └── Preact
```

---

## React

### Overview

React is a JavaScript library for building user interfaces, maintained by Meta.

### Core Concepts

```jsx
// Functional Component
function Counter() {
    const [count, setCount] = React.useState(0);

    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={() => setCount(c => c + 1)}>
                Increment
            </button>
        </div>
    );
}

// Component with Props
function UserCard({ user, onSelect }) {
    return (
        <div className="user-card" onClick={() => onSelect(user)}>
            <img src={user.avatar} alt={user.name} />
            <h3>{user.name}</h3>
            <p>{user.email}</p>
        </div>
    );
}

// List Rendering
function UserList({ users }) {
    return (
        <ul>
            {users.map(user => (
                <li key={user.id}>
                    <UserCard user={user} />
                </li>
            ))}
        </ul>
    );
}
```

### React Hooks

```jsx
// useState
const [state, setState] = useState(initialValue);

// useEffect
useEffect(() => {
    // Side effect
    return () => {
        // Cleanup
    };
}, [dependencies]);

// useRef
const inputRef = useRef(null);
inputRef.current.focus();

// useMemo
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);

// useCallback
const memoizedCallback = useCallback(() => {
    doSomething(a, b);
}, [a, b]);

// useContext
const value = useContext(MyContext);

// useReducer
const [state, dispatch] = useReducer(reducer, initialState);
```

### React Ecosystem

| Category | Options |
|----------|---------|
| State Management | Redux, Zustand, Jotai, Recoil |
| Routing | React Router, TanStack Router |
| Forms | React Hook Form, Formik |
| Data Fetching | TanStack Query, SWR, Apollo |
| UI Libraries | Material-UI, Chakra UI, Ant Design |
| Animation | Framer Motion, React Spring |
| Testing | Jest, React Testing Library, Cypress |

### Pros and Cons

| Pros | Cons |
|------|------|
| Large ecosystem | Requires additional libraries |
| Strong community | Frequent changes |
| Job market demand | JSX learning curve |
| Flexible architecture | State management complexity |
| Excellent tooling | Bundle size concerns |

---

## Vue.js

### Overview

Vue.js is a progressive JavaScript framework for building user interfaces.

### Core Concepts

```vue
<!-- Single File Component -->
<template>
    <div class="user-card">
        <img :src="user.avatar" :alt="user.name" />
        <h3>{{ user.name }}</h3>
        <p>{{ user.email }}</p>
        <button @click="handleClick">Select</button>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';

const props = defineProps({
    user: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['select']);

const handleClick = () => {
    emit('select', props.user);
};
</script>

<style scoped>
.user-card {
    border: 1px solid #ccc;
    border-radius: 8px;
    padding: 1rem;
}
</style>
```

### Vue 3 Composition API

```javascript
// Composition API
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';

export function useCounter(initialValue = 0) {
    const count = ref(initialValue);
    const doubled = computed(() => count.value * 2);

    const increment = () => count.value++;
    const decrement = () => count.value--;
    const reset = () => count.value = initialValue;

    return {
        count,
        doubled,
        increment,
        decrement,
        reset
    };
}

// Composable for data fetching
export function useFetch(url) {
    const data = ref(null);
    const error = ref(null);
    const loading = ref(true);

    const fetchData = async () => {
        try {
            const response = await fetch(url);
            data.value = await response.json();
        } catch (e) {
            error.value = e;
        } finally {
            loading.value = false;
        }
    };

    onMounted(fetchData);

    return { data, error, loading, refetch: fetchData };
}
```

### Vue Ecosystem

| Category | Options |
|----------|---------|
| State Management | Pinia, Vuex |
| Routing | Vue Router |
| Forms | VeeValidate, FormKit |
| Data Fetching | TanStack Query, Apollo |
| UI Libraries | Vuetify, Element Plus, PrimeVue |
| Animation | Vue Transition, Motion |
| Testing | Vitest, Vue Test Utils, Cypress |

### Pros and Cons

| Pros | Cons |
|------|------|
| Gentle learning curve | Smaller ecosystem |
| Excellent documentation | Fewer job opportunities |
| Built-in reactivity | Less flexible |
| Single-file components | Chinese community perception |
| TypeScript support | Enterprise adoption slower |

---

## Angular

### Overview

Angular is a platform and framework for building single-page client applications.

### Core Concepts

```typescript
// Component
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
    selector: 'app-user-card',
    template: `
        <div class="user-card" (click)="handleClick()">
            <img [src]="user.avatar" [alt]="user.name" />
            <h3>{{ user.name }}</h3>
            <p>{{ user.email }}</p>
        </div>
    `
})
export class UserCardComponent {
    @Input() user!: User;
    @Output() select = new EventEmitter<User>();

    handleClick() {
        this.select.emit(this.user);
    }
}

// Service
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class UserService {
    private apiUrl = '/api/users';

    constructor(private http: HttpClient) {}

    getUsers(): Observable<User[]> {
        return this.http.get<User[]>(this.apiUrl);
    }

    getUser(id: number): Observable<User> {
        return this.http.get<User>(`${this.apiUrl}/${id}`);
    }
}

// Route Guard
import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from './auth.service';

@Injectable({
    providedIn: 'root'
})
export class AuthGuard implements CanActivate {
    constructor(
        private authService: AuthService,
        private router: Router
    ) {}

    canActivate(): boolean {
        if (this.authService.isAuthenticated()) {
            return true;
        }
        this.router.navigate(['/login']);
        return false;
    }
}
```

### Angular Features

```typescript
// Reactive Forms
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
    selector: 'app-user-form',
    template: `
        <form [formGroup]="userForm" (ngSubmit)="onSubmit()">
            <input formControlName="name" placeholder="Name" />
            <input formControlName="email" placeholder="Email" />
            <button type="submit" [disabled]="userForm.invalid">
                Submit
            </button>
        </form>
    `
})
export class UserFormComponent {
    userForm: FormGroup;

    constructor(private fb: FormBuilder) {
        this.userForm = this.fb.group({
            name: ['', [Validators.required, Validators.minLength(3)]],
            email: ['', [Validators.required, Validators.email]]
        });
    }
}

// Pipes
@Pipe({
    name: 'capitalize'
})
export class CapitalizePipe implements PipeTransform {
    transform(value: string): string {
        return value.charAt(0).toUpperCase() + value.slice(1).toLowerCase();
    }
}

// HTTP Interceptor
import { Injectable } from '@angular/core';
import {
    HttpInterceptor,
    HttpRequest,
    HttpHandler,
    HttpEvent
} from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
    intercept(
        req: HttpRequest<any>,
        next: HttpHandler
    ): Observable<HttpEvent<any>> {
        const token = localStorage.getItem('token');

        if (token) {
            const cloned = req.clone({
                headers: req.headers.set('Authorization', `Bearer ${token}`)
            });
            return next.handle(cloned);
        }

        return next.handle(req);
    }
}
```

### Angular Ecosystem

| Category | Options |
|----------|---------|
| State Management | NgRx, NGXS, Akita |
| Routing | Angular Router |
| Forms | Reactive Forms, Template-driven |
| Data Fetching | HttpClient, Apollo Angular |
| UI Libraries | Angular Material, PrimeNG |
| Animation | Angular Animations |
| Testing | Jasmine, Karma, Cypress |

### Pros and Cons

| Pros | Cons |
|------|------|
| Full-featured framework | Steep learning curve |
| TypeScript native | Verbose syntax |
| Enterprise-ready | Slower bundle size |
| Strong CLI | Opinionated |
| Consistent patterns | Overkill for small projects |

---

## Svelte

### Overview

Svelte is a radical new approach to building UIs with compile-time optimizations.

### Core Concepts

```svelte
<!-- Component -->
<script>
    export let user;
    export let onSelect;

    let isSelected = false;

    $: displayName = user.name.toUpperCase();
    $: if (isSelected) {
        onSelect(user);
    }

    function handleClick() {
        isSelected = !isSelected;
    }
</script>

<div
    class="user-card"
    class:selected={isSelected}
    on:click={handleClick}
    on:keydown={handleClick}
    role="button"
    tabindex="0"
>
    <img src={user.avatar} alt={user.name} />
    <h3>{displayName}</h3>
    <p>{user.email}</p>
</div>

<style>
    .user-card {
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 1rem;
        transition: border-color 0.2s;
    }
    .user-card.selected {
        border-color: blue;
    }
</style>
```

### Svelte 5 (Runes)

```svelte
<script>
    let count = $state(0);
    let doubled = $derived(count * 2);

    function increment() {
        count += 1;
    }

    $effect(() => {
        console.log('Count changed:', count);
    });
</script>

<button onclick={increment}>
    Count: {count}, Doubled: {doubled}
</button>
```

### Svelte Stores

```javascript
// writable store
import { writable } from 'svelte/store';

export const count = writable(0);

// derived store
import { derived } from 'svelte/store';

export const doubled = derived(count, $count => $count * 2);

// readable store
import { readable } from 'svelte/store';

export const time = readable(new Date(), function start(set) {
    const interval = setInterval(() => {
        set(new Date());
    }, 1000);

    return function stop() {
        clearInterval(interval);
    };
});
```

### SvelteKit

```javascript
// +page.js (Load function)
export async function load({ fetch, params }) {
    const response = await fetch(`/api/users/${params.id}`);
    const user = await response.json();

    return { user };
}

// +page.svelte
<script>
    export let data;
</script>

<h1>{data.user.name}</h1>
```

### Pros and Cons

| Pros | Cons |
|------|------|
| No Virtual DOM overhead | Smaller ecosystem |
| Tiny bundle sizes | Fewer job opportunities |
| Less boilerplate | Less mature |
| Truly reactive | Different mental model |
| Excellent performance | Fewer third-party components |

---

## Next.js

### Overview

Next.js is a React framework for production with hybrid static & server rendering.

### Core Features

```javascript
// app/layout.js (Root Layout)
export const metadata = {
    title: 'My App',
    description: 'Built with Next.js',
};

export default function RootLayout({ children }) {
    return (
        <html lang="en">
            <body>{children}</body>
        </html>
    );
}

// app/page.js (Server Component)
async function getUsers() {
    const res = await fetch('https://api.example.com/users', {
        cache: 'no-store' // or 'force-cache' for ISR
    });
    return res.json();
}

export default async function Home() {
    const users = await getUsers();

    return (
        <main>
            <h1>Users</h1>
            <ul>
                {users.map(user => (
                    <li key={user.id}>{user.name}</li>
                ))}
            </ul>
        </main>
    );
}

// app/users/[id]/page.js (Dynamic Route)
async function getUser(id) {
    const res = await fetch(`https://api.example.com/users/${id}`);
    return res.json();
}

export default async function UserPage({ params }) {
    const user = await getUser(params.id);

    return (
        <div>
            <h1>{user.name}</h1>
            <p>{user.email}</p>
        </div>
    );
}

// app/api/users/route.js (API Route)
import { NextResponse } from 'next/server';

export async function GET() {
    const users = await fetchUsers();
    return NextResponse.json(users);
}

export async function POST(request) {
    const body = await request.json();
    const newUser = await createUser(body);
    return NextResponse.json(newUser, { status: 201 });
}
```

### Data Fetching Patterns

```javascript
// Server Components (default)
async function ServerComponent() {
    const data = await fetch('https://api.example.com/data');
    return <div>{/* Render data */}</div>;
}

// Client Components
'use client';
import { useState, useEffect } from 'react';

function ClientComponent() {
    const [data, setData] = useState(null);

    useEffect(() => {
        fetch('https://api.example.com/data')
            .then(res => res.json())
            .then(setData);
    }, []);

    return <div>{/* Render data */}</div>;
}

// Server Actions
async function createPost(formData) {
    'use server';
    const title = formData.get('title');
    await db.posts.create({ data: { title } });
    revalidatePath('/posts');
}
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Hybrid rendering | Opinionated |
| API routes built-in | Vercel lock-in concerns |
| Excellent performance | Complexity can grow |
| Great DX | Learning curve |
| Production-ready | Overkill for simple apps |

---

## Comparison Matrix

### Core Features

| Feature | React | Vue | Angular | Svelte |
|---------|-------|-----|---------|--------|
| Type | Library | Framework | Framework | Compiler |
| Learning Curve | Medium | Low | High | Low |
| Bundle Size | Medium | Small | Large | Tiny |
| Performance | Good | Good | Good | Excellent |
| TypeScript | Good | Good | Excellent | Good |
| Mobile | React Native | Capacitor | Ionic | Capacitor |
| SSR | Next.js | Nuxt | Angular Universal | SvelteKit |

### Performance Benchmarks

| Benchmark | React 18 | Vue 3 | Angular 17 | Svelte 4 |
|-----------|----------|-------|------------|----------|
| DOM Operations | 1.2x | 1.0x | 1.1x | 0.8x |
| Memory Usage | 1.3x | 1.0x | 1.4x | 0.7x |
| Bundle Size | 42KB | 33KB | 65KB | 2KB |
| First Paint | 1.1x | 1.0x | 1.2x | 0.9x |

### Ecosystem Size

| Category | React | Vue | Angular | Svelte |
|----------|-------|-----|---------|--------|
| npm Downloads/week | 20M | 5M | 3M | 500K |
| GitHub Stars | 220K | 200K | 95K | 75K |
| Job Listings | 50K+ | 15K+ | 20K+ | 3K+ |
| Stack Overflow Questions | 400K+ | 100K+ | 150K+ | 25K+ |

---

## Choosing a Framework

### Decision Matrix

```
Starting Point:
│
├── What type of project?
│   ├── Enterprise SPA → Angular
│   ├── Startup MVP → React + Next.js
│   ├── Small/Medium App → Vue.js
│   ├── Performance-Critical → Svelte
│   └── Static Site → Next.js or Nuxt
│
├── Team experience?
│   ├── JavaScript-heavy → React or Vue
│   ├── TypeScript-heavy → Angular
│   └── Mixed → Vue or React
│
├── Job market?
│   ├── Maximum opportunities → React
│   ├── Enterprise roles → Angular
│   └── Growing demand → Vue
│
└── Long-term maintenance?
    ├── Large team → Angular
    ├── Medium team → React
    └── Small team → Vue or Svelte
```

### By Use Case

| Use Case | Recommended | Why |
|----------|-------------|-----|
| E-commerce | Next.js | SEO, SSR, performance |
| Dashboard | React + Redux | Complex state, large ecosystem |
| Content Site | Next.js or Nuxt | SSG, SEO |
| Real-time App | React or Vue | WebSocket support, reactivity |
| Enterprise | Angular | Consistency, TypeScript |
| Portfolio/Blog | SvelteKit | Performance, simplicity |

---

## Common Interview Questions

### Q1: What are the key differences between React, Vue, and Angular?

**Answer:**
- **React**: Library focused on view layer, uses JSX, requires additional libraries for routing/state
- **Vue**: Progressive framework, template syntax, built-in state management and routing
- **Angular**: Full framework, TypeScript-first, opinionated architecture, enterprise-focused

### Q2: When would you choose Svelte over React?

**Answer:**
Choose Svelte when: performance is critical, bundle size matters, you want less boilerplate, or the team prefers compile-time optimizations. Choose React when: ecosystem matters, hiring is a concern, or you need React Native for mobile.

### Q3: What is server-side rendering and when should you use it?

**Answer:**
SSR renders pages on the server before sending to client. Use it for: SEO-critical pages, content-heavy sites, initial load performance, social media sharing. Avoid for: dashboards, admin panels, apps behind authentication.

### Q4: Explain the Virtual DOM debate.

**Answer:**
React uses Virtual DOM for efficient updates. Svelte and Angular use different approaches (compiler/runtime). The debate centers on whether Virtual DOM overhead is worth its benefits. Modern benchmarks show both approaches can be highly performant.

### Q5: How do you handle state management in large applications?

**Answer:**
- **React**: Redux Toolkit, Zustand, or Context API
- **Vue**: Pinia or Vuex
- **Angular**: NgRx or services with RxJS
- **Svelte**: Stores
- Generally: Local state for UI, global state for shared data, server state with TanStack Query
