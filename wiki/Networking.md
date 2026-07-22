# Networking

## Overview

Networking is the foundation of modern software systems. Understanding how
data moves across networks is essential for backend development, system design,
and debugging distributed applications.

---

## OSI Model (7 Layers)

The Open Systems Interconnection model conceptualizes network communication
as seven abstraction layers.

| Layer # | Name           | Description                          | Examples              |
|---------|---------------|--------------------------------------|-----------------------|
| 7       | Application    | User-facing protocols                | HTTP, FTP, SMTP, DNS  |
| 6       | Presentation   | Data formatting, encryption          | SSL/TLS, JPEG, ASCII  |
| 5       | Session        | Managing connections                 | NetBIOS, RPC          |
| 4       | Transport      | End-to-end communication             | TCP, UDP              |
| 3       | Network        | Routing and addressing               | IP, ICMP, routers     |
| 2       | Data Link      | Frame transfer on local network      | Ethernet, MAC, switch |
| 1       | Physical       | Raw bit transmission                 | Cables, WiFi, hub     |

### Mnemonic: "All People Seem To Need Data Processing"

---

## TCP vs UDP

| Feature          | TCP                           | UDP                          |
|-----------------|-------------------------------|------------------------------|
| Connection       | Connection-oriented          | Connectionless               |
| Reliability      | Guaranteed delivery          | Best-effort delivery         |
| Order            | Ordered                      | Unordered                    |
| Speed            | Slower (overhead)            | Faster (minimal overhead)    |
| Use Case         | Web, email, file transfer    | Streaming, gaming, DNS       |
| Header Size      | 20 bytes                     | 8 bytes                      |
| Flow Control     | Yes                          | No                           |

### TCP Three-Way Handshake

```
Client          Server
  |---- SYN ---->|
  |<--- SYN-ACK--|
  |---- ACK ---->|
  |   Connected   |
```

### TCP Four-Way Termination

```
Client          Server
  |---- FIN ---->|
  |<--- ACK -----|
  |<--- FIN -----|
  |---- ACK ---->|
  |  Disconnected |
```

---

## HTTP/HTTPS Basics

### HTTP Methods

| Method   | Purpose              | Idempotent | Safe  |
|---------|----------------------|------------|-------|
| GET      | Retrieve resource    | Yes        | Yes   |
| POST     | Create resource      | No         | No    |
| PUT      | Update resource      | Yes        | No    |
| DELETE   | Delete resource      | Yes        | No    |
| PATCH    | Partial update       | No         | No    |
| HEAD     | Headers only         | Yes        | Yes   |

### Common HTTP Status Codes

| Code  | Meaning                     |
|-------|-----------------------------|
| 200   | OK (success)                |
| 201   | Created                     |
| 301   | Moved permanently           |
| 304   | Not modified (cached)       |
| 400   | Bad request                 |
| 401   | Unauthorized                |
| 403   | Forbidden                   |
| 404   | Not found                   |
| 429   | Too many requests           |
| 500   | Internal server error       |
| 503   | Service unavailable         |

### HTTPS

- HTTP over TLS (Transport Layer Security)
- Encrypts data in transit
- Uses certificates for server identity verification
- Default port: 443

---

## DNS Resolution Process

DNS (Domain Name System) translates domain names to IP addresses.

```
1. Browser checks local cache
       |
       v (miss)
2. OS checks hosts file
       |
       v (miss)
3. Query to recursive resolver (ISP)
       |
       v (miss)
4. Root DNS server -> TLD server (.com)
       |
       v
5. Authoritative DNS server
       |
       v
6. Returns IP address to browser
```

### DNS Record Types

| Record | Purpose                              |
|--------|--------------------------------------|
| A      | Maps domain to IPv4 address          |
| AAAA   | Maps domain to IPv6 address          |
| CNAME  | Alias to another domain              |
| MX     | Mail server for domain               |
| TXT    | Text information (SPF, DKIM)         |
| NS     | Name server for domain               |

---

## Common Ports

| Port | Protocol    | Service               |
|------|------------|-----------------------|
| 20   | TCP        | FTP (data)            |
| 21   | TCP        | FTP (control)         |
| 22   | TCP        | SSH                   |
| 23   | TCP        | Telnet                |
| 25   | TCP        | SMTP                  |
| 53   | UDP/TCP    | DNS                   |
| 80   | TCP        | HTTP                  |
| 110  | TCP        | POP3                  |
| 143  | TCP        | IMAP                  |
| 443  | TCP        | HTTPS                 |
| 3306 | TCP        | MySQL                 |
| 5432 | TCP        | PostgreSQL            |
| 6379 | TCP        | Redis                 |
| 8080 | TCP        | HTTP Alternate        |
| 27017| TCP        | MongoDB               |

---

## Common Interview Questions

1. Explain the difference between TCP and UDP
2. What happens when you type a URL in the browser?
3. How does DNS resolution work?
4. What are the OSI layers and their purposes?
5. What is the difference between HTTP and HTTPS?

---

## See Also

- [[System-Design]]
- [[Operating-System]]
- [[Databases]]
- [[Low-Level-Design]]
- [[Competitive-Programming]]

---

> Full content: [17-Computer-Networks](../17-Computer-Networks/)
