# Frontend Performance Optimization

## Table of Contents

1. [Performance Metrics](#performance-metrics)
2. [Core Web Vitals](#core-web-vitals)
3. [Loading Performance](#loading-performance)
4. [Runtime Performance](#runtime-performance)
5. [Rendering Optimization](#rendering-optimization)
6. [Network Optimization](#network-optimization)
7. [Build Optimization](#build-optimization)
8. [Performance Testing](#performance-testing)
9. [Performance Monitoring](#performance-monitoring)
10. [Common Interview Questions](#common-interview-questions)

---

## Performance Metrics

### Key Performance Indicators

```
Performance Metrics
├── Loading
│   ├── Time to First Byte (TTFB)
│   ├── First Contentful Paint (FCP)
│   ├── Largest Contentful Paint (LCP)
│   └── Speed Index
│
├── Interactivity
│   ├── First Input Delay (FID)
│   ├── Interaction to Next Paint (INP)
│   └── Total Blocking Time (TBT)
│
├── Visual Stability
│   ├── Cumulative Layout Shift (CLS)
│   └── Layout Stability Score
│
└── User Experience
    ├── Time to Interactive (TTI)
    ├── First Meaningful Paint (FMP)
    └── Bounce Rate
```

### Performance Budget

```javascript
// performance-budget.json
{
    "budgets": [
        {
            "type": "initial",
            "maximumWarning": "200kb",
            "maximumError": "300kb"
        },
        {
            "type": "bundle",
            "name": "main",
            "maximumWarning": "150kb",
            "maximumError": "200kb"
        },
        {
            "type": "bundle",
            "name": "vendor",
            "maximumWarning": "100kb",
            "maximumError": "150kb"
        }
    ],
    "thresholds": {
        "first-contentful-paint": 1500,
        "largest-contentful-paint": 2500,
        "cumulative-layout-shift": 0.1,
        "total-blocking-time": 300
    }
}
```

---

## Core Web Vitals

### Largest Contentful Paint (LCP)

```javascript
// Measure LCP
const observer = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const lastEntry = entries[entries.length - 1];
    console.log('LCP:', lastEntry.startTime);
});

observer.observe({ type: 'largest-contentful-paint', buffered: true });

// Optimize LCP
// 1. Preload critical resources
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/hero.jpg" as="image">

// 2. Use responsive images
<img
    srcset="hero-400.jpg 400w, hero-800.jpg 800w, hero-1200.jpg 1200w"
    sizes="(max-width: 600px) 400px, (max-width: 1000px) 800px, 1200px"
    src="hero-800.jpg"
    alt="Hero image"
    loading="eager"
/>

// 3. Inline critical CSS
<style>
    /* Critical above-the-fold CSS */
    .header { display: flex; }
    .hero { min-height: 50vh; }
</style>
```

### Cumulative Layout Shift (CLS)

```javascript
// Measure CLS
let clsValue = 0;
let clsEntries = [];

const clsObserver = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        if (!entry.hadRecentInput) {
            clsValue += entry.value;
            clsEntries.push(entry);
        }
    }
});

clsObserver.observe({ type: 'layout-shift', buffered: true });

// Prevent CLS
// 1. Set dimensions on images
<img width="800" height="600" src="image.jpg" alt="..." />

// 2. Reserve space for dynamic content
.skeleton {
    width: 100%;
    height: 200px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
}

// 3. Use aspect-ratio CSS
.video-container {
    aspect-ratio: 16 / 9;
    width: 100%;
}

// 4. Avoid inserting content above existing content
.dynamic-content {
    contain: layout;
}
```

### Interaction to Next Paint (INP)

```javascript
// Measure INP
const inpObserver = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const longestInteraction = entries.reduce((prev, curr) =>
        curr.duration > prev.duration ? curr : prev
    );
    console.log('INP:', longestInteraction.duration);
});

inpObserver.observe({ type: 'event', buffered: true });

// Optimize INP
// 1. Break up long tasks
function processLargeDataset(data) {
    const chunkSize = 1000;
    let index = 0;

    function processChunk(deadline) {
        while (index < data.length && deadline.timeRemaining() > 0) {
            // Process item
            index++;
        }

        if (index < data.length) {
            requestIdleCallback(processChunk);
        }
    }

    requestIdleCallback(processChunk);
}

// 2. Use requestAnimationFrame for animations
function animate(element) {
    let start = null;

    function step(timestamp) {
        if (!start) start = timestamp;
        const progress = timestamp - start;
        element.style.transform = `translateX(${progress}px)`;

        if (progress < 2000) {
            requestAnimationFrame(step);
        }
    }

    requestAnimationFrame(step);
}

// 3. Debounce event handlers
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}
```

---

## Loading Performance

### Code Splitting

```javascript
// React Lazy Loading
import { lazy, Suspense } from 'react';

const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));

function App() {
    return (
        <Suspense fallback={<Loading />}>
            <Routes>
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/settings" element={<Settings />} />
            </Routes>
        </Suspense>
    );
}

// Route-based splitting
const routes = [
    {
        path: '/dashboard',
        component: lazy(() => import('./pages/Dashboard'))
    },
    {
        path: '/analytics',
        component: lazy(() => import('./pages/Analytics'))
    }
];

// Component-based splitting
function HeavyComponent() {
    const [showChart, setShowChart] = useState(false);

    return (
        <div>
            <button onClick={() => setShowChart(true)}>Show Chart</button>
            {showChart && (
                <Suspense fallback={<ChartSkeleton />}>
                    <Chart />
                </Suspense>
            )}
        </div>
    );
}
```

### Lazy Loading Images

```html
<!-- Native lazy loading -->
<img src="image.jpg" loading="lazy" alt="..." width="800" height="600" />

<!-- Intersection Observer -->
<script>
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.dataset.src;
            img.classList.add('loaded');
            observer.unobserve(img);
        }
    });
});

document.querySelectorAll('img[data-src]').forEach(img => {
    observer.observe(img);
});
</script>

<img data-src="image.jpg" src="placeholder.jpg" alt="..." class="lazy" />
```

### Preloading Strategies

```html
<!-- Preload critical resources -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/hero.jpg" as="image">

<!-- Prefetch next page resources -->
<link rel="prefetch" href="/dashboard">

<!-- DNS Prefetch -->
<link rel="dns-prefetch" href="https://api.example.com">

<!-- Preconnect -->
<link rel="preconnect" href="https://fonts.googleapis.com">
```

### Font Optimization

```css
/* Font face with font-display */
@font-face {
    font-family: 'CustomFont';
    src: url('/fonts/custom-font.woff2') format('woff2');
    font-display: swap;
}

/* System font stack */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
        Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

/* Font loading strategy */
.font-loaded .custom-font {
    font-family: 'CustomFont', sans-serif;
}
```

---

## Runtime Performance

### Virtualization

```javascript
// React Virtualized List
import { FixedSizeList } from 'react-window';

function VirtualizedList({ items }) {
    const Row = ({ index, style }) => (
        <div style={style}>
            {items[index].name}
        </div>
    );

    return (
        <FixedSizeList
            height={500}
            width="100%"
            itemCount={items.length}
            itemSize={50}
        >
            {Row}
        </FixedSizeList>
    );
}

// React Window
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualizedList({ items }) {
    const parentRef = React.useRef(null);

    const virtualizer = useVirtualizer({
        count: items.length,
        getScrollElement: () => parentRef.current,
        estimateSize: () => 50,
    });

    return (
        <div ref={parentRef} style={{ height: '500px', overflow: 'auto' }}>
            <div style={{ height: virtualizer.getTotalSize() }}>
                {virtualizer.getVirtualItems().map((virtualRow) => (
                    <div
                        key={virtualRow.key}
                        style={{
                            position: 'absolute',
                            top: virtualRow.start,
                            height: virtualRow.size,
                            width: '100%',
                        }}
                    >
                        {items[virtualRow.index].name}
                    </div>
                ))}
            </div>
        </div>
    );
}
```

### Memoization

```javascript
// React.memo for components
const MemoizedComponent = React.memo(function MyComponent({ data }) {
    return <div>{/* Render data */}</div>;
});

// useMemo for expensive computations
function ExpensiveComponent({ items }) {
    const sortedItems = useMemo(() => {
        return items.sort((a, b) => a.value - b.value);
    }, [items]);

    const filteredItems = useMemo(() => {
        return sortedItems.filter(item => item.active);
    }, [sortedItems]);

    return (
        <ul>
            {filteredItems.map(item => (
                <li key={item.id}>{item.name}</li>
            ))}
        </ul>
    );
}

// useCallback for event handlers
function ParentComponent() {
    const [count, setCount] = useState(0);

    const handleClick = useCallback(() => {
        setCount(c => c + 1);
    }, []);

    return (
        <div>
            <p>Count: {count}</p>
            <MemoizedChild onClick={handleClick} />
        </div>
    );
}

const MemoizedChild = React.memo(function Child({ onClick }) {
    return <button onClick={onClick}>Increment</button>;
});
```

### Web Workers

```javascript
// main.js
const worker = new Worker('/worker.js');

worker.postMessage({ type: 'process', data: largeDataset });

worker.onmessage = (event) => {
    const { result } = event.data;
    updateUI(result);
};

// worker.js
self.onmessage = (event) => {
    const { type, data } = event.data;

    if (type === 'process') {
        const result = processData(data);
        self.postMessage({ result });
    }
};

function processData(data) {
    // CPU-intensive operations
    return data.map(item => ({
        ...item,
        processed: true
    }));
}
```

---

## Rendering Optimization

### React Rendering Optimization

```javascript
// 1. Avoid inline objects and functions
// Bad
function App() {
    return (
        <ChildComponent
            style={{ color: 'red' }}
            onClick={() => console.log('clicked')}
        />
    );
}

// Good
const style = { color: 'red' };
const handleClick = () => console.log('clicked');

function App() {
    return (
        <ChildComponent style={style} onClick={handleClick} />
    );
}

// 2. Use React.memo for pure components
const PureChild = React.memo(function Child({ data }) {
    return <div>{data.name}</div>;
});

// 3. Use key prop correctly
function List({ items }) {
    return (
        <ul>
            {items.map(item => (
                <ListItem key={item.id} item={item} />
            ))}
        </ul>
    );
}

// 4. Avoid unnecessary re-renders
function Parent() {
    const [count, setCount] = useState(0);

    return (
        <div>
            <ExpensiveComponent /> {/* Won't re-render */}
            <button onClick={() => setCount(c => c + 1)}>
                Count: {count}
            </button>
        </div>
    );
}
```

### CSS Performance

```css
/* 1. Use transform instead of top/left/right/bottom */
.bad {
    position: absolute;
    top: 0;
    animation: move 1s infinite;
}

@keyframes move {
    50% { top: 100px; } /* Triggers layout */
}

.good {
    position: absolute;
    top: 0;
    animation: move 1s infinite;
}

@keyframes move {
    50% { transform: translateY(100px); } /* Only triggers composite */
}

/* 2. Use contain for isolation */
.card {
    contain: layout style paint;
}

/* 3. Use will-change sparingly */
.animated {
    will-change: transform;
    transition: transform 0.3s;
}

/* 4. Avoid layout thrashing */
.bad {
    height: 100px;
    margin-top: 20px;
}

.good {
    height: 100px;
    padding-top: 20px; /* Uses padding instead of margin */
}
```

---

## Network Optimization

### HTTP/2 and HTTP/3

```javascript
// Server configuration
const http2 = require('http2');
const server = http2.createSecureServer({
    key: fs.readFileSync('server.key'),
    cert: fs.readFileSync('server.cert')
});

// Enable HTTP/2 push
server.on('stream', (stream, headers) => {
    const path = headers[':path'];

    // Push critical resources
    if (path === '/') {
        stream.pushStream({ ':path': '/styles.css' }, (err, pushStream) => {
            pushStream.respond({ ':status': 200 });
            pushStream.end(fs.readFileSync('styles.css'));
        });
    }
});
```

### Caching Strategies

```javascript
// Service Worker with Cache API
const CACHE_NAME = 'v1';
const urlsToCache = [
    '/',
    '/styles.css',
    '/script.js',
    '/offline.html'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then((cache) => cache.addAll(urlsToCache))
    );
});

self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request)
            .then((response) => {
                if (response) {
                    return response;
                }
                return fetch(event.request)
                    .then((response) => {
                        if (!response || response.status !== 200) {
                            return response;
                        }
                        const responseToCache = response.clone();
                        caches.open(CACHE_NAME)
                            .then((cache) => {
                                cache.put(event.request, responseToCache);
                            });
                        return response;
                    });
            })
            .catch(() => {
                return caches.match('/offline.html');
            })
    );
});
```

### Resource Hints

```html
<!-- Preconnect to third-party origins -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://cdn.example.com" crossorigin>

<!-- Prefetch next page -->
<link rel="prefetch" href="/dashboard">

<!-- Prerender next page (Chrome) -->
<link rel="prerender" href="/dashboard">
```

---

## Build Optimization

### Tree Shaking

```javascript
// webpack.config.js
module.exports = {
    mode: 'production',
    optimization: {
        usedExports: true,
        minimize: true,
        splitChunks: {
            chunks: 'all',
            maxInitialRequests: 25,
            minSize: 20000,
            cacheGroups: {
                vendor: {
                    test: /[\\/]node_modules[\\/]/,
                    name(module) {
                        const packageName = module.context.match(
                            /[\\/]node_modules[\\/](.*?)([\\/]|$)/
                        )[1];
                        return `vendor.${packageName.replace('@', '')}`;
                    }
                }
            }
        }
    }
};
```

### Bundle Analysis

```javascript
// webpack-bundle-analyzer
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');

module.exports = {
    plugins: [
        new BundleAnalyzerPlugin({
            analyzerMode: 'static',
            reportFilename: 'bundle-report.html',
            openAnalyzer: false
        })
    ]
};

// Source Map Explorer
const { generateSourceMaps } = require('source-map-explorer');
```

### Compression

```javascript
// gzip compression
const compression = require('compression');
app.use(compression());

// Brotli compression
const brotli = require('brotli-compress');
app.use((req, res, next) => {
    if (req.headers['accept-encoding'].includes('br')) {
        res.setHeader('Content-Encoding', 'br');
        // Use Brotli
    }
});
```

---

## Performance Testing

### Lighthouse CI

```javascript
// lighthouserc.js
module.exports = {
    ci: {
        collect: {
            url: ['http://localhost:3000'],
            numberOfRuns: 3
        },
        assert: {
            assertions: {
                'categories:performance': ['error', { minScore: 0.9 }],
                'categories:accessibility': ['warn', { minScore: 0.9 }],
                'first-contentful-paint': ['error', { maxNumericValue: 2000 }],
                'largest-contentful-paint': ['error', { maxNumericValue: 2500 }],
                'cumulative-layout-shift': ['error', { maxNumericValue: 0.1 }]
            }
        },
        upload: {
            target: 'lhci'
        }
    }
};
```

### Web Vitals Monitoring

```javascript
// web-vitals.js
import { onLCP, onFID, onCLS, onINP, onFCP } from 'web-vitals';

function sendToAnalytics(metric) {
    const body = JSON.stringify(metric);
    if (navigator.sendBeacon) {
        navigator.sendBeacon('/analytics', body);
    } else {
        fetch('/analytics', { body, method: 'POST', keepalive: true });
    }
}

onLCP(sendToAnalytics);
onFID(sendToAnalytics);
onCLS(sendToAnalytics);
onINP(sendToAnalytics);
onFCP(sendToAnalytics);
```

### Performance Budget in CI

```yaml
# .github/workflows/performance.yml
name: Performance Budget

on:
  pull_request:
    branches: [main]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - run: npm ci
      - run: npm run build

      - name: Lighthouse CI
        uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
          budgetPath: ./performance-budget.json
```

---

## Performance Monitoring

### Real User Monitoring (RUM)

```javascript
// Performance Observer for RUM
const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
        // Send to monitoring service
        fetch('/api/metrics', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                name: entry.name,
                type: entry.entryType,
                startTime: entry.startTime,
                duration: entry.duration,
                // ... other metrics
            })
        });
    }
});

observer.observe({ entryTypes: ['navigation', 'resource', 'paint'] });
```

### Error Tracking

```javascript
// Sentry integration
import * as Sentry from '@sentry/react';

Sentry.init({
    dsn: 'your-dsn',
    integrations: [
        new Sentry.BrowserTracing(),
    ],
    tracesSampleRate: 0.1,
    replaysSessionSampleRate: 0.1,
    replaysOnErrorSampleRate: 1.0,
});

// React Error Boundary
class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false };
    }

    static getDerivedStateFromError(error) {
        return { hasError: true };
    }

    componentDidCatch(error, errorInfo) {
        Sentry.captureException(error, { extra: errorInfo });
    }

    render() {
        if (this.state.hasError) {
            return <h1>Something went wrong.</h1>;
        }
        return this.props.children;
    }
}
```

---

## Common Interview Questions

### Q1: What are Core Web Vitals?

**Answer:**
Core Web Vitals are three metrics that measure user experience:
- **LCP (Largest Contentful Paint)**: Loading performance (should be < 2.5s)
- **INP (Interaction to Next Paint)**: Interactivity (should be < 200ms)
- **CLS (Cumulative Layout Shift)**: Visual stability (should be < 0.1)

### Q2: How do you optimize LCP?

**Answer:**
- Preload critical resources
- Optimize images (compression, modern formats, responsive)
- Use CDN for static assets
- Minimize server response time (TTFB)
- Inline critical CSS
- Reduce render-blocking resources

### Q3: What is the difference between lazy loading and code splitting?

**Answer:**
- **Lazy loading**: Deferring loading of non-critical resources until they're needed (images, components)
- **Code splitting**: Breaking code into smaller chunks that can be loaded on demand (routes, features)

### Q4: How do you prevent layout shifts?

**Answer:**
- Always set dimensions on images and videos
- Use CSS `aspect-ratio` for responsive media
- Reserve space for dynamic content with skeleton screens
- Avoid inserting content above existing content
- Use `font-display: swap` for web fonts

### Q5: Explain the render cycle in React.

**Answer:**
1. State change triggers re-render
2. React calls component function to get new JSX
3. React diffs new vs old Virtual DOM
4. React updates only changed elements in real DOM
5. Browser paints pixels to screen

Optimization: `React.memo`, `useMemo`, `useCallback` prevent unnecessary re-renders.
