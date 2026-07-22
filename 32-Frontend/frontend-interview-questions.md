# Frontend Interview Questions

## Table of Contents

1. [HTML Questions](#html-questions)
2. [CSS Questions](#css-questions)
3. [JavaScript Questions](#javascript-questions)
4. [React Questions](#react-questions)
5. [Performance Questions](#performance-questions)
6. [Architecture Questions](#architecture-questions)
7. [System Design Questions](#system-design-questions)
8. [Coding Challenges](#coding-challenges)

---

## HTML Questions

### Q1: What is the difference between `alt` and `title` attributes?

**Answer:**
- **alt**: Provides alternative text for images, essential for accessibility and screen readers
- **title**: Provides advisory information, shown as tooltip on hover

```html
<img src="photo.jpg" alt="Mountain landscape" title="View from Everest base camp">
```

### Q2: What are Semantic HTML elements?

**Answer:**
Semantic elements clearly describe their meaning to both browser and developer.

```html
<!-- Non-semantic -->
<div class="header">...</div>
<div class="nav">...</div>
<div class="main">...</div>

<!-- Semantic -->
<header>...</header>
<nav>...</nav>
<main>
    <article>...</article>
    <aside>...</aside>
</main>
<footer>...</footer>
```

Benefits:
- Better accessibility
- Improved SEO
- Clearer code structure
- Easier maintenance

### Q3: What is the difference between `display: none` and `visibility: hidden`?

**Answer:**
| Property | Space | Rendered | Accessible |
|----------|-------|----------|------------|
| `display: none` | Removed | No | No |
| `visibility: hidden` | Preserved | No | No |

```css
.hidden { display: none; }      /* Element removed from layout */
.invisible { visibility: hidden; } /* Element invisible but takes space */
```

### Q4: What are Web Workers?

**Answer:**
Web Workers run scripts in background threads, enabling parallel processing without blocking the main thread.

```javascript
// main.js
const worker = new Worker('worker.js');
worker.postMessage('Hello');
worker.onmessage = (e) => console.log(e.data);

// worker.js
self.onmessage = (e) => {
    self.postMessage('Worker: ' + e.data);
};
```

### Q5: What is the difference between `<script>`, `<script async>`, and `<script defer>`?

**Answer:**
| Attribute | Blocking | Execution |
|-----------|----------|-----------|
| `<script>` | Yes | Immediately |
| `<script async>` | No | As soon as downloaded |
| `<script defer>` | No | After HTML parsing |

```html
<!-- Blocks HTML parsing -->
<script src="app.js"></script>

<!-- Downloads in parallel, executes immediately -->
<script src="analytics.js" async></script>

<!-- Downloads in parallel, executes after HTML parsing -->
<script src="app.js" defer></script>
```

---

## CSS Questions

### Q1: What is the CSS Box Model?

**Answer:**
Every element is a rectangular box with content, padding, border, and margin.

```css
/* Content Box (default) */
.box {
    box-sizing: content-box;
    width: 200px;
    padding: 20px;
    border: 5px solid black;
    /* Total width: 200 + 40 + 10 = 250px */
}

/* Border Box */
.box {
    box-sizing: border-box;
    width: 200px;
    padding: 20px;
    border: 5px solid black;
    /* Total width: 200px (content: 155px) */
}
```

### Q2: Explain CSS Specificity.

**Answer:**
Specificity determines which CSS rule is applied when multiple rules match.

```
Priority (highest to lowest):
1. !important (avoid using)
2. Inline styles (style="...")
3. ID selectors (#id)
4. Class selectors (.class), attribute selectors, pseudo-classes
5. Element selectors (div, p), pseudo-elements (::before)
```

```css
/* Specificity: 0-0-1 */
p { color: blue; }

/* Specificity: 0-1-0 */
.text { color: green; }

/* Specificity: 0-1-1 */
p.text { color: red; }

/* Specificity: 1-0-0 */
#main { color: yellow; }
```

### Q3: What is Flexbox and when would you use it?

**Answer:**
Flexbox is a one-dimensional layout method for arranging items in rows or columns.

```css
.container {
    display: flex;
    justify-content: space-between; /* Main axis */
    align-items: center;            /* Cross axis */
    flex-wrap: wrap;
    gap: 1rem;
}

.item {
    flex: 1;           /* Grow equally */
    flex: 0 0 200px;   /* Fixed width */
    flex: 1 1 auto;    /* Grow, shrink, auto basis */
}
```

Use Flexbox for:
- Navigation bars
- Card layouts
- Centering content
- Equal-height columns

### Q4: What is CSS Grid and when would you use it?

**Answer:**
CSS Grid is a two-dimensional layout system for rows and columns.

```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: auto 1fr auto;
    gap: 1rem;
}

.item {
    grid-column: span 2;
    grid-row: 1 / 3;
}
```

Use Grid for:
- Page layouts
- Complex two-dimensional designs
- Magazine-style layouts
- Dashboard layouts

### Q5: What is the difference between `em`, `rem`, `px`, and `%`?

**Answer:**
| Unit | Reference | Use Case |
|------|-----------|----------|
| `px` | Absolute | Borders, fixed sizes |
| `em` | Parent font size | Component-level scaling |
| `rem` | Root font size | Consistent sizing |
| `%` | Parent element | Responsive widths |

```css
:root {
    font-size: 16px;
}

.parent {
    font-size: 20px;
}

.child-em {
    font-size: 1.5em;    /* 30px (1.5 * 20px parent) */
}

.child-rem {
    font-size: 1.5rem;   /* 24px (1.5 * 16px root) */
}
```

---

## JavaScript Questions

### Q1: What is the difference between `let`, `const`, and `var`?

**Answer:**
| Feature | `var` | `let` | `const` |
|---------|-------|-------|---------|
| Scope | Function | Block | Block |
| Hoisting | Yes | Yes (TDZ) | Yes (TDZ) |
| Reassignable | Yes | Yes | No |
| Redeclarable | Yes | No | No |

```javascript
// var - function scoped
function example() {
    if (true) {
        var x = 10;
    }
    console.log(x); // 10
}

// let - block scoped
function example() {
    if (true) {
        let y = 10;
    }
    console.log(y); // ReferenceError
}

// const - block scoped, cannot reassign
const z = 10;
z = 20; // TypeError
```

### Q2: Explain closures.

**Answer:**
A closure is a function that has access to variables from its outer (enclosing) scope, even after the outer function has returned.

```javascript
function createCounter() {
    let count = 0;

    return {
        increment: () => ++count,
        decrement: () => --count,
        getCount: () => count
    };
}

const counter = createCounter();
console.log(counter.increment()); // 1
console.log(counter.increment()); // 2
console.log(counter.getCount());  // 2
```

Practical uses:
- Data privacy
- Function factories
- Event handlers
- Memoization

### Q3: What is the event loop?

**Answer:**
The event loop handles asynchronous operations in JavaScript.

```
┌───────────────────────┐
│      Call Stack        │
│  (synchronous code)   │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│     Web APIs           │
│  (setTimeout, fetch)  │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│    Callback Queue      │
│  (ready to execute)   │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│      Event Loop        │
│  (checks if stack     │
│   is empty, then      │
│   pushes from queue)  │
└───────────────────────┘
```

```javascript
console.log('1');              // Sync - Call Stack

setTimeout(() => {
    console.log('2');          // Async - Callback Queue
}, 0);

Promise.resolve().then(() => {
    console.log('3');          // Microtask - Higher priority
});

console.log('4');              // Sync - Call Stack

// Output: 1, 4, 3, 2
```

### Q4: What is prototypal inheritance?

**Answer:**
JavaScript objects inherit from other objects via the prototype chain.

```javascript
class Animal {
    constructor(name) {
        this.name = name;
    }

    speak() {
        return `${this.name} makes a sound`;
    }
}

class Dog extends Animal {
    speak() {
        return `${this.name} barks`;
    }
}

const dog = new Dog('Rex');
console.log(dog.speak()); // "Rex barks"
console.log(dog instanceof Animal); // true
```

### Q5: What are Promises and async/await?

**Answer:**
Promises represent eventual completion/failure of asynchronous operations.

```javascript
// Promise
function fetchUser(id) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (id > 0) {
                resolve({ id, name: 'John' });
            } else {
                reject(new Error('Invalid ID'));
            }
        }, 1000);
    });
}

// Async/Await
async function getUser(id) {
    try {
        const user = await fetchUser(id);
        console.log(user);
    } catch (error) {
        console.error(error);
    }
}

// Parallel execution
async function getUsers() {
    const [user1, user2, user3] = await Promise.all([
        fetchUser(1),
        fetchUser(2),
        fetchUser(3)
    ]);
    return [user1, user2, user3];
}
```

---

## React Questions

### Q1: What is the Virtual DOM?

**Answer:**
The Virtual DOM is a lightweight JavaScript representation of the actual DOM. When state changes:

1. New Virtual DOM tree is created
2. Diffing algorithm compares old vs new tree
3. Only necessary updates are applied to real DOM

Benefits:
- Batched updates
- Minimal DOM manipulation
- Cross-platform compatibility

### Q2: Explain React hooks.

**Answer:**
Hooks let you use state and lifecycle in functional components.

```javascript
// useState - State management
const [count, setCount] = useState(0);

// useEffect - Side effects
useEffect(() => {
    document.title = `Count: ${count}`;
    return () => {
        // Cleanup
    };
}, [count]);

// useContext - Context consumption
const theme = useContext(ThemeContext);

// useRef - Mutable references
const inputRef = useRef(null);

// useMemo - Memoized values
const memoizedValue = useMemo(() => compute(a, b), [a, b]);

// useCallback - Memoized functions
const memoizedFn = useCallback(() => doSomething(a), [a]);

// useReducer - Complex state
const [state, dispatch] = useReducer(reducer, initialState);
```

### Q3: What are keys and why are they important?

**Answer:**
Keys help React identify which items have changed, added, or removed.

```jsx
// Bad - Using index as key
{items.map((item, index) => (
    <Item key={index} {...item} />
))}

// Good - Using unique ID
{items.map(item => (
    <Item key={item.id} {...item} />
))}
```

Keys should be:
- Unique among siblings
- Stable (don't change)
- Predictable

### Q4: What is prop drilling and how to avoid it?

**Answer:**
Prop drilling is passing props through many component layers.

```jsx
// Bad - Prop drilling
function App() {
    const [user, setUser] = useState(null);
    return <Layout user={user} />;
}

function Layout({ user }) {
    return <Sidebar user={user} />;
}

function Sidebar({ user }) {
    return <UserProfile user={user} />;
}

// Good - Context
const UserContext = React.createContext();

function App() {
    const [user, setUser] = useState(null);
    return (
        <UserContext.Provider value={user}>
            <Layout />
        </UserContext.Provider>
    );
}

function UserProfile() {
    const user = useContext(UserContext);
    return <div>{user.name}</div>;
}
```

### Q5: What is the difference between controlled and uncontrolled components?

**Answer:**
| Type | State | Value | onChange |
|------|-------|-------|----------|
| Controlled | React | `value` prop | Required |
| Uncontrolled | DOM | `defaultValue` | Optional |

```jsx
// Controlled
function ControlledInput() {
    const [value, setValue] = useState('');
    return (
        <input
            value={value}
            onChange={(e) => setValue(e.target.value)}
        />
    );
}

// Uncontrolled
function UncontrolledInput() {
    const inputRef = useRef();
    return (
        <input
            defaultValue=""
            ref={inputRef}
        />
    );
}
```

---

## Performance Questions

### Q1: How do you optimize React performance?

**Answer:**
- Use `React.memo` for pure components
- Use `useMemo` for expensive computations
- Use `useCallback` for stable function references
- Code split with `React.lazy`
- Virtualize long lists
- Avoid inline objects/functions
- Use proper key props

### Q2: What is lazy loading?

**Answer:**
Lazy loading defers loading of non-critical resources until needed.

```javascript
// Route-based
const Dashboard = lazy(() => import('./Dashboard'));

// Component-based
const HeavyChart = lazy(() => import('./HeavyChart'));

// Image lazy loading
<img src="image.jpg" loading="lazy" alt="..." />
```

### Q3: How do you measure frontend performance?

**Answer:**
- **Lighthouse**: Overall performance score
- **Web Vitals**: LCP, FID, CLS, INP
- **Chrome DevTools**: Performance tab, Network tab
- **React DevTools**: Profiler
- **Webpack Bundle Analyzer**: Bundle size

### Q4: What causes layout thrashing?

**Answer:**
Layout thrashing occurs when JavaScript repeatedly reads and writes layout properties.

```javascript
// Bad - Layout thrashing
elements.forEach(el => {
    const height = el.offsetHeight; // Read (triggers layout)
    el.style.height = height + 10 + 'px'; // Write (triggers layout)
});

// Good - Batch reads and writes
const heights = elements.map(el => el.offsetHeight); // All reads
elements.forEach((el, i) => {
    el.style.height = heights[i] + 10 + 'px'; // All writes
});
```

### Q5: Explain Critical Rendering Path.

**Answer:**
The Critical Rendering Path is the sequence of steps to render initial HTML:

1. **HTML Parsing** → DOM tree
2. **CSS Parsing** → CSSOM tree
3. **Render Tree** → DOM + CSSOM
4. **Layout** → Compute positions
5. **Paint** → Draw pixels
6. **Composite** → Layer management

Optimization:
- Inline critical CSS
- Defer non-critical CSS
- Minimize render-blocking resources
- Use `font-display: swap`

---

## Architecture Questions

### Q1: How do you structure a large React application?

**Answer:**
```
src/
├── components/         # Reusable UI components
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   └── Button.styles.ts
│   └── index.ts
├── features/           # Feature-based modules
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── index.ts
│   └── dashboard/
├── hooks/              # Shared custom hooks
├── services/           # API and external services
├── store/              # State management
├── utils/              # Utility functions
└── App.tsx
```

### Q2: When do you use server-side rendering?

**Answer:**
Use SSR for:
- SEO-critical pages
- Content-heavy sites
- Social media sharing
- Initial load performance

Avoid SSR for:
- Dashboards
- Admin panels
- Apps behind auth

### Q3: How do you handle authentication in React?

**Answer:**
```javascript
// Auth Context
const AuthContext = React.createContext();

function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        checkAuth().then(setUser).finally(() => setLoading(false));
    }, []);

    const login = async (credentials) => {
        const user = await authService.login(credentials);
        setUser(user);
    };

    const logout = async () => {
        await authService.logout();
        setUser(null);
    };

    return (
        <AuthContext.Provider value={{ user, login, logout, loading }}>
            {children}
        </AuthContext.Provider>
    );
}

// Protected Route
function ProtectedRoute({ children }) {
    const { user, loading } = useContext(AuthContext);

    if (loading) return <Spinner />;
    if (!user) return <Navigate to="/login" />;

    return children;
}
```

---

## System Design Questions

### Q1: Design a component library.

**Answer:**
Considerations:
- **Design tokens**: Colors, spacing, typography
- **Component API**: Props, variants, states
- **Accessibility**: WCAG compliance
- **Documentation**: Storybook, props table
- **Testing**: Unit, visual regression
- **Bundle size**: Tree shaking, code splitting

### Q2: Design a real-time notification system.

**Answer:**
Architecture:
- **WebSocket connection**: For real-time updates
- **Service Worker**: For push notifications
- **State management**: Store notifications
- **UI**: Toast, notification center, badge count

```javascript
// WebSocket hook
function useNotifications() {
    const [notifications, setNotifications] = useState([]);

    useEffect(() => {
        const ws = new WebSocket('wss://api.example.com/notifications');

        ws.onmessage = (event) => {
            const notification = JSON.parse(event.data);
            setNotifications(prev => [notification, ...prev]);
        };

        return () => ws.close();
    }, []);

    return notifications;
}
```

---

## Coding Challenges

### Challenge 1: Implement debounce

```javascript
function debounce(func, delay) {
    let timeoutId;

    return function (...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => {
            func.apply(this, args);
        }, delay);
    };
}

// Usage
const debouncedSearch = debounce((query) => {
    fetch(`/api/search?q=${query}`);
}, 300);
```

### Challenge 2: Implement throttle

```javascript
function throttle(func, limit) {
    let inThrottle;

    return function (...args) {
        if (!inThrottle) {
            func.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Usage
const throttledScroll = throttle(() => {
    console.log('Scroll event');
}, 100);
```

### Challenge 3: Deep clone an object

```javascript
function deepClone(obj) {
    if (obj === null || typeof obj !== 'object') {
        return obj;
    }

    if (obj instanceof Date) {
        return new Date(obj.getTime());
    }

    if (obj instanceof Array) {
        return obj.map(item => deepClone(item));
    }

    const cloned = {};
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            cloned[key] = deepClone(obj[key]);
        }
    }
    return cloned;
}
```

### Challenge 4: Implement promise.all

```javascript
function promiseAll(promises) {
    return new Promise((resolve, reject) => {
        const results = [];
        let completed = 0;

        if (promises.length === 0) {
            resolve(results);
            return;
        }

        promises.forEach((promise, index) => {
            Promise.resolve(promise)
                .then(result => {
                    results[index] = result;
                    completed++;

                    if (completed === promises.length) {
                        resolve(results);
                    }
                })
                .catch(reject);
        });
    });
}
```

### Challenge 5: Implement memoize

```javascript
function memoize(fn) {
    const cache = new Map();

    return function (...args) {
        const key = JSON.stringify(args);

        if (cache.has(key)) {
            return cache.get(key);
        }

        const result = fn.apply(this, args);
        cache.set(key, result);
        return result;
    };
}

// Usage
const expensiveCalculation = memoize((n) => {
    console.log('Computing...');
    return n * n;
});

expensiveCalculation(4); // Computing... 16
expensiveCalculation(4); // 16 (cached)
```
