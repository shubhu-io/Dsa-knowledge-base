# Linux Administration Guide

## 1. System Information

### System Identification

```bash
uname -a                # All system information
uname -r                # Kernel version
hostname                # System hostname
hostnamectl             # Full hostname info (systemd)
lsb_release -a          # Distribution info
cat /etc/os-release     # OS identification
cat /etc/redhat-release # RHEL/CentOS specific
uptime                  # Uptime and load averages
date                    # Current date and time
timedatectl             # Timezone and NTP status
```

### Hardware Information

```bash
# CPU
lscpu                   # CPU architecture
cat /proc/cpuinfo       # Detailed CPU info
nproc                   # Number of CPU cores

# Memory
free -h                 # Memory usage
cat /proc/meminfo       # Detailed memory info
lsmem                   # Memory layout

# Disk
lsblk                   # Block devices
fdisk -l                # Disk partitions
blkid                   # Block device UUIDs
hdparm -I /dev/sda      # Disk drive info

# PCI devices
lspci                   # List PCI devices
lspci -v                # Verbose
lspci -k                # Kernel drivers

# USB devices
lsusb                   # List USB devices

# All hardware
lshw                    # Full hardware list
lshw -short             # Summary
lshw -html > hw.html    # HTML report
```

---

## 2. Service Management (systemd)

### Core Commands

```bash
# Start/stop/restart
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl reload nginx       # Reload config without restart

# Enable/disable on boot
systemctl enable nginx
systemctl disable nginx

# Check status
systemctl status nginx

# Mask/unmask (prevent manual start)
systemctl mask nginx
systemctl unmask nginx

# List services
systemctl list-units --type=service
systemctl list-units --type=service --state=running
systemctl list-unit-files --type=service
```

### Service States

| State | Description |
|-------|-------------|
| **active (running)** | Currently running |
| **active (exited)** | One-shot service completed |
| **inactive (dead)** | Not running |
| **failed** | Exited with error |
| **activating** | Starting up |
| **deactivating** | Shutting down |

### Creating Custom Services

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Custom Application
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/start.sh
ExecStop=/opt/myapp/stop.sh
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/myapp

[Install]
WantedBy=multi-user.target
```

```bash
# Reload after creating service file
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp
```

### Journal (Logs)

```bash
# View logs for a service
journalctl -u nginx
journalctl -u nginx --since "1 hour ago"
journalctl -u nginx --since "2024-01-01" --until "2024-01-02"
journalctl -u nginx -f              # Follow (like tail -f)
journalctl -u nginx -n 50           # Last 50 lines
journalctl -u nginx --no-pager      # Don't paginate

# System logs
journalctl -b                       # Current boot
journalctl -b -1                    # Previous boot
journalctl --priority=err           # Errors only
journalctl -p warning..emerg        # Warning and above
journalctl --disk-usage             # Journal size
journalctl --vacuum-size=100M       # Limit journal size
```

---

## 3. User and Group Administration

### User Management

```bash
# Create user
useradd -m -s /bin/bash -c "Full Name" username
passwd username

# Create user with expiry
useradd -m -e 2025-12-31 username

# Modify user
usermod -aG sudo username           # Add to supplementary group
usermod -s /bin/zsh username         # Change shell
usermod -L username                  # Lock account
usermod -U username                  # Unlock account
usermod -d /new/home username        # Change home directory

# Delete user
userdel username                     # Keep home directory
userdel -r username                  # Remove home directory

# View user info
id username
getent passwd username
chage -l username                    # Password aging info
```

### Password Policies

```bash
# Password aging
chage -M 90 username          # Max 90 days between changes
chage -m 7 username           # Min 7 days between changes
chage -W 14 username          # Warning 14 days before expiry
chage -E 2025-12-31 username  # Account expiry date

# Force password change on next login
chage -d 0 username

# View password policy
chage -l username
```

### Group Management

```bash
groupadd developers
groupadd -g 1500 developers    # With specific GID
groupdel developers
groupmod -n newname oldname

# Add/remove users from groups
usermod -aG groupname username    # Add (append)
gpasswd -a username groupname     # Add
gpasswd -d username groupname     # Remove
```

### sudo Configuration

```bash
# Edit sudoers (NEVER edit directly)
visudo

