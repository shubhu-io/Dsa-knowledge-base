# Mobile Test Automation Guide

This document covers test automation strategies and tools for mobile applications.

## Mobile Testing Types

### Types of Mobile Tests
1. **Unit Tests**: Test individual components/functions
2. **Integration Tests**: Test interactions between components
3. **UI Tests**: Test user interface and interactions
4. **End-to-End Tests**: Test complete user workflows
5. **Performance Tests**: Test app performance under load
6. **Security Tests**: Test for security vulnerabilities

### Testing Platforms
- **iOS**: iPhone, iPad devices
- **Android**: Various manufacturers and screen sizes
- **Cross-platform**: React Native, Flutter, Xamarin

## Testing Frameworks

### Appium (Cross-platform)
```javascript
// Appium test example
const { remote } = require('webdriverio');

const opts = {
  path: '/wd/hub',
  port: 4723,
  capabilities: {
    platformName: 'Android',
    platformVersion: '11',
    deviceName: 'Android Emulator',
    app: '/path/to/app.apk',
    automationName: 'UiAutomator2'
  }
};

describe('Login Test', () => {
  let driver;

  before(async () => {
    driver = await remote(opts);
  });

  it('should login successfully', async () => {
    const emailField = await driver.$('~email');
    await emailField.setValue('user@example.com');

    const passwordField = await driver.$('~password');
    await passwordField.setValue('password123');

    const loginButton = await driver.$('~login');
    await loginButton.click();

    const dashboard = await driver.$('~dashboard');
    await expect(dashboard).toExist();
  });

  after(async () => {
    await driver.deleteSession();
  });
});
```

### Detox (React Native)
```javascript
// detox test example
describe('Login Screen', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show login screen', async () => {
    await expect(element(by.id('loginScreen'))).toBeVisible();
  });

  it('should login successfully', async () => {
    await element(by.id('emailInput')).typeText('user@example.com');
    await element(by.id('passwordInput')).typeText('password123');
    await element(by.id('loginButton')).tap();
    
    await expect(element(by.id('dashboardScreen'))).toBeVisible();
  });
});
```

### Espresso (Android)
```java
// Espresso test example
@RunWith(AndroidJUnit4.class)
public class LoginTest {

    @Rule
    public ActivityScenarioRule<LoginActivity> activityRule =
        new ActivityScenarioRule<>(LoginActivity.class);

    @Test
    public void testLogin() {
        onView(withId(R.id.email))
            .perform(typeText("user@example.com"), closeSoftKeyboard());
        
        onView(withId(R.id.password))
            .perform(typeText("password123"), closeSoftKeyboard());
        
        onView(withId(R.id.loginButton))
            .perform(click());
        
        onView(withId(R.id.dashboard))
            .check(matches(isDisplayed()));
    }
}
```

### XCUITest (iOS)
```swift
// XCUITest example
import XCTest

class LoginTests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testLogin() {
        app.textFields["email"].tap()
        app.textFields["email"].typeText("user@example.com")
        
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("password123")
        
        app.buttons["login"].tap()
        
        XCTAssertTrue(app.tables["dashboard"].exists)
    }
}
```

## Test Data Management

### Test Data Factories
```javascript
// Create test user
const createTestUser = (overrides = {}) => ({
  email: `test${Date.now()}@example.com`,
  password: 'password123',
  name: 'Test User',
  ...overrides
});

// Usage
const user = createTestUser({ role: 'admin' });
```

### Mock Data
```javascript
// Mock API responses
const mockLoginResponse = {
  success: true,
  token: 'mock-jwt-token',
  user: {
    id: 1,
    email: 'user@example.com',
    name: 'Test User'
  }
};
```

### Database Seeding
```javascript
// Seed test database
async function seedTestData() {
  await User.create({
    email: 'test@example.com',
    password: await bcrypt.hash('password123', 10),
    name: 'Test User'
  });
}
```

## Page Object Model

### Page Object Pattern
```javascript
// pages/LoginPage.js
class LoginPage {
  constructor(driver) {
    this.driver = driver;
    this.emailInput = '~email';
    this.passwordInput = '~password';
    this.loginButton = '~login';
  }

  async login(email, password) {
    await this.driver.$(this.emailInput).setValue(email);
    await this.driver.$(this.passwordInput).setValue(password);
    await this.driver.$(this.loginButton).click();
  }

  async isDisplayed() {
    return await this.driver.$(this.loginButton).isDisplayed();
  }
}

// tests/login.test.js
describe('Login', () => {
  let driver;
  let loginPage;

  before(async () => {
    driver = await remote(opts);
    loginPage = new LoginPage(driver);
  });

  it('should login successfully', async () => {
    await loginPage.login('user@example.com', 'password123');
    // Assert dashboard is displayed
  });
});
```

## Performance Testing

### Mobile Performance Metrics
- **App Launch Time**: Cold start, warm start
- **Frame Rate**: FPS during animations
- **Memory Usage**: RAM consumption
- **Battery Usage**: Power consumption
- **Network Usage**: Data transfer

### Performance Testing Tools
```bash
# Android profiling
adb shell dumpsys meminfo <package>
adb shell dumpsys cpuinfo

# iOS profiling
instruments -t "Time Profiler" MyApp.app
```

## Cross-Platform Testing

### Device Matrix
| Platform | Versions | Devices |
|----------|----------|---------|
| iOS | 14+, 15+, 16+ | iPhone 12, 13, 14, iPad |
| Android | 10+, 11+, 12+ | Pixel, Samsung, OnePlus |

### Cloud Testing Services
- **BrowserStack**: Real device testing
- **Sauce Labs**: Cross-browser testing
- **AWS Device Farm**: Real device testing
- **Firebase Test Lab**: Android testing

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Mobile Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test
        
      - name: Build iOS
        run: |
          cd ios
          pod install
          xcodebuild -workspace MyApp.xcworkspace -scheme MyApp -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Best Practices

### Test Design
1. **Keep tests independent**: No dependencies between tests
2. **Use meaningful names**: Describe what is being tested
3. **Test one thing per test**: Single assertion per test
4. **Use setup/teardown**: Clean state between tests

### Test Data
1. **Use realistic data**: Match production data patterns
2. **Clean up after tests**: Remove test data
3. **Use fixtures**: Consistent test data
4. **Mock external services**: Isolate tests

### Maintenance
1. **Regular updates**: Keep frameworks updated
2. **Refactor tests**: Improve maintainability
3. **Monitor flaky tests**: Fix or remove unreliable tests
4. **Document tests**: Clear test documentation

## Common Challenges

### Device Fragmentation
- Test on multiple device sizes
- Use responsive design
- Consider different screen densities

### Network Conditions
- Test on different network speeds
- Handle offline scenarios
- Test data synchronization

### Platform Differences
- iOS and Android behavior differences
- Platform-specific UI conventions
- Different permission models

## See Also

- [[automation-guide]]
- [[automation-tools]]
- [[automation-frameworks]]
- [[automation-best-practices]]
