# OWASP Top 10 Security Risks

This document covers the OWASP Top 10 most critical web application security risks.

## What is OWASP?

The Open Web Application Security Project (OWASP) is a nonprofit foundation that works to improve the security of software. The OWASP Top 10 is a standard awareness document for web application security.

## OWASP Top 10 (2021)

### 1. Broken Access Control

**Description:** Restrictions on what authenticated users are allowed to do are not properly enforced.

**Common Vulnerabilities:**
- Violation of the principle of least privilege
- Bypassing access control checks by modifying the URL or HTML page
- Viewing or editing someone else's account
- Accessing API with missing access controls for POST, PUT, and DELETE

**Prevention:**
```javascript
// Access control check
app.get('/admin/users', (req, res) => {
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  // Return admin-only data
});
```

### 2. Cryptographic Failures

**Description:** Failures related to cryptography which often leads to exposure of sensitive data.

**Common Vulnerabilities:**
- Data transmitted in clear text (HTTP, FTP, SMTP)
- Old or weak cryptographic algorithms
- Default crypto keys in use
- Missing or weak crypto key management

**Prevention:**
```javascript
// Use strong encryption
const crypto = require('crypto');

const algorithm = 'aes-256-cbc';
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);

// Encrypt data
function encrypt(text) {
  let cipher = crypto.createCipheriv(algorithm, Buffer.from(key), iv);
  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return { iv: iv.toString('hex'), encryptedData: encrypted.toString('hex') };
}
```

### 3. Injection

**Description:** User-supplied data is not validated, filtered, or sanitized by the application.

**Types:**
- SQL Injection
- NoSQL Injection
- OS Command Injection
- LDAP Injection

**Prevention:**
```javascript
// Parameterized queries
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId], (err, results) => {
  // Safe from SQL injection
});

// Input validation
const validator = require('validator');
if (!validator.isEmail(email)) {
  throw new Error('Invalid email');
}
```

### 4. Insecure Design

**Description:** Risks related to design flaws, missing or ineffective security controls.

**Common Issues:**
- Missing threat modeling
- Missing security architecture review
- Insufficient access control

**Prevention:**
- Implement threat modeling
- Use secure design patterns
- Write security requirements
- Conduct architecture reviews

### 5. Security Misconfiguration

**Description:** Missing appropriate security hardening across any part of the application stack.

**Common Issues:**
- Missing appropriate security hardening
- Improperly configured permissions on cloud services
- Unnecessary features enabled
- Default accounts and passwords enabled

**Prevention:**
```nginx
# Nginx security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

### 6. Vulnerable and Outdated Components

**Description:** Using components (libraries, frameworks) with known vulnerabilities.

**Common Issues:**
- Using unsupported or outdated software
- Not scanning for vulnerabilities regularly
- Not fixing or upgrading vulnerable components

**Prevention:**
```bash
# Check for vulnerable dependencies
npm audit
pip check
bundle audit

# Update dependencies
npm update
pip install --upgrade <package>
```

### 7. Identification and Authentication Failures

**Description:** Confirmation of the user's identity, authentication, and session management is not implemented correctly.

**Common Issues:**
- Permitting automated attacks (credential stuffing)
- Permitting brute force or other automated attacks
- Permitting weak passwords
- Missing or ineffective multi-factor authentication

**Prevention:**
```javascript
// Strong password policy
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

// Rate limiting
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
```

### 8. Software and Data Integrity Failures

**Description:** Code and infrastructure that does not protect against integrity violations.

**Common Issues:**
- Insecure CI/CD pipelines
- Auto-update without sufficient integrity verification
- Deserialization of untrusted data

**Prevention:**
```javascript
// Verify package integrity
const crypto = require('crypto');

function verifySignature(data, signature, publicKey) {
  const verify = crypto.createVerify('RSA-SHA256');
  verify.update(data);
  return verify.verify(publicKey, signature);
}
```

### 9. Security Logging and Monitoring Failures

**Description:** Insufficient logging, detection, monitoring, and active response.

**Common Issues:**
- Auditable events not logged
- Logs only stored locally
- Missing alerting for suspicious activities

**Prevention:**
```javascript
// Security logging
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'security.log' }),
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

### 10. Server-Side Request Forgery (SSRF)

**Description:** SSRF flaws occur when a web application fetches a remote resource without validating the user-supplied URL.

**Common Issues:**
- Fetching remote resources without validation
- Allowing internal network access
- Not enforcing URL scheme restrictions

**Prevention:**
```javascript
// Validate and sanitize URLs
const validUrl = require('valid-url');

function validateUrl(url) {
  if (!validUrl.isUri(url)) {
    throw new Error('Invalid URL');
  }
  
  // Block internal IPs
  const hostname = new URL(url).hostname;
  if (isInternalIP(hostname)) {
    throw new Error('Internal URLs not allowed');
  }
  
  return url;
}
```

## Security Best Practices

### Defense in Depth
1. **Multiple layers**: Don't rely on single security measure
2. **Least privilege**: Grant minimum necessary access
3. **Separation of duties**: Split critical tasks
4. **Security by design**: Build security from the start

### Regular Security Activities
1. **Code reviews**: Include security in review process
2. **Penetration testing**: Regular security testing
3. **Vulnerability scanning**: Automated scanning
4. **Security training**: Regular team training

### Incident Response
1. **Preparation**: Have a response plan
2. **Detection**: Monitor for security events
3. **Response**: Act quickly on incidents
4. **Recovery**: Restore normal operations
5. **Lessons learned**: Improve defenses

## Tools and Resources

### Security Testing Tools
- **OWASP ZAP**: Web application security scanner
- **Burp Suite**: Web vulnerability scanner
- **SonarQube**: Static code analysis
- **Snyk**: Dependency vulnerability scanning

### Learning Resources
- OWASP Website: https://owasp.org
- OWASP Top 10: https://owasp.org/www-project-top-ten/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org/

## See Also

- [[cybersecurity-guide]]
- [[cybersecurity-threats]]
- [[cybersecurity-tools]]
- [[cybersecurity-interview-questions]]