# Common sudoers entries
username    ALL=(ALL:ALL) ALL           # Full access
username    ALL=(ALL:ALL) NOPASSWD:ALL  # No password
%groupname  ALL=(ALL:ALL) ALL           # Group access
username    ALL=(ALL:ALL) /usr/bin/systemctl restart nginx  # Specific command
```

---

## 4. Disk Management

### Partitioning

```bash
# MBR partitioning (fdisk)
fdisk /dev/sdb
# Commands: n (new), d (delete), p (print), w (write), t (type)

# GPT partitioning (gdisk or parted)
gdisk /dev/sdb
parted /dev/sdb
```

### Filesystem Creation

```bash
mkfs.ext4 /dev/sdb1
mkfs.xfs /dev/sdb1
mkfs.vfat -F 32 /dev/sdb1
mkfs.ntfs /dev/sdb1
```

### Mounting

```bash
# Temporary mount
mount /dev/sdb1 /mnt/data
mount -o rw,noexec,nosuid /dev/sdb1 /mnt/data

# Mount ISO
mount -o loop /path/to/image.iso /mnt/iso

# Mount NFS
mount -t nfs server:/share /mnt/nfs

# Mount CIFS/SMB
mount -t cifs //server/share /mnt/smb -o username=user,password=pass

# Unmount
umount /mnt/data
umount -l /mnt/data            # Lazy unmount

# Auto-mount in /etc/fstab
# <device>    <mount>    <type>    <options>    <dump>    <pass>
UUID=xxx-xxx  /mnt/data  ext4      defaults     0         2

# Find UUID
blkid /dev/sdb1
```

### LVM (Logical Volume Management)

```bash
# Physical Volumes
pvcreate /dev/sdb /dev/sdc
pvs                         # List PVs
pvdisplay                   # Detailed PV info

# Volume Groups
vgcreate myvg /dev/sdb /dev/sdc
vgs                         # List VGs
vgdisplay                   # Detailed VG info
vgextend myvg /dev/sdd      # Add disk to VG

# Logical Volumes
lvcreate -L 10G -n mydata myvg
lvcreate -l 100%FREE -n mylog myvg
lvs                         # List LVs
lvdisplay                   # Detailed LV info

# Extend LV
lvextend -L +5G /dev/myvg/mydata
lvextend -l +100%FREE /dev/myvg/mydata
resize2fs /dev/myvg/mydata     # ext4
xfs_growfs /dev/myvg/mydata    # XFS

# Reduce LV (ext4 only, must unmount first)
umount /dev/myvg/mydata
e2fsck -f /dev/myvg/mydata
resize2fs /dev/myvg/mydata 5G
lvreduce -L 5G /dev/myvg/mydata
```

### RAID

```bash
# Software RAID with mdadm
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm --detail /dev/md0
cat /proc/mdstat

# Monitor RAID
mdadm --monitor --scan
```

---

## 5. Network Configuration

### Network Interfaces

```bash
# Show interfaces
ip addr show
ip -br addr show              # Brief format

# Show status
ip link show
ethtool eth0                  # Interface details

# Configure interface
ip addr add 192.168.1.100/24 dev eth0
ip addr del 192.168.1.100/24 dev eth0
ip link set eth0 up
ip link set eth0 down

# Routing
ip route show
ip route add default via 192.168.1.1
ip route add 10.0.0.0/8 via 192.168.1.254
ip route del 10.0.0.0/8

# DNS
cat /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
systemd-resolve --status
```

### Network Configuration Files

```bash
# Debian/Ubuntu: /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8

# RHEL/CentOS: /etc/sysconfig/network-scripts/ifcfg-eth0
BOOTPROTO=static
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
ONBOOT=yes
```

### DNS Configuration

```bash
# /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search example.com

# /etc/hosts
192.168.1.10   server1.example.com   server1
192.168.1.11   server2.example.com   server2
```

### Firewall (iptables)

```bash
# View rules
iptables -L -n -v
iptables -L -n --line-numbers

# Allow connections
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow from specific IP
iptables -A INPUT -s 192.168.1.0/24 -p tcp --dport 3306 -j ACCEPT

# Drop connections
iptables -A INPUT -j DROP

# Delete rule
iptables -D INPUT 3

# Save rules
iptables-save > /etc/iptables/rules.v4

# Restore rules
iptables-restore < /etc/iptables/rules.v4
```

### Firewall (UFW - Ubuntu)

```bash
ufw status
ufw status verbose
ufw enable
ufw disable

