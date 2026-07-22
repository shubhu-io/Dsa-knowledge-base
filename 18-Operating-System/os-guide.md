# Operating System Guide

## What is an Operating System?

An OS is system software that manages computer hardware and software resources and provides services for programs.

## Key Concepts

### Process Management
- **Process**: Program in execution
- **Thread**: Lightweight process within a process
- **Process States**: New, Ready, Running, Waiting, Terminated

### Process vs Thread
| Feature | Process | Thread |
|---------|---------|--------|
| Memory | Separate | Shared |
| Creation | Heavy | Light |
| Communication | IPC | Direct |
| Crash Impact | Isolated | Affects all |

### CPU Scheduling
- **FCFS**: First Come First Serve
- **SJF**: Shortest Job First
- **Round Robin**: Time slices
- **Priority**: Based on priority

### Memory Management
- **Virtual Memory**: Illusion of large memory
- **Paging**: Fixed-size blocks
- **Segmentation**: Variable-size blocks

### Deadlock
Four conditions must hold:
1. Mutual Exclusion
2. Hold and Wait
3. No Preemption
4. Circular Wait

### File Systems
- **FAT**: File Allocation Table
- **NTFS**: New Technology File System
- **ext4**: Linux file system

## Linux Commands

### File Operations
```
ls              # List files
cd              # Change directory
pwd             # Print working directory
mkdir           # Make directory
rm              # Remove file
cp              # Copy file
mv              # Move/rename
cat             # Display file
nano/vim        # Edit file
```

### Process Management
```
ps              # List processes
top             # Process monitor
kill            # Kill process
bg/fg           # Background/foreground
jobs            # List jobs
```

### System Info
```
uname -a        # System info
df -h           # Disk usage
free -m         # Memory usage
whoami          # Current user
history         # Command history
```

### Networking
```
ifconfig        # Network interfaces
ping            # Test connectivity
netstat         # Network stats
ssh             # Remote login
scp             # Secure copy
```

## Virtual Memory

### How It Works
1. Process requests memory
2. OS checks physical memory
3. If full, swap to disk
4. Page table maps virtual to physical

### Page Replacement Algorithms
- **FIFO**: First In First Out
- **LRU**: Least Recently Used
- **Optimal**: Replace page not used longest

## File System

### Inodes
- Metadata about files
- Permissions, size, timestamps
- Pointers to data blocks

### Hard vs Soft Links
| Feature | Hard Link | Soft Link |
|---------|-----------|-----------|
| Inode | Same | Different |
| Cross FS | No | Yes |
| Delete | Doesn't break | Breaks |

## Shell Scripting

### Basics
```bash
#!/bin/bash
# Variables
name="Alice"
echo "Hello, $name"

# Conditionals
if [ $age -ge 18 ]; then
    echo "Adult"
else
    echo "Minor"
fi

# Loops
for i in {1..5}; do
    echo $i
done

# Functions
greet() {
    echo "Hello, $1"
}
greet "Alice"
```

## Interview Tips

1. Know process vs thread
2. Understand deadlock conditions
3. Know scheduling algorithms
4. Understand virtual memory
5. Practice shell scripting