# Network Security Fundamentals

This document covers essential network security concepts and practices.

## Network Security Overview

Network security involves policies, processes, and practices designed to protect networks, data, and devices from unauthorized access, misuse, or theft.

## Common Network Attacks

### Man-in-the-Middle (MITM)
Attacker intercepts communication between two parties.

**Prevention:**
- Use HTTPS/SSL/TLS encryption
- Implement certificate pinning
- Use VPN for sensitive communications

### Distributed Denial of Service (DDoS)
Attacker overwhelms systems with traffic from multiple sources.

**Prevention:**
- Use DDoS protection services (Cloudflare, AWS Shield)
- Implement rate limiting
- Configure traffic filtering
- Have an incident response plan

### SQL Injection
Attacker inserts malicious SQL code through input fields.

**Prevention:**
- Use parameterized queries
- Validate and sanitize input
- Apply principle of least privilege
- Use Web Application Firewalls (WAF)

### Cross-Site Scripting (XSS)
Attacker injects malicious scripts into web pages viewed by users.

**Prevention:**
- Encode output data
- Implement Content Security Policy (CSP)
- Validate and sanitize input
- Use HTTP-only cookies

## Firewall Configuration

### Types of Firewalls
1. **Packet Filtering**: Examines packet headers
2. **Stateful Inspection**: Tracks connection state
3. **Application Layer**: Deep packet inspection
4. **Next-Generation**: Advanced threat prevention

### iptables Configuration
```bash
# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block all other incoming
sudo iptables -A INPUT -j DROP

# Save rules
sudo iptables-save > /etc/iptables/rules.v4
```

### firewalld Configuration
```bash
# Add service
sudo firewall-cmd --add-service=http --permanent

# Add port
sudo firewall-cmd --add-port=8080/tcp --permanent

# Reload
sudo firewall-cmd --reload
```

## VPN Technologies

### OpenVPN Setup
```bash
# Install OpenVPN
sudo apt install openvpn

# Generate certificates
easyrsa build-client-full client1 nopass

# Connect
sudo openvpn --config client1.ovpn
```

### WireGuard
```bash
# Install WireGuard
sudo apt install wireguard

# Generate keys
wg genkey | tee privatekey | wg pubkey > publickey

# Configure
sudo wg-quick up wg0
```

## Intrusion Detection Systems (IDS)

### Snort
```bash
# Install Snort
sudo apt install snort

# Test configuration
sudo snort -T -c /etc/snort/snort.conf

# Run in IDS mode
sudo snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i eth0
```

## Network Monitoring

### Wireshark
- Network protocol analyzer
- Capture and analyze network traffic
- Useful for troubleshooting and security analysis

### tcpdump
```bash
# Capture traffic on interface
sudo tcpdump -i eth0 -w capture.pcap

# Capture specific port
sudo tcpdump -i eth0 port 80

# Read captured file
tcpdump -r capture.pcap
```

### nmap
```bash
# Scan target
nmap -sV target_ip

# Aggressive scan
nmap -A target_ip

# Scan specific ports
nmap -p 80,443 target_ip
```

## SSL/TLS Security

### Certificate Management
```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365

# Check certificate
openssl x509 -in cert.pem -text -noout

# Verify certificate chain
openssl verify -CAfile ca.pem cert.pem
```

### TLS Configuration
- Use TLS 1.2 or higher
- Disable weak cipher suites
- Enable HSTS (HTTP Strict Transport Security)
- Implement certificate pinning

## Access Control

### Network Access Control (NAC)
- 802.1X authentication
- RADIUS/TACACS+ servers
- Device profiling and posture assessment

### Role-Based Access Control (RBAC)
- Define roles and permissions
- Assign users to roles
- Audit access logs regularly

## Security Best Practices

### Defense in Depth
- Multiple layers of security controls
- No single point of failure
- Redundancy and failover

### Principle of Least Privilege
- Grant minimum necessary access
- Regular access reviews
- Remove unused permissions

### Security Monitoring
- Centralized logging (SIEM)
- Real-time alerting
- Regular security audits

## Incident Response

### Response Steps
1. **Preparation**: Have a plan and team ready
2. **Detection**: Identify security incidents
3. **Containment**: Limit damage and spread
4. **Eradication**: Remove the threat
5. **Recovery**: Restore normal operations
6. **Lessons Learned**: Improve defenses

## Compliance Standards

### Common Standards
- **PCI DSS**: Payment card industry
- **HIPAA**: Healthcare data
- **GDPR**: European data protection
- **SOC 2**: Service organization controls

## See Also

- [[networking-guide]]
- [[networking-protocols]]
- [[networking-cheatsheet]]
- [[networking-interview-questions]]
