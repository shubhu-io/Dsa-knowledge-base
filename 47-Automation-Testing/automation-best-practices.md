# Automation Best Practices

## Table of Contents

1. [General Principles](#general-principles)
2. [Test Design Best Practices](#test-design-best-practices)
3. [Code Organization](#code-organization)
4. [Selector Strategies](#selector-strategies)
5. [Handling Test Data](#handling-test-data)
6. [Managing Test Environment](#managing-test-environment)
7. [Writing Maintainable Tests](#writing-maintainable-tests)
8. [Performance Optimization](#performance-optimization)
9. [Debugging and Troubleshooting](#debugging-and-troubleshooting)
10. [Team Collaboration](#team-collaboration)

---

## General Principles

### The FIRST Principles

```
F - Fast          Tests should run quickly
I - Independent   Tests should not depend on each other
R - Repeatable    Tests should produce the same results
S - Self-Validating Tests should have a clear pass/fail
T - Timely        Tests should be written alongside code
```

### Test Automation Pyramid (Realistic)

```
                    ┌─────────────┐
                    │   Manual    │  5-10%
                    │   Tests     │  Exploratory, Usability
                    ├─────────────┤
                    │    E2E      │  10-15%
                    │   Tests     │  Critical user flows
                    ├─────────────┤
                    │ Integration │  15-25%
                    │   Tests     │  API, Service integration
                    ├─────────────┤
                    │    Unit     │  50-70%
                    │   Tests     │  Business logic, utils
                    └─────────────┘
```

### Key Principles

```markdown
**1. Test What Matters**
- Business critical paths first
- High-risk areas
- Frequently changed code
- Bug-prone features

**2. Test Early, Test Often**
- Shift-left testing
- Tests in development
- CI/CD integration
- Fast feedback loops

**3. Keep Tests Simple**
- One assertion per concept
- Clear test names
- Minimal setup
- Readable code

**4. Make Tests Reliable**
- No flaky tests
- Proper waits
- Independent tests
- Clean state
```

---

## Test Design Best Practices

### AAA Pattern (Arrange-Act-Assert)

```javascript
// ✅ Good: Clear AAA structure
test('calculates total price with tax', () => {
  // Arrange
  const items = [
    { price: 10, quantity: 2 },
    { price: 20, quantity: 1 }
  ];
  const taxRate = 0.1;

  // Act
  const total = calculateTotal(items, taxRate);

  // Assert
  expect(total).toBe(44); // (10*2 + 20*1) * 1.1
});

// ❌ Bad: Mixed concerns
test('price', () => {
  expect(calculateTotal([{ price: 10, quantity: 2 }], 0.1)).toBe(22);
  // What does this test? Unclear!
});
```

### Descriptive Test Names

```javascript
// ✅ Good: Descriptive names
describe('ShoppingCart', () => {
  describe('addItem', () => {
    test('increases quantity when adding same item twice', () => {});
    test('adds new item when cart is empty', () => {});
    test('does not add item with zero quantity', () => {});
  });
});

// ❌ Bad: Vague names
describe('ShoppingCart', () => {
  test('test 1', () => {});
  test('works', () => {});
  test('add item', () => {});
});
```

### Test One Thing

```javascript
// ✅ Good: Tests one specific behavior
test('rejects order when payment fails', async () => {
  mockPaymentService.failNext();

  await expect(orderService.createOrder(orderData))
    .rejects.toThrow('Payment failed');
});

// ❌ Bad: Tests multiple things
test('order creation', async () => {
  // Tests payment, inventory, email, database...
  // Hard to know what failed
});
```

### Independent Tests

```javascript
// ✅ Good: Independent tests
test('creates user', async () => {
  const user = await createUser({ name: 'Test' });
  expect(user.id).toBeDefined();
});

test('deletes user', async () => {
  const user = await createUser({ name: 'To Delete' });
  await deleteUser(user.id);
  await expect(getUser(user.id)).rejects.toThrow();
});

// ❌ Bad: Dependent tests
let userId;

test('creates user', async () => {
  const user = await createUser({ name: 'Test' });
  userId = user.id; // Shared state!
  expect(user.id).toBeDefined();
});

test('deletes user', async () => {
  await deleteUser(userId); // Depends on previous test
  await expect(getUser(userId)).rejects.toThrow();
});
```

---

## Code Organization

### Project Structure

```
automation/
├── tests/
│   ├── e2e/
│   │   ├── auth/
│   │   │   ├── login.spec.js
│   │   │   └── registration.spec.js
│   │   ├── checkout/
│   │   │   └── checkout.spec.js
│   │   └── smoke/
│   │       └── health.spec.js
│   ├── api/
│   │   ├── users.api.test.js
│   │   └── orders.api.test.js
│   └── visual/
│       └── homepage.visual.spec.js
├── pages/
│   ├── BasePage.js
│   ├── LoginPage.js
│   ├── DashboardPage.js
│   └── components/
│       ├── Header.js
│       └── Modal.js
├── fixtures/
│   ├── users.json
│   └── products.json
├── helpers/
│   ├── ApiHelper.js
│   ├── DatabaseHelper.js
│   └── TestDataGenerator.js
├── config/
│   ├── default.config.js
│   └── environments/
│       ├── staging.js
│       └── production.js
└── utils/
    ├── assertions.js
    └── report.js
```

### Page Object Model (POM)

```javascript
// pages/BasePage.js
class BasePage {
  constructor(page) {
    this.page = page;
  }

  async navigateTo(path) {
    await this.page.goto(path);
  }

  async waitForElement(selector, options = {}) {
    await this.page.waitForSelector(selector, {
      timeout: 10000,
      ...options
    });
  }

  async screenshot(name) {
    await this.page.screenshot({
      path: `screenshots/${name}.png`,
      fullPage: true
    });
  }
}

// pages/LoginPage.js
class LoginPage extends BasePage {
  constructor(page) {
    super(page);
    this.emailInput = '[data-testid="email"]';
    this.passwordInput = '[data-testid="password"]';
    this.loginButton = '[data-testid="login-button"]';
    this.errorMessage = '.error-message';
  }

  async goto() {
    await this.navigateTo('/login');
  }

  async login(email, password) {
    await this.page.fill(this.emailInput, email);
    await this.page.fill(this.passwordInput, password);
    await this.page.click(this.loginButton);
  }

  async getErrorMessage() {
    return await this.page.textContent(this.errorMessage);
  }

  async isErrorVisible() {
    return await this.page.isVisible(this.errorMessage);
  }
}

module.exports = { BasePage, LoginPage };
```

### Test Fixtures

```javascript
// fixtures/users.json
{
  "validUsers": [
    {
      "name": "John Doe",
      "email": "john@example.com",
      "password": "SecurePass123!",
      "role": "user"
    },
    {
      "name": "Jane Admin",
      "email": "jane@example.com",
      "password": "AdminPass123!",
      "role": "admin"
    }
  ],
  "invalidUsers": [
    {
      "name": "",
      "email": "invalid-email",
      "password": "123"
    }
  ]
}

// Using fixtures
const testData = require('../fixtures/users.json');

test('login with valid user', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login(
    testData.validUsers[0].email,
    testData.validUsers[0].password
  );
});
```

---

## Selector Strategies

### Priority Order

```markdown
**1. Data-testid (Best)**
✅ Unique, stable, explicit
✅ Not affected by UI changes
✅ Clear intent

**2. ARIA roles and labels**
✅ Semantic, accessible
✅ Works with screen readers
✅ Good for accessibility testing

**3. CSS selectors (Use carefully)**
⚠️ May break with UI changes
⚠️ Can be fragile
❌ Avoid complex selectors

**4. Text content (Last resort)**
❌ Localization issues
❌ May change frequently
❌ Not unique always
```

### Examples

```javascript
// ✅ Best: data-testid
await page.click('[data-testid="submit-button"]');

// ✅ Good: ARIA role
await page.click('button[name="submit"]');

// ✅ Acceptable: Simple CSS
await page.click('#submit-button');
await page.click('.btn-primary');

// ❌ Avoid: Complex CSS
await page.click('div.container > form > div:nth-child(2) > button');

// ❌ Avoid: XPath (fragile)
await page.click('//div[@class="container"]/form/div[2]/button');
```

### Element Selection Patterns

```javascript
// Button by text
await page.click('button:has-text("Submit")');

// Input by label
await page.fill('input[name="email"]', 'user@example.com');

// List items
const items = await page.$$eval('.list-item', els =>
  els.map(el => el.textContent)
);

// Form elements
await page.selectOption('#country', 'US');
await page.check('#agree-terms');
await page.uncheck('#newsletter');

// Waiting for elements
await page.waitForSelector('.loaded', { state: 'visible' });
await page.waitForSelector('.deleted', { state: 'hidden' });
```

---

## Handling Test Data

### Test Data Strategies

```markdown
**1. Static Fixtures**
- JSON/YAML files
- Good for consistent data
- Easy to maintain

**2. Dynamic Generation**
- Faker library
- Unique data per test
- Avoids conflicts

**3. Database Seeding**
- Pre-populated test data
- Realistic scenarios
- Controlled state

**4. API-driven**
- Create via API calls
- Clean after tests
- Fast setup
```

### Data Generation

```javascript
const { faker } = require('@faker-js/faker');

// Generate random user
function generateUser() {
  return {
    name: faker.person.fullName(),
    email: faker.internet.email(),
    phone: faker.phone.number(),
    address: {
      street: faker.location.streetAddress(),
      city: faker.location.city(),
      zip: faker.location.zipCode()
    }
  };
}

// Generate unique email
function generateUniqueEmail() {
  return `test-${Date.now()}-${Math.random().toString(36).substr(2, 9)}@test.com`;
}

// Use in tests
test('creates user with generated data', async ({ request }) => {
  const user = generateUser();
  const response = await request.post('/api/users', { data: user });

  expect(response.status()).toBe(201);
  expect((await response.json()).email).toBe(user.email);
});
```

### Test Data Cleanup

```javascript
// Cleanup after tests
test.afterEach(async ({ page }) => {
  // Clear browser storage
  await page.context().clearCookies();
  await page.evaluate(() => localStorage.clear());
});

// Database cleanup
test.afterAll(async () => {
  await db.users.deleteMany({ email: { contains: 'test-' } });
});

// API cleanup
async function cleanupTestData(testId) {
  await api.delete(`/test-data/${testId}`);
}
```

---

## Managing Test Environment

### Environment Configuration

```javascript
// config/environments.js
const environments = {
  local: {
    baseUrl: 'http://localhost:3000',
    apiUrl: 'http://localhost:3001/api',
    db: {
      host: 'localhost',
      port: 5432,
      name: 'app_test'
    }
  },
  staging: {
    baseUrl: 'https://staging.example.com',
    apiUrl: 'https://api-staging.example.com',
    db: {
      host: 'staging-db.example.com',
      port: 5432,
      name: 'app_staging'
    }
  }
};

const env = process.env.TEST_ENV || 'local';
module.exports = environments[env];
```

### Environment Variables

```bash
# .env.test
TEST_ENV=staging
BASE_URL=https://staging.example.com
API_TOKEN=test-token-123
DB_HOST=localhost
DB_PORT=5432

# Don't commit real credentials!
# Use CI/CD secrets for sensitive data
```

### Docker for Test Environment

```yaml
# docker-compose.test.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=test
      - DATABASE_URL=postgres://test:test@db:5432/app_test

  db:
    image: postgres:14
    environment:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: app_test
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    ports:
      - "6379:6379"
```

---

## Writing Maintainable Tests

### DRY Principle (Don't Repeat Yourself)

```javascript
// ❌ Bad: Duplicated code
test('test 1', async ({ page }) => {
  await page.goto('/login');
  await page.fill('#email', 'user@test.com');
  await page.fill('#password', 'pass123');
  await page.click('#login');
  await page.waitForSelector('.dashboard');
});

test('test 2', async ({ page }) => {
  await page.goto('/login');
  await page.fill('#email', 'admin@test.com');
  await page.fill('#password', 'admin123');
  await page.click('#login');
  await page.waitForSelector('.dashboard');
});

// ✅ Good: Extracted helper
async function login(page, email, password) {
  await page.goto('/login');
  await page.fill('#email', email);
  await page.fill('#password', password);
  await page.click('#login');
  await page.waitForSelector('.dashboard');
}

test('test 1', async ({ page }) => {
  await login(page, 'user@test.com', 'pass123');
});

test('test 2', async ({ page }) => {
  await login(page, 'admin@test.com', 'admin123');
});
```

### Custom Assertions

```javascript
// utils/assertions.js
async function expectElementVisible(page, selector, timeout = 5000) {
  const element = await page.waitForSelector(selector, {
    state: 'visible',
    timeout
  });
  return element;
}

async function expectTextContains(page, selector, expectedText) {
  const text = await page.textContent(selector);
  if (!text.includes(expectedText)) {
    throw new Error(
      `Expected "${text}" to contain "${expectedText}"`
    );
  }
}

// Usage in tests
test('dashboard loads', async ({ page }) => {
  await expectElementVisible(page, '.dashboard');
  await expectTextContains(page, '.welcome', 'Welcome back');
});
```

### Test Helper Classes

```javascript
// helpers/TestHelper.js
class TestHelper {
  constructor(page) {
    this.page = page;
  }

  async login(email, password) {
    await this.page.goto('/login');
    await this.page.fill('#email', email);
    await this.page.fill('#password', password);
    await this.page.click('#login-button');
    await this.page.waitForURL('**/dashboard');
  }

  async logout() {
    await this.page.click('.user-menu');
    await this.page.click('[data-testid="logout"]');
  }

  async createItem(item) {
    await this.page.click('[data-testid="create-button"]');
    await this.page.fill('#name', item.name);
    await this.page.fill('#description', item.description);
    await this.page.click('[data-testid="save-button"]');
    await this.page.waitForSelector('.success-message');
  }

  async waitForApiCall(urlPattern) {
    return this.page.waitForResponse(
      response => response.url().includes(urlPattern)
    );
  }
}

module.exports = TestHelper;
```

---

## Performance Optimization

### Parallel Execution

```javascript
// playwright.config.js
module.exports = defineConfig({
  fullyParallel: true,
  workers: process.env.CI ? 4 : undefined,
  retries: process.env.CI ? 2 : 0
});
```

### Test Sharding

```yaml
# GitHub Actions matrix strategy
strategy:
  matrix:
    shard: [1, 2, 3, 4]

steps:
  - name: Run tests
    run: npx playwright test --shard=${{ matrix.shard }}/4
```

### Optimize Test Setup

```javascript
// ❌ Slow: Setup per test
test.beforeEach(async ({ page }) => {
  await page.goto('/login');
  await page.fill('#email', 'user@test.com');
  await page.fill('#password', 'pass123');
  await page.click('#login');
});

// ✅ Fast: Setup once for describe block
test.describe('Dashboard', () => {
  test.beforeAll(async ({ browser }) => {
    const page = await browser.newPage();
    await login(page, 'user@test.com', 'pass123');
    await page.context().storageState({ path: 'auth.json' });
  });

  test('shows stats', async ({ page }) => {
    // Uses saved authentication state
  });
});
```

### Reduce Test Flakiness

```javascript
// ❌ Flaky: Race condition
test('submit form', async ({ page }) => {
  await page.click('#submit');
  expect(await page.textContent('.result')).toBe('Success');
});

// ✅ Stable: Proper wait
test('submit form', async ({ page }) => {
  await page.click('#submit');
  await page.waitForSelector('.result');
  expect(await page.textContent('.result')).toBe('Success');
});

// ✅ Better: Use auto-waiting assertions
test('submit form', async ({ page }) => {
  await page.click('#submit');
  await expect(page.locator('.result')).toHaveText('Success');
});
```

---

## Debugging and Troubleshooting

### Debugging Techniques

```javascript
// 1. Console logging
test('debug test', async ({ page }) => {
  const element = await page.$('#my-element');
  console.log('Element HTML:', await element.innerHTML());
});

// 2. Screenshots on failure
test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    await page.screenshot({
      path: `screenshots/${testInfo.title}.png`
    });
  }
});

// 3. Trace recording
// playwright.config.js
module.exports = defineConfig({
  use: {
    trace: 'on-first-retry'
  }
});

// 4. Pause for manual inspection
test('debug interactively', async ({ page }) => {
  await page.goto('/');
  await page.pause(); // Opens Playwright Inspector
});
```

### Common Issues and Solutions

```markdown
| Issue | Cause | Solution |
|-------|-------|----------|
| Test passes locally, fails in CI | Environment differences | Match CI environment |
| Element not found | Timing issue | Add explicit wait |
| Flaky test | Race condition | Use proper synchronization |
| Slow tests | Too much setup | Optimize test setup |
| False negatives | Wrong assertion | Verify test logic |
| Database state | Shared data | Clean up after tests |
```

### Logging Best Practices

```javascript
// Test logging
test('user creation', async ({ page }) => {
  const email = generateEmail();
  console.log(`Creating user with email: ${email}`);

  await createUser(page, email);

  const user = await getUser(email);
  console.log('Created user:', JSON.stringify(user, null, 2));

  expect(user.email).toBe(email);
});

// Custom reporter logging
class Logger {
  static info(message) {
    console.log(`[INFO] ${new Date().toISOString()}: ${message}`);
  }

  static error(message, error) {
    console.error(`[ERROR] ${new Date().toISOString()}: ${message}`);
    if (error) console.error(error);
  }
}
```

---

## Team Collaboration

### Test Code Review Checklist

```markdown
**Test Quality**:
- [ ] Tests are independent
- [ ] Clear, descriptive test names
- [ ] Proper setup and teardown
- [ ] Appropriate assertions
- [ ] No hardcoded values

**Code Quality**:
- [ ] DRY principle followed
- [ ] Page objects used
- [ ] Helpers extracted
- [ ] Proper error handling
- [ ] Comments where needed

**Maintainability**:
- [ ] Easy to understand
- [ ] Easy to modify
- [ ] Proper documentation
- [ ] Consistent patterns
- [ ] No test smells
```

### Documentation

```markdown
# Test Automation README

## Getting Started
1. Install dependencies: `npm install`
2. Install browsers: `npx playwright install`
3. Run tests: `npm test`

## Writing Tests
- Use Page Object Model
- Follow AAA pattern
- Use data-testid selectors
- Keep tests independent

## Test Structure
- `/tests/e2e` - End-to-end tests
- `/tests/api` - API tests
- `/pages` - Page objects
- `/fixtures` - Test data
- `/helpers` - Utility functions

## CI/CD
Tests run automatically on:
- Pull requests
- Push to main
- Daily at 2 AM

## Debugging
- Use Playwright Inspector
- Check screenshots in reports
- Review trace files
```

### Code Standards

```markdown
# Test Code Standards

## Naming Conventions
- Test files: `*.spec.js` or `*.test.js`
- Page objects: `*Page.js`
- Helpers: `*Helper.js`
- Fixtures: `*.json`

## File Organization
- One page object per file
- Related tests in same directory
- Shared helpers in `/helpers`
- Test data in `/fixtures`

## Code Style
- Use async/await
- Prefer data-testid selectors
- Extract common operations
- Write descriptive comments
```

---

## Quick Reference Checklist

### Before Writing Tests
- [ ] Understand the requirements
- [ ] Identify test scenarios
- [ ] Plan test data
- [ ] Choose appropriate test type
- [ ] Design page objects if E2E

### While Writing Tests
- [ ] Follow AAA pattern
- [ ] Use descriptive names
- [ ] Keep tests independent
- [ ] Handle async properly
- [ ] Add proper waits

### After Writing Tests
- [ ] Run locally
- [ ] Check for flakiness
- [ ] Verify in CI/CD
- [ ] Document if complex
- [ ] Review with team

### Test Maintenance
- [ ] Fix flaky tests immediately
- [ ] Update tests with code changes
- [ ] Remove obsolete tests
- [ ] Refactor when needed
- [ ] Monitor test health
