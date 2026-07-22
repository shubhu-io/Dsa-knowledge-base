# Ethical Hacking Tips & Best Practices

## Table of Contents

1. [Getting Started](#getting-started)
2. [Reconnaissance Tips](#reconnaissance-tips)
3. [Scanning Tips](#scanning-tips)
4. [Exploitation Tips](#exploitation-tips)
5. [Post-Exploitation Tips](#post-exploitation-tips)
6. [Report Writing Tips](#report-writing-tips)
7. [Career Advice](#career-advice)
8. [Common Mistakes](#common-mistakes)
9. [Pro Tips](#pro-tips)

---

## Getting Started

### Building Your Lab

```
Home Lab Setup:

Hardware:
├── Old laptop/desktop
├── USB WiFi adapter (monitor mode)
├── External hard drive
└── Network switch

Software:
├── VirtualBox/VMware
├── Kali Linux
├── Metasploitable
├── DVWA
├── Windows VM
└── Vulnerable applications

Network:
├── Isolated network
├── Virtual networks
└── No production access
```

### Practice Platforms

| Platform | Type | Difficulty |
|----------|------|------------|
| TryHackMe | Guided labs | Beginner |
| Hack The Box | CTF-style | Intermediate |
| OverTheWire | Wargames | Beginner-Advanced |
| VulnHub | VM downloads | Intermediate |
| PentesterLab | Web focus | Intermediate |
| Hack.me | Free hosting | All levels |
| Root Me | CTF challenges | All levels |

### Learning Path

```
Beginner (0-6 months):
├── Networking (TCP/IP, DNS, HTTP)
├── Linux fundamentals
├── Basic security concepts
├── TryHackMe beginner path
└── CompTIA Security+

Intermediate (6-18 months):
├── Linux administration
├── Python scripting
├── Vulnerability assessment
├── Web application security
├── Hack The Box machines
└── CEH or Pentest+

Advanced (18+ months):
├── Exploit development
├── Binary analysis
├── Active Directory attacks
├── Cloud security
├── Custom tool development
└── OSCP certification
```

---

## Reconnaissance Tips

### Passive Reconnaissance

```bash
# Google Dorking tips
site:target.com filetype:pdf           # Find documents
inurl:admin site:target.com            # Admin panels
intitle:"index of" site:target.com     # Open directories
"target.com" password site:pastebin.com # Leaked credentials

# Social media OSINT
# LinkedIn: Employee enumeration
# Twitter: Real-time intel
# GitHub: Code leaks, credentials

# DNS enumeration
dig target.com ANY
host -t mx target.com
```

### Active Reconnaissance

```bash
# Efficient scanning
nmap -sS -T4 --top-ports 1000 target   # Quick scan first
nmap -sV -p 22,80,443 target           # Specific ports

# Service enumeration
nmap --script=http-enum target
nmap --script=smb-enum-shares target

# Avoid detection
nmap -sS -T2 target                    # Slower, stealthier
```

### OSINT Mindset

```
Think like a detective:
• What information is publicly available?
• What can be inferred from the data?
• What patterns emerge?
• What can be leveraged?
```

---

## Scanning Tips

### Efficient Scanning Strategy

```
Scanning Workflow:

1. Discovery scan (fast)
   nmap -sn 192.168.1.0/24
   
2. Port scan (targeted)
   nmap -sV -p 22,80,443 target
   
3. Service enumeration
   nmap --script=smb-enum-shares target
   
4. Vulnerability scan
   nmap --script=vuln target
   nikto -h target

5. Deep dive (as needed)
   nessus/openvas full scan
```

### Reducing Scan Time

```bash
# Quick host discovery
nmap -sn 192.168.1.0/24

# Top ports only
nmap --top-ports 100 target

# Fast timing
nmap -T4 target

# Skip DNS resolution
nmap -n target

# Limit port range
nmap -p 1-1024 target
```

### Avoiding Detection

```
Stealth Scanning:
├── SYN scan (-sS) instead of connect scan
├── Slower timing (-T2)
├── Fragment packets (-f)
├── Decoys (-D)
├── Source port spoofing
└── Idle/zombie scanning (-sI)
```

---

## Exploitation Tips

### Finding Vulnerabilities

```
Vulnerability Research:

1. Check CVE databases
   cve.mitre.org
   nvd.nist.gov

2. Search exploit databases
   exploit-db.com
   github.com/exploits

3. Use vulnerability scanners
   Nessus
   OpenVAS
   Qualys

4. Manual testing
   Review configurations
   Test access controls
   Check input validation
```

### Choosing Exploits

```python
# Considerations for exploit selection
factors = {
    "reliability": "Will it work consistently?",
    "stealth": "Will it be detected?",
    "impact": "What's the effect?",
    "scope": "Does it match engagement?",
    "legality": "Is it authorized?"
}
```

### Payload Selection

```bash
# Windows payloads
windows/x64/meterpreter/reverse_tcp     # Interactive
windows/x64/shell_reverse_tcp           # Simple shell
windows/meterpreter/vnc_reverse_tcp     # GUI access

# Linux payloads
linux/x64/meterpreter/reverse_tcp       # Interactive
linux/x64/shell_reverse_tcp             # Simple shell

# Web payloads
php/meterpreter/reverse_tcp             # PHP shells
java/jsp_shell_reverse_tcp              # Java shells
```

### Post-Exploitation

```bash
# Immediate actions
sysinfo                                 # Gather info
getuid                                  # Check privileges
hashdump                                # Extract hashes

# Privilege escalation
getsystem                               # Try auto-escalation
background                              # Keep session

# Pivoting
portfwd add -l 3389 -p 3389 -r target  # Port forwarding
run autoroute -s 192.168.2.0/24         # Route through
```

---

## Post-Exploitation Tips

### Maintaining Access

```
Persistence Methods:

Windows:
├── Registry run keys
├── Scheduled tasks
├── Services
├── WMI subscriptions
└── DLL hijacking

Linux:
├── Crontab
├── Systemd services
├── SSH keys
├── Bashrc/profile
└── PAM modules
```

### Lateral Movement

```bash
# Credential reuse
# Check for shared passwords

# Pass-the-hash
psexec.py -hashes :NTLM_HASH admin@target

# Kerberoasting
GetUserSPNs.py domain/user:pass -request

# BloodHound
SharpHound.exe -c All
```

### Evidence Collection

```bash
# Document everything
# Screenshots of:
# - Successful login
# - Accessed data
# - System information
# - Network configuration

# Save logs
# Command history
# Output of commands
# File listings
```

---

## Report Writing Tips

### Report Structure

```markdown
# Executive Summary
- Scope overview
- Key findings
- Risk summary

# Technical Findings
## Critical
### [Finding Name]
- Description
- Evidence (screenshots, logs)
- Impact
- Remediation

## High
...

# Methodology
- Tools used
- Techniques employed
- Timeline

# Recommendations
- Immediate actions
- Long-term improvements
```

### Finding Documentation

```
For each finding, include:

1. Title - Clear, descriptive name
2. Severity - Critical/High/Medium/Low/Info
3. CVSS Score - Quantified risk
4. Description - What was found
5. Evidence - Proof of vulnerability
6. Impact - What an attacker could do
7. Remediation - How to fix it
```

### Evidence Best Practices

```
Screenshot Guidelines:
├── Include URL/address bar
├── Show timestamp
├── Capture full context
├── Use consistent naming
└── Annotate as needed

Log Guidelines:
├── Capture relevant sections
├── Include timestamps
├── Document source
└── Redact sensitive data
```

---

## Career Advice

### Certification Path

```
Beginner:
├── CompTIA Security+
├── CompTIA Pentest+
└── eJPT (eLearnSecurity)

Intermediate:
├── CEH (EC-Council)
├── GPEN (SANS)
└── PNPT (TCM Security)

Advanced:
├── OSCP (Offensive Security)
├── GXPN (GIAC)
└── CREST (UK)

Expert:
├── OSCE (Offensive Security)
├── OSEP (Offensive Security)
└── GXPN with GPEN
```

### Building a Portfolio

```
Portfolio Components:

1. Blog/Write-ups
   - Hack The Box walkthroughs
   - CTF solutions
   - Tool reviews

2. GitHub Projects
   - Custom scripts
   - Security tools
   - Automation

3. Certifications
   - Relevant certs
   - Continuing education

4. Bug Bounties
   - Valid findings
   - Hall of fame

5. Conference Talks
   - Presentations
   - Workshops
```

### Job Search Tips

```
Job Titles:
├── Penetration Tester
├── Security Consultant
├── Red Team Operator
├── Security Analyst
├── Application Security Engineer
└── Security Researcher

Resume Tips:
├── Highlight certifications
├── List technical skills
├── Showcase projects
├── Include CTF achievements
└── Demonstrate continuous learning
```

---

## Common Mistakes

### Technical Mistakes

```bash
# Mistake 1: Not validating scope
# Always confirm scope before testing

# Mistake 2: Skipping reconnaissance
# Recon is crucial for success

# Mistake 3: Not documenting findings
# Document everything as you go

# Mistake 4: Using default wordlists
# Customize wordlists for target

# Mistake 5: Not cleaning up
# Remove all tools and artifacts
```

### Professional Mistakes

```
❌ Not getting written authorization
❌ Exceeding the defined scope
❌ Not reporting all findings
❌ Keeping test data
❌ Sharing findings publicly
❌ Testing production without approval
❌ Ignoring legal requirements
```

### Communication Mistakes

```
❌ Using too much jargon with executives
❌ Not providing context for findings
❌ Delaying critical notifications
❌ Being defensive about findings
❌ Not following up on remediation
```

---

## Pro Tips

### Efficiency Tips

```bash
# Create aliases
alias scan='nmap -sV -sC'
alias web='nikto -h'

# Use scripts
#!/bin/bash
# quick_recon.sh
nmap -sn $1/24
nmap -sV -p 22,80,443 $1

# Organize findings
mkdir -p project/{recon,scans,evidence,report}
```

### Advanced Techniques

```
1. Custom wordlists
   cewl -m 5 -w wordlist.txt http://target

2. DNS brute forcing
   dnsrecon -d target.com -t brt

3. Subdomain takeover
   subjack -w subdomains.txt -t 100

4. SSRF testing
   Test internal services via web app
```

### Time Management

```
Engagement Time Allocation:

Reconnaissance: 30%
├── Passive: 15%
└── Active: 15%

Scanning: 20%
├── Port scanning: 10%
└── Vulnerability scanning: 10%

Exploitation: 30%
├── Finding entry: 15%
└── Post-exploitation: 15%

Reporting: 20%
├── Documentation: 15%
└── Remediation: 5%
```

### Staying Updated

```
Resources:

News:
├── Krebs on Security
├── The Hacker News
├── BleepingComputer
└── SecurityWeek

Podcasts:
├── Darknet Diaries
├── Risky Business
├── Security Now
└── Malicious Life

Social:
├── Twitter/X security community
├── Reddit r/netsec
├── InfoSec Mastodon
└── Discord servers
```

---

## Quick Reference Card

### Essential Commands

```bash
# Recon
nmap -sV target.com
theHarvester -d target.com -b all
dig target.com ANY

# Exploit
msfconsole
use exploit/name
set RHOSTS target
exploit

# Post-exploit
sysinfo
hashdump
shell

# Password
hydra -l admin -P wordlist.txt ssh://target
john hash.txt
hashcat -m 0 hash.txt wordlist.txt
```

### Checklists

```
Pre-Engagement:
□ Authorization obtained
□ Scope defined
□ ROE signed
□ Emergency contacts
□ Testing window

Post-Engagement:
□ All access revoked
□ Tools removed
□ Evidence preserved
□ Report delivered
□ Findings discussed
```

---

*Last Updated: 2024*
