# Backend Security Best Practices

This document covers essential security practices for backend development.

## Authentication and Authorization

### JWT (JSON Web Tokens)
```javascript
// Token generation
const jwt = require('jsonwebtoken');
const token = jwt.sign(
  { userId: user.id, role: user.role },
  process.env.JWT_SECRET,
  { expiresIn: '24h' }
);

// Token verification
const decoded = jwt.verify(token, process.env.JWT_SECRET);
```

### Password Hashing
```javascript
const bcrypt = require('bcrypt');
const saltRounds = 12;

// Hash password
const hashedPassword = await bcrypt.hash(password, saltRounds);

// Verify password
const isValid = await bcrypt.compare(password, hashedPassword);
```

### OAuth 2.0 Implementation
```javascript
// Using passport.js
const passport = require('passport');

app.get('/auth/google',
  passport.authenticate('google', { scope: ['profile', 'email'] }));

app.get('/auth/google/callback',
  passport.authenticate('google', { failureRedirect: '/login' }),
  (req, res) => {
    res.redirect('/dashboard');
  });
```

## Input Validation

### Sanitize User Input
```javascript
const validator = require('validator');

// Email validation
if (!validator.isEmail(email)) {
  throw new Error('Invalid email address');
}

// SQL injection prevention
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]); // Use parameterized queries
```

### Schema Validation
```javascript
const Joi = require('joi');

const schema = Joi.object({
  username: Joi.string().alphanum().min(3).max(30).required(),
  email: Joi.string().email().required(),
  password: Joi.string().pattern(new RegExp('^[a-zA-Z0-9]{3,30}$'))
});

const { error, value } = schema.validate(req.body);
```

## API Security

### Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP'
});

app.use('/api/', limiter);
```

### CORS Configuration
```javascript
const cors = require('cors');

app.use(cors({
  origin: 'https://yourdomain.com',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));
```

### API Key Management
```javascript
// Middleware to verify API key
const verifyApiKey = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  
  if (!apiKey || !validApiKeys.includes(apiKey)) {
    return res.status(401).json({ error: 'Invalid API key' });
  }
  
  next();
};

app.use('/api/', verifyApiKey);
```

## Data Protection

### Encryption at Rest
```javascript
const crypto = require('crypto');

// Encrypt data
const algorithm = 'aes-256-cbc';
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);

const encrypt = (text) => {
  let cipher = crypto.createCipheriv(algorithm, Buffer.from(key), iv);
  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return { iv: iv.toString('hex'), encryptedData: encrypted.toString('hex') };
};
```

### Sensitive Data Handling
```javascript
// Environment variables
require('dotenv').config();
const dbPassword = process.env.DB_PASSWORD;

// Never log sensitive data
console.log('User logged in:', user.id); // OK
console.log('Password:', password); // NEVER DO THIS
```

### PII (Personally Identifiable Information)
```javascript
// Mask sensitive data
const maskEmail = (email) => {
  const [username, domain] = email.split('@');
  const maskedUsername = username[0] + '***' + username[username.length - 1];
  return `${maskedUsername}@${domain}`;
};

// Data retention policies
const deleteOldUserData = async () => {
  const cutoffDate = new Date();
  cutoffDate.setFullYear(cutoffDate.getFullYear() - 2);
  
  await User.deleteMany({ lastActivity: { $lt: cutoffDate } });
};
```

## Session Management

### Secure Session Configuration
```javascript
const session = require('express-session');

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true, // HTTPS only
    httpOnly: true, // No JavaScript access
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
    sameSite: 'strict'
  }
}));
```

### Session Invalidation
```javascript
// Logout
app.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ error: 'Logout failed' });
    }
    res.clearCookie('sessionId');
    res.json({ message: 'Logged out successfully' });
  });
});
```

## Security Headers

### Helmet.js Configuration
```javascript
const helmet = require('helmet');

app.use(helmet());

// Customize headers
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", "'unsafe-inline'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:", "https:"],
  }
}));
```

### Essential Security Headers
```javascript
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  next();
});
```

## Logging and Monitoring

### Security Logging
```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// Log security events
logger.info('Login attempt', {
  userId: user.id,
  ip: req.ip,
  userAgent: req.get('User-Agent'),
  success: true
});
```

### Intrusion Detection
```javascript
// Detect multiple failed logins
const failedLogins = new Map();

app.post('/login', async (req, res) => {
  const { email } = req.body;
  const attempts = failedLogins.get(email) || 0;
  
  if (attempts >= 5) {
    logger.warn('Account locked due to multiple failed attempts', { email });
    return res.status(429).json({ error: 'Account temporarily locked' });
  }
  
  // Attempt login...
  if (!isValid) {
    failedLogins.set(email, attempts + 1);
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  
  failedLogins.delete(email);
  res.json({ success: true });
});
```

## Dependency Security

### Regular Updates
```bash
# Check for vulnerable dependencies
npm audit

# Fix vulnerabilities
npm audit fix

# Update packages
npm update
```

### Security Scanning
```bash
# Using Snyk
npm install -g snyk
snyk test
snyk monitor
```

## Incident Response

### Preparation
1. **Have an incident response plan**
2. **Document contact information**
3. **Practice incident response**
4. **Maintain backups**

### Response Steps
1. **Identify**: Detect and confirm the incident
2. **Contain**: Limit the damage
3. **Eradicate**: Remove the threat
4. **Recover**: Restore normal operations
5. **Learn**: Document and improve

## Security Checklist

### Authentication
- [ ] Passwords are hashed with bcrypt
- [ ] JWT tokens have appropriate expiration
- [ ] Multi-factor authentication is available
- [ ] Account lockout after failed attempts

### Authorization
- [ ] Role-based access control is implemented
- [ ] Users can only access their own resources
- [ ] Admin actions are logged
- [ ] API endpoints are protected

### Input Validation
- [ ] All user input is sanitized
- [ ] SQL queries use parameterized statements
- [ ] File uploads are validated
- [ ] Request size limits are enforced

### Data Protection
- [ ] Sensitive data is encrypted at rest
- [ ] HTTPS is enforced
- [ ] Security headers are configured
- [ ] PII is handled according to regulations

### Monitoring
- [ ] Security events are logged
- [ ] Failed login attempts are tracked
- [ ] Unusual activity is alerted
- [ ] Logs are securely stored

## See Also

- [[backend-guide]]
- [[backend-api-design]]
- [[backend-architectures]]
- [[backend-interview-questions]]
