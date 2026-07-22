# Software Testing: Complete Guide

## Table of Contents

1. [What is Software Testing](#what-is-software-testing)
2. [Testing Fundamentals](#testing-fundamentals)
3. [The Testing Pyramid](#the-testing-pyramid)
4. [Writing Your First Tests](#writing-your-first-tests)
5. [Test-Driven Development](#test-driven-development)
6. [Behavior-Driven Development](#behavior-driven-development)
7. [Mocking and Stubbing](#mocking-and-stubbing)
8. [Test Coverage](#test-coverage)
9. [CI/CD Integration](#cicd-integration)
10. [Common Mistakes](#common-mistakes)

---

## What is Software Testing

Software testing is the process of validating that a software application works as expected. It involves executing programs with the intent of finding bugs and verifying that the system meets its requirements.

### Testing Objectives

- **Verify correctness**: Ensure the software does what it's supposed to do
- **Find defects**: Identify bugs before users do
- **Build confidence**: Assure stakeholders of quality
- **Document behavior**: Tests serve as executable specifications
- **Prevent regressions**: Catch issues introduced by new changes

---

## Testing Fundamentals

### The Four Testing Principles (Goodhart's Law)

1. **Testing shows the presence of defects, not their absence**
   - Finding no bugs doesn't mean there are none
   - Testing reduces the probability of undiscovered defects

2. **Exhaustive testing is impossible**
   - You can't test every input combination
   - Use risk-based testing to prioritize

3. **Early testing saves time and money**
   - The cost of fixing bugs increases exponentially over time
   - Shift-left testing catches issues in requirements/design

4. **Defects cluster together**
   - Most bugs are found in a few modules
   - Focus testing efforts on high-risk areas

### Test Case Structure

```markdown
**Test Case ID**: TC-001
**Title**: User login with valid credentials
**Preconditions**: User exists in the database
**Steps**:
1. Navigate to login page
2. Enter valid email
3. Enter valid password
4. Click "Login" button
**Expected Result**: User is redirected to dashboard
**Actual Result**: (filled during execution)
**Status**: Pass/Fail
```

---

## The Testing Pyramid

```
        /  E2E  \          Few, slow, expensive
       /  Tests   \
      /─────────────\
     / Integration   \     Moderate number
    /    Tests        \
   /───────────────────\
  /   Unit Tests        \   Many, fast, cheap
 /________________________\
```

### Unit Tests (Foundation)

- Test individual functions or classes in isolation
- Run in milliseconds
- Mock external dependencies
- Target: 70-80% of all tests

```javascript
// Unit Test Example (JavaScript/Jest)
function add(a, b) {
  return a + b;
}

describe('add function', () => {
  test('adds two positive numbers', () => {
    expect(add(2, 3)).toBe(5);
  });

  test('handles negative numbers', () => {
    expect(add(-1, -2)).toBe(-3);
  });

  test('handles zero', () => {
    expect(add(0, 5)).toBe(5);
  });
});
```

### Integration Tests (Middle Layer)

- Test interaction between multiple components
- Use real databases or services (or test doubles)
- Verify wiring and configuration
- Target: 15-20% of all tests

```javascript
// Integration Test Example
describe('User API', () => {
  test('POST /users creates a new user', async () => {
    const response = await request(app)
      .post('/users')
      .send({
        name: 'John Doe',
        email: 'john@example.com',
        password: 'securepass123'
      });

    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('John Doe');

    // Verify in database
    const user = await User.findById(response.body.id);
    expect(user).toBeTruthy();
    expect(user.email).toBe('john@example.com');
  });
});
```

### End-to-End Tests (Top Layer)

- Test complete user workflows
- Simulate real user interactions
- Slow but high confidence
- Target: 5-10% of all tests

```javascript
// E2E Test Example (Cypress)
describe('User Registration Flow', () => {
  it('completes full registration', () => {
    cy.visit('/register');
    cy.get('[data-testid="name-input"]').type('Jane Doe');
    cy.get('[data-testid="email-input"]').type('jane@example.com');
    cy.get('[data-testid="password-input"]').type('SecurePass123!');
    cy.get('[data-testid="confirm-password"]').type('SecurePass123!');
    cy.get('[data-testid="register-button"]').click();

    cy.url().should('include', '/welcome');
    cy.contains('Welcome, Jane!');
  });
});
```

---

## Writing Your First Tests

### Setup (Node.js/Jest)

```bash
npm install --save-dev jest
```

```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

### Basic Test Patterns

```javascript
// calculator.test.js
const Calculator = require('./calculator');

describe('Calculator', () => {
  let calculator;

  beforeEach(() => {
    calculator = new Calculator();
  });

  describe('addition', () => {
    test('adds two numbers correctly', () => {
      expect(calculator.add(2, 3)).toBe(5);
    });

    test('handles decimal numbers', () => {
      expect(calculator.add(0.1, 0.2)).toBeCloseTo(0.3);
    });
  });

  describe('division', () => {
    test('divides two numbers correctly', () => {
      expect(calculator.divide(10, 2)).toBe(5);
    });

    test('throws error when dividing by zero', () => {
      expect(() => calculator.divide(10, 0))
        .toThrow('Cannot divide by zero');
    });
  });
});
```

### Async Testing

```javascript
// Testing promises and async code
describe('fetchUser', () => {
  test('returns user data', async () => {
    const user = await fetchUser(1);
    expect(user).toEqual({
      id: 1,
      name: expect.any(String),
      email: expect.stringContaining('@')
    });
  });

  test('rejects for invalid user id', async () => {
    await expect(fetchUser(-1))
      .rejects.toThrow('User not found');
  });
});
```

---

## Test-Driven Development

### The TDD Cycle

```
    Write Failing Test
          ↓
    Run Test (FAIL)
          ↓
    Write Minimal Code
          ↓
    Run Test (PASS)
          ↓
    Refactor Code
          ↓
    Run Test (PASS)
          ↓
    Repeat...
```

### TDD Example

```javascript
// Step 1: Write a failing test
test('capitalize first letter of word', () => {
  expect(capitalize('hello')).toBe('Hello');
});

// Step 2: Write minimal implementation
function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

// Step 3: Refactor (add edge cases)
test('handles empty string', () => {
  expect(capitalize('')).toBe('');
});

test('handles single character', () => {
  expect(capitalize('a')).toBe('A');
});

test('does not affect already capitalized', () => {
  expect(capitalize('Hello')).toBe('Hello');
});

// Step 4: Refactor implementation
function capitalize(str) {
  if (!str) return str;
  return str[0].toUpperCase() + str.slice(1);
}
```

### Benefits of TDD

- Better design through test-first thinking
- Comprehensive test coverage naturally
- Faster debugging (small changes between test runs)
- Living documentation of expected behavior
- Confidence to refactor

---

## Behavior-Driven Development

### Gherkin Syntax

```gherkin
Feature: User Authentication
  As a user
  I want to log into my account
  So that I can access my personal dashboard

  Scenario: Successful login with valid credentials
    Given I am on the login page
    When I enter my valid email "user@example.com"
    And I enter my valid password "SecurePass123"
    And I click the "Login" button
    Then I should be redirected to the dashboard
    And I should see "Welcome back!"

  Scenario: Failed login with incorrect password
    Given I am on the login page
    When I enter my valid email "user@example.com"
    And I enter an incorrect password "wrongpass"
    And I click the "Login" button
    Then I should see an error message "Invalid credentials"
    And I should remain on the login page
```

### Step Definitions (JavaScript)

```javascript
const { Given, When, Then } = require('@cucumber/cucumber');

Given('I am on the login page', async function () {
  await this.page.goto('http://localhost:3000/login');
});

When('I enter my valid email {string}', async function (email) {
  await this.page.fill('#email', email);
});

When('I enter my valid password {string}', async function (password) {
  await this.page.fill('#password', password);
});

When('I click the {string} button', async function (buttonText) {
  await this.page.click(`button:has-text("${buttonText}")`);
});

Then('I should be redirected to the dashboard', async function () {
  expect(this.page.url()).toContain('/dashboard');
});

Then('I should see {string}', async function (text) {
  await expect(this.page.locator(`text=${text}`)).toBeVisible();
});
```

---

## Mocking and Stubbing

### When to Mock

- External API calls
- Database operations
- File system operations
- Time-dependent code
- Random number generators

### Mock Examples

```javascript
// Mocking an API call
jest.mock('./api');

describe('UserService', () => {
  test('fetches user profile', async () => {
    const mockUser = { id: 1, name: 'Test User' };
    api.getUser.mockResolvedValue(mockUser);

    const user = await userService.getProfile(1);

    expect(api.getUser).toHaveBeenCalledWith(1);
    expect(user.name).toBe('Test User');
  });
});

// Mocking database
jest.mock('./database');

describe('OrderService', () => {
  test('creates order and updates inventory', async () => {
    database.orders.create.mockResolvedValue({ id: 1 });
    database.inventory.decrement.mockResolvedValue(true);

    await orderService.createOrder({ items: [1, 2, 3] });

    expect(database.orders.create).toHaveBeenCalled();
    expect(database.inventory.decrement)
      .toHaveBeenCalledTimes(3);
  });
});

// Mocking time
describe('Token expiration', () => {
  test('token expires after 24 hours', () => {
    const futureDate = new Date('2025-01-02T00:00:00Z');
    jest.setSystemTime(futureDate);

    const token = createToken();
    expect(isTokenValid(token)).toBe(false);
  });
});
```

---

## Test Coverage

### Measuring Coverage

```bash
# Jest coverage report
npx jest --coverage --collectCoverageFrom='src/**/*.js'

# Coverage thresholds in jest.config.js
module.exports = {
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

### Coverage Report Interpretation

```
-----------------------|---------|----------|---------|---------|
File                   | % Stmts | % Branch | % Funcs | % Lines |
-----------------------|---------|----------|---------|---------|
All files              |   85.71 |    80.00 |   90.00 |   85.71 |
 src/                  |   85.71 |    80.00 |   90.00 |   85.71 |
  calculator.js        |  100.00 |   100.00 |  100.00 |  100.00 |
  validator.js         |   75.00 |    66.67 |   80.00 |   75.00 |
  api.js               |   82.14 |    75.00 |   88.89 |   82.14 |
-----------------------|---------|----------|---------|---------|
```

### Coverage Targets by Layer

| Test Type | Statement Coverage | Branch Coverage |
|-----------|-------------------|-----------------|
| Unit Tests | 90%+ | 85%+ |
| Integration | 80%+ | 75%+ |
| E2E | Critical paths | N/A |
| Overall | 80%+ | 75%+ |

### What NOT to Aim For

- 100% coverage is not always practical
- Coverage doesn't equal quality
- Focus on meaningful tests, not numbers
- Test edge cases and business logic first

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Run linting
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

### Pre-commit Hooks

```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "pre-push": "npm test"
    }
  },
  "lint-staged": {
    "*.js": ["eslint --fix", "jest --findRelatedTests"]
  }
}
```

### Quality Gates

```javascript
// jest.config.js
module.exports = {
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  bail: true,           // Stop on first failure in CI
  forceExit: true,      // Force exit after tests complete
  detectOpenHandles: true
};
```

---

## Common Mistakes

### Testing Anti-Patterns

1. **Testing implementation details**
   ```javascript
   // Bad: Testing internal state
   expect(component.state.isLoading).toBe(true);

   // Good: Testing observable behavior
   expect(screen.getByText('Loading...')).toBeInTheDocument();
   ```

2. **Not cleaning up between tests**
   ```javascript
   // Bad: Tests affect each other
   let counter = 0;
   test('increments', () => { counter++; expect(counter).toBe(1); });
   test('increments again', () => { counter++; expect(counter).toBe(2); });

   // Good: Isolated tests
   test('increments', () => {
     let counter = 0;
     counter++;
     expect(counter).toBe(1);
   });
   ```

3. **Over-mocking**
   ```javascript
   // Bad: Mocking everything
   jest.mock('./utils');
   jest.mock('./config');
   jest.mock('./logger');

   // Good: Mock only external dependencies
   jest.mock('./api');  // Only mock what you must
   ```

4. **Writing only happy path tests**
   ```javascript
   // Always test:
   // - Valid inputs
   // - Invalid inputs
   // - Boundary conditions
   // - Error scenarios
   // - Empty states
   ```

5. **Ignoring flaky tests**
   ```javascript
   // Bad: Just retry flaky tests
   // Good: Fix the root cause
   // Common causes:
   // - Race conditions
   // - Time-dependent tests
   // - Shared state
   // - Network dependencies
   ```

6. **Test names that don't describe behavior**
   ```javascript
   // Bad
   test('test1', () => {});
   test('function works', () => {});

   // Good
   test('returns empty array when no items exist', () => {});
   test('throws ValidationError for invalid email format', () => {});
   ```

---

## Quick Reference Checklist

- [ ] Write tests before implementation (TDD)
- [ ] Follow the test pyramid (more unit, fewer E2E)
- [ ] Mock external dependencies
- [ ] Test edge cases and error scenarios
- [ ] Keep tests independent and isolated
- [ ] Use descriptive test names
- [ ] Maintain 80%+ code coverage
- [ ] Run tests in CI/CD pipeline
- [ ] Fix flaky tests immediately
- [ ] Review test code in PRs
