# Linux Commands Reference

## 1. Navigation and Files

### Directory Navigation

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Print working directory | `pwd` |
| `cd` | Change directory | `cd /var/log` |
| `cd ~` | Go to home directory | `cd ~` |
| `cd -` | Go to previous directory | `cd -` |
| `cd ..` | Go up one directory | `cd ..` |

### File Operations

| Command | Description | Example |
|---------|-------------|---------|
| `ls` | List files | `ls -la /etc` |
| `cp` | Copy files | `cp -r dir1/ dir2/` |
| `mv` | Move/rename | `mv old.txt new.txt` |
| `rm` | Remove files | `rm -rf /tmp/dir` |
| `mkdir` | Create directory | `mkdir -p a/b/c` |
| `rmdir` | Remove empty directory | `rmdir mydir` |
| `touch` | Create empty file | `touch file.txt` |
| `ln` | Create links | `ln -s /path/to/file link` |
| `find` | Find files | `find / -name "*.log" -mtime -1` |
| `locate` | Find by name (database) | `locate nginx.conf` |
| `which` | Find command location | `which python3` |
| `whereis` | Find binary, source, man | `whereis gcc` |

### ls Command Flags

```bash
ls -l     # Long format (permissions, size, date)
ls -a     # Show hidden files (dotfiles)
ls -la    # Long format + hidden
ls -h     # Human-readable sizes (KB, MB, GB)
ls -t     # Sort by modification time
ls -r     # Reverse sort order
ls -S     # Sort by file size
ls -R     # Recursive listing
ls -1     # One file per line
ls --color=auto  # Colorized output
```

### find Command Examples

```bash
# Find files by name
find / -name "*.conf" -type f

# Find files modified in last 24 hours
find /var/log -mtime -1

# Find files larger than 100MB
find / -size +100M -type f

# Find and execute command on results
find . -name "*.tmp" -exec rm {} \;

# Find and delete empty directories
find . -type d -empty -delete

# Find by permissions
find / -perm 777 -type f

# Find by owner
find /home -user john -type f
```

---

## 2. File Viewing and Editing

### Viewing Files

| Command | Description | Example |
|---------|-------------|---------|
| `cat` | View entire file | `cat file.txt` |
| `less` | View with paging | `less /var/log/syslog` |
| `more` | View with paging | `more file.txt` |
| `head` | First N lines | `head -20 file.txt` |
| `tail` | Last N lines | `tail -f /var/log/syslog` |
| `nl` | Number lines | `nl file.txt` |
| `wc` | Count lines/words/bytes | `wc -l file.txt` |
| `diff` | Compare files | `diff file1.txt file2.txt` |
| `vim` | Text editor | `vim file.txt` |
| `nano` | Simple text editor | `nano file.txt` |

### Viewing Binary Files

```bash
xxd file          # Hex dump
hexdump -C file   # Alternative hex dump
strings file      # Extract printable strings
```

---

## 3. Text Processing (grep, sed, awk)

### grep

```bash
# Basic search
grep "pattern" file.txt

# Case-insensitive
grep -i "error" logfile

# Recursive search (in directories)
grep -rn "TODO" /path/to/project/

# Show line numbers
grep -n "function" script.js

# Invert match (lines NOT matching)
grep -v "debug" logfile

# Count matches
grep -c "error" logfile

# Extended regex (egrep)
grep -E "error|warning|critical" logfile

# Perl regex
grep -P "\d{3}-\d{4}" contacts.txt

# Only matching part
grep -o "\b[0-9]{1,3}\b" file.txt

# Context lines
grep -B2 -A2 "panic" /var/log/syslog  # 2 lines before/after
```

### sed

```bash
# Substitute (first occurrence per line)
sed 's/old/new/' file.txt

# Substitute (all occurrences per line)
sed 's/old/new/g' file.txt

# In-place editing
sed -i 's/old/new/g' file.txt

# Delete lines
sed '/^#/d' config.txt          # Remove comments
sed '/^$/d' file.txt           # Remove blank lines
sed '3d' file.txt              # Delete line 3
sed '1,5d' file.txt            # Delete lines 1-5

# Insert/append
sed '3a\New line after 3' file.txt    # Append after line 3
sed '1i\New first line' file.txt      # Insert before line 1

# Print specific lines
sed -n '5,10p' file.txt        # Print lines 5-10

# Multiple commands
sed -e 's/foo/bar/g' -e 's/baz/qux/g' file.txt
```

### awk

```bash
# Print specific columns
awk '{print $1, $3}' file.txt

# Custom delimiter
awk -F: '{print $1, $6}' /etc/passwd

# Print lines matching pattern
awk '/error/ {print $0}' logfile

# Conditional filtering
awk '$3 > 1000' file.txt

# Calculate sum
awk '{sum += $1} END {print sum}' numbers.txt

# Print first and last line
awk 'NR==1 || NR==NF' file.txt

# Print line numbers
awk '{print NR, $0}' file.txt

# Complex example: process access logs
awk '{print $1, $7}' access.log | sort | uniq -c | sort -rn | head -20

# Field separator with multiple delimiters
awk -F'[,;:]' '{print $1, $2}' data.txt

# IF-ELSE
awk '{if ($3 > 100) print "HIGH:", $0; else print "LOW:", $0}' data.txt
```

