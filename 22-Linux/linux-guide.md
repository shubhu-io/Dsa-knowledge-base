# Linux Guide

## 1. Linux Architecture

### Layered Architecture

```
┌─────────────────────────────────────────┐
│           User Space                     │
│  ┌─────────────┐  ┌──────────────────┐  │
│  │ Applications │  │ System Libraries │  │
│  │ (vim, gcc,   │  │ (glibc, libm,    │  │
│  │  nginx, etc)│  │  libpthread)     │  │
│  └──────┬──────┘  └────────┬─────────┘  │
│         │                  │             │
│  ┌──────┴──────────────────┴─────────┐  │
│  │      System Call Interface         │  │
│  │   (open, read, write, fork, exec) │  │
│  └──────────────┬────────────────────┘  │
├─────────────────┼───────────────────────┤
│           Kernel Space                   │
│  ┌──────────────┴────────────────────┐  │
│  │          Linux Kernel             │  │
│  │  ┌──────┬───────┬──────┬───────┐ │  │
│  │  │Process│Memory │Files │Network│ │  │
│  │  │ Mgmt  │ Mgmt  │ Sys  │ Stack │ │  │
│  │  └──────┴───────┴──────┴───────┘ │  │
│  │  ┌──────┬───────┬──────┬───────┐ │  │
│  │  │Device│ IPC  │Sched-│Security│ │  │
│  │  │ Drvrs│      │uler  │ (SELinux│ │  │
│  │  └──────┴───────┴──────┴───────┘ │  │
│  └──────────────────────────────────┘  │
├─────────────────────────────────────────┤
│              Hardware                    │
│  (CPU, RAM, Disk, NIC, GPU, etc.)       │
└─────────────────────────────────────────┘
```

### Kernel vs User Space

| Feature | Kernel Space | User Space |
|---------|-------------|------------|
| **Privilege** | Full hardware access | Restricted access |
| **Memory** | Direct physical access | Virtual address space |
| **Operations** | All instructions | Only safe instructions |
| **Crash Impact** | System panic (kernel oops) | Only that process dies |
| **Switch Cost** | Context switch overhead | N/A |

---

## 2. Linux Filesystem

### Filesystem Hierarchy Standard (FHS)

```
/                   Root directory
├── bin/            Essential user binaries (ls, cp, mv)
├── sbin/           System binaries (fdisk, iptables)
├── etc/            Configuration files
├── home/           User home directories
├── root/           Root user's home directory
├── var/            Variable data (logs, caches, spool)
│   ├── log/        System logs
│   ├── cache/      Package cache
│   └── www/        Web server files
├── tmp/            Temporary files (cleared on reboot)
├── usr/            User programs and libraries
│   ├── bin/        User binaries
│   ├── lib/        Libraries
│   ├── local/      Locally installed software
│   └── share/      Architecture-independent data
├── opt/            Optional/third-party software
├── dev/            Device files (null, zero, random, sda)
├── proc/           Process and kernel information (virtual)
├── sys/            Kernel and hardware info (virtual)
├── mnt/            Temporary mount points
├── media/          Removable media mount points
├── boot/           Boot loader files (kernel, initrd)
├── lib/            Shared libraries for /bin and /sbin
├── srv/            Service data (web, FTP)
└── lost+found/     Recovered files (ext4)
```

### Key Directories Explained

| Directory | Purpose | Example Files |
|-----------|---------|---------------|
| `/etc/passwd` | User account info | username:x:UID:GID:comment:home:shell |
| `/etc/shadow` | Encrypted passwords | Only root can read |
| `/etc/group` | Group definitions | group_name:GID:members |
| `/etc/fstab` | Filesystem mount table | Auto-mount on boot |
| `/etc/hostname` | System hostname | myserver |
| `/etc/resolv.conf` | DNS configuration | nameserver 8.8.8.8 |

---

## 3. File Types

