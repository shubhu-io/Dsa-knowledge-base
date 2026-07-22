# React Cheat Sheet

Quick reference for React concepts, hooks, and patterns.

## Installation

```bash
# Create new React app
npx create-react-app my-app

# Or with Vite (faster)
npm create vite@latest my-app -- --template react

# Install dependencies
npm install
npm start
```

## Components

### Functional Components
```jsx
// Basic component
function Welcome({ name }) {
  return <h1>Hello, {name}!</h1>;
}

// Arrow function
const Welcome = ({ name }) => <h1>Hello, {name}!</h1>;

// With children
function Card({ children }) {
  return <div className="card">{children}</div>;
}
```

### Class Components
```jsx
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}
```

## JSX

### Basic Syntax
```jsx
// Expressions
const element = <h1>Hello, {name}!</h1>;

// Attributes
const element = <img src={imageUrl} alt="description" />;

// Children
const element = <div><p>Child 1</p><p>Child 2</p></div>;

// Fragments
const element = (
  <>
    <p>Child 1</p>
    <p>Child 2</p>
  </>
);

// Conditional rendering
const element = isLoggedIn ? <Dashboard /> : <Login />;

// List rendering
const element = items.map(item => <li key={item.id}>{item.name}</li>);
```

## Hooks

### useState
```jsx
import { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(prev => prev - 1)}>Decrement</button>
    </div>
  );
}
```

### useEffect
```jsx
import { useEffect, useState } from 'react';

function DataFetcher() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    fetch('/api/data')
      .then(res => res.json())
      .then(data => {
        setData(data);
        setLoading(false);
      });
  }, []); // Empty dependency array = run once on mount
  
  return loading ? <p>Loading...</p> : <pre>{JSON.stringify(data)}</pre>;
}
```

### useContext
```jsx
import { createContext, useContext } from 'react';

const ThemeContext = createContext('light');

function App() {
  return (
    <ThemeContext.Provider value="dark">
      <Toolbar />
    </ThemeContext.Provider>
  );
}

function Toolbar() {
  const theme = useContext(ThemeContext);
  return <div className={theme}>Toolbar</div>;
}
```

### useReducer
```jsx
import { useReducer } from 'react';

const initialState = { count: 0 };

function reducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    default:
      throw new Error();
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, initialState);
  
  return (
    <div>
      Count: {state.count}
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
    </div>
  );
}
```

### useCallback and useMemo
```jsx
import { useCallback, useMemo, useState } from 'react';

function App() {
  const [count, setCount] = useState(0);
  
  // Memoized function
  const handleClick = useCallback(() => {
    console.log('Clicked');
  }, []);
  
  // Memoized value
  const expensiveValue = useMemo(() => {
    return computeExpensiveValue(count);
  }, [count]);
  
  return <button onClick={handleClick}>{expensiveValue}</button>;
}
```

### useRef
```jsx
import { useRef, useEffect } from 'react';

function TextInput() {
  const inputRef = useRef(null);
  
  useEffect(() => {
    inputRef.current.focus();
  }, []);
  
  return <input ref={inputRef} type="text" />;
}
```

## State Management

### Local State (useState/useReducer)
```jsx
function App() {
  const [state, setState] = useState({
    count: 0,
    text: ''
  });
  
  const updateCount = () => {
    setState(prev => ({ ...prev, count: prev.count + 1 }));
  };
}
```

### Context API
```jsx
// Create context
const AppContext = createContext();

// Provider
function App() {
  const [theme, setTheme] = useState('light');
  
  return (
    <AppContext.Provider value={{ theme, setTheme }}>
      <Child />
    </AppContext.Provider>
  );
}

// Consumer
function Child() {
  const { theme, setTheme } = useContext(AppContext);
  return <div>Theme: {theme}</div>;
}
```

### External State (Redux Toolkit)
```jsx
import { createSlice, configureStore } from '@reduxjs/toolkit';

// Slice
const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: {
    increment: state => { state.value += 1; },
    decrement: state => { state.value -= 1; }
  }
});

// Store
const store = configureStore({
  reducer: { counter: counterSlice.reducer }
});

// Component
function Counter() {
  const count = useSelector(state => state.counter.value);
  const dispatch = useDispatch();
  
  return (
    <div>
      <button onClick={() => dispatch(counterSlice.actions.decrement())}>-</button>
      {count}
      <button onClick={() => dispatch(counterSlice.actions.increment())}>+</button>
    </div>
  );
}
```

## Routing

### React Router v6
```jsx
import { BrowserRouter, Routes, Route, Link, useParams } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/users">Users</Link>
      </nav>
      
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/users" element={<Users />} />
        <Route path="/users/:id" element={<User />} />
      </Routes>
    </BrowserRouter>
  );
}

function User() {
  const { id } = useParams();
  return <h1>User {id}</h1>;
}
```

## Forms

### Controlled Components
```jsx
function Form() {
  const [formData, setFormData] = useState({
    name: '',
    email: ''
  });
  
  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };
  
  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(formData);
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input
        name="name"
        value={formData.name}
        onChange={handleChange}
      />
      <input
        name="email"
        value={formData.email}
        onChange={handleChange}
      />
      <button type="submit">Submit</button>
    </form>
  );
}
```

## Performance Optimization

### Lazy Loading
```jsx
import { lazy, Suspense } from 'react';

const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <HeavyComponent />
    </Suspense>
  );
}
```

### Memoization
```jsx
import { memo } from 'react';

const MemoizedComponent = memo(function MyComponent({ data }) {
  return <div>{data}</div>;
});
```

### Code Splitting
```jsx
// Route-based splitting
const Home = lazy(() => import('./pages/Home'));
const About = lazy(() => import('./pages/About'));

// Component-based splitting
const Modal = lazy(() => import('./components/Modal'));
```

## Testing

### Jest + React Testing Library
```jsx
import { render, screen, fireEvent } from '@testing-library/react';
import Counter from './Counter';

test('increments count', () => {
  render(<Counter />);
  
  const button = screen.getByText('Increment');
  fireEvent.click(button);
  
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

## Common Patterns

### Error Boundary
```jsx
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }
    return this.props.children;
  }
}
```

### Higher-Order Component (HOC)
```jsx
function withLoading(WrappedComponent) {
  return function WithLoadingComponent({ isLoading, ...props }) {
    if (isLoading) return <div>Loading...</div>;
    return <WrappedComponent {...props} />;
  };
}

const UserListWithLoading = withLoading(UserList);
```

### Render Props
```jsx
class MouseTracker extends React.Component {
  state = { x: 0, y: 0 };
  
  handleMouseMove = (e) => {
    this.setState({ x: e.clientX, y: e.clientY });
  };
  
  render() {
    return (
      <div onMouseMove={this.handleMouseMove}>
        {this.props.render(this.state)}
      </div>
    );
  }
}

// Usage
<MouseTracker render={({ x, y }) => <p>Mouse: {x}, {y}</p>} />
```

## See Also

- [[frontend-guide]]
- [[frontend-frameworks]]
- [[frontend-performance]]
- [[frontend-accessibility]]
