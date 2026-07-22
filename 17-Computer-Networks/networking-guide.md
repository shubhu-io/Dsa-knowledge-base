# Computer Networks Guide

## OSI Model

### 7 Layers

| Layer | Name | Protocol | Description |
|-------|------|----------|-------------|
| 7 | Application | HTTP, FTP, SMTP | User interface |
| 6 | Presentation | SSL, JPEG | Data formatting |
| 5 | Session | NetBIOS | Session management |
| 4 | Transport | TCP, UDP | End-to-end communication |
| 3 | Network | IP, ICMP | Routing |
| 2 | Data Link | Ethernet, WiFi | Frame transmission |
| 1 | Physical | Cables, Signals | Bit transmission |

## TCP/IP Model

### 4 Layers
1. **Application**: HTTP, DNS, FTP
2. **Transport**: TCP, UDP
3. **Internet**: IP, ICMP
4. **Network Access**: Ethernet, WiFi

## TCP vs UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | Best effort |
| Ordering | Ordered | Unordered |
| Speed | Slower | Faster |
| Header | 20 bytes | 8 bytes |
| Use | Web, email, file transfer | Streaming, gaming, DNS |

## HTTP/HTTPS

### HTTP Methods
- **GET**: Retrieve data
- **POST**: Create resource
- **PUT**: Update resource
- **DELETE**: Remove resource
- **PATCH**: Partial update

### Status Codes
| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 301 | Moved Permanently |
| 304 | Not Modified |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |
| 503 | Service Unavailable |

### HTTPS
- HTTP + SSL/TLS encryption
- Port 443
- Certificate-based authentication

## DNS

### How DNS Works
1. Browser checks cache
2. OS checks cache
3. Router checks cache
4. ISP DNS server
5. Root DNS server
6. TLD DNS server
7. Authoritative DNS server

### Record Types
- **A**: Domain → IPv4
- **AAAA**: Domain → IPv6
- **CNAME**: Alias to another domain
- **MX**: Mail server
- **NS**: Name server
- **TXT**: Text information

## IP Addressing

### IPv4
- 32-bit address
- Dotted decimal (192.168.1.1)
- ~4.3 billion addresses

### IPv6
- 128-bit address
- Hexadecimal notation
- Virtually unlimited addresses

### Subnetting
- Divides network into smaller segments
- Subnet mask determines network/host portions

## Common Protocols

| Protocol | Port | Purpose |
|----------|------|---------|
| HTTP | 80 | Web |
| HTTPS | 443 | Secure web |
| FTP | 21 | File transfer |
| SSH | 22 | Secure shell |
| SMTP | 25 | Email |
| DNS | 53 | Domain resolution |
| DHCP | 67/68 | IP assignment |

## Network Devices

- **Hub**: Broadcasts to all ports
- **Switch**: Forwards to specific port
- **Router**: Routes between networks
- **Firewall**: Filters traffic
- **Load Balancer**: Distributes traffic

## Security

### SSL/TLS Handshake
1. Client Hello
2. Server Hello + Certificate
3. Key Exchange
4. Encrypted Communication

### VPN
- Encrypted tunnel
- Remote access
- Privacy protection