# Test Automation Guide

This document covers test automation strategies, tools, and best practices.

## Why Automate Tests?

### Benefits
- **Speed**: Automated tests run faster than manual tests
- **Consistency**: Same tests produce consistent results
- **Coverage**: Can test more scenarios in less time
- **Feedback**: Quick feedback on code changes
- **Documentation**: Tests serve as living documentation

### When to Automate
- Repetitive tests that need to run frequently
- Tests with predictable results
- Tests that are time-consuming to perform manually
- Critical functionality that must always work
- Regression tests for bug fixes

## Test Automation Pyramid

### Unit Tests (Base)
- Test individual functions/methods
- Fast execution
- High coverage
- Low maintenance cost

### Integration Tests (Middle)
- Test interactions between components
- Moderate execution time
- Medium coverage
- Medium maintenance cost

### End-to-End Tests (Top)
- Test complete user workflows
- Slow execution
- Low coverage
- High maintenance cost

## Unit Testing Frameworks

### JavaScript (Jest)
```javascript
// sum.test.js
const sum = require('./sum');

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});

test('adds negative numbers', () => {
  expect(sum(-1, -2)).toBe(-3);
});
```

### Python (pytest)
```python
# test_calculator.py
import pytest
from calculator import add

def test_add_positive():
    assert add(1, 2) == 3

def test_add_negative():
    assert add(-1, -2) == -3
```

### Java (JUnit)
```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculatorTest {
    @Test
    void testAdd() {
        assertEquals(3, Calculator.add(1, 2));
    }
}
```

## Integration Testing

### API Testing (Postman/Newman)
```javascript
// Collection runner script
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response time is less than 200ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(200);
});
```

### Database Testing
```python
# test_database.py
import pytest
from database import Database

@pytest.fixture
def db():
    database = Database()
    yield database
    database.cleanup()

def test_insert_user(db):
    user = {"name": "John", "email": "john@example.com"}
    db.insert_user(user)
    result = db.get_user_by_email("john@example.com")
    assert result["name"] == "John"
```

## End-to-End Testing

### Cypress (JavaScript)
```javascript
// login.spec.js
describe('Login', () => {
  it('should login successfully', () => {
    cy.visit('/login');
    cy.get('#email').type('user@example.com');
    cy.get('#password').type('password123');
    cy.get('button[type="submit"]').click();
    cy.url().should('include', '/dashboard');
  });
});
```

### Selenium (Multi-browser)
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class LoginTest {
    @Test
    public void testLogin() {
        WebDriver driver = new ChromeDriver();
        driver.get("http://localhost:3000/login");
        driver.findElement(By.id("email")).sendKeys("user@example.com");
        driver.findElement(By.id("password")).sendKeys("password123");
        driver.findElement(By.tagName("button")).click();
        assertEquals("Dashboard", driver.getTitle());
        driver.quit();
    }
}
```

### Playwright (Modern E2E)
```javascript
// login.spec.js
const { test, expect } = require('@playwright/test');

test('should login successfully', async ({ page }) => {
  await page.goto('/login');
  await page.fill('#email', 'user@example.com');
  await page.fill('#password', 'password123');
  await page.click('button[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
});
```

## Performance Testing

### Load Testing (k6)
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '1m', target: 20 },
    { duration: '30s', target: 0 },
  ],
};

export default function () {
  const res = http.get('http://test.k6.io');
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}
```

### Stress Testing
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 },
    { duration: '2m', target: 100 },
    { duration: '1m', target: 200 },
    { duration: '2m', target: 200 },
    { duration: '1m', target: 0 },
  ],
};
```

## Test Data Management

### Test Data Factories
```javascript
// User factory
const createUser = (overrides = {}) => ({
  name: `User ${Date.now()}`,
  email: `user${Date.now()}@example.com`,
  password: 'password123',
  ...overrides
});

// Usage
const testUser = createUser({ role: 'admin' });
```

### Mock Data
```javascript
// Using faker.js
const faker = require('faker');

const mockUser = {
  name: faker.name.findName(),
  email: faker.internet.email(),
  phone: faker.phone.phoneNumber(),
  address: faker.address.streetAddress()
};
```

### Database Seeding
```javascript
// seed.js
const bcrypt = require('bcrypt');

async function seedDatabase() {
  const hashedPassword = await bcrypt.hash('password123', 12);
  
  await User.create({
    name: 'Test User',
    email: 'test@example.com',
    password: hashedPassword
  });
}
```

## Continuous Integration

### GitHub Actions Example
```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test
        
      - name: Run linting
        run: npm run lint
        
      - name: Build
        run: npm run build
```

### Test Coverage Reporting
```javascript
// Jest configuration
module.exports = {
  collectCoverage: true,
  coverageDirectory: 'coverage',
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

## Test Maintenance

### Page Object Model (E2E)
```javascript
// pages/LoginPage.js
class LoginPage {
  constructor(page) {
    this.page = page;
    this.emailInput = page.locator('#email');
    this.passwordInput = page.locator('#password');
    this.submitButton = page.locator('button[type="submit"]');
  }

  async login(email, password) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}

// tests/login.spec.js
test('should login', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.login('user@example.com', 'password123');
});
```

### Test Configuration Management
```javascript
// config/test.js
module.exports = {
  baseUrl: process.env.TEST_URL || 'http://localhost:3000',
  timeout: 30000,
  retries: 2,
  parallel: true
};
```

## Best Practices

### Writing Good Tests
1. **One assertion per test**: Each test should verify one behavior
2. **Descriptive names**: Test names should describe the behavior
3. **Isolated tests**: Tests should not depend on each other
4. **Fast execution**: Tests should run quickly
5. **Deterministic**: Tests should produce the same result every time

### Test Organization
1. **Group related tests**: Use describe/it blocks
2. **Setup and teardown**: Use before/after hooks
3. **Test data management**: Use factories and fixtures
4. **Environment configuration**: Use environment variables

### Common Anti-patterns
- **Testing implementation details**: Focus on behavior, not implementation
- **Brittle tests**: Avoid testing specific UI elements or database queries
- **Slow tests**: Keep tests fast and focused
- **Flaky tests**: Ensure tests are deterministic
- **Over-mocking**: Mock only external dependencies

## Tools and Frameworks

### JavaScript/TypeScript
- **Unit**: Jest, Mocha, Vitest
- **Integration**: Supertest, Testing Library
- **E2E**: Cypress, Playwright, Puppeteer
- **Performance**: k6, Artillery, autocannon

### Python
- **Unit**: pytest, unittest
- **Integration**: requests, httpx
- **E2E**: Selenium, Playwright
- **Performance**: Locust, k6

### Java
- **Unit**: JUnit, TestNG
- **Integration**: Spring Test, REST Assured
- **E2E**: Selenium, Appium
- **Performance**: JMeter, Gatling

## See Also

- [[testing-guide]]
- [[testing-types]]
- [[testing-strategies]]
- [[testing-interview-questions]]
