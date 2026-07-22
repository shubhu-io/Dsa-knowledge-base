# Automation Frameworks: Comprehensive Guide

## Table of Contents

1. [Framework Overview](#framework-overview)
2. [Playwright](#playwright)
3. [Cypress](#cypress)
4. [Selenium](#selenium)
5. [Puppeteer](#puppeteer)
6. [TestCafe](#testcafe)
7. [Framework Comparison](#framework-comparison)
8. [Choosing the Right Framework](#choosing-the-right-framework)
9. [Custom Framework Design](#custom-framework-design)
10. [Migration Strategies](#migration-strategies)

---

## Framework Overview

### Types of Automation Frameworks

```
┌─────────────────────────────────────────────────────────────┐
│                  Automation Framework Types                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Linear Framework (Record & Playback)                     │
│     └── Simple but hard to maintain                          │
│                                                              │
│  2. Modular Driven Framework                                  │
│     └── Test scripts split into modules                      │
│                                                              │
│  3. Data-Driven Framework                                     │
│     └── Test data stored externally                          │
│                                                              │
│  4. Keyword-Driven Framework                                  │
│     └── Tests written as keywords/actions                    │
│                                                              │
│  5. Page Object Model Framework                               │
│     └── UI elements encapsulated in page objects              │
│                                                              │
│  6. Hybrid Framework                                          │
│     └── Combination of multiple approaches                   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Framework Selection Criteria

| Criterion | Questions to Ask |
|-----------|------------------|
| Application Type | Web, mobile, API, or desktop? |
| Team Skills | JavaScript, Java, Python expertise? |
| Testing Needs | E2E, API, visual, performance? |
| CI/CD Integration | Which tools are already in use? |
| Browser Support | Which browsers need testing? |
| Community Support | Documentation, plugins, community? |
| Cost | Open source or commercial? |

---

## Playwright

### Overview
Playwright is Microsoft's modern E2E testing framework for web applications.

### Key Features
- Multi-browser support (Chromium, Firefox, WebKit)
- Auto-wait and intelligent assertions
- Network interception
- Mobile emulation
- Parallel execution built-in
- Trace viewer for debugging

### Setup

```bash
# Create project
npm init -y
npm install @playwright/test
npx playwright install

# Project structure
mkdir -p tests/{e2e,api,visual} pages fixtures
```

### Basic Example

```javascript
// tests/example.spec.js
const { test, expect } = require('@playwright/test');

test('homepage loads correctly', async ({ page }) => {
  await page.goto('https://example.com');

  await expect(page).toHaveTitle(/Example/);
  await expect(page.locator('h1')).toContainText('Welcome');
  await expect(page.locator('.content')).toBeVisible();
});

test('form submission', async ({ page }) => {
  await page.goto('/contact');

  await page.fill('#name', 'John Doe');
  await page.fill('#email', 'john@example.com');
  await page.fill('#message', 'Hello World');
  await page.click('button[type="submit"]');

  await expect(page.locator('.success-message'))
    .toContainText('Thank you');
});
```

### Advanced Features

```javascript
// Network interception
test('mock API response', async ({ page }) => {
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 200,
      body: JSON.stringify([
        { id: 1, name: 'Mock User' }
      ])
    });
  });

  await page.goto('/users');
  await expect(page.locator('.user-name'))
    .toContainText('Mock User');
});

// Mobile testing
test('mobile viewport', async ({ browser }) => {
  const context = await browser.newContext({
    viewport: { width: 375, height: 812 },
    userAgent: 'iPhone',
    isMobile: true
  });
  const page = await context.newPage();

  await page.goto('/');
  await expect(page.locator('.mobile-menu')).toBeVisible();
});

// File upload
test('file upload', async ({ page }) => {
  await page.goto('/upload');

  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.click('#upload-button');
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles('fixtures/test-file.txt');

  await expect(page.locator('.upload-success')).toBeVisible();
});
```

### Configuration

```javascript
// playwright.config.js
const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 30000,
  expect: {
    timeout: 5000
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['json', { outputFile: 'test-results.json' }],
    ['junit', { outputFile: 'test-results.xml' }]
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000
  },
  projects: [
    {
      name: 'setup',
      testMatch: /.*\.setup\.js/
    },
    {
      name: 'chromium',
      use: {
        browserName: 'chromium',
        storageState: 'auth.json'
      },
      dependencies: ['setup']
    },
    {
      name: 'firefox',
      use: {
        browserName: 'firefox',
        storageState: 'auth.json'
      },
      dependencies: ['setup']
    },
    {
      name: 'webkit',
      use: {
        browserName: 'webkit',
        storageState: 'auth.json'
      },
      dependencies: ['setup']
    },
    {
      name: 'mobile-chrome',
      use: {
        ...devices['Pixel 5']
      },
      dependencies: ['setup']
    },
    {
      name: 'mobile-safari',
      use: {
        ...devices['iPhone 13']
      },
      dependencies: ['setup']
    }
  ]
});
```

---

## Cypress

### Overview
Cypress is a JavaScript-based end-to-end testing framework built for modern web applications.

### Key Features
- Time travel debugging
- Automatic waiting
- Network traffic control
- Screenshot and video capture
- Real-time reloads
- Dashboard service

### Setup

```bash
npm install cypress
npx cypress open
```

### Basic Example

```javascript
// cypress/e2e/login.cy.js
describe('Login', () => {
  beforeEach(() => {
    cy.visit('/login');
  });

  it('successful login', () => {
    cy.get('#email').type('user@example.com');
    cy.get('#password').type('password123');
    cy.get('button[type="submit"]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Welcome');
  });

  it('invalid credentials', () => {
    cy.get('#email').type('wrong@example.com');
    cy.get('#password').type('wrongpass');
    cy.get('button[type="submit"]').click();

    cy.get('.error-message')
      .should('be.visible')
      .and('contain', 'Invalid credentials');
  });
});
```

### Advanced Features

```javascript
// Custom commands
// cypress/support/commands.js
Cypress.Commands.add('login', (email, password) => {
  cy.session([email, password], () => {
    cy.visit('/login');
    cy.get('#email').type(email);
    cy.get('#password').type(password);
    cy.get('button[type="submit"]').click();
    cy.url().should('include', '/dashboard');
  });
});

// API testing
cy.request('POST', '/api/login', {
  email: 'user@example.com',
  password: 'password123'
}).then((response) => {
  expect(response.status).to.eq(200);
  expect(response.body).to.have.property('token');
});

// Intercepts
cy.intercept('GET', '/api/users', {
  fixture: 'users.json'
}).as('getUsers');

cy.visit('/users');
cy.wait('@getUsers');
```

### Cypress Configuration

```javascript
// cypress.config.js
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    supportFile: 'cypress/support/e2e.js',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
    retries: {
      runMode: 2,
      openMode: 0
    },
    env: {
      apiUrl: 'http://localhost:3001/api'
    }
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'webpack'
    }
  }
});
```

---

## Selenium

### Overview
Selenium is the industry standard for browser automation with support for multiple programming languages.

### Key Features
- Multi-language support (Java, Python, C#, JavaScript)
- Wide browser support
- WebDriver protocol
- Large ecosystem
- Grid support for parallel execution

### Setup (JavaScript)

```bash
npm install selenium-webdriver
npm install chromedriver
```

### Basic Example

```javascript
const { Builder, By, until } = require('selenium-webdriver');