| Type | Symbol | Example | Description |
|------|--------|---------|-------------|
| **Regular** | `-` | `-rw-r--r--` | Normal file |
| **Directory** | `d` | `drwxr-xr-x` | Folder |
| **Link** | `l` | `lrwxrwxrwx` | Symbolic link |
| **Character Device** | `c` | `crw-rw----` | Terminal, serial port |
| **Block Device** | `b` | `brw-rw----` | Hard disk, partitions |
| **Pipe** | `p` | `prw-r--r--` | Named pipe (FIFO) |
| **Socket** | `s` | `srwxrwxrwx` | Unix domain socket |

### Permissions

```
-rwxr-xr-- 1 user group 4096 Jan 1 12:00 file.txt
│└┬┘└┬┘└┬┘
│ │   │  └── Others: read only (r--)
│ │   └───── Group: read + execute (r-x)
│ └───────── Owner: read + write + execute (rwx)
└─────────── File type (-)
```

| Permission | File | Directory |
|-----------|------|-----------|
| **r (read)** | View content | List contents |
| **w (write)** | Modify content | Create/delete files |
| **x (execute)** | Run as program | Enter directory |

### Numeric Permission Codes

| Octal | Binary | Meaning |
|-------|--------|---------|
| 0 | 000 | No permissions |
| 1 | 001 | Execute only |
| 2 | 010 | Write only |
| 3 | 011 | Write + execute |
| 4 | 100 | Read only |
| 5 | 101 | Read + execute |
| 6 | 110 | Read + write |
| 7 | 111 | Read + write + execute |

**Common examples:**
- `chmod 755`: rwxr-xr-x (executables, directories)
- `chmod 644`: rw-r--r-- (regular files)
- `chmod 700`: rwx------ (private directories)
- `chmod 600`: rw------- (private files, SSH keys)

---

## 4. Process Management

### Process States

```
          fork()
  ┌──────────────────┐
  │                  ▼
  │            ┌──────────┐
  │            │ RUNNING  │◄─────── scheduling
  │            └────┬─────┘
  │        ┌───────┼────────┐
  │        ▼       ▼        ▼
  │  ┌─────────┐ ┌────────┐ ┌─────────┐
  │  │ WAITING │ │STOPPED │ │ ZOMBIE  │
  │  │(sleeping)│ │        │ │         │
  │  └────┬────┘ └───┬────┘ └─────────┘
  │       │          │
  │       ▼          │
  │  ┌─────────┐     │
  └──│  READY  │     │
     └─────────┘     │
           │         │
           ▼         ▼
        ┌──────────────┐
        │   TERMINATED  │
        └──────────────┘
```

| State | Description |
|-------|-------------|
| **Running** | Currently executing on CPU |
| **Ready** | Waiting to be scheduled |
| **Sleeping/Waiting** | Waiting for I/O or event |
| **Stopped** | Paused (SIGSTOP, SIGTSTP) |
| **Zombie** | Terminated but not reaped by parent |

### Process Priority (Nice Values)

- Range: -20 (highest priority) to +19 (lowest priority)
- Default: 0
- `nice -n 10 command`: Start with nice value 10
- `renice -n -5 -p PID`: Change priority of running process

---

## 5. Filesystems

### Supported Filesystems

| Filesystem | Type | Features | Best For |
|-----------|------|----------|----------|
| **ext4** | Journaling | Reliable, mature | General Linux use |
| **XFS** | Journaling | High performance, large files | Servers, databases |
| **Btrfs** | Copy-on-write | Snapshots, RAID, compression | Desktop, NAS |
| **ZFS** | Copy-on-write | Pooled storage, checksums | Enterprise, NAS |
| **FAT32** | Legacy | Universal compatibility | USB drives |
| **NTFS** | Windows | Windows compatibility | Dual-boot |
| **tmpfs** | Virtual | RAM-based, volatile | /tmp, /run |

### Mounting

```bash
# View mounted filesystems
mount
cat /proc/mounts

# Mount a partition
mount /dev/sda1 /mnt/data

# Mount with options
mount -o ro,noexec /dev/sda1 /mnt/data

# Unmount
umount /mnt/data

# Auto-mount in /etc/fstab
# UUID=xxxx  /mnt/data  ext4  defaults,noatime  0  2
```

---

## 6. The Boot Process