---

## 4. Process Management

| Command | Description | Example |
|---------|-------------|---------|
| `ps` | List processes | `ps aux` |
| `top` | Interactive process viewer | `top` |
| `htop` | Improved top | `htop` |
| `kill` | Send signal to process | `kill -9 PID` |
| `killall` | Kill by name | `killall nginx` |
| `pkill` | Kill by pattern | `pkill -f "python.*server"` |
| `bg` | Background process | `bg %1` |
| `fg` | Foreground process | `fg %1` |
| `jobs` | List background jobs | `jobs -l` |
| `nohup` | Run immune to hangups | `nohup command &` |
| `nice` | Run with priority | `nice -n 10 command` |
| `renice` | Change priority | `renice -n -5 -p PID` |
| `pgrep` | Find PID by name | `pgrep -f nginx` |
| `pstree` | Process tree | `pstree -p` |
| `lsof` | List open files | `lsof -i :80` |

### ps Command Variants

```bash
ps aux                  # All processes (BSD style)
ps -ef                  # All processes (System V style)
ps aux | grep nginx     # Find nginx processes
ps --sort=-%mem | head  # Top memory consumers
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head  # Top CPU consumers
```

### Process Signals

| Signal | Number | Description |
|--------|--------|-------------|
| `SIGHUP` | 1 | Hangup (reload config) |
| `SIGINT` | 2 | Interrupt (Ctrl+C) |
| `SIGQUIT` | 3 | Quit with core dump |
| `SIGKILL` | 9 | Force kill (uncatchable) |
| `SIGTERM` | 15 | Graceful termination |
| `SIGSTOP` | 19 | Stop (uncatchable) |
| `SIGCONT` | 18 | Continue stopped process |
| `SIGUSR1` | 10 | User-defined signal 1 |
| `SIGUSR2` | 12 | User-defined signal 2 |

---

## 5. Disk and Filesystem

```bash
# Disk usage
df -h                   # Filesystem space usage
df -i                   # Inode usage
du -sh /var/log          # Directory size
du -h --max-depth=1 /   # Top-level sizes
ncdu /                   # Interactive disk usage

# Partitioning
lsblk                    # List block devices
fdisk -l                 # List partitions
parted /dev/sdb          # Partition editor

# Formatting
mkfs.ext4 /dev/sdb1
mkfs.xfs /dev/sdb1
mkfs.vfat -F 32 /dev/sdb1

# Mounting
mount /dev/sdb1 /mnt
mount -o ro,noexec /dev/sdb1 /mnt
umount /mnt

# Filesystem check
fsck /dev/sdb1
e2fsck -f /dev/sdb1

# LVM
pvcreate /dev/sdb
vgcreate data /dev/sdb
lvcreate -L 50G -n apps data
lvextend -L +10G /dev/data/apps
resize2fs /dev/data/apps
```

---

## 6. User and Permission Management

```bash
# Users
useradd -m -s /bin/bash john
passwd john
userdel -r john
usermod -aG sudo john
id john
whoami

# Groups
groupadd developers
groupdel developers
usermod -aG developers john
groups john
getent group developers

# Permissions
chmod 755 file           # rwxr-xr-x
chmod u+x file           # Add execute for owner
chmod -R 644 /var/www/   # Recursive
chown user:group file    # Change ownership
chown -R www-data:www-data /var/www/

# Special permissions
chmod u+s /usr/bin/prog  # Setuid
chmod g+s /shared/dir    # Setgid
chmod +t /tmp            # Sticky bit

# Access Control Lists
setfacl -m u:john:rwx /shared
getfacl /shared
```

---

## 7. Archive and Compression

| Command | Description | Example |
|---------|-------------|---------|
| `tar` | Tape archive | `tar -czvf archive.tar.gz dir/` |
| `zip` | ZIP archive | `zip -r archive.zip dir/` |
| `unzip` | Extract ZIP | `unzip archive.zip` |
| `gzip` | Gzip compression | `gzip file.txt` |
| `gunzip` | Decompress gzip | `gunzip file.gz` |
| `bzip2` | Bzip2 compression | `bzip2 file.txt` |
| `xz` | XZ compression | `xz file.txt` |
| `zcat` | View gzipped file | `zcat file.gz` |

### tar Command Flags

```bash
tar -c    # Create archive
tar -x    # Extract archive
tar -t    # List archive contents
tar -v    # Verbose output
tar -f    # Specify filename
tar -z    # gzip compression
tar -j    # bzip2 compression
tar -J    # xz compression
tar -C    # Change to directory before extract
tar -p    # Preserve permissions
tar --exclude='*.log'  # Exclude patterns
```

### Common tar Operations