describe('Login Test', function () {
  let driver;

  before(async function () {
    driver = await new Builder().forBrowser('chrome').build();
  });

  after(async function () {
    await driver.quit();
  });

  it('successful login', async function () {
    await driver.get('http://localhost:3000/login');

    await driver.findElement(By.id('email'))
      .sendKeys('user@example.com');
    await driver.findElement(By.id('password'))
      .sendKeys('password123');
    await driver.findElement(By.id('login-button')).click();

    await driver.wait(
      until.urlContains('/dashboard'),
      5000
    );

    const welcomeText = await driver.findElement(
      By.css('.welcome-message')
    ).getText();

    expect(welcomeText).to.contain('Welcome');
  });
});
```

### Page Object with Selenium

```javascript
// pages/LoginPage.js
const { By } = require('selenium-webdriver');

class LoginPage {
  constructor(driver) {
    this.driver = driver;
    this.emailInput = By.id('email');
    this.passwordInput = By.id('password');
    this.loginButton = By.id('login-button');
    this.errorMessage = By.css('.error-message');
  }

  async goto(url) {
    await this.driver.get(url);
  }

  async login(email, password) {
    await this.driver.findElement(this.emailInput).sendKeys(email);
    await this.driver.findElement(this.passwordInput).sendKeys(password);
    await this.driver.findElement(this.loginButton).click();
  }