ufw default deny incoming
ufw default allow outgoing

ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow from 192.168.1.0/24
ufw allow from 192.168.1.100 to any port 3306

ufw delete allow 80/tcp
```

### Firewall (firewalld - RHEL)

```bash
firewall-cmd --state
firewall-cmd --list-all
firewall-cmd --list-ports
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --remove-port=80/tcp --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --reload
```

---

## 6. Security Hardening

### SSH Hardening

```bash
# /etc/ssh/sshd_config
Port 2222                          # Non-standard port
PermitRootLogin no                 # Disable root login
PasswordAuthentication no          # Key-based only
PubkeyAuthentication yes           # Enable key auth
MaxAuthTries 3                     # Limit auth attempts
AllowUsers user1 user2             # Whitelist users
ClientAliveInterval 300            # Timeout idle connections
ClientAliveCountMax 2
Protocol 2                         # SSH protocol version
X11Forwarding no                   # Disable X11 forwarding
```

### Fail2Ban

```bash
# Install
apt install fail2ban

# Configure
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600

# Commands
fail2ban-client status
fail2ban-client status sshd
fail2ban-client set sshd unbanip 192.168.1.100
```

### AppArmor / SELinux

```bash
# AppArmor (Ubuntu)
aa-status                       # Status
aa-enforce /usr/sbin/nginx       # Enforce profile
aa-complain /usr/sbin/nginx      # Set to complain mode

# SELinux (RHEL)
getenforce                      # Check mode
setenforce 0                    # Permissive (temporary)
setenforce 1                    # Enforcing (temporary)
semanage port -a -t http_port_t -p tcp 8080  # Allow port
```

### File Permissions Security

```bash
# Find world-writable files
find / -type f -perm -0002 -exec ls -la {} \;

# Find SUID/SGID files
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -la {} \;

# Find files owned by nobody
find / -nouser -o -nogroup

