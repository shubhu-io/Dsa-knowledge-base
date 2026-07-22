# Cybersecurity Interview Questions

## Table of Contents

1. [Fundamental Questions](#fundamental-questions)
2. [Network Security](#network-security)
3. [Cryptography](#cryptography)
4. [Application Security](#application-security)
5. [Incident Response](#incident-response)
6. [Security Operations](#security-operations)
7. [Scenario-Based Questions](#scenario-based-questions)
8. [Leadership & Management](#leadership--management)

---

## Fundamental Questions

### General Security Concepts

**Q1: What is the CIA Triad?**

```
Answer:
┌─────────────────────────────────────┐
│           CIA TRIAD                 │
├─────────────────────────────────────┤
│ Confidentiality                     │
│ → Only authorized access           │
│ → Encryption, access controls      │
├─────────────────────────────────────┤
│ Integrity                           │
│ → Data accuracy and consistency    │
│ → Hashing, checksums               │
├─────────────────────────────────────┤
│ Availability                        │
│ → Systems accessible when needed   │
│ → Redundancy, backups              │
└─────────────────────────────────────┘

Additional concepts:
• Authentication - Verify identity
• Authorization - Grant permissions
• Non-repudiation - Prove action occurred
```

**Q2: What is Defense in Depth?**

```
Answer:
Multiple layers of security controls throughout
an IT system.

Layers:
1. Policy & Procedures
2. Physical Security
3. Perimeter Security (Firewall)
4. Network Security (IDS/IPS)
5. Host Security (Antivirus)
6. Application Security (Input validation)
7. Data Security (Encryption)

Each layer provides backup if another fails.
```

**Q3: What is Zero Trust Architecture?**

```
Answer:
Security model that requires strict identity
verification for every person and device.

Principles:
• Never trust, always verify
• Assume breach
• Verify explicitly
• Least privilege access
• Micro-segmentation

Benefits:
• Reduces lateral movement
• Better visibility
• Improved access control
• Adapted for remote work
```

**Q4: Explain the difference between IDS and IPS.**

```
Answer:
┌──────────────┬─────────────────┬─────────────────┐
│ Feature      │ IDS             │ IPS             │
├──────────────┼─────────────────┼─────────────────┤
│ Function     │ Detect          │ Detect + Block  │
│ Placement    │ Passive         │ Inline          │
│ Action       │ Alert only      │ Prevent         │
│ Impact       │ None            │ Can block legit │
│ Response     │ Manual          │ Automated       │
└──────────────┴─────────────────┴─────────────────┘

IDS: Monitors traffic, generates alerts
IPS: Monitors and actively blocks threats
```

**Q5: What is Social Engineering?**

```
Answer:
Psychological manipulation of people into
performing actions or divulging information.

Types:
• Phishing - Email deception
• Spear Phishing - Targeted phishing
• Vishing - Voice phishing
• Pretexting - Creating false scenario
• Baiting - Leaving infected media
• Tailgating - Following authorized person
• Quid Pro Quo - Exchange of services

Defense:
• Security awareness training
• Verification procedures
• Security policies
• Technical controls
```

---

## Network Security

**Q6: What is a Firewall and its types?**

```
Answer:
Network security device that monitors and
filters traffic based on rules.

Types:
┌─────────────────────────────────────────┐
│ Packet Filtering ──── Layer 3/4         │
│ Stateful Inspection ── Connection state  │
│ Proxy Firewall ────── Application layer │
│ NGFW ──────────────── Advanced features │
│ WAF ───────────────── Web applications  │
│ Cloud Firewall ────── Cloud-based       │
└─────────────────────────────────────────┘
```

**Q7: Explain the OSI Model security at each layer.**

```
Answer:
Layer 7 - Application: WAF, Input validation
Layer 6 - Presentation: Encryption (SSL/TLS)
Layer 5 - Session: Session management
Layer 4 - Transport: TLS, Port security
Layer 3 - Network: IPsec, Routing security
Layer 2 - Data Link: 802.1X, MAC filtering
Layer 1 - Physical: Locks, Cameras
```

**Q8: What is a VPN and how does it work?**

```
Answer:
Virtual Private Network creates encrypted
tunnel over public network.

VPN Types:
• Remote Access - Individual to network
• Site-to-Site - Network to network
• SSL VPN - Browser-based
• IPsec VPN - Network layer

Protocols:
• OpenVPN - Open source, flexible
• WireGuard - Modern, fast
• IPsec - Industry standard
• L2TP/IPsec - Layer 2 tunneling
```

**Q9: What is DNS Poisoning?**

```
Answer:
Corrupting DNS cache to redirect traffic
to malicious servers.

Attack Flow:
1. Attacker queries DNS with spoofed response
2. DNS server caches false record
3. Users redirected to malicious site
4. Data theft or malware delivery

Defense:
• DNSSEC
• DNS over HTTPS (DoH)
• DNS filtering
• Monitor DNS logs
```

---

## Cryptography

**Q10: What is the difference between Symmetric and Asymmetric encryption?**

```
Answer:
┌───────────────────┬─────────────────────┐
│ Symmetric         │ Asymmetric          │
├───────────────────┼─────────────────────┤
│ One key           │ Key pair (pub/priv) │
│ Fast              │ Slow                │
│ Same key encrypt/ │ Different keys      │
│ decrypt           │                     │
│ Key distribution  │ No key distribution │
│ issue             │ problem             │
├───────────────────┼─────────────────────┤
│ AES, DES, 3DES    │ RSA, ECC, Diffie-   │
│ ChaCha20          │ Hellman             │
└───────────────────┴─────────────────────┘

Hybrid: Use asymmetric for key exchange,
symmetric for data encryption.
```

**Q11: What is a Hash Function and its properties?**

```
Answer:
One-way function converting input to fixed-size
output (digest).

Properties:
• Deterministic - Same input = same output
• Fast computation
• Pre-image resistant - Can't reverse
• Collision resistant - Unique outputs
• Avalanche effect - Small change = big difference

Common Algorithms:
• MD5 - 128-bit (deprecated)
• SHA-1 - 160-bit (deprecated)
• SHA-256 - 256-bit (secure)
• SHA-3 - Latest standard
• bcrypt/Argon2 - Password hashing

Use Cases:
• Password storage
• Data integrity
• Digital signatures
• Checksums
```

**Q12: What is PKI (Public Key Infrastructure)?**

```
Answer:
Framework for managing digital certificates
and encryption keys.

Components:
┌─────────────────────────────────────┐
│ CA (Certificate Authority)          │
│ → Issues certificates               │
├─────────────────────────────────────┤
│ RA (Registration Authority)         │
│ → Verifies identity                 │
├─────────────────────────────────────┤
│ Certificate Repository              │
│ → Stores certificates               │
├─────────────────────────────────────┤
│ CRL (Certificate Revocation List)   │
│ → Revoked certificates              │
└─────────────────────────────────────┘

Certificate contains:
• Subject name
• Public key
• Issuer
• Validity period
• Digital signature
```

---

## Application Security

**Q13: What is SQL Injection and how to prevent it?**

```
Answer:
Malicious SQL code inserted into queries.

Example:
Input: ' OR '1'='1
Query: SELECT * FROM users WHERE name='' OR '1'='1'

Prevention:
1. Parameterized queries (Prepared statements)
2. Input validation
3. Stored procedures
4. Escape special characters
5. Least privilege DB accounts
6. WAF deployment

Example (Python):
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

**Q14: What is Cross-Site Scripting (XSS)?**

```
Answer:
Injecting malicious scripts into web pages.

Types:
• Stored XSS - Permanent in database
• Reflected XSS - In URL/parameters
• DOM-based XSS - Client-side only

Impact:
• Session hijacking
• Data theft
• Defacement
• Malware distribution

Prevention:
1. Output encoding
2. Content Security Policy (CSP)
3. Input validation
4. HTTPOnly cookies
5. Input sanitization
```

**Q15: What is OWASP Top 10?**

```
Answer:
Standard awareness document for web security.

OWASP Top 10 (2021):
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Identification and Authentication Failures
8. Software and Data Integrity Failures
9. Security Logging and Monitoring Failures
10. Server-Side Request Forgery (SSRF)

Defense requires addressing all categories.
```

---

## Incident Response

**Q16: What are the phases of Incident Response?**

```
Answer:
NIST Incident Response Lifecycle:

1. Preparation
   • IR plan
   • Training
   • Tools setup

2. Detection & Analysis
   • Monitor alerts
   • Validate incidents
   • Classify severity

3. Containment
   • Short-term containment
   • Evidence preservation
   • Long-term containment

4. Eradication
   • Remove malware
   • Patch vulnerabilities
   • Reset credentials

5. Recovery
   • Restore systems
   • Verify functionality
   • Monitor closely

6. Post-Incident Activity
   • Lessons learned
   • Update procedures
   • Reporting
```

**Q17: How do you handle a ransomware attack?**

```
Answer:
Immediate Actions:
1. Isolate infected systems
2. Disconnect from network
3. Preserve evidence
4. Notify IR team/legal

Investigation:
1. Identify ransomware variant
2. Determine scope of infection
3. Identify initial attack vector
4. Check for data exfiltration

Recovery Options:
1. Restore from backups (preferred)
2. Consider decryption tools
3. Incident reporting
4. Law enforcement notification

NOT Recommended:
• Paying ransom (doesn't guarantee recovery)
• Rebooting systems
```

**Q18: What is a SIEM and why is it important?**

```
Answer:
Security Information and Event Management
centralizes security data.

Features:
• Log aggregation
• Real-time analysis
• Alert generation
• Correlation
• Compliance reporting

Benefits:
• Centralized visibility
• Automated detection
• Faster response
• Compliance support
• Forensic analysis

Popular SIEMs:
• Splunk
• IBM QRadar
• Microsoft Sentinel
• Elastic SIEM
• LogRhythm
```

---

## Security Operations

**Q19: What is Vulnerability Management?**

```
Answer:
Process of identifying, evaluating, and
remediating vulnerabilities.

Lifecycle:
┌─────────────────────────────────────┐
│ 1. Discovery                        │
│    Asset inventory                  │
│ 2. Assessment                       │
│    Vulnerability scanning           │
│ 3. Prioritization                   │
│    Risk-based approach              │
│ 4. Remediation                      │
│    Patching, configuration          │
│ 5. Verification                     │
│    Rescan to confirm                │
│ 6. Reporting                        │
│    Metrics and dashboards           │
└─────────────────────────────────────┘

Tools: Nessus, Qualys, OpenVAS, Rapid7
```

**Q20: What is Penetration Testing?**

```
Answer:
Authorized simulated attack to find
weaknesses before criminals do.

Types:
• Black Box - No prior knowledge
• White Box - Full knowledge
• Gray Box - Partial knowledge

Phases:
1. Planning & Reconnaissance
2. Scanning
3. Gaining Access
4. Maintaining Access
5. Analysis & Reporting

Methodologies:
• PTES (Penetration Testing Execution Standard)
• OSSTMM
• NIST SP 800-115

Certifications: OSCP, GPEN, CEH
```

**Q21: What is Threat Intelligence?**

```
Answer:
Evidence-based knowledge about existing
or emerging threats.

Types:
• Strategic - High-level for executives
• Tactical - TTPs for security teams
• Operational - Specific threat details
• Technical - IOCs for detection

Sources:
• Government (CISA, FBI)
• Industry (ISACs)
• Commercial (Recorded Future)
• Open Source (VirusTotal)

Frameworks:
• MITRE ATT&CK
• Kill Chain
• Diamond Model
```

---

## Scenario-Based Questions

**Q22: A user reports their computer is running slowly and showing strange pop-ups. What do you do?**

```
Answer:
Immediate Steps:
1. Disconnect from network
2. Document symptoms
3. Preserve evidence

Investigation:
1. Check running processes
2. Review installed programs
3. Scan with anti-malware
4. Check browser extensions
5. Review system logs

Containment:
1. Quarantine system
2. Block malicious IPs/domains
3. Check for lateral movement

Recovery:
1. Remove malware
2. Reset passwords
3. Patch vulnerabilities
4. Monitor for recurrence

Lessons:
• Update security awareness
• Review endpoint protection
```

**Q23: You suspect a data breach. How do you respond?**

```
Answer:
Phase 1: Initial Response
1. Assemble IR team
2. Preserve evidence
3. Contain compromised systems
4. Notify legal/compliance

Phase 2: Investigation
1. Determine breach scope
2. Identify affected data
3. Find attack vector
4. Check for ongoing access

Phase 3: Containment
1. Isolate affected systems
2. Block attacker access
3. Preserve forensic images

Phase 4: Recovery
1. Restore from clean backups
2. Patch vulnerabilities
3. Reset credentials
4. Enhanced monitoring

Phase 5: Notification
1. Regulatory notification (72 hrs GDPR)
2. Affected individuals
3. Law enforcement
4. Public disclosure (if required)
```

**Q24: How would you secure a new web application?**

```
Answer:
Development Phase:
• Secure coding training
• Threat modeling
• Secure design review

Development:
• Input validation
• Output encoding
• Parameterized queries
• Proper authentication
• Session management
• Error handling

Testing:
• SAST (Static analysis)
• DAST (Dynamic analysis)
• Penetration testing
• Code review

Deployment:
• HTTPS everywhere
• Security headers
• WAF deployment
• Least privilege
• Logging & monitoring

Maintenance:
• Regular patching
• Vulnerability scanning
• Incident response plan
```

---

## Leadership & Management

**Q25: How do you build a security program?**

```
Answer:
Assessment:
• Current state analysis
• Risk assessment
• Gap analysis

Framework:
• Choose framework (NIST, ISO, CIS)
• Define policies
• Establish procedures

People:
• Security team structure
• Training programs
• Awareness campaigns

Process:
• Incident response
• Vulnerability management
• Change management

Technology:
• Security architecture
• Tool selection
• Integration

Metrics:
• KPIs/KRIs
• Dashboards
• Reporting
```

**Q26: How do you communicate security risks to executives?**

```
Answer:
Key Principles:
• Use business language
• Focus on risk, not technical details
• Quantify impact
• Provide options

Structure:
1. Executive Summary
2. Risk Overview
3. Business Impact
4. Recommendations
5. Resource Requirements

Metrics:
• Financial impact
• Compliance status
• Incident trends
• Risk reduction ROI

Visualization:
• Risk heat maps
• Trend charts
• Comparison benchmarks
```

---

## Technical Deep Dives

### Python for Security

```python
# Network scanning
import socket

def port_scan(host, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(1)
    result = sock.connect_ex((host, port))
    sock.close()
    return result == 0

# Password strength checker
import re

def check_password_strength(password):
    strength = 0
    if len(password) >= 8: strength += 1
    if len(password) >= 12: strength += 1
    if re.search(r'[A-Z]', password): strength += 1
    if re.search(r'[a-z]', password): strength += 1
    if re.search(r'[0-9]', password): strength += 1
    if re.search(r'[!@#$%^&*]', password): strength += 1
    return strength
```

### Log Analysis

```bash
# Find failed SSH attempts
grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn

# Monitor real-time access
tail -f /var/log/apache2/access.log | awk '{print $1}' | sort -u

# Detect brute force
grep "Failed password" /var/log/auth.log | cut -d' ' -f8 | sort | uniq -c | sort -rn | head
```

---

## Quick Reference Card

### Common Ports & Services

| Port | Service | Risk |
|------|---------|------|
| 21 | FTP | High |
| 22 | SSH | Medium |
| 23 | Telnet | Critical |
| 25 | SMTP | Low |
| 53 | DNS | Medium |
| 80 | HTTP | Medium |
| 443 | HTTPS | Low |
| 445 | SMB | High |
| 3389 | RDP | High |

### Security Acronyms

```
CIA - Confidentiality, Integrity, Availability
DLP - Data Loss Prevention
DOS - Denial of Service
DR - Disaster Recovery
FW - Firewall
IDS - Intrusion Detection System
IPS - Intrusion Prevention System
MFA - Multi-Factor Authentication
NAC - Network Access Control
NGFW - Next-Generation Firewall
PKI - Public Key Infrastructure
SIEM - Security Information and Event Management
SOC - Security Operations Center
TLS - Transport Layer Security
VPN - Virtual Private Network
WAF - Web Application Firewall
```

---

*Last Updated: 2024*
