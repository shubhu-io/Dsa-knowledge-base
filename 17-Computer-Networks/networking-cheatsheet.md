# Networking Cheat Sheet

## Common Ports

| Port | Protocol | Service |
|------|----------|---------|
| 20/21 | TCP | FTP |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 67/68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 143 | TCP | IMAP |
| 443 | TCP | HTTPS |
| 993 | TCP | IMAPS |
| 995 | TCP | POP3S |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 6379 | TCP | Redis |
| 8080 | TCP | HTTP Alt |

## Network Commands

### Windows
```
ipconfig          # View IP configuration
ping host         # Test connectivity
tracert host      # Trace route
nslookup domain   # DNS lookup
netstat -an       # View connections
```

### Linux/Mac
```
ifconfig          # View IP configuration
ping host         # Test connectivity
traceroute host   # Trace route
dig domain        # DNS lookup
netstat -tuln     # View connections
ss -tuln          # Socket statistics
curl url          # HTTP requests
wget url          # Download files
```

## Subnet Cheat Sheet

| CIDR | Subnet Mask | Hosts |
|------|-------------|-------|
| /8 | 255.0.0.0 | 16M |
| /16 | 255.255.0.0 | 65K |
| /24 | 255.255.255.0 | 254 |
| /25 | 255.255.255.128 | 126 |
| /26 | 255.255.255.192 | 62 |
| /27 | 255.255.255.224 | 30 |
| /28 | 255.255.255.240 | 14 |
| /29 | 255.255.255.248 | 6 |
| /30 | 255.255.255.252 | 2 |

## HTTP Headers

### Request Headers
```
Host: example.com
User-Agent: Mozilla/5.0
Accept: text/html
Authorization: Bearer token
Content-Type: application/json
```

### Response Headers
```
Content-Type: text/html
Content-Length: 1234
Cache-Control: max-age=3600
Set-Cookie: session=abc123
```

## SSL/TLS

### Certificate Chain
```
Root CA → Intermediate CA → Server Certificate
```

### Ports
- HTTP: 80
- HTTPS: 443
- SSL: 465
- TLS: 587