  async getErrorMessage() {
    return await this.driver.findElement(this.errorMessage).getText();
  }
}

module.exports = LoginPage;
```

### Selenium Grid Setup

```yaml
# docker-compose.yml
version: '3'
services:
  selenium-hub:
    image: selenium/hub:latest
    ports:
      - "4442:4442"
      - "4443:4443"
      - "4444:4444"

  chrome:
    image: selenium/node-chrome:latest
    depends_on:
      - selenium-hub
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443

  firefox:
    image: selenium/node-firefox:latest
    depends_on:
      - selenium-hub
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
```

---

## Puppeteer

### Overview
Puppeteer is a Node.js library for controlling Chrome/Chromium browsers.

### Key Features
- Chrome DevTools Protocol
- High performance
- Screenshot and PDF generation
- Network interception
- Mobile emulation

### Setup

```bash
npm install puppeteer
```

### Basic Example

```javascript
const puppeteer = require('puppeteer');

describe('Puppeteer Tests', () => {
  let browser;
  let page;

  before(async () => {
    browser = await puppeteer.launch({
      headless: 'new'
    });
    page = await browser.newPage();
  });

  after(async () => {
    await browser.close();
  });

  it('homepage loads', async () => {
    await page.goto('http://localhost:3000');

    const title = await page.title();
    expect(title).to.contain('Example');

    const h1 = await page.$eval('h1', el => el.textContent);
    expect(h1).to.equal('Welcome');
  });

  it('form submission', async () => {
    await page.goto('http://localhost:3000/contact');

    await page.type('#name', 'John Doe');
    await page.type('#email', 'john@example.com');
    await page.click('button[type="submit"]');

    await page.waitForSelector('.success-message');
    const message = await page.$eval(
      '.success-message',
      el => el.textContent
    );
    expect(message).to.contain('Thank you');
  });
});
```

### Advanced Puppeteer

```javascript
// Screenshot comparison
const pixelmatch = require('pixelmatch');
const { PNG } = require('pngjs');

async function compareScreenshots(page, name) {
  const screenshot = await page.screenshot({ fullPage: true });
  const current = PNG.sync.read(screenshot);

  const baseline = PNG.sync.read(
    fs.readFileSync(`baselines/${name}.png`)
  );

  const diff = new PNG({
    width: current.width,
    height: current.height
  });

  const numDiffPixels = pixelmatch(
    current.data, baseline.data, diff.data,
    current.width, current.height,
    { threshold: 0.1 }
  );

  return numDiffPixels === 0;
}

// Network interception
await page.setRequestInterception(true);
page.on('request', (req) => {
  if (req.resourceType() === 'image') {
    req.abort();
  } else {
    req.continue();
  }
});
```

---

## TestCafe

### Overview
TestCafe is a Node.js tool for testing web apps without WebDriver or browser plugins.

### Key Features
- No WebDriver/ChromeDriver needed
- Automatic waiting
- Built-in assertion library
- Multi-browser testing
- Live mode for development

### Setup

```bash
npm install testcafe
```

### Basic Example

```javascript
// tests/login.test.js
import { Selector } from 'testcafe';

fixture`Login Page`
  .page`http://localhost:3000/login`;

test('successful login', async t => {
  await t
    .typeText('#email', 'user@example.com')
    .typeText('#password', 'password123')
    .click('#login-button')
    .expect(Selector('.welcome-message').innerText)
    .contains('Welcome');
});

test('invalid credentials', async t => {
  await t
    .typeText('#email', 'wrong@example.com')
    .typeText('#password', 'wrongpass')
    .click('#login-button')
    .expect(Selector('.error-message').innerText)
    .contains('Invalid credentials');
});
```

### Advanced TestCafe

```javascript
// Page Model
class LoginPage {
  constructor() {
    this.emailInput = Selector('#email');
    this.passwordInput = Selector('#password');
    this.loginButton = Selector('#login-button');
    this.errorMessage = Selector('.error-message');
  }