```
┌─────────────┐
│   BIOS/UEFI │  ← Hardware initialization
└──────┬──────┘
       ▼
┌─────────────┐
│  Bootloader  │  ← GRUB, systemd-boot
│  (GRUB2)    │     Loads kernel into memory
└──────┬──────┘
       ▼
┌─────────────┐
│   Kernel     │  ← Initializes hardware, mounts rootfs
│  (vmlinuz)   │
└──────┬──────┘
       ▼
┌─────────────┐
│   init/     │  ← PID 1, starts system services
│  systemd    │
└──────┬──────┘
       ▼
┌─────────────┐
│  Userspace   │  ← Login prompt, desktop, services
└─────────────┘
```

### systemd

Modern Linux uses `systemd` as the init system.

```bash
# Start/stop/restart services
systemctl start nginx
systemctl stop nginx
systemctl restart nginx

# Enable/disable on boot
systemctl enable nginx
systemctl disable nginx

# Check service status
systemctl status nginx

# List all services
systemctl list-units --type=service

# View logs
journalctl -u nginx
journalctl -u nginx --since "1 hour ago"
```

---

## 7. Shell Concepts

### Default Shell

The default shell is defined in `/etc/passwd`:

```bash
# Check current shell
echo $SHELL
echo $0

# Change shell
chsh -s /bin/bash
chsh -s /bin/zsh
```

### Shell Configuration Files

| File | Scope | Purpose |
|------|-------|---------|
| `/etc/profile` | System-wide | Login shell initialization |
| `/etc/bash.bashrc` | System-wide | Bash interactive shell config |
| `~/.bashrc` | Per-user | Interactive shell config |
| `~/.bash_profile` | Per-user | Login shell config |
| `~/.profile` | Per-user | Generic login shell config |
| `~/.bash_logout` | Per-user | Cleanup on logout |

### Environment Variables

```bash
# View all environment variables
env
printenv

# Set a variable (current session only)
export MY_VAR="hello"

# Make permanent (add to ~/.bashrc)
echo 'export MY_VAR="hello"' >> ~/.bashrc

# Common environment variables
echo $HOME       # Home directory
echo $PATH       # Executable search path
echo $USER       # Current username
echo $SHELL      # Default shell
echo $LANG       # Language/locale
echo $HOSTNAME   # System hostname
```

---

## 8. User and Group Management

### User Types

| Type | UID Range | Description |
|------|-----------|-------------|
| **Root** | 0 | Superuser, full access |
| **System** | 1-999 | Service accounts (www, sshd, etc.) |
| **Regular** | 1000+ | Normal user accounts |

### User Management Commands

```bash
# Create user
useradd -m -s /bin/bash username
passwd username

# Delete user
userdel -r username

# Modify user
usermod -aG sudo username      # Add to group
usermod -s /bin/zsh username    # Change shell

# View user info
id username
groups username
whoami
```

### Group Management

```bash
# Create group
groupadd groupname

# Delete group
groupdel groupname

# Add user to group
usermod -aG groupname username
gpasswd -a username groupname

# View groups
getent group groupname
```

---

## 9. I/O and Redirection

### Standard Streams

| Stream | File Descriptor | Purpose |
|--------|----------------|---------|
| **stdin** | 0 | Standard input (keyboard) |
| **stdout** | 1 | Standard output (terminal) |
| **stderr** | 2 | Standard error (terminal) |

### Redirection Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `>` | Redirect stdout (overwrite) | `echo "hi" > file.txt` |
| `>>` | Redirect stdout (append) | `echo "hi" >> file.txt` |
| `2>` | Redirect stderr | `ls /nonexist 2> error.log` |
| `2>>` | Append stderr | `ls /nonexist 2>> error.log` |
| `&>` | Redirect both stdout and stderr | `command &> all.log` |
| `<` | Redirect stdin | `sort < file.txt` |
| `<<` | Here document | `cat << EOF` |
| `<<<` | Here string | `grep "hello" <<< "hello world"` |

### Pipes

```bash
# Pipe stdout to next command's stdin
ls -la | grep ".txt"

# Chain multiple commands
cat access.log | grep "404" | awk '{print $7}' | sort | uniq -c | sort -rn

# Pipe with stderr
command 2>&1 | tee output.log

# Pipe only stdout (not stderr)
command | grep "pattern"
```

---

