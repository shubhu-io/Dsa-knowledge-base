# Networking Flashcards

Q&A flashcards covering essential networking concepts for technical interviews.

---

## OSI Model

### Card 1: OSI Model Layers

**Q:** What are the 7 layers of the OSI model?

**A:**

| Layer | Name | Function | Protocols |
|-------|------|----------|-----------|
| 7 | Application | User interface | HTTP, FTP, SMTP |
| 6 | Presentation | Data formatting | SSL/TLS, JPEG |
| 5 | Session | Connection management | NetBIOS, RPC |
| 4 | Transport | End-to-end delivery | TCP, UDP |
| 3 | Network | Routing | IP, ICMP, ARP |
| 2 | Data Link | Frame transmission | Ethernet, WiFi |
| 1 | Physical | Bit transmission | Cables, Hubs |

**Mnemonic:** All People Seem To Need Data Processing

---

### Card 2: TCP/IP Model

**Q:** How does TCP/IP model differ from OSI?

**A:**

| TCP/IP Layer | OSI Layers |
|--------------|------------|
| Application | 5, 6, 7 |
| Transport | 4 |
| Internet | 3 |
| Network Access | 1, 2 |

**TCP/IP is more practical, used in real implementations.**

---

## Transport Layer

### Card 3: TCP vs UDP

**Q:** What are the differences between TCP and UDP?

**A:**

| TCP | UDP |
|-----|-----|
| Connection-oriented | Connectionless |
| Reliable delivery | Best-effort delivery |
| Ordered packets | No ordering guarantee |
| Flow control | No flow control |
| Error checking | Basic error checking |
| Slower | Faster |
| HTTP, SSH, FTP | DNS, VoIP, Gaming |

**TCP:** When reliability matters
**UDP:** When speed matters

---

### Card 4: TCP Three-Way Handshake

**Q:** How does TCP establish a connection?

**A:**

```
Client          Server
  |               |
  |--- SYN ------>|
  |               |
  |<-- SYN-ACK ---|
  |               |
  |--- ACK ------->|
  |               |
  | Connection Established |
```

**Steps:**
1. Client sends SYN
2. Server sends SYN-ACK
3. Client sends ACK
4. Data transfer begins

**Four-Way Teardown:** FIN, ACK, FIN, ACK

---

### Card 5: TCP Flow Control

**Q:** How does TCP handle flow control?

**A:**

**Sliding Window Protocol:**
- Receiver advertises window size
- Sender won't send more than window
- Window adjusts based on buffer space

**Congestion Control:**
- Slow Start
- Congestion Avoidance
- Fast Retransmit
- Fast Recovery

---

## HTTP

### Card 6: HTTP Methods

**Q:** What are the main HTTP methods and their purposes?

**A:**

| Method | Purpose | Idempotent | Safe |
|--------|---------|------------|------|
| GET | Retrieve resource | Yes | Yes |
| POST | Create resource | No | No |
| PUT | Replace resource | Yes | No |
| PATCH | Partial update | No | No |
| DELETE | Remove resource | Yes | No |
| HEAD | Get headers only | Yes | Yes |
| OPTIONS | Get allowed methods | Yes | Yes |

---

### Card 7: HTTP Status Codes

**Q:** What do the different HTTP status code ranges mean?

**A:**

| Code Range | Meaning | Examples |
|------------|---------|----------|
| 1xx | Informational | 100 Continue |
| 2xx | Success | 200 OK, 201 Created, 204 No Content |
| 3xx | Redirection | 301 Moved, 304 Not Modified |
| 4xx | Client Error | 400 Bad Request, 401 Unauthorized, 404 Not Found |
| 5xx | Server Error | 500 Internal Error, 502 Bad Gateway, 503 Unavailable |

---

### Card 8: HTTP Headers

**Q:** What are important HTTP headers?

**A:**

