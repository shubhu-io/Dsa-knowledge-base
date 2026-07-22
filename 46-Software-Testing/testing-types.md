# Testing Types: Complete Reference

## Table of Contents

1. [Functional Testing](#functional-testing)
2. [Non-Functional Testing](#non-functional-testing)
3. [Black-Box Testing](#black-box-testing)
4. [White-Box Testing](#white-box-testing)
5. [Performance Testing](#performance-testing)
6. [Security Testing](#security-testing)
7. [Mobile Testing](#mobile-testing)
8. [Database Testing](#database-testing)
9. [API Testing](#api-testing)
10. [Accessibility Testing](#accessibility-testing)

---

## Functional Testing

### What It Is

Functional testing validates that each function of the software operates in conformance with the requirement specification.

### Types of Functional Testing

#### 1. Unit Testing
```javascript
// Testing individual components in isolation
describe('Calculator.multiply', () => {
  it('should return product of two numbers', () => {
    expect(calc.multiply(3, 4)).toBe(12);
  });

  it('should return zero when multiplied by zero', () => {
    expect(calc.multiply(5, 0)).toBe(0);
  });
});
```

#### 2. Integration Testing
```javascript
// Testing interaction between components
describe('UserRegistration', () => {
  it('should create user and send welcome email', async () => {
    const user = await registerUser({
      name: 'John',
      email: 'john@example.com'
    });

    expect(user.id).toBeDefined();
    expect(mockEmailService.send).toHaveBeenCalledWith(
      expect.objectContaining({
        to: 'john@example.com',
        template: 'welcome'
      })
    );
  });
});
```

#### 3. System Testing
```markdown
**Test Scenario**: Complete e-commerce checkout flow

**Steps**:
1. Add items to cart
2. Proceed to checkout
3. Enter shipping information
4. Select payment method
5. Complete purchase
6. Verify order confirmation email
7. Check inventory update
8. Verify payment processing
```

#### 4. Regression Testing
```javascript
// Re-running tests after changes to ensure nothing broke
describe('Regression: Bug #1234', () => {
  it('should handle null values in user preferences', () => {
    const result = parsePreferences(null);
    expect(result).toEqual(defaultPreferences);
  });

  it('should not crash when API returns empty response', async () => {
    mockApi.get.mockResolvedValue(null);
    const data = await fetchData();
    expect(data).toEqual([]);
  });
});
```

#### 5. Smoke Testing
```bash
# Quick verification that critical paths work
npm run test:smoke

# Smoke test suite (run first in CI)
describe('Smoke Tests', () => {
  test('application starts', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
  });

  test('database connection works', async () => {
    await expect(db.ping()).resolves.not.toThrow();
  });

  test('user can login', async () => {
    const res = await request(app)
      .post('/login')
      .send({ email: 'test@test.com', password: 'pass123' });
    expect(res.status).toBe(200);
  });
});
```

#### 6. Sanity Testing
```markdown
**Sanity Test Checklist**:
- [ ] Login works
- [ ] Dashboard loads
- [ ] Create new record
- [ ] Edit existing record
- [ ] Delete record
- [ ] Search functionality
- [ ] Export data
- [ ] Settings save correctly
```

#### 7. Acceptance Testing
```gherkin
Feature: Order Management
  Scenario: Customer places an order
    Given I have items in my cart
    When I complete the checkout process
    Then I should receive an order confirmation
    And my payment should be processed
    And the items should be reserved
```

---

## Non-Functional Testing

### Types of Non-Functional Testing

#### 1. Performance Testing
```javascript
// k6 load test example
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 },  // Ramp up
    { duration: '5m', target: 100 },  // Stay at 100 users
    { duration: '2m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<300'],  // 95% under 300ms
    http_req_failed: ['rate<0.01'],    // Less than 1% errors
  },
};

export default function () {
  const res = http.get('http://test-api.com/users');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  sleep(1);
}
```

#### 2. Load Testing
```bash
# Artillery load test config
# load-test.yml
config:
  target: "http://localhost:3000"
  phases:
    - duration: 60
      arrivalRate: 10
      name: "Warm up"
    - duration: 120
      arrivalRate: 50
      name: "Sustained load"
    - duration: 60
      arrivalRate: 100
      name: "Peak load"

scenarios:
  - name: "User browsing"
    flow:
      - get:
          url: "/products"
      - think: 2
      - get:
          url: "/products/1"
```

#### 3. Stress Testing
```javascript
// Finding the breaking point
const stressTest = {
  stages: [
    { duration: '1m', target: 50 },
    { duration: '1m', target: 100 },
    { duration: '1m', target: 200 },
    { duration: '1m', target: 400 },
    { duration: '1m', target: 800 },
    { duration: '2m', target: 1000 },  // Push to limits
    { duration: '1m', target: 500 },
    { duration: '1m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(99)<1000'],
    http_req_failed: ['rate<0.05'],
  },
};
```

#### 4. Security Testing
```bash
# OWASP ZAP scan example
docker run -t owasp/zap2docker-stable zap-baseline.py \
  -t http://localhost:3000 \
  -r security-report.html

# Security checklist:
# - SQL injection
# - XSS vulnerabilities
# - CSRF protection
# - Authentication bypass
# - Session management
# - Data encryption
```

#### 5. Usability Testing
```markdown
**Usability Test Script**:

**Task 1**: Complete user registration
- Time to complete: ____
- Errors encountered: ____
- User satisfaction (1-5): ____

**Task 2**: Find and purchase a product
- Time to complete: ____
- Errors encountered: ____
- User satisfaction (1-5): ____

**Observations**:
- Did the user hesitate at any point?
- Which steps caused confusion?
- What improvements would help?
```

#### 6. Compatibility Testing
```markdown
**Browser Compatibility Matrix**:

| Browser | Version | OS | Status |
|---------|---------|-----|--------|
| Chrome | Latest | Windows 11 | ✓ |
| Chrome | Latest | macOS | ✓ |
| Firefox | Latest | Windows 11 | ✓ |
| Safari | Latest | macOS | ✓ |
| Edge | Latest | Windows 11 | ✓ |

**Mobile Compatibility**:
| Device | OS | Browser | Status |
|--------|-----|---------|--------|
| iPhone 14 | iOS 16 | Safari | ✓ |
| Samsung S23 | Android 13 | Chrome | ✓ |
| iPad Pro | iPadOS 16 | Safari | ✓ |
```

---

## Black-Box Testing

### Techniques

#### 1. Equivalence Partitioning
```markdown
**Input**: Age (valid range: 18-65)

**Partitions**:
- Valid: 18-65 (test with 30)
- Invalid: <18 (test with 10)
- Invalid: >65 (test with 70)
- Boundary: 18, 65

**Test Cases**:
1. age = 10 → Invalid
2. age = 18 → Valid
3. age = 30 → Valid
4. age = 65 → Valid
5. age = 70 → Invalid
```

#### 2. Boundary Value Analysis
```javascript
// Test boundaries of valid input range
describe('Age validation (18-65)', () => {
  const testCases = [
    { input: 17, expected: false, desc: 'below minimum' },
    { input: 18, expected: true, desc: 'at minimum' },
    { input: 19, expected: true, desc: 'above minimum' },
    { input: 32, expected: true, desc: 'middle value' },
    { input: 64, expected: true, desc: 'below maximum' },
    { input: 65, expected: true, desc: 'at maximum' },
    { input: 66, expected: false, desc: 'above maximum' },
  ];

  testCases.forEach(({ input, expected, desc }) => {
    test(`${desc}: ${input}`, () => {
      expect(validateAge(input)).toBe(expected);
    });
  });
});
```

#### 3. Decision Table Testing
```markdown
**Rules for Login**:

| Condition | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
|-----------|--------|--------|--------|--------|
| Valid email | Y | Y | N | N |
| Valid password | Y | N | Y | N |
| **Action** | | | | |
| Login success | ✓ | ✗ | ✗ | ✗ |
| Error: invalid email | | | ✓ | ✓ |
| Error: wrong password | | ✓ | | |
```

#### 4. State Transition Testing
```markdown
**Order States**:

```
[Created] → [Paid] → [Shipped] → [Delivered]
    ↓         ↓         ↓
[Cancelled] [Refunded] [Returned]
```

**Test Transitions**:
1. Created → Paid (valid)
2. Paid → Shipped (valid)
3. Shipped → Delivered (valid)
4. Created → Shipped (invalid)
5. Delivered → Created (invalid)
```

#### 5. Use Case Testing
```markdown
**Use Case: User makes a purchase**

**Main Flow**:
1. User browses products → Show product list
2. User adds item to cart → Cart updated
3. User proceeds to checkout → Show checkout form
4. User enters payment info → Validate payment
5. User confirms order → Order created

**Alternative Flows**:
- 2a: Cart is empty → Show "cart empty" message
- 4a: Payment fails → Show error, retry option
- 4b: Invalid card → Show validation error

**Exception Flows**:
- E1: Server error → Show generic error
- E2: Session timeout → Redirect to login
```

---

## White-Box Testing

### Techniques

#### 1. Statement Coverage
```javascript
// Aim: Execute every line of code at least once
function getDiscount(amount) {
  let discount = 0;           // Line 1
  if (amount > 100) {        // Line 2
    discount = 10;            // Line 3
  } else if (amount > 50) {  // Line 4
    discount = 5;             // Line 5
  }                          // Line 6
  return discount;            // Line 7
}

// Test cases for 100% statement coverage:
// Test 1: amount = 150 → Lines 1,2,3,7
// Test 2: amount = 75 → Lines 1,2,4,5,7
// Test 3: amount = 25 → Lines 1,2,4,6,7
```

#### 2. Branch Coverage
```javascript
// Aim: Test both true and false branches
describe('getDiscount branch coverage', () => {
  test('amount > 100 (true branch)', () => {
    expect(getDiscount(150)).toBe(10);
  });

  test('amount <= 100, > 50 (false, true)', () => {
    expect(getDiscount(75)).toBe(5);
  });

  test('amount <= 50 (false, false)', () => {
    expect(getDiscount(25)).toBe(0);
  });
});
```

#### 3. Path Coverage
```javascript
// Test all possible execution paths
function processOrder(order) {
  if (!order) return null;                    // Path 1
  if (order.items.length === 0) return null;  // Path 2
  if (order.paymentFailed) {                  // Path 3
    if (order.retryCount < 3) {
      return retryPayment(order);             // Path 4
    }
    return cancelOrder(order);                // Path 5
  }
  return completeOrder(order);                // Path 6
}

// Path coverage tests:
// Path 1: processOrder(null)
// Path 2: processOrder({ items: [] })
// Path 3a: processOrder({ paymentFailed: false })
// Path 4: processOrder({ paymentFailed: true, retryCount: 1 })
// Path 5: processOrder({ paymentFailed: true, retryCount: 3 })
```

---

## Performance Testing

### Metrics to Track

| Metric | Description | Target |
|--------|-------------|--------|
| Response Time | Time to complete a request | < 200ms |
| Throughput | Requests per second | Varies |
| Error Rate | Percentage of failed requests | < 1% |
| Latency (p95) | 95th percentile response time | < 500ms |
| CPU Usage | Processor utilization | < 80% |
| Memory Usage | RAM utilization | < 80% |

### Performance Test Types

```markdown
| Test Type | Purpose | Duration | Users |
|-----------|---------|----------|-------|
| Load Test | Expected load | 15-60 min | Normal traffic |
| Stress Test | Find breaking point | 30-60 min | Beyond normal |
| Spike Test | Sudden traffic spikes | 5-15 min | 10x normal |
| Endurance Test | Long-term stability | 2-24 hours | Normal traffic |
| Scalability Test | Measure scaling | Variable | Increasing |
```

---

## Security Testing

### OWASP Top 10 Checklist

```markdown
**A01: Broken Access Control**
- [ ] Users can't access other users' data
- [ ] Admin functions require admin role
- [ ] CORS is properly configured

**A02: Cryptographic Failures**
- [ ] Passwords are hashed (bcrypt/scrypt)
- [ ] Sensitive data is encrypted at rest
- [ ] TLS is enforced for all connections

**A03: Injection**
- [ ] SQL queries use parameterized queries
- [ ] User input is sanitized
- [ ] No eval() with user input

**A04: Insecure Design**
- [ ] Threat modeling performed
- [ ] Rate limiting implemented
- [ ] Input validation on all endpoints

**A05: Security Misconfiguration**
- [ ] Default credentials changed
- [ ] Error messages don't leak info
- [ ] Security headers configured

**A06: Vulnerable Components**
- [ ] Dependencies regularly updated
- [ ] No known CVEs in dependencies
- [ ] Security scanning in CI/CD

**A07: Authentication Failures**
- [ ] Multi-factor auth available
- [ ] Password requirements enforced
- [ ] Session management secure

**A08: Software/Data Integrity**
- [ ] Signed dependencies
- [ ] CI/CD pipeline secured
- [ ] Deserialization is safe

**A09: Logging/Monitoring**
- [ ] Security events logged
- [ ] Logs are tamper-proof
- [ ] Monitoring alerts configured

**A10: SSRF**
- [ ] URL validation implemented
- [ ] Internal network access restricted
- [ ] Allowlist for external requests
```

---

## Mobile Testing

### Key Considerations

```markdown
**Device Diversity**:
- Different screen sizes
- Various OS versions
- Hardware limitations
- Network conditions

**Test Scenarios**:
1. App installation and uninstallation
2. Background/foreground transitions
3. Incoming call during app use
4. Low battery behavior
5. Network switching (WiFi ↔ Cellular)
6. Offline mode functionality
7. Push notification handling
8. Deep linking
9. Camera/gallery integration
10. GPS/location services
```

### Mobile Test Automation

```javascript
// Appium test example (pseudo-code)
describe('Mobile Login', () => {
  it('should login successfully', async () => {
    const emailField = await driver.$('~email-input');
    await emailField.setValue('user@example.com');

    const passwordField = await driver.$('~password-input');
    await passwordField.setValue('password123');

    const loginButton = await driver.$('~login-button');
    await loginButton.click();

    const dashboard = await driver.$('~dashboard');
    await expect(dashboard).toBeDisplayed();
  });
});
```

---

## Database Testing

### Test Categories

```markdown
**Schema Testing**:
- Table structure matches specification
- Column types are correct
- Indexes exist for performance
- Foreign keys are properly set

**CRUD Testing**:
- Create: Insert works correctly
- Read: Queries return expected data
- Update: Modifications persist
- Delete: Removal is clean

**Data Integrity Testing**:
- Constraints are enforced
- Transactions maintain consistency
- Rollbacks work correctly
- Null handling is proper

**Performance Testing**:
- Query execution time acceptable
- Indexes are being used
- No N+1 query problems
- Connection pooling works
```

### Database Test Example

```sql
-- Test: Verify user constraints
-- Should fail due to NOT NULL constraint
INSERT INTO users (email) VALUES (NULL);

-- Should fail due to UNIQUE constraint
INSERT INTO users (email, name) VALUES ('test@test.com', 'User 1');
INSERT INTO users (email, name) VALUES ('test@test.com', 'User 2');

-- Test: Foreign key constraint
-- Should fail if role_id doesn't exist
INSERT INTO users (email, name, role_id)
VALUES ('test@test.com', 'User', 9999);
```

---

## API Testing

### REST API Test Examples

```javascript
// Complete API test suite
describe('Users API', () => {
  describe('GET /api/users', () => {
    it('returns paginated users', async () => {
      const res = await request(app)
        .get('/api/users?page=1&limit=10')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveLength(10);
      expect(res.body.pagination).toEqual({
        page: 1,
        limit: 10,
        total: expect.any(Number)
      });
    });

    it('requires authentication', async () => {
      const res = await request(app).get('/api/users');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/users', () => {
    it('creates a new user', async () => {
      const res = await request(app)
        .post('/api/users')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({
          name: 'New User',
          email: 'new@example.com',
          role: 'user'
        });

      expect(res.status).toBe(201);
      expect(res.body).toHaveProperty('id');
      expect(res.body.name).toBe('New User');
    });

    it('validates required fields', async () => {
      const res = await request(app)
        .post('/api/users')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ name: 'No Email' });

      expect(res.status).toBe(400);
      expect(res.body.errors).toContainEqual(
        expect.objectContaining({ field: 'email' })
      );
    });
  });
});
```

### GraphQL API Testing

```javascript
describe('GraphQL Users Query', () => {
  it('fetches users with specific fields', async () => {
    const query = `
      query GetUsers {
        users(limit: 5) {
          id
          name
          email
          posts {
            title
          }
        }
      }
    `;

    const res = await request(app)
      .post('/graphql')
      .send({ query });

    expect(res.status).toBe(200);
    expect(res.body.data.users).toHaveLength(5);
    expect(res.body.data.users[0]).toHaveProperty('posts');
  });
});
```

---

## Accessibility Testing

### WCAG 2.1 Checklist

```markdown
**Perceivable**:
- [ ] Images have alt text
- [ ] Color contrast ratio ≥ 4.5:1
- [ ] Text can be resized to 200%
- [ ] Content is available when zoomed

**Operable**:
- [ ] All functionality available via keyboard
- [ ] No keyboard traps
- [ ] Skip navigation link present
- [ ] Focus order is logical

**Understandable**:
- [ ] Language of page is specified
- [ ] Form labels are associated
- [ ] Error messages are descriptive
- [ ] Consistent navigation

**Robust**:
- [ ] Valid HTML markup
- [ ] ARIA landmarks used
- [ ] Custom components have ARIA roles
- [ ] Works with screen readers
```

### Automated Accessibility Testing

```javascript
// jest-axe for automated accessibility testing
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('Login Form Accessibility', () => {
  it('should have no accessibility violations', async () => {
    const { container } = render(<LoginForm />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('all form inputs have associated labels', () => {
    render(<LoginForm />);
    const inputs = screen.getAllByRole('textbox');
    inputs.forEach(input => {
      expect(input).toHaveAccessibleName();
    });
  });
});
```

### Manual Accessibility Testing Tools

```markdown
**Screen Readers**:
- NVDA (Windows, free)
- VoiceOver (macOS, built-in)
- JAWS (Windows, commercial)

**Browser Extensions**:
- axe DevTools
- WAVE
- Lighthouse
- Accessibility Insights

**Keyboard Testing**:
1. Tab through all interactive elements
2. Verify focus is visible
3. Test Enter/Space on buttons
4. Test Escape to close modals
5. Verify no keyboard traps
```

---

## Quick Reference Matrix

| Testing Type | When to Use | Tools | Automation Level |
|-------------|-------------|-------|------------------|
| Unit | Development | Jest, Mocha | High |
| Integration | After unit tests | Supertest, Cypress | High |
| E2E | Before release | Cypress, Playwright | Medium |
| Performance | Pre-production | k6, Artillery | High |
| Security | Regular intervals | OWASP ZAP, Snyk | Medium |
| Accessibility | Every sprint | axe, WAVE | Medium |
| Usability | Design phase | User testing | Low |
| Compatibility | Release | BrowserStack | Medium |
