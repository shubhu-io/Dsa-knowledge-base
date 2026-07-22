# Testing Strategies: Building Effective Test Suites

## Table of Contents

1. [Strategy Overview](#strategy-overview)
2. [Test Pyramid in Practice](#test-pyramid-in-practice)
3. [Test Organization](#test-organization)
4. [Mocking Strategies](#mocking-strategies)
4. [Testing Data-Intensive Applications](#testing-data-intensive-applications)
5. [Testing Microservices](#testing-microservices)
6. [Testing in CI/CD](#testing-in-cicd)
7. [Regression Testing Strategies](#regression-testing-strategies)
8. [Contract Testing](#contract-testing)
9. [Chaos Engineering](#chaos-engineering)
10. [Testing Debt Management](#testing-debt-management)

---

## Strategy Overview

### Choosing the Right Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                   Testing Strategy Decision                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. What are we testing?                                     │
│     ├── Business logic → Unit tests                          │
│     ├── Integration points → Integration tests               │
│     ├── User workflows → E2E tests                           │
│     └── Non-functional → Performance/Security tests          │
│                                                              │
│  2. What's the risk level?                                   │
│     ├── High risk → More thorough testing                    │
│     ├── Medium risk → Standard test coverage                 │
│     └── Low risk → Minimal tests                             │
│                                                              │
│  3. What's the testing cost?                                 │
│     ├── Cheap → Write more tests                             │
│     ├── Moderate → Balance cost vs value                     │
│     └── Expensive → Test critical paths only                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Strategy Components

```markdown
**1. Test Types Mix**:
- Unit: 70%
- Integration: 20%
- E2E: 10%

**2. Coverage Goals**:
- Critical paths: 100%
- Business logic: 90%+
- Utility functions: 95%+
- Overall: 80%+

**3. Test Speed Targets**:
- Unit tests: < 100ms each
- Integration tests: < 1s each
- E2E tests: < 10s each
- Full suite: < 5 minutes
```

---

## Test Pyramid in Practice

### Real-World Example: E-Commerce Application

```
                    ┌─────────────┐
                    │    E2E      │  5 tests
                    │  Checkout   │  User flows
                    │  Flow       │
                    ├─────────────┤
                    │ Integration │  30 tests
                    │   API +     │  Service interactions
                    │  Database   │
                    ├─────────────┤
                    │    Unit     │  200 tests
                    │  Business   │  Pure functions
                    │   Logic     │
                    └─────────────┘
```

### Layer Responsibilities

```javascript
// UNIT TEST - Pure business logic
describe('calculateDiscount', () => {
  test('applies percentage discount', () => {
    expect(calculateDiscount(100, { type: 'percent', value: 10 }))
      .toBe(90);
  });

  test('applies fixed discount', () => {
    expect(calculateDiscount(100, { type: 'fixed', value: 25 }))
      .toBe(75);
  });

  test('does not go below zero', () => {
    expect(calculateDiscount(10, { type: 'fixed', value: 25 }))
      .toBe(0);
  });
});

// INTEGRATION TEST - Service + Database interaction
describe('OrderService.createOrder', () => {
  test('creates order and updates inventory', async () => {
    const order = await orderService.createOrder({
      userId: 1,
      items: [{ productId: 101, quantity: 2 }]
    });

    expect(order.id).toBeDefined();
    expect(order.status).toBe('pending');

    const inventory = await inventoryService.get(101);
    expect(inventory.quantity).toBe(8); // Was 10, ordered 2
  });
});

// E2E TEST - Complete user workflow
describe('Checkout Flow', () => {
  test('user completes purchase', async () => {
    // Add to cart
    await page.click('[data-product="101"]');
    await page.click('[data-testid="add-to-cart"]');

    // Proceed to checkout
    await page.click('[data-testid="checkout"]');

    // Fill shipping info
    await page.fill('#address', '123 Main St');
    await page.fill('#city', 'Springfield');

    // Complete purchase
    await page.click('[data-testid="complete-purchase"]');

    // Verify
    await expect(page.locator('.confirmation'))
      .toContainText('Thank you for your order');
  });
});
```

---

## Test Organization

### Directory Structure

```
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx        # Co-located tests
│   │   └── Button.stories.tsx
│   └── Modal/
│       ├── Modal.tsx
│       ├── Modal.test.tsx
│       └── Modal.stories.tsx
├── services/
│   ├── api.ts
│   ├── api.test.ts
│   ├── auth.ts
│   └── auth.test.ts
└── utils/
    ├── helpers.ts
    └── helpers.test.ts

tests/
├── integration/
│   ├── api/
│   │   ├── users.test.ts
│   │   └── orders.test.ts
│   └── database/
│       ├── migrations.test.ts
│       └── queries.test.ts
├── e2e/
│   ├── auth/
│   │   ├── login.test.ts
│   │   └── registration.test.ts
│   └── checkout/
│       └── checkout.test.ts
└── fixtures/
    ├── users.json
    └── products.json
```

### Test File Naming Conventions

```markdown
**Naming Patterns**:
- `feature.test.ts` - Unit tests
- `feature.integration.test.ts` - Integration tests
- `feature.e2e.test.ts` - End-to-end tests
- `feature.spec.ts` - Specification tests (BDD)
- `feature.perf.test.ts` - Performance tests
```

### Test Grouping

```javascript
// Group related tests with describe blocks
describe('Authentication', () => {
  describe('Login', () => {
    describe('with valid credentials', () => {
      test('returns JWT token', () => {});
      test('sets secure cookie', () => {});
      test('logs the login event', () => {});
    });

    describe('with invalid credentials', () => {
      test('returns 401 error', () => {});
      test('increments failed login count', () => {});
      test('locks account after 5 failures', () => {});
    });

    describe('with expired account', () => {
      test('returns account disabled error', () => {});
      test('sends reactivation email', () => {});
    });
  });

  describe('Registration', () => {
    // Tests...
  });

  describe('Password Reset', () => {
    // Tests...
  });
});
```

### Test Data Management

```javascript
// Factory pattern for test data
class UserFactory {
  static create(overrides = {}) {
    return {
      id: faker.datatype.uuid(),
      name: faker.name.fullName(),
      email: faker.internet.email(),
      password: 'hashedPassword123',
      role: 'user',
      createdAt: new Date(),
      ...overrides
    };
  }

  static createAdmin() {
    return this.create({ role: 'admin' });
  }

  static createBatch(count) {
    return Array.from({ length: count }, () => this.create());
  }
}

// Fixture files
// tests/fixtures/users.json
{
  "validUser": {
    "name": "Test User",
    "email": "test@example.com",
    "password": "SecurePass123!"
  },
  "adminUser": {
    "name": "Admin User",
    "email": "admin@example.com",
    "password": "AdminPass123!",
    "role": "admin"
  }
}
```

---

## Mocking Strategies

### When to Mock vs When to Use Real Implementations

```markdown
**Mock**:
✓ External APIs (rate limits, cost, reliability)
✓ Time-dependent code
✓ Random number generation
✓ Email/SMS services
✓ Payment gateways (in unit tests)
✓ File system (for unit tests)

**Real Implementation**:
✓ Database (in integration tests)
✓ Internal services (in integration tests)
✓ Utility functions
✓ Data transformations
✓ Configuration
```

### Mocking Patterns

```javascript
// 1. Jest Mock Functions
const mockSendEmail = jest.fn();
emailService.send = mockSendEmail;

test('sends welcome email on registration', async () => {
  await registerUser({ email: 'test@test.com' });

  expect(mockSendEmail).toHaveBeenCalledWith({
    to: 'test@test.com',
    template: 'welcome',
    data: expect.any(Object)
  });
});

// 2. Manual Mocks
// __mocks__/api.js
module.exports = {
  getUsers: jest.fn(),
  getUser: jest.fn(),
  createUser: jest.fn()
};

// In test
const api = require('./api');
api.getUsers.mockResolvedValue([
  { id: 1, name: 'User 1' }
]);

// 3. Spy on existing methods
const spy = jest.spyOn(console, 'log');
expect(spy).toHaveBeenCalledWith('expected message');
spy.mockRestore();

// 4. Mock entire modules
jest.mock('./email-service');
const EmailService = require('./email-service');
EmailService.send.mockResolvedValue(true);
```

### Mock vs Stub vs Fake

```markdown
| Type | Description | Use Case |
|------|-------------|----------|
| Mock | Pre-programmed with expectations | Verify interactions |
| Stub | Returns pre-defined values | Provide test data |
| Fake | Working but simplified implementation | Speed up tests |

**Example**:
```javascript
// Mock - verifies it was called
const mockSend = jest.fn();
sendEmail(mockSend);
expect(mockSend).toHaveBeenCalled();

// Stub - returns fixed value
jest.spyOn(api, 'getUser').mockResolvedValue({ id: 1 });

// Fake - simplified real implementation
class FakeDatabase {
  constructor() { this.store = new Map(); }
  save(entity) { this.store.set(entity.id, entity); }
  findById(id) { return this.store.get(id); }
}
```

---

## Testing Data-Intensive Applications

### Database Testing Strategies

```javascript
// 1. Test Database Setup
beforeAll(async () => {
  await db.migrate.latest();
  await db.seed.run();
});

afterEach(async () => {
  await db('users').truncate();
  await db('orders').truncate();
});

afterAll(async () => {
  await db.destroy();
});

// 2. Transaction Rollback Pattern
describe('User operations', () => {
  let trx;

  beforeEach(async () => {
    trx = await db.transaction();
  });

  afterEach(async () => {
    await trx.rollback();
  });

  test('creates user', async () => {
    await trx('users').insert({
      name: 'Test User',
      email: 'test@test.com'
    });

    const user = await trx('users').where({ email: 'test@test.com' }).first();
    expect(user.name).toBe('Test User');
  });
});
```

### Data Pipeline Testing

```javascript
// Test data transformation pipeline
describe('Data Pipeline', () => {
  const inputData = [
    { name: 'John', age: 25, city: 'NYC' },
    { name: 'Jane', age: 30, city: 'LA' },
    null,  // Invalid entry
    { name: 'Bob', age: -5, city: 'Chicago' }  // Invalid age
  ];

  test('filters and transforms data correctly', () => {
    const result = processPipeline(inputData);

    expect(result).toEqual([
      { name: 'JOHN', age: 25, city: 'NYC', processed: true },
      { name: 'JANE', age: 30, city: 'LA', processed: true }
    ]);

    expect(result).toHaveLength(2);
    expect(result.every(item => item.processed)).toBe(true);
  });

  test('handles empty input', () => {
    expect(processPipeline([])).toEqual([]);
    expect(processPipeline(null)).toEqual([]);
  });

  test('logs invalid entries', () => {
    const logger = jest.spyOn(console, 'warn');
    processPipeline(inputData);

    expect(logger).toHaveBeenCalledWith(
      expect.stringContaining('Invalid entry')
    );
  });
});
```

### Testing with Realistic Data

```javascript
// Generate realistic test data
const generateUsers = (count) => {
  return Array.from({ length: count }, (_, i) => ({
    id: i + 1,
    name: faker.name.fullName(),
    email: faker.internet.email(),
    phone: faker.phone.phoneNumber(),
    address: {
      street: faker.address.streetAddress(),
      city: faker.address.city(),
      state: faker.address.stateAbbr(),
      zip: faker.address.zipCode()
    },
    createdAt: faker.date.past(2),
    preferences: {
      newsletter: faker.datatype.boolean(),
      theme: faker.random.arrayElement(['light', 'dark'])
    }
  }));
};

// Test with different data volumes
describe('User search performance', () => {
  test('handles 100 users', async () => {
    const users = generateUsers(100);
    await seedDatabase(users);

    const results = await searchUsers('John');
    expect(results.length).toBeGreaterThan(0);
  });

  test('handles 10000 users', async () => {
    const users = generateUsers(10000);
    await seedDatabase(users);

    const results = await searchUsers('John');
    expect(results.length).toBeGreaterThan(0);
  });
});
```

---

## Testing Microservices

### Testing Pyramid for Microservices

```
            ┌─────────────────────┐
            │   Contract Tests    │  Service agreements
            ├─────────────────────┤
            │ Integration Tests   │  Service interactions
            ├─────────────────────┤
            │    Unit Tests       │  Business logic
            └─────────────────────┘
```

### Service Integration Testing

```javascript
// Test service-to-service communication
describe('Order Service ↔ Inventory Service', () => {
  test('reserves inventory when order is placed', async () => {
    // Mock inventory service
    const inventoryMock = nock('http://inventory-service')
      .post('/api/inventory/reserve')
      .reply(200, { reserved: true, reservationId: '123' });

    const order = await orderService.createOrder({
      items: [{ productId: 'prod-1', quantity: 2 }]
    });

    expect(order.status).toBe('created');
    expect(inventoryMock.isDone()).toBe(true);
  });

  test('handles inventory service failure', async () => {
    nock('http://inventory-service')
      .post('/api/inventory/reserve')
      .reply(503, { error: 'Service unavailable' });

    await expect(
      orderService.createOrder({
        items: [{ productId: 'prod-1', quantity: 2 }]
      })
    ).rejects.toThrow('Inventory service unavailable');
  });
});
```

### Event-Driven Testing

```javascript
// Test message queue interactions
describe('Order Events', () => {
  test('emits order.created event', async () => {
    const eventSpy = jest.spyOn(eventBus, 'emit');

    await orderService.createOrder({ items: [] });

    expect(eventSpy).toHaveBeenCalledWith('order.created', {
      orderId: expect.any(String),
      items: expect.any(Array),
      timestamp: expect.any(Date)
    });
  });

  test('handles order.completed event', async () => {
    const order = await createTestOrder();

    await eventBus.emit('order.completed', {
      orderId: order.id
    });

    const updatedOrder = await orderService.get(order.id);
    expect(updatedOrder.status).toBe('completed');
  });
});
```

---

## Testing in CI/CD

### Pipeline Configuration

```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:unit
      - run: npm run test:coverage

  integration-tests:
    runs-on: ubuntu-latest
    needs: unit-tests
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
      redis:
        image: redis:7
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run test:integration
        env:
          DATABASE_URL: postgres://postgres:test@localhost:5432/test
          REDIS_URL: redis://localhost:6379

  e2e-tests:
    runs-on: ubuntu-latest
    needs: integration-tests
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npx playwright install
      - run: npm run test:e2e
```

### Test Parallelization

```javascript
// Jest parallel configuration
// jest.config.js
module.exports = {
  // Run tests in parallel
  maxWorkers: '50%',

  // Or use projects for different test types
  projects: [
    {
      displayName: 'unit',
      testMatch: ['<rootDir>/src/**/*.test.js'],
      maxWorkers: 4
    },
    {
      displayName: 'integration',
      testMatch: ['<rootDir>/tests/integration/**/*.test.js'],
      maxWorkers: 2
    }
  ]
};
```

### Test Reporting

```javascript
// Custom test reporter
class CustomReporter {
  onRunComplete(contexts, results) {
    const summary = {
      totalTests: results.numTotalTests,
      passed: results.numPassedTests,
      failed: results.numFailedTests,
      coverage: results.coverageMap,
      duration: results.testResults
        .reduce((sum, t) => sum + t.testFilePath, 0)
    };

    console.log(JSON.stringify(summary, null, 2));

    // Send to monitoring service
    if (process.env.CI) {
      sendToDatadog(summary);
    }
  }
}

module.exports = CustomReporter;
```

---

## Regression Testing Strategies

### Selective Regression Testing

```markdown
**Approach 1: Risk-Based Selection**
- Identify high-risk areas
- Focus tests on changed components
- Test dependent features

**Approach 2: Change-Based Selection**
- Run tests affected by code changes
- Use code coverage to identify impact
- Automated via CI/CD

**Approach 3: Critical Path Testing**
- Maintain list of critical paths
- Run critical tests first
- Full suite for releases
```

### Regression Test Suite

```javascript
// Critical path tests (always run)
// tests/critical-path/
describe('Critical: User Can Purchase', () => {
  test('complete purchase flow', async () => {
    // This test MUST pass before any deployment
    const user = await createUser();
    await login(user);
    await addItemToCart();
    await checkout();
    await verifyOrderConfirmation();
  });
});

// Smoke tests (run on every PR)
// tests/smoke/
describe('Smoke: App Health', () => {
  test('API is responding', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
  });

  test('Database is accessible', async () => {
    await expect(db.raw('SELECT 1')).resolves.toBeDefined();
  });
});
```

### Automated Regression Detection

```bash
# Visual regression testing
npx percy exec -- npx cypress run

# Performance regression testing
npx lighthouse-ci autorun --compare-url=http://staging.example.com

# API regression testing
npx dredd init
npx dredd
```

---

## Contract Testing

### Consumer-Driven Contracts

```javascript
// Consumer side (Order Service)
const { Pact } = require('@pact-foundation/pact');

const provider = new Pact({
  consumer: 'OrderService',
  provider: 'InventoryService',
  port: 1234
});

describe('Inventory API Contract', () => {
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());
  afterEach(() => provider.verify());

  test('gets product inventory', async () => {
    await provider.addInteraction({
      state: 'product exists',
      uponReceiving: 'a request for product inventory',
      withRequest: {
        method: 'GET',
        path: '/api/products/prod-123/inventory'
      },
      willRespondWith: {
        status: 200,
        body: {
          productId: 'prod-123',
          quantity: 50,
          reserved: 5
        }
      }
    });

    const inventory = await inventoryClient.getProduct('prod-123');
    expect(inventory.quantity).toBe(50);
  });
});
```

### Provider Verification

```javascript
// Provider side (Inventory Service)
const { Verifier } = require('@pact-foundation/pact');

describe('Inventory Service Provider', () => {
  test('validates expectations of OrderService', async () => {
    await new Verifier({
      providerBaseUrl: 'http://localhost:3000',
      pactBrokerUrl: 'http://pact-broker:9292',
      provider: 'InventoryService',
      publishVerificationResult: true,
      providerVersion: '1.0.0'
    }).verifyProvider();
  });
});
```

---

## Chaos Engineering

### Testing Resilience

```javascript
// Chaos test configuration
const chaosTests = [
  {
    name: 'Database failure',
    action: async () => {
      await db.pause();
      await delay(5000);
      await db.resume();
    },
    expectedBehavior: 'Graceful degradation'
  },
  {
    name: 'Network latency',
    action: async () => {
      await addLatency('inventory-service', 2000);
    },
    expectedBehavior: 'Timeout handling'
  },
  {
    name: 'Memory pressure',
    action: async () => {
      await consumeMemory('500MB');
    },
    expectedBehavior: 'No crashes, proper cleanup'
  }
];

// Run chaos tests in staging
describe('Chaos Engineering', () => {
  chaosTests.forEach(({ name, action, expectedBehavior }) => {
    test(name, async () => {
      const healthBefore = await checkHealth();

      await action();

      const healthAfter = await checkHealth();
      expect(healthAfter.status).toBe('degraded');
      expect(healthAfter.errors).toContain(expectedBehavior);

      // Recovery
      await delay(10000);
      const healthRecovered = await checkHealth();
      expect(healthRecovered.status).toBe('healthy');
    });
  });
});
```

### Fault Injection

```javascript
// Inject faults at specific points
const faultInjection = {
  // Random 10% failure rate
  randomFailure: (fn, failureRate = 0.1) => {
    return async (...args) => {
      if (Math.random() < failureRate) {
        throw new Error('Injected fault');
      }
      return fn(...args);
    };
  },

  // Delay responses
  addDelay: (fn, minMs = 100, maxMs = 1000) => {
    return async (...args) => {
      const delay = Math.random() * (maxMs - minMs) + minMs;
      await new Promise(resolve => setTimeout(resolve, delay));
      return fn(...args);
    };
  },

  // Simulate partial failure
  partialFailure: (fn, failPercentage = 50) => {
    return async (...args) => {
      if (Math.random() * 100 < failPercentage) {
        throw new Error('Partial failure');
      }
      return fn(...args);
    };
  }
};
```

---

## Testing Debt Management

### Identifying Testing Debt

```markdown
**Signs of Testing Debt**:
1. Flaky tests that fail intermittently
2. Long-running test suites (>10 minutes)
3. Low coverage in critical areas
4. Tests that are never run
5. Manual testing steps
6. Missing tests for new features
7. Tests that break on refactor
8. Inconsistent test patterns
```

### Prioritizing Test Improvements

```markdown
**Priority Matrix**:

| Impact / Effort | Low Effort | High Effort |
|-----------------|------------|-------------|
| **High Impact** | Do First | Plan |
| **Low Impact** | Do When Free | Defer |

**Examples**:
- Fix flaky tests → High Impact, Low Effort → Do First
- Add E2E for critical path → High Impact, High Effort → Plan
- Add edge case unit tests → Low Impact, Low Effort → Do When Free
- Complete 100% coverage → Low Impact, High Effort → Defer
```

### Paying Down Testing Debt

```javascript
// Weekly testing debt sprint
const testingDebtSprint = {
  // Fix one flaky test per day
  fixFlakyTests: {
    frequency: 'daily',
    allocation: '10% of development time'
  },

  // Improve coverage incrementally
  improveCoverage: {
    frequency: 'weekly',
    target: 'Increase by 2% per week',
    focus: 'Critical paths first'
  },

  // Refactor test utilities
  refactorTestUtils: {
    frequency: 'bi-weekly',
    action: 'Extract common patterns into helpers'
  },

  // Review and update tests
  reviewTests: {
    frequency: 'monthly',
    action: 'Remove obsolete tests, update patterns'
  }
};
```

---

## Quick Strategy Checklist

- [ ] Define test types mix (unit/integration/E2E)
- [ ] Set coverage targets for each layer
- [ ] Establish test speed budget
- [ ] Create test data management strategy
- [ ] Define mocking guidelines
- [ ] Set up CI/CD pipeline with test stages
- [ ] Implement contract testing for services
- [ ] Create regression test suite
- [ ] Schedule regular testing debt reduction
- [ ] Monitor test metrics and trends
- [ ] Document testing conventions
- [ ] Train team on testing practices