| Header | Purpose |
|--------|---------|
| Content-Type | Data format |
| Authorization | Authentication credentials |
| Cache-Control | Caching directives |
| Cookie | Session data |
| Set-Cookie | Set cookies |
| Host | Target hostname |
| User-Agent | Client software |
| Accept | Acceptable response formats |

---

### Card 9: HTTPS

**Q:** How does HTTPS secure HTTP?

**A:**

**Process:**
1. Client requests HTTPS connection
2. Server sends SSL certificate
3. Client verifies certificate
4. Key exchange occurs
5. Encrypted communication begins

**Provides:**
- Encryption (confidentiality)
- Authentication (identity)
- Integrity (no tampering)

---

## DNS

### Card 10: DNS Resolution

**Q:** How does DNS resolve a domain name?

**A:**

**Steps:**
1. Browser cache
2. OS cache
3. Router cache
4. ISP DNS server
5. Root DNS server
6. TLD server (.com, .org)
7. Authoritative DNS server

**Record Types:**
| Type | Purpose |
|------|---------|
| A | IPv4 address |
| AAAA | IPv6 address |
| CNAME | Alias to another domain |
| MX | Mail server |
| TXT | Text records |

---

### Card 11: DNS Load Balancing

**Q:** How can DNS be used for load balancing?

**A:**

**Methods:**
1. **Round Robin:** Multiple A records
2. **Geo DNS:** Different IPs by location
3. **Weighted:** Different distribution ratios

**Limitations:**
- TTL caching
- No health checks
- Uneven distribution

---

## IP Addressing

### Card 12: IPv4 vs IPv6

**Q:** What are the differences between IPv4 and IPv6?

**A:**

| IPv4 | IPv6 |
|------|------|
| 32-bit address | 128-bit address |
| ~4 billion addresses | 3.4×10³⁸ addresses |
| Dotted decimal | Hexadecimal |
| Broadcast | Multicast only |
| ARP for MAC | NDP |

---

### Card 13: Subnetting

**Q:** What is subnetting and why is it used?

**A:**

**Subnetting:** Dividing a network into smaller sub-networks.

**Benefits:**
- Better organization
- Improved security
- Reduced broadcast domain
- Efficient IP usage

**Example:**
- 192.168.1.0/24 = 256 addresses
- 192.168.1.0/25 = 128 addresses
- 192.168.1.0/26 = 64 addresses

---

### Card 14: NAT

**Q:** What is Network Address Translation (NAT)?

**A:**

**NAT:** Maps private IPs to public IP.

**Types:**
- **Static NAT:** One-to-one mapping
- **Dynamic NAT:** Pool of public IPs
- **PAT (Port Address Translation):** Multiple private to one public

**Benefits:**
- Conserves public IPs
- Security (hides internal network)
- Simplified network design

---

## Routing

### Card 15: Routing Algorithms

**Q:** What are common routing algorithms?

**A:**

| Algorithm | Type | Use Case |
|-----------|------|----------|
| Distance Vector | Distributed | Small networks (RIP) |
| Link State | Centralized | Large networks (OSPF) |
| Path Vector | Policy-based | Internet (BGP) |

**Dijkstra's:** Used in OSPF
**Bellman-Ford:** Used in RIP
**BGP:** Used between ISPs

---

### Card 16: ARP

**Q:** What is ARP and how does it work?

**A:**

**ARP (Address Resolution Protocol):** Maps IP to MAC address.

**Process:**
1. Host knows destination IP
2. Broadcasts ARP request
3. Target responds with MAC
4. Host caches the mapping

**ARP Cache:** Temporary storage of IP-MAC mappings

---

## Web Technologies

### Card 17: REST API

**Q:** What are the principles of REST API design?

**A:**

**Principles:**
1. Client-server architecture
2. Stateless
3. Cacheable
4. Uniform interface
5. Layered system

**Best Practices:**
- Use nouns for resources
- Use HTTP methods correctly
- Return appropriate status codes
- Version your API
- Use pagination

---

### Card 18: WebSockets

**Q:** How do WebSockets differ from HTTP?

**A:**