# Fix permissions
chmod 600 /etc/shadow
chmod 644 /etc/passwd
chmod 700 /root
```

---

## 7. Log Management

### Log Files

| File | Purpose |
|------|---------|
| `/var/log/syslog` | System log (Debian/Ubuntu) |
| `/var/log/messages` | System log (RHEL/CentOS) |
| `/var/log/auth.log` | Authentication log |
| `/var/log/kern.log` | Kernel log |
| `/var/log/dmesg` | Boot messages |
| `/var/log/dpkg.log` | Package installation |
| `/var/log/apt/` | APT package manager |
| `/var/log/nginx/` | Nginx web server |
| `/var/log/apache2/` | Apache web server |
| `/var/log/mysql/` | MySQL database |

### Logrotate

```bash
# Configuration
# /etc/logrotate.d/myapp
/var/log/myapp/*.log {
    daily               # Rotate daily
    rotate 30           # Keep 30 rotations
    compress            # Compress old logs
    delaycompress       # Delay compression by one rotation
    missingok           # Don't error if log missing
    notifempty          # Don't rotate empty files
    create 0644 www-data www-data
    sharedscripts       # Run postrotate once for all matching
    postrotate
        systemctl reload myapp > /dev/null 2>&1 || true
    endscript
}

# Test configuration
logrotate -d /etc/logrotate.d/myapp

# Force rotation
logrotate -f /etc/logrotate.d/myapp
```

---

## 8. Backup Strategies

### Backup Tools

| Tool | Type | Best For |
|------|------|----------|
| `rsync` | Incremental sync | File-level backup |
| `tar` | Archive | Simple backups |
| `borgbackup` | Deduplicating | Efficient backups |
| `restic` | Deduplicating | Encrypted backups |
| `dd` | Block-level | Disk imaging |
| `mysqldump` | Database | MySQL/MariaDB |

### rsync

```bash
# Local sync
rsync -avz /source/ /destination/

# Remote sync
rsync -avz -e ssh /local/path/ user@remote:/remote/path/

# Incremental backup
rsync -avz --delete --backup --backup-dir=/backups/$(date +%Y%m%d) \
    /source/ /destination/

# Include/exclude patterns
rsync -avz --include='*.conf' --exclude='*.log' /source/ /dest/

# Dry run (preview changes)
rsync -avzn /source/ /destination/
```

### tar Backup

```bash
# Full backup
tar -czvf /backup/full-$(date +%Y%m%d).tar.gz /home /etc /var/www

# Incremental backup
tar -czvf /backup/incr-$(date +%Y%m%d).tar.gz \
    --listed-incremental=/backup/snapshot.file /home

# Restore from incremental
tar -xzvf /backup/full-20240101.tar.gz -C /
tar -xzvf /backup/incr-20240102.tar.gz -C /
```

### Automated Backup Script

```bash
#!/bin/bash
set -euo pipefail

BACKUP_DIR="/backup"
SOURCE="/home /etc /var/www"
RETENTION_DAYS=30
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_DIR/backup-$DATE.tar.gz" $SOURCE

# Cleanup old backups
find "$BACKUP_DIR" -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup completed: backup-$DATE.tar.gz"
```

---

## 9. Performance Monitoring

### System Performance

```bash
# CPU
top -bn1 | head -20
mpstat 1 5                  # CPU utilization per second
sar -u 1 5                  # CPU usage

# Memory
free -h
vmstat 1 5                  # Virtual memory stats
slabtop                     # Kernel slab cache

# Disk I/O
iostat -xz 1 5              # Disk I/O stats
iotop                       # Per-process I/O (requires root)

# Network
sar -n DEV 1 5              # Network interface stats
sar -n TCP 1 5              # TCP stats
iftop                       # Network bandwidth per connection
nethogs                     # Per-process network usage

# Process
pidstat 1 5                 # Per-process stats
strace -p PID               # System call trace
lsof -p PID                 # Open files for process
```

### Performance Analysis Tools

```bash
# Sysstat package (sar, iostat, mpstat, pidstat)
apt install sysstat
systemctl enable --now sysstat

# Compile system profile
perf record -a -g sleep 10
perf report

# Flame graphs
perf script | stackcollapse-perf.pl | flamegraph.pl > flame.svg
```

---

## 10. Troubleshooting Checklist

### System Won't Boot

```bash
# From recovery mode or live CD
fsck /dev/sda1               # Check filesystem
mount /dev/sda1 /mnt         # Mount root
chroot /mnt                  # Change root
grub-install /dev/sda        # Reinstall GRUB
update-grub                  # Update GRUB config
```

### High CPU Usage

```bash
top -bn1 | head -20          # Find CPU-heavy process
ps aux --sort=-%cpu | head   # Top CPU consumers
strace -p PID                # Trace system calls
pidstat -p PID 1             # Monitor specific process
```

### High Memory Usage

```bash
free -h                      # Check memory usage
ps aux --sort=-%mem | head   # Top memory consumers
cat /proc/PID/status | grep VmRSS  # Process memory
smem -t -k -s pss            # Memory with PSS
```

### Disk Full

```bash
df -h                        # Check disk usage
du -sh /* | sort -rh | head  # Largest directories
find / -type f -size +100M   # Large files
journalctl --vacuum-size=100M # Clear old journals
apt clean                    # Clear apt cache
truncate -s 0 /var/log/large.log  # Clear large log
```

### Network Issues

```bash
ip addr show                 # Check IP configuration
ip route show                # Check routing
ping 8.8.8.8                 # Test connectivity
dig example.com              # Test DNS
ss -tuln                     # Check listening ports
journalctl -u networking     # Check network service
ethtool eth0                 # Check link status
```

---

## Summary

| Area | Key Commands/Tools |
|------|-------------------|
| **System Info** | `uname`, `lsblk`, `lscpu`, `free -h` |
| **Services** | `systemctl start/stop/enable/status` |
| **Users** | `useradd`, `usermod`, `groupadd`, `visudo` |
| **Disk** | `lsblk`, `fdisk`, `mkfs`, `mount`, LVM |
| **Network** | `ip`, `ss`, `ufw/iptables`, `dig` |
| **Security** | SSH hardening, fail2ban, file permissions |
| **Logs** | `journalctl`, `logrotate`, `/var/log/` |
| **Backup** | `rsync`, `tar`, automated scripts |
| **Performance** | `top`, `iostat`, `vmstat`, `sar` |
| **Troubleshooting** | `dmesg`, `strace`, `lsof`, `journalctl` |

> **Key Insight**: Good system administration is proactive, not reactive. Set up monitoring, log rotation, automated backups, and security hardening before problems occur.
