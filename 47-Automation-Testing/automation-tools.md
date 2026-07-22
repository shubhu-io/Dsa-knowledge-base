# Automation Tools: Complete Reference

## Table of Contents

1. [Tool Categories](#tool-categories)
2. [E2E Testing Tools](#e2e-testing-tools)
3. [API Testing Tools](#api-testing-tools)
4. [Performance Testing Tools](#performance-testing-tools)
5. [Visual Testing Tools](#visual-testing-tools)
6. [Mobile Testing Tools](#mobile-testing-tools)
7. [Code Coverage Tools](#code-coverage-tools)
8. [Mocking Tools](#mocking-tools)
9. [CI/CD Integration Tools](#cicd-integration-tools)
10. [Tool Selection Matrix](#tool-selection-matrix)

---

## Tool Categories

```
┌─────────────────────────────────────────────────────────────┐
│                    Testing Tool Categories                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  E2E Testing          → Playwright, Cypress, Selenium        │
│  API Testing          → Postman, REST Assured, Supertest     │
│  Performance          → k6, Artillery, JMeter, Locust        │
│  Visual Regression    → Percy, Applitools, BackstopJS        │
│  Mobile               → Appium, Detox, Espresso, XCUITest    │
│  Code Coverage        → Istanbul, JaCoCo, Coverage.py        │
│  Mocking              → Jest mocks, MSW, WireMock            │
│  Test Management      → TestRail, Zephyr, qTest              │
│  Bug Tracking         → Jira, Bugzilla, GitHub Issues        │
│  CI/CD                → GitHub Actions, Jenkins, GitLab CI    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## E2E Testing Tools

### Playwright

**Best for**: Modern web applications, multi-browser testing

```bash
# Installation
npm install @playwright/test
npx playwright install
```

**Strengths**:
- Auto-wait and intelligent assertions
- Network interception
- Multi-browser support (Chromium, Firefox, WebKit)
- Trace viewer for debugging
- Parallel execution built-in

**Example**:
```javascript
const { test, expect } = require('@playwright/test');

test('search functionality', async ({ page }) => {
  await page.goto('/');
  await page.fill('[data-testid="search"]', 'test query');
  await page.keyboard.press('Enter');
  await expect(page.locator('.search-results')).toBeVisible();
});
```

### Cypress

**Best for**: Frontend developers, modern JavaScript apps

```bash
# Installation
npm install cypress
npx cypress open
```

**Strengths**:
- Time travel debugging
- Real-time reloads
- Automatic waiting
- Network stubbing
- Dashboard service

**Example**:
```javascript
describe('Search', () => {
  it('returns results', () => {
    cy.visit('/');
    cy.get('[data-testid="search"]').type('test query');
    cy.get('[data-testid="search-button"]').click();
    cy.get('.search-results').should('be.visible');
  });
});
```

### Selenium WebDriver

**Best for**: Enterprise applications, multi-language teams

```bash
# Installation (Java)
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.15.0</version>
</dependency>
```

**Strengths**:
- Multi-language support (Java, Python, C#, JS)
- Wide browser support
- Large ecosystem
- Grid for parallel execution
- Industry standard

**Example (Python)**:
```python
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("http://localhost:3000")

search = driver.find_element(By.ID, "search")
search.send_keys("test query")
search.submit()

results = driver.find_element(By.CLASS_NAME, "search-results")
assert results.is_displayed()

driver.quit()
```

### Puppeteer

**Best for**: Chrome-specific testing, performance auditing

```bash
# Installation
npm install puppeteer
```

**Strengths**:
- Chrome DevTools Protocol
- High performance
- Screenshot and PDF generation
- Network interception
- Lighthouse integration

**Example**:
```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.goto('http://localhost:3000');
  await page.type('#search', 'test query');
  await page.keyboard.press('Enter');

  const results = await page.$('.search-results');
  const isVisible = await results.isIntersectingViewport();

  await browser.close();
})();
```

### TestCafe

**Best for**: Quick setup, no WebDriver dependencies

```bash
# Installation
npm install testcafe
```

**Strengths**:
- No WebDriver/ChromeDriver needed
- Built-in assertion library
- Multi-browser testing
- Live mode for development
- Automatic waiting

**Example**:
```javascript
import { Selector } from 'testcafe';

fixture`Search`.page`http://localhost:3000`;

test('returns results', async t => {
  await t
    .typeText('#search', 'test query')
    .click('#search-button')
    .expect(Selector('.search-results').visible).ok();
});
```

---

## API Testing Tools

### Postman

**Best for**: API exploration, manual testing, team collaboration

**Strengths**:
- Visual interface
- Collection runner
- Environment variables
- Pre-request scripts
- Newman CLI for automation

**Example (Newman)**:
```bash
# Run collection
newman run collection.json -e environment.json

# With reporters
newman run collection.json -r html,json
```

### REST Assured (Java)

**Best for**: Java teams, BDD-style API tests

**Example**:
```java
import io.restassured.RestAssured;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class ApiTest {
    @Test
    public void testGetUsers() {
        given()
            .baseUri("http://localhost:3000")
            .header("Authorization", "Bearer " + token)
        .when()
            .get("/api/users")
        .then()
            .statusCode(200)
            .body("data.size()", greaterThan(0));
    }
}
```

### Supertest (Node.js)

**Best for**: Express/Node.js application testing

```javascript
const request = require('supertest');
const app = require('../app');

describe('Users API', () => {
  it('GET /api/users returns users', async () => {
    const res = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);

    expect(res.body.data).toHaveLength(10);
  });

  it('POST /api/users creates user', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({
        name: 'Test User',
        email: 'test@example.com'
      })
      .expect(201);

    expect(res.body).toHaveProperty('id');
  });
});
```

### Axios + Jest

**Best for**: Custom API test suites

```javascript
const axios = require('axios');

const api = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: {
    Authorization: `Bearer ${process.env.API_TOKEN}`
  }
});

describe('Users API', () => {
  it('fetches users', async () => {
    const response = await api.get('/users');
    expect(response.status).toBe(200);
    expect(Array.isArray(response.data)).toBe(true);
  });

  it('handles errors', async () => {
    try {
      await api.get('/nonexistent');
    } catch (error) {
      expect(error.response.status).toBe(404);
    }
  });
});
```

### Karate (Java)

**Best for**: BDD-style API testing, non-programmers

```gherkin
Feature: Users API

  Background:
    * url 'http://localhost:3000/api'
    * def token = call read('login.feature')

  Scenario: Get all users
    Given path '/users'
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And match response.data[*].id == '#present'

  Scenario: Create user
    Given path '/users'
    And header Authorization = 'Bearer ' + token
    And request { name: 'Test', email: 'test@test.com' }
    When method POST
    Then status 201
    And match response.id == '#present'
```

---

## Performance Testing Tools

### k6 (Grafana)

**Best for**: Developer-friendly load testing

```bash
# Installation
brew install k6  # macOS
choco install k6  # Windows
```

**Example Script**:
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '2m', target: 0 }
  ],
  thresholds: {
    http_req_duration: ['p(95)<300'],
    http_req_failed: ['rate<0.01']
  }
};

export default function () {
  const res = http.get('http://test-api.com/users');

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 300ms': (r) => r.timings.duration < 300,
    'has data': (r) => JSON.parse(r.body).length > 0
  });

  sleep(1);
}
```

### Artillery

**Best for**: Easy-to-write load tests, YAML configuration

```yaml
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
  defaults:
    headers:
      Authorization: "Bearer {{ $processEnvironment.API_TOKEN }}"

scenarios:
  - name: "Browse products"
    flow:
      - get:
          url: "/api/products"
      - think: 2
      - get:
          url: "/api/products/1"

  - name: "User login"
    flow:
      - post:
          url: "/api/auth/login"
          json:
            email: "load@test.com"
            password: "password123"
```

### JMeter

**Best for**: Enterprise load testing, protocol testing

**Features**:
- GUI-based test creation
- Multiple protocol support
- Distributed testing
- Extensive plugin ecosystem
- Detailed reporting

### Locust

**Best for**: Python-based load testing, custom scenarios

```python
from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 3)

    @task
    def get_users(self):
        self.client.get("/api/users")

    @task(3)
    def view_product(self):
        self.client.get("/api/products/1")

    @task(2)
    def search(self):
        self.client.get("/api/search?q=test")

    def on_start(self):
        response = self.client.post("/api/auth/login", json={
            "email": "test@test.com",
            "password": "password123"
        })
        self.token = response.json()["token"]
        self.client.headers.update({
            "Authorization": f"Bearer {self.token}"
        })
```

---

## Visual Testing Tools

### Percy (BrowserStack)

**Best for**: Enterprise visual testing, CI/CD integration

```javascript
// Playwright integration
const percySnapshot = require('@percy/playwright');

test('homepage visual test', async ({ page }) => {
  await page.goto('/');
  await percySnapshot(page, 'Homepage');
});

// Responsive testing
test('responsive test', async ({ page }) => {
  await page.goto('/');
  await percySnapshot(page, 'Homepage', {
    widths: [320, 768, 1280]
  });
});
```

### Applitools

**Best for**: AI-powered visual testing, cross-browser

```javascript
const { test, expect } = require('@applitools/eyes-playwright');

test('visual test', async ({ eyes, page }) => {
  await page.goto('/');
  await eyes.check('Homepage', Target.window().fully());
});
```

### BackstopJS

**Best for**: Open-source visual regression testing

```javascript
// backstop.json
module.exports = {
  id: "my_project",
  viewports: [
    { label: "phone", width: 375, height: 667 },
    { label: "tablet", width: 768, height: 1024 },
    { label: "desktop", width: 1280, height: 800 }
  ],
  scenarios: [
    {
      label: "Homepage",
      url: "http://localhost:3000/",
      referenceUrl: "https://staging.example.com/",
      selectors: ["document"]
    }
  ],
  paths: {
    bitmaps_reference: "backstop_data/bitmaps_reference",
    bitmaps_test: "backstop_data/bitmaps_test",
    html_report: "backstop_data/html_report"
  }
};
```

### Loki

**Best for**: Storybook visual testing

```javascript
// .loki/config.json
{
  "chromeSelector": "#storybook-root",
  "variants": {
    "Desktop 1280": {
      "viewport": [1280, 720]
    },
    "Mobile 320": {
      "viewport": [320, 568]
    }
  }
}
```

---

## Mobile Testing Tools

### Appium

**Best for**: Cross-platform mobile testing

```javascript
const wdio = require('webdriverio');

const opts = {
  path: '/wd/hub',
  port: 4723,
  capabilities: {
    platformName: 'Android',
    automationName: 'UiAutomator2',
    deviceName: 'emulator-5554',
    app: '/path/to/app.apk'
  }
};

describe('Mobile App', () => {
  let client;

  before(async () => {
    client = await wdio.remote(opts);
  });

  it('logs in successfully', async () => {
    const emailInput = await client.$('#email');
    await emailInput.setValue('user@test.com');

    const passwordInput = await client.$('#password');
    await passwordInput.setValue('password123');

    const loginButton = await client.$('#login');
    await loginButton.click();

    const dashboard = await client.$('#dashboard');
    expect(await dashboard.isDisplayed()).toBe(true);
  });

  after(async () => {
    await client.deleteSession();
  });
});
```

### Detox (React Native)

**Best for**: React Native applications

```javascript
describe('Login Screen', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show login screen', async () => {
    await expect(element(by.id('login-screen'))).toBeVisible();
  });

  it('should login successfully', async () => {
    await element(by.id('email-input')).typeText('user@test.com');
    await element(by.id('password-input')).typeText('password123');
    await element(by.id('login-button')).tap();

    await expect(element(by.id('dashboard-screen'))).toBeVisible();
  });
});
```

### Espresso (Android)

**Best for**: Native Android applications

```java
@RunWith(AndroidJUnit4.class)
public class LoginTest {

    @Rule
    public ActivityScenarioRule<LoginActivity> activityRule =
        new ActivityScenarioRule<>(LoginActivity.class);

    @Test
    public void loginSuccess() {
        onView(withId(R.id.email))
            .perform(typeText("user@test.com"), closeSoftKeyboard());
        onView(withId(R.id.password))
            .perform(typeText("password123"), closeSoftKeyboard());
        onView(withId(R.id.login_button)).perform(click());

        onView(withId(R.id.dashboard)).check(matches(isDisplayed()));
    }
}
```

### XCUITest (iOS)

**Best for**: Native iOS applications

```swift
func testLoginSuccess() {
    let emailTextField = app.textFields["email"]
    emailTextField.tap()
    emailTextField.typeText("user@test.com")

    let passwordTextField = app.secureTextFields["password"]
    passwordTextField.tap()
    passwordTextField.typeText("password123")

    app.buttons["Login"].tap()

    XCTAssertTrue(app.otherElements["dashboard"].waitForExistence(timeout: 5))
}
```

---

## Code Coverage Tools

### Istanbul (nyc)

**Best for**: JavaScript code coverage

```bash
# Installation
npm install --save-dev nyc

# Run with coverage
npx nyc npm test

# Coverage report
npx nyc report --reporter=html
```

**Configuration**:
```json
// .nycrc
{
  "all": true,
  "check-coverage": true,
  "branches": 80,
  "functions": 80,
  "lines": 80,
  "include": ["src/**/*.js"],
  "exclude": ["tests/**"],
  "reporter": ["text", "html", "lcov"],
  "report-dir": "coverage"
}
```

### JaCoCo (Java)

**Best for**: Java code coverage

```xml
<!-- pom.xml -->
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.11</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

### Coverage.py (Python)

**Best for**: Python code coverage

```bash
# Installation
pip install coverage

# Run with coverage
coverage run -m pytest

# Generate report
coverage report
coverage html
```

---

## Mocking Tools

### Jest Mocks

**Best for**: Unit testing with Jest

```javascript
// Mock function
const mockFn = jest.fn();
mockFn.mockReturnValue(42);
expect(mockFn()).toBe(42);

// Mock module
jest.mock('./api');
const api = require('./api');
api.getUsers.mockResolvedValue([{ id: 1 }]);

// Spy
const spy = jest.spyOn(console, 'log');
console.log('test');
expect(spy).toHaveBeenCalledWith('test');
```

### Mock Service Worker (MSW)

**Best for**: API mocking in tests and development

```javascript
import { setupServer } from 'msw/node';
import { rest } from 'msw';

const server = setupServer(
  rest.get('/api/users', (req, res, ctx) => {
    return res(
      ctx.json([
        { id: 1, name: 'User 1' },
        { id: 2, name: 'User 2' }
      ])
    );
  }),
  rest.post('/api/users', (req, res, ctx) => {
    return res(ctx.json({ id: 3, ...req.body }));
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

### WireMock

**Best for**: API stubbing and mocking

```java
stubFor(get(urlEqualTo("/api/users"))
    .withHeader("Accept", containing("application/json"))
    .willReturn(aResponse()
        .withStatus(200)
        .withHeader("Content-Type", "application/json")
        .withBody("[{\"id\": 1, \"name\": \"User 1\"}]")));
```

### Nock (Node.js)

**Best for**: HTTP request mocking

```javascript
const nock = require('nock');

nock('http://api.example.com')
  .get('/users')
  .reply(200, [
    { id: 1, name: 'User 1' }
  ]);

// Test
const users = await api.getUsers();
expect(users).toHaveLength(1);
```

---

## CI/CD Integration Tools

### GitHub Actions

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
      - run: npm ci
      - run: npm test
      - uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results
          path: reports/
```

### Jenkins

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
            post {
                always {
                    junit 'reports/**/*.xml'
                    publishHTML([
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
    }
}
```

### GitLab CI

```yaml
test:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm test
  artifacts:
    reports:
      junit: report.xml
      coverage: '/Lines\\s*:\\s*(\\d+\\.?\\d*)%/'
  coverage: '/Lines\\s*:\\s*(\\d+\\.?\\d*)%/'
```

---

## Tool Selection Matrix

### By Project Type

| Project Type | E2E | API | Performance | Visual | Mobile |
|-------------|-----|-----|-------------|--------|--------|
| React/Vue SPA | Playwright/Cypress | Supertest | k6 | Percy | Detox |
| Node.js API | Supertest | Jest/Supertest | Artillery | - | - |
| Java Enterprise | Selenium | REST Assured | JMeter | Applitools | Espresso |
| Python Django | Playwright | pytest | Locust | - | - |
| React Native | Detox | Supertest | - | - | Detox |
| iOS Native | XCUITest | - | - | - | XCUITest |
| Android Native | Espresso | - | - | - | Espresso |

### By Team Size

| Team Size | Recommended Stack |
|-----------|-------------------|
| Solo Developer | Playwright + Jest |
| Small Team (2-5) | Playwright + Supertest + k6 |
| Medium Team (5-20) | Playwright + REST Assured + JMeter |
| Enterprise (20+) | Selenium Grid + Postman + JMeter + TestRail |

### By Budget

| Budget | Tools |
|--------|-------|
| Free | Playwright, Cypress, Jest, k6, BackstopJS |
| Low ($100-500/mo) | Postman Pro, Percy |
| Medium ($500-2000/mo) | Applitools, BrowserStack |
| Enterprise (2000+/mo) | Sauce Labs, TestRail, qTest |

---

## Quick Reference

### Tool Installation Commands

```bash
# E2E Testing
npm install @playwright/test
npm install cypress
npm install selenium-webdriver
npm install puppeteer
npm install testcafe

# API Testing
npm install supertest
npm install axios
pip install requests
brew install newman  # Postman CLI

# Performance
brew install k6
npm install -g artillery
brew install locust

# Coverage
npm install --save-dev nyc
pip install coverage
```

### Common Commands

```bash
# Playwright
npx playwright test
npx playwright test --headed
npx playwright show-report

# Cypress
npx cypress run
npx cypress open

# k6
k6 run script.js
k6 cloud script.js

# Artillery
artillery run load-test.yml
artillery report report.json
```
