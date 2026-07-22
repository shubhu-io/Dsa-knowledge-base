# Computer Networks Interview Questions

## Top Interview Questions

### Basic Concepts

**Q: What is the difference between TCP and UDP?**
A: TCP is connection-oriented, reliable, and ordered. UDP is connectionless, unreliable, and faster. TCP is used for web/email; UDP for streaming/gaming.

**Q: What happens when you type a URL in a browser?**
A: DNS resolution → TCP connection → HTTP request → Server processing → HTTP response → Browser rendering.

**Q: What is the OSI model?**
A: 7-layer model: Physical, Data Link, Network, Transport, Session, Presentation, Application.

### HTTP Questions

**Q: What is the difference between HTTP and HTTPS?**
A: HTTPS adds SSL/TLS encryption for secure communication. Port 443 vs 80.

**Q: Explain HTTP methods and their purposes.**
A: GET (retrieve), POST (create), PUT (update), DELETE (remove), PATCH (partial update).

**Q: What are HTTP status codes?**
A: 2xx (success), 3xx (redirect), 4xx (client error), 5xx (server error).

### TCP/IP Questions

**Q: What is the TCP three-way handshake?**
A: SYN → SYN-ACK → ACK. Establishes connection before data transfer.

**Q: What is the difference between a switch and a router?**
A: Switch operates at Layer 2 (MAC addresses), Router at Layer 3 (IP addresses).

**Q: What is NAT?**
A: Network Address Translation maps private IPs to public IPs for internet access.

### DNS Questions

**Q: How does DNS resolution work?**
A: Recursive query through: Browser → OS → Router → ISP → Root → TLD → Authoritative server.

**Q: What is DNS caching?**
A: Storing DNS results temporarily to reduce lookup time.

### Advanced Questions

**Q: What is a CDN?**
A: Content Delivery Network caches content at edge locations for faster delivery.

**Q: What is a load balancer?**
A: Distributes incoming traffic across multiple servers to ensure availability.

**Q: Explain the concept of virtual hosting.**
A: Multiple domains hosted on single server using Host header.

## Coding Questions

**Q: Implement a simple HTTP client.**
```python
import socket

def http_get(url):
    host = url.split('/')[2]
    path = '/' + '/'.join(url.split('/')[3:])
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((host, 80))
    
    request = f"GET {path} HTTP/1.1\r\nHost: {host}\r\n\r\n"
    sock.send(request.encode())
    
    response = sock.recv(4096)
    sock.close()
    
    return response.decode()
```

**Q: Implement a simple DNS resolver.**
```python
import socket

def dns_lookup(domain):
    try:
        ip = socket.gethostbyname(domain)
        return ip
    except socket.gaierror:
        return None
```

## Resources

- Computer Networking: A Top-Down Approach
- TCP/IP Illustrated
- RFC documents