## 10. Text Processing

### Essential Text Tools

| Command | Purpose | Example |
|---------|---------|---------|
| `grep` | Search text patterns | `grep -rn "error" /var/log/` |
| `sed` | Stream editor | `sed 's/old/new/g' file.txt` |
| `awk` | Pattern scanning | `awk '{print $1, $3}' file.txt` |
| `cut` | Extract columns | `cut -d: -f1 /etc/passwd` |
| `sort` | Sort lines | `sort -u file.txt` |
| `uniq` | Filter duplicates | `sort file.txt \| uniq -c` |
| `tr` | Character translation | `echo "HELLO" \| tr 'A-Z' 'a-z'` |
| `wc` | Word/line/byte count | `wc -l file.txt` |
| `head` | First N lines | `head -20 file.txt` |
| `tail` | Last N lines | `tail -f /var/log/syslog` |

### Regular Expressions

| Pattern | Meaning | Example |
|---------|---------|---------|
| `^` | Start of line | `^error` |
| `$` | End of line | `done$` |
| `.` | Any character | `a.c` matches abc, aXc |
| `*` | Zero or more | `ab*c` matches ac, abc, abbc |
| `+` | One or more | `ab+c` matches abc, abbc |
| `?` | Zero or one | `ab?c` matches ac, abc |
| `[]` | Character class | `[aeiou]` |
| `[^]` | Negated class | `[^0-9]` |
| `\|` | Alternation | `cat\|dog` |
| `()` | Grouping | `(ab)+` |
| `\d` | Digit `[0-9]` | |
| `\w` | Word char `[a-zA-Z0-9_]` | |
| `\s` | Whitespace | |

---

## 11. Disk Management

### Disk Commands

```bash
# List disks and partitions
lsblk
fdisk -l
parted -l

# Partition disk
fdisk /dev/sdb
gdisk /dev/sdb        # GPT partitioning

# Format partition
mkfs.ext4 /dev/sdb1
mkfs.xfs /dev/sdb1

# Check filesystem
fsck /dev/sdb1

# Disk usage
df -h                 # Filesystem usage
du -sh /var/log       # Directory size
du -h --max-depth=1 / # Top-level sizes
```

### LVM (Logical Volume Manager)

```bash
# Create physical volume
pvcreate /dev/sdb /dev/sdc

# Create volume group
vgcreate myvg /dev/sdb /dev/sdc

# Create logical volume
lvcreate -L 10G -n mylv myvg

# Extend logical volume
lvextend -L +5G /dev/myvg/mylv
resize2fs /dev/myvg/mylv    # ext4
xfs_growfs /dev/myvg/mylv   # XFS
```

---

## 12. Networking Basics

### Network Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `ip addr` | Show IP addresses | `ip addr show eth0` |
| `ip route` | Show routing table | `ip route show` |
| `ip link` | Show network interfaces | `ip link show` |
| `ss` | Socket statistics | `ss -tuln` |
| `netstat` | Network connections | `netstat -tuln` |
| `ping` | Test connectivity | `ping 8.8.8.8` |
| `traceroute` | Trace route | `traceroute google.com` |
| `dig` | DNS lookup | `dig example.com` |
| `nslookup` | DNS lookup | `nslookup example.com` |
| `curl` | HTTP requests | `curl https://api.example.com` |
| `wget` | Download files | `wget https://example.com/file.zip` |
| `scp` | Secure copy | `scp file.txt user@host:/path/` |
| `ssh` | Secure shell | `ssh user@hostname` |

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| Architecture | Kernel space vs User space; system calls bridge them |
| Filesystem | FHS standard; everything is a file in Linux |
| Permissions | Owner/Group/Others; rwx in octal (755, 644, etc.) |
| Processes | States: Running, Ready, Sleeping, Stopped, Zombie |
| systemd | Modern init system; `systemctl` manages services |
| Shell | Configuration cascades from /etc to ~/. files |
| Text Processing | grep, sed, awk are the power trio |
| Networking | ip, ss, curl, ssh are essential tools |

> **Key Insight**: Linux follows the Unix philosophy: "Do one thing and do it well." Commands are small, composable utilities combined with pipes to build powerful data processing pipelines.