  async login(t, email, password) {
    await t
      .typeText(this.emailInput, email)
      .typeText(this.passwordInput, password)
      .click(this.loginButton);
  }
}

fixture`Login`
  .page`http://localhost:3000/login`;

const loginPage = new LoginPage();

test('login with page model', async t => {
  await loginPage.login(t, 'user@example.com', 'password123');
  await t.expect(getLocation()).contains('/dashboard');
});

// Hooks
fixture`My Fixture`
  .page`http://localhost:3000`
  .beforeEach(async t => {
    await t.maximizeWindow();
  })
  .afterEach(async t => {
    await clearBrowserLocalStorage();
  });
```

---

## Framework Comparison

### Feature Matrix

| Feature | Playwright | Cypress | Selenium | Puppeteer | TestCafe |
|---------|-----------|---------|----------|-----------|----------|
| **Languages** | JS/TS | JS/TS | Multi | JS | JS/TS |
| **Browsers** | 3 | 3 | All | Chrome | All |
| **Speed** | Fast | Fast | Moderate | Fast | Fast |
| **Auto-wait** | Yes | Yes | No | Partial | Yes |
| **Debugging** | Excellent | Excellent | Good | Good | Good |
| **API Testing** | Yes | Yes | No | Yes | No |
| **Mobile** | Yes | Limited | Yes | Limited | No |
| **Parallel** | Yes | Paid | Yes | Yes | Yes |
| **iFrames** | Yes | Limited | Yes | Yes | Yes |
| **Multi-tab** | Yes | No | Yes | Yes | No |
| **Community** | Growing | Large | Largest | Large | Medium |
| **Dashboard** | Yes | Paid | No | No | No |

### Performance Comparison

```
Test Execution Speed (approximate):

Playwright   ████████████████████ Fastest
Cypress      ████████████████     Fast
Puppeteer    ████████████████     Fast
TestCafe     ████████████         Moderate
Selenium     ████████             Moderate
```

### Use Case Recommendations

| Use Case | Recommended Framework |
|----------|----------------------|
| Modern web apps | Playwright or Cypress |
| Enterprise apps | Selenium |
| Chrome extensions | Puppeteer |
| No WebDriver setup | TestCafe |
| API + E2E testing | Playwright |
| Visual regression | Playwright or Cypress |
| Cross-browser | Selenium or Playwright |
| Quick prototypes | Cypress or TestCafe |

---

## Choosing the Right Framework

### Decision Tree

```
Start Here
    │
    ├─► Need cross-browser support?
    │   ├─► Yes → Selenium or Playwright
    │   └─► No
    │       │
    │       ├─► Need API testing?
    │       │   ├─► Yes → Playwright
    │       │   └─► No
    │       │       │
    │       │       ├─► Team prefers Cypress?
    │       │       │   └─► Yes → Cypress
    │       │       │
    │       │       ├─► Need Chrome-specific?
    │       │       │   └─► Yes → Puppeteer
    │       │       │
    │       │       └─► Want easy setup?
    │       │           └─► Yes → Cypress or TestCafe
    │       │
    │       └─► Multi-language team?
    │           └─► Yes → Selenium
```

### Migration Considerations

```markdown
**Selenium → Playwright**:
- Rewrite selectors (usually similar)
- Replace explicit waits with auto-wait
- Update configuration
- Learn new debugging tools

**Cypress → Playwright**:
- Similar API, easier migration
- Update custom commands
- Replace cy.intercept with page.route
- Update assertions

**Puppeteer → Playwright**:
- Similar API
- Add multi-browser support
- Update configuration
- Use built-in assertions
```

---

## Custom Framework Design

### Building Your Own Framework

```javascript
// core/BaseTest.js
class BaseTest {
  constructor() {
    this.page = null;
    this.context = null;
    this.browser = null;
  }

  async setup() {
    this.browser = await chromium.launch();
    this.context = await this.browser.newContext();
    this.page = await this.context.newPage();
  }

  async teardown() {
    if (this.browser) {
      await this.browser.close();
    }
  }