| HTTP | WebSocket |
|------|-----------|
| Request-response | Full-duplex |
| Stateless | Stateful connection |
| High overhead | Low overhead |
| Pull model | Push model |

**Use cases:** Chat apps, live feeds, gaming, collaboration tools

---

## Security

### Card 19: SSL/TLS

**Q:** What is the difference between SSL and TLS?

**A:**

**TLS (Transport Layer Security):**
- Successor to SSL
- Current standard (TLS 1.3)
- Encrypts data in transit

**Handshake Process:**
1. ClientHello (supported ciphers)
2. ServerHello (chosen cipher)
3. Certificate exchange
4. Key exchange
5. Encrypted communication

---

### Card 20: Firewalls

**Q:** What are the types of firewalls?

**A:**

| Type | Layer | Function |
|------|-------|----------|
| Packet Filtering | Network | Check headers |
| Stateful | Transport | Track connections |
| Application | Application | Inspect content |
| Next-Gen | Multiple | Combined features |

---

## Performance

### Card 21: CDN

**Q:** What is a CDN and how does it improve performance?

**A:**

**CDN (Content Delivery Network):** Distributed servers delivering content.

**Benefits:**
- Reduced latency
- Improved availability
- DDoS protection
- Reduced bandwidth costs

**Types:**
- Push CDN: Origin pushes to CDN
- Pull CDN: CDN pulls from origin

---

### Card 22: Caching at Network Level

**Q:** What are network-level caching mechanisms?

**A:**

| Mechanism | Description |
|-----------|-------------|
| Browser Cache | Stores responses locally |
| Proxy Cache | Intermediate server cache |
| DNS Cache | Stores DNS lookups |
| CDN Cache | Edge server cache |

**Cache Headers:**
- Cache-Control
- ETag
- Last-Modified
- Expires

---

## Common Protocols

### Card 23: Port Numbers

**Q:** What are common port numbers?

**A:**

| Port | Protocol | Service |
|------|----------|---------|
| 22 | TCP | SSH |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 6379 | TCP | Redis |
| 8080 | TCP | HTTP Alt |

---

### Card 24: ICMP

**Q:** What is ICMP and when is it used?

**A:**

**ICMP (Internet Control Message Protocol):** Network diagnostics.

**Use cases:**
- Ping (connectivity test)
- Traceroute (path discovery)
- Destination unreachable
- Time exceeded

**Not used for data transfer, only control messages.**

---

### Card 25: DHCP

**Q:** How does DHCP assign IP addresses?

**A:**

**DHCP (Dynamic Host Configuration Protocol):**

**Process (DORA):**
1. **Discover:** Client broadcasts
2. **Offer:** Server offers IP
3. **Request:** Client requests IP
4. **Acknowledge:** Server confirms

**Provides:**
- IP address
- Subnet mask
- Default gateway
- DNS servers

---

## Quick Reference

### Network Commands

```bash
# Connectivity
ping google.com
traceroute google.com
telnet example.com 80

# DNS
nslookup example.com
dig example.com
host example.com

# Configuration
ipconfig /all        # Windows
ifconfig             # Linux/Mac
netstat -an          # Connections
ss -tuln             # Listening ports

# Diagnostics
curl -v https://example.com
wget https://example.com
```

### Network Troubleshooting Checklist

```
□ Is physical connection OK?
□ Can you ping gateway?
□ Can you ping external IP?
□ Can you resolve DNS?
□ Can you connect to port?
□ Is firewall blocking?
□ Is proxy configured?
□ Is DNS working?
```

---

## Interview Focus Areas

### Must Know

1. TCP vs UDP differences
2. HTTP methods and status codes
3. DNS resolution process
4. OSI model layers
5. How HTTPS works
6. REST API principles
7. Load balancing algorithms
8. Caching strategies

### Common Questions

- "Explain the TCP handshake"
- "What happens when you type a URL?"
- "How does DNS work?"
- "Difference between TCP and UDP?"
- "What is NAT and why do we need it?"
