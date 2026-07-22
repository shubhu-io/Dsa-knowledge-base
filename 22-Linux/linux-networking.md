# Linux Networking

This document covers essential Linux networking concepts, commands, and configuration.

## Network Configuration Files

### Network Interfaces
- `/etc/network/interfaces` (Debian/Ubuntu)
- `/etc/sysconfig/network-scripts/ifcfg-*` (RHEL/CentOS)
- `/etc/netplan/*.yaml` (Ubuntu 17+)

### DNS Configuration
- `/etc/resolv.conf` - DNS resolver configuration
- `/etc/hosts` - Local hostname to IP mapping
- `/etc/nsswitch.conf` - Name service switch configuration

### Hostname Configuration
- `/etc/hostname` - System hostname
- `/etc/hosts` - Local hostname entries

## Essential Network Commands

### ifconfig (Legacy) / ip (Modern)
```bash
# View network interfaces (legacy)
ifconfig -a

# View network interfaces (modern)
ip addr show

# Bring interface up/down
sudo ip link set eth0 up
sudo ip link set eth0 down

# Assign IP address
sudo ip addr add 192.168.1.100/24 dev eth0
```

### Route Management
```bash
# View routing table
ip route show

# Add default gateway
sudo ip route add default via 192.168.1.1

# Add static route
sudo ip route add 10.0.0.0/24 via 192.168.1.1
```

### DNS Tools
```bash
# DNS lookup
nslookup example.com
dig example.com

# Resolve hostname
host example.com
getent hosts example.com
```

### Network Testing
```bash
# Ping a host
ping google.com

# Trace network path
traceroute google.com
tracepath google.com

# Test TCP connections
telnet google.com 80
nc -zv google.com 80

# Download a file
curl -O http://example.com/file.txt
wget http://example.com/file.txt
```

## Network Services

### SSH (Secure Shell)
```bash
# Connect to remote server
ssh user@server_ip

# Copy file to remote server
scp file.txt user@server_ip:/path/

# SSH key generation
ssh-keygen -t rsa -b 4096

# View SSH config
cat ~/.ssh/config
```

### Network File System (NFS)
```bash
# Mount NFS share
sudo mount server:/share /mnt/nfs

# View mounted filesystems
df -h
mount | grep nfs
```

### Firewall (ufw/firewalld)
```bash
# UFW (Uncomplicated Firewall)
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw enable

# firewalld (RHEL/CentOS)
sudo firewall-cmd --list-all
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload
```

## Network Troubleshooting

### Network Interface Issues
```bash
# Check link status
ethtool eth0

# Check driver information
ethtool -i eth0

# Check interface statistics
cat /proc/net/dev
```

### Network Connectivity
```bash
# Check DNS resolution
dig @8.8.8.8 google.com

# Check network path
mtr google.com

# Check open ports
ss -tuln
netstat -tuln

# Monitor network traffic
iftop
nethogs
```

### Log Files
```bash
# System logs
journalctl -u networking.service
tail -f /var/log/syslog

# Network-specific logs
tail -f /var/log/kern.log
dmesg | grep eth0
```

## Advanced Networking

### Network Bonding (Link Aggregation)
Configure in `/etc/network/interfaces`:
```
auto bond0
iface bond0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    bond-slaves eth0 eth1
    bond-mode active-backup
    bond-miimon 100
```

### VLAN Configuration
```bash
# Create VLAN interface
sudo ip link add link eth0 name eth0.10 type vlan id 10

# Assign IP to VLAN
sudo ip addr add 192.168.10.100/24 dev eth0.10
```

### Network Namespaces
```bash
# Create namespace
sudo ip netns add ns1

# Move interface to namespace
sudo ip link set eth0 netns ns1

# Execute command in namespace
sudo ip netns exec ns1 ip addr show
```

## Network Security

### TCP Wrappers
- `/etc/hosts.allow` - Allowed hosts
- `/etc/hosts.deny` - Denied hosts

### SSL/TLS Certificates
```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365

# Check certificate information
openssl x509 -in cert.pem -text -noout
```

## Performance Tuning

### Network Kernel Parameters
Edit `/etc/sysctl.conf`:
```
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.ipv4.tcp_congestion_control = bbr
```

Apply changes:
```bash
sudo sysctl -p
```

### Traffic Control (tc)
```bash
# Limit bandwidth
sudo tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms

# View rules
sudo tc qdisc show dev eth0

# Remove rules
sudo tc qdisc del dev eth0 root
```

## See Also

- [[linux-commands]]
- [[linux-guide]]
- [[linux-shell-scripting]]
- [[linux-administration]]