```bash
# Create compressed archive
tar -czvf backup.tar.gz /home/user/

# Extract to specific directory
tar -xzvf backup.tar.gz -C /restore/

# List contents
tar -tzvf backup.tar.gz

# Extract specific file
tar -xzvf backup.tar.gz home/user/file.txt

# Create tarball excluding .git
tar -czvf project.tar.gz --exclude='.git' project/
```

---

## 8. System Monitoring

| Command | Description | Key Use |
|---------|-------------|---------|
| `top` | Process monitor | Real-time CPU/memory |
| `htop` | Enhanced top | Better UI, mouse support |
| `vmstat` | Virtual memory stats | System performance |
| `iostat` | I/O statistics | Disk performance |
| `sar` | System activity report | Historical performance |
| `free` | Memory usage | Available/used memory |
| `uptime` | System uptime | Load averages |
| `w` | Who is logged in | Current sessions |
| `dmesg` | Kernel messages | Hardware/driver issues |
| `lscpu` | CPU information | CPU model, cores, threads |
| `lsmem` | Memory information | Memory layout |

### Useful Monitoring Commands

```bash
# Real-time process monitoring
top -bn1 | head -20

# Memory usage
free -h

# CPU information
lscpu
cat /proc/cpuinfo

# System uptime and load
uptime

# Kernel messages
dmesg | tail -20

# Network connections
ss -tuln

# Open files
lsof | head -20

# Hardware info
lshw -short
```

---

## 9. Networking

```bash
# IP configuration
ip addr show
ip addr add 192.168.1.100/24 dev eth0
ip link set eth0 up/down

# Routing
ip route show
ip route add default via 192.168.1.1

# DNS
cat /etc/resolv.conf
dig example.com
nslookup example.com

# Connectivity testing
ping -c 4 8.8.8.8
traceroute google.com
mtr google.com

# HTTP tools
curl -I https://example.com        # Headers only
curl -X POST -d '{"key":"val"}' https://api.com
wget https://example.com/file.zip

# SSH
ssh user@host
ssh -p 2222 user@host
ssh -L 8080:localhost:80 user@host  # Port forwarding
scp file.txt user@host:/path/       # Secure copy
rsync -avz dir/ user@host:/path/    # Sync files

# Firewall (UFW)
ufw enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw status verbose

# Firewall (firewalld)
firewall-cmd --list-all
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
```

---

## 10. Package Management

### Debian/Ubuntu (apt)

```bash
apt update                     # Update package list
apt upgrade                    # Upgrade all packages
apt install nginx              # Install package
apt remove nginx               # Remove package
apt purge nginx                # Remove + config
apt autoremove                 # Remove unused deps
apt search nginx               # Search packages
apt show nginx                 # Package info
apt list --installed           # Installed packages
dpkg -l | grep nginx           # List installed
dpkg -L nginx                  # Files in package
```

### Red Hat/CentOS (yum/dnf)

```bash
yum update                     # Update all packages
yum install nginx              # Install package
yum remove nginx               # Remove package
yum search nginx               # Search packages
yum info nginx                 # Package info
yum list installed             # Installed packages
rpm -qa | grep nginx           # List installed
rpm -ql nginx                  # Files in package
```

---

## 11. Scheduling

### cron

```bash
# Edit crontab
crontab -e

# View crontab
crontab -l

# Cron format:
# ┌───── minute (0-59)
# │ ┌───── hour (0-23)
# │ │ ┌───── day of month (1-31)
# │ │ │ ┌───── month (1-12)
# │ │ │ │ ┌───── day of week (0-7, 0 and 7 = Sunday)
# │ │ │ │ │
# * * * * * command

# Examples:
0 2 * * * /usr/local/bin/backup.sh     # Daily at 2 AM
*/5 * * * * /usr/local/bin/check.sh    # Every 5 minutes
0 0 * * 0 /usr/local/bin/weekly.sh     # Weekly on Sunday
0 9 1 * * /usr/local/bin/monthly.sh    # Monthly at 9 AM
```

### at (one-time scheduling)

```bash
echo "shutdown -h now" | at 23:00       # Shutdown at 11 PM
echo "backup.sh" | at now + 1 hour      # Run in 1 hour
atq                                    # List pending jobs
atrm 1                                 # Remove job 1
```

### systemd timers

```bash
# View active timers
systemctl list-timers

# Create timer unit
# /etc/systemd/system/mytimer.timer
# [Timer]
# OnCalendar=daily
# Persistent=true
```

---

## Quick Reference: Most Used Commands

| Task | Command |
|------|---------|
| Find file | `find / -name "file" 2>/dev/null` |
| Search in files | `grep -rn "pattern" .` |
| Show disk space | `df -h` |
| Show directory size | `du -sh dir` |
| Show running processes | `ps aux` |
| Kill process | `kill -9 PID` |
| Show network connections | `ss -tuln` |
| Show system info | `uname -a` |
| Show logged in users | `who` |
| Show file permissions | `ls -la file` |
| Change permissions | `chmod 755 file` |
| Change ownership | `chown user:group file` |
| Create archive | `tar -czvf archive.tar.gz dir/` |
| Extract archive | `tar -xzvf archive.tar.gz` |
| Search command history | `history \| grep "command"` |
