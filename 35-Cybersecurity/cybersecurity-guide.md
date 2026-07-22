# Comprehensive Cybersecurity Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Core Principles](#core-principles)
3. [Security Domains](#security-domains)
4. [Network Security](#network-security)
5. [Application Security](#application-security)
6. [Cloud Security](#cloud-security)
7. [Identity and Access Management](#identity-and-access-management)
8. [Security Frameworks](#security-frameworks)
9. [Compliance and Governance](#compliance-and-governance)

---

## Introduction

Cybersecurity encompasses technologies, processes, and practices designed to protect networks, devices, programs, and data from attack, damage, or unauthorized access.

### CIA Triad

```
        Confidentiality
              /\
             /  \
            /    \
           /  CIA \
          /________\
    Integrity    Availability
```

- **Confidentiality**: Ensure only authorized users access data
- **Integrity**: Maintain accuracy and consistency of data
- **Availability**: Ensure systems and data are accessible when needed

---

## Core Principles

### Defense in Depth

Multiple layers of security controls:

```
┌─────────────────────────────────┐
│         Policy Layer            │
│  ┌───────────────────────────┐  │
│  │      Physical Layer       │  │
│  │  ┌───────────────────┐    │  │
│  │  │  Network Layer     │    │  │
│  │  │  ┌─────────────┐   │    │  │
│  │  │  │ Host Layer   │   │    │  │
│  │  │  │  ┌───────┐   │   │    │  │
│  │  │  │  │App    │   │   │    │  │
│  │  │  │  │Layer  │   │   │    │  │
│  │  │  │  └───────┘   │   │    │  │
│  │  │  └─────────────┘   │    │  │
│  │  └───────────────────┘    │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

### Least Privilege

Grant minimum permissions needed for a task:

```python
# Bad: Overly permissive
permissions = ["read", "write", "delete", "admin"]

# Good: Least privilege
permissions = ["read", "write"]  # Only what's needed
```

### Zero Trust

- Never trust, always verify
- Assume breach mentality
- Verify explicitly
- Use least privilege access
- Micro-segment networks

---

## Security Domains

### 1. Network Security

```bash
# Firewall rules example (iptables)
iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP

# Network scanning
nmap -sV -O target_ip
```

### 2. Endpoint Security

```bash
# Check for suspicious processes (Linux)
ps aux | grep -i suspicious

# Check open ports
netstat -tuln

# Check running services
systemctl list-units --type=service --state=running
```

### 3. Application Security

```python
# Input validation example
import re

def validate_email(email):
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    if re.match(pattern, email):
        return True
    return False

# SQL injection prevention
import sqlite3

def safe_query(user_input):
    cursor.execute("SELECT * FROM users WHERE id = ?", (user_input,))
    return cursor.fetchall()
```

---

## Network Security

### Common Network Attacks

| Attack | Description | Defense |
|--------|-------------|---------|
| Man-in-the-Middle | Intercept communications | TLS/SSL, VPN |
| DDoS | Overwhelm with traffic | Rate limiting, CDN |
| ARP Spoofing | Redirect network traffic | Static ARP, 802.1X |
| DNS Spoofing | Redirect domain resolution | DNSSEC |

### Security Monitoring

```bash
# Wireshark filter examples
# Filter by IP
ip.addr == 192.168.1.100

# Filter HTTP traffic
http

# Filter by port
tcp.port == 443

# Detect suspicious traffic
tcp.flags.syn == 1 and tcp.flags.ack == 0
```

### VPN Configuration

```bash
# OpenVPN client config
client
dev tun
proto udp
remote vpn.example.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
auth SHA256
```

---

## Application Security

### OWASP Top 10 (2023)

1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable Components
7. Authentication Failures
8. Software and Data Integrity Failures
9. Security Logging Failures
10. Server-Side Request Forgery (SSRF)

### Secure Coding Practices

```python
# Password hashing
import bcrypt

def hash_password(password):
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed)

# CSRF protection
from functools import wraps
import secrets

def csrf_protect(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = session.get('csrf_token')
        if not token or token != request.form.get('csrf_token'):
            abort(403)
        return f(*args, **kwargs)
    return decorated
```

---

## Cloud Security

### AWS Security Best Practices

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::bucket/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
```

### Cloud Security Checklist

- [ ] Enable MFA on all accounts
- [ ] Encrypt data at rest and in transit
- [ ] Implement IAM policies
- [ ] Enable logging and monitoring
- [ ] Configure security groups properly
- [ ] Regular security assessments
- [ ] Backup and disaster recovery plan

---

## Identity and Access Management

### Authentication Methods

```
Something You Know     → Passwords, PINs
Something You Have     → Tokens, Smart cards
Something You Are      → Biometrics
Somewhere You Are      → Location-based
Something You Do       → Behavioral patterns
```

### Multi-Factor Authentication

```python
# TOTP implementation example
import pyotp

# Generate secret
secret = pyotp.random_base32()
totp = pyotp.TOTP(secret)

# Generate current code
current_code = totp.now()

# Verify code
is_valid = totp.verify(user_input_code)
```

### Role-Based Access Control (RBAC)

```yaml
# Example RBAC configuration
roles:
  admin:
    permissions:
      - user:read
      - user:write
      - user:delete
      - system:admin
  
  editor:
    permissions:
      - content:read
      - content:write
      - content:publish
  
  viewer:
    permissions:
      - content:read
```

---

## Security Frameworks

### NIST Cybersecurity Framework

```
1. Identify    → Asset management, Risk assessment
2. Protect     → Access control, Training
3. Detect      → Monitoring, Anomaly detection
4. Respond     → Response planning, Communications
5. Recover     → Recovery planning, Improvements
```

### ISO 27001 Controls

| Category | Description |
|----------|-------------|
| A.5 | Information Security Policies |
| A.6 | Organization of Information Security |
| A.7 | Human Resource Security |
| A.8 | Asset Management |
| A.9 | Access Control |
| A.10 | Cryptography |
| A.11 | Physical Security |
| A.12 | Operations Security |
| A.13 | Communications Security |
| A.14 | System Acquisition |
| A.15 | Supplier Relationships |
| A.16 | Incident Management |
| A.17 | Business Continuity |
| A.18 | Compliance |

---

## Compliance and Governance

### Major Regulations

| Regulation | Industry | Key Requirements |
|------------|----------|------------------|
| GDPR | EU Data | Data protection, Privacy rights |
| HIPAA | Healthcare | PHI protection, BAAs |
| PCI-DSS | Payment | Card data security |
| SOX | Financial | Internal controls |
| FERPA | Education | Student records |

### Risk Assessment Matrix

```
Impact →    Low      Medium     High      Critical
Likelihood
Almost Certain  M        H         H          E
Likely          L        M         H          E
Possible        L        M         M          H
Unlikely        L        L         M          H
Rare            L        L         L          M

L = Low    M = Medium    H = High    E = Extreme
```

---

## Incident Response

### Incident Response Lifecycle

```
1. Preparation
   ↓
2. Detection & Analysis
   ↓
3. Containment
   ↓
4. Eradication
   ↓
5. Recovery
   ↓
6. Post-Incident Activity
```

### Incident Response Checklist

- [ ] Identify and classify incident
- [ ] Notify appropriate teams
- [ ] Preserve evidence
- [ ] Contain the threat
- [ ] Eradicate malware/attacker
- [ ] Recover systems
- [ ] Document lessons learned

---

## Learning Resources

### Books
- "The Art of Deception" by Kevin Mitnick
- "Hacking: The Art of Exploitation" by Jon Erickson
- "Applied Cryptography" by Bruce Schneier
- "Security Engineering" by Ross Anderson

### Platforms
- Hack The Box (hackthebox.com)
- TryHackMe (tryhackme.com)
- OverTheWire (overthewire.org)
- VulnHub (vulnhub.com)

### Certifications Path

```
Beginner:     CompTIA Security+ → CEH
Intermediate: CySA+ → Pentest+ → CISM
Advanced:     OSCP → CISSP → GXPN
```

---

## Quick Reference

### Essential Commands

```bash
# Network
netstat -tuln          # Open ports
nmap -sV target        # Service version
tcpdump -i eth0        # Packet capture

# System
chmod 700 file         # Restrict permissions
chown user:group file  # Change ownership
find / -perm -4000     # SUID files

# Logs
tail -f /var/log/auth.log    # Auth logs
grep "Failed" /var/log/auth.log  # Failed logins
journalctl -u sshd            # SSH logs
```

### Security Tools Quick List

| Category | Tools |
|----------|-------|
| Scanning | Nmap, Nessus, OpenVAS |
| Analysis | Wireshark, tcpdump |
| Exploitation | Metasploit, Burp Suite |
| Password | John the Ripper, Hashcat |
| Forensics | Autopsy, Volatility |
| Monitoring | Splunk, ELK Stack |

---

*Last Updated: 2024*