  async screenshot(name) {
    await this.page.screenshot({
      path: `screenshots/${name}.png`,
      fullPage: true
    });
  }
}

// core/TestRunner.js
class TestRunner {
  constructor(config) {
    this.config = config;
    this.results = [];
  }

  async run(suite) {
    for (const test of suite.tests) {
      const testInstance = new suite.testClass();
      await testInstance.setup();

      try {
        await test.fn.call(testInstance);
        this.results.push({ name: test.name, status: 'passed' });
      } catch (error) {
        this.results.push({
          name: test.name,
          status: 'failed',
          error: error.message
        });
      }

      await testInstance.teardown();
    }

    return this.results;
  }
}

module.exports = { BaseTest, TestRunner };
```

### Framework Template

```
automation-framework/
├── core/
│   ├── BaseTest.js
│   ├── TestRunner.js
│   ├── Reporter.js
│   └── Utils.js
├── pages/
│   ├── BasePage.js
│   └── LoginPage.js
├── components/
│   ├── HeaderComponent.js
│   └── FooterComponent.js
├── helpers/
│   ├── ApiHelper.js
│   ├── DbHelper.js
│   └── DataGenerator.js
├── config/
│   ├── default.config.js
│   └── environments/
├── fixtures/
│   └── data/
├── tests/
│   ├── e2e/
│   ├── api/
│   └── visual/
├── reports/
└── package.json
```

---

## Migration Strategies

### Common Migration Paths

| From | To | Difficulty | Effort |
|------|-----|------------|--------|
| Selenium | Playwright | Medium | 2-4 weeks |
| Cypress | Playwright | Easy | 1-2 weeks |
| Puppeteer | Playwright | Easy | 1 week |
| Manual | Any | Hard | 4-8 weeks |
| TestCafe | Playwright | Medium | 2-3 weeks |

### Migration Checklist

```markdown
**Phase 1: Planning**
- [ ] Audit existing tests
- [ ] Identify common patterns
- [ ] Choose target framework
- [ ] Create migration timeline

**Phase 2: Setup**
- [ ] Install new framework
- [ ] Configure CI/CD
- [ ] Set up test environment
- [ ] Create base classes

**Phase 3: Migration**
- [ ] Migrate page objects
- [ ] Migrate test utilities
- [ ] Migrate tests (priority order)
- [ ] Verify all tests pass

**Phase 4: Validation**
- [ ] Run parallel execution
- [ ] Compare test results
- [ ] Performance benchmarking
- [ ] Team training

**Phase 5: Cleanup**
- [ ] Remove old framework
- [ ] Update documentation
- [ ] Archive old tests
- [ ] Final review
```

### Parallel Running Strategy

```javascript
// During migration, run both frameworks
// package.json
{
  "scripts": {
    "test:legacy": "cypress run",
    "test:new": "playwright test",
    "test:migration": "npm run test:legacy && npm run test:new"
  }
}

// Compare results
const legacyResults = require('./legacy-results.json');
const newResults = require('./new-results.json');

function compareResults(legacy, newTests) {
  const legacyPassed = new Set(
    legacy.tests.filter(t => t.status === 'passed').map(t => t.name)
  );
  const newPassed = new Set(
    newTests.tests.filter(t => t.status === 'passed').map(t => t.name)
  );

  const missing = [...legacyPassed].filter(x => !newPassed.has(x));
  const added = [...newPassed].filter(x => !legacyPassed.has(x));

  return { missing, added };
}
```

---

## Quick Reference

### Framework Selection Guide

```
Need multi-browser + API testing? → Playwright
Need fastest setup + debugging? → Cypress
Need multi-language support? → Selenium
Need Chrome-only + performance? → Puppeteer
Need zero WebDriver setup? → TestCafe
Building custom framework? → Use Playwright as base
```

### Key Commands

```bash
# Playwright
npx playwright test
npx playwright test --headed
npx playwright test --ui

# Cypress
npx cypress run
npx cypress open
npx cypress run --browser firefox

# Selenium
npm test

# Puppeteer
node tests/example.js

# TestCafe
npx testcafe chrome tests/
npx testcafe "chrome:headless" tests/
```
