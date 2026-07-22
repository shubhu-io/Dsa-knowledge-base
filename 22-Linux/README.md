# 22 - Linux

## Overview

Linux is an open-source Unix-like operating system kernel first released by Linus Torvalds in 1991. Today, Linux powers the majority of servers, supercomputers, cloud infrastructure, embedded systems, and Android devices. Understanding Linux is essential for every developer and system administrator.

## What You'll Learn

| Topic | File | Description |
|-------|------|-------------|
| Linux Guide | [linux-guide.md](linux-guide.md) | Core concepts, architecture, and filesystem |
| Linux Commands | [linux-commands.md](linux-commands.md) | Essential commands with examples and reference |
| Shell Scripting | [linux-shell-scripting.md](linux-shell-scripting.md) | Bash scripting from basics to advanced |
| Administration | [linux-administration.md](linux-administration.md) | System admin, services, networking, security |

## Why Linux Matters

- **Server Dominance**: >90% of cloud servers run Linux
- **Supercomputers**: 100% of the world's top 500 supercomputers run Linux
- **DevOps & Cloud**: Docker, Kubernetes, and CI/CD pipelines are Linux-native
- **Career Growth**: Linux skills are among the most in-demand in tech
- **Security**: Open-source transparency enables rapid vulnerability discovery
- **Cost**: Free and open-source reduces infrastructure costs

## Linux Distributions

| Distribution | Best For | Package Manager |
|-------------|----------|----------------|
| **Ubuntu** | Beginners, Desktop, Server | apt (deb) |
| **Debian** | Stability, Servers | apt (deb) |
| **CentOS/RHEL** | Enterprise, Servers | yum/dnf (rpm) |
| **Fedora** | Cutting-edge, Developers | dnf (rpm) |
| **Arch** | Advanced users, Customization | pacman |
| **Alpine** | Containers, Minimal systems | apk |
| **SUSE** | Enterprise, SAP | zypper (rpm) |

## Key Concepts

```
┌───────────────────────────────────────┐
│           User Applications           │
├───────────────────────────────────────┤
│           Shell / Terminal             │
├───────────────────────────────────────┤
│           System Libraries            │
│          (glibc, musl, etc.)          │
├───────────────────────────────────────┤
│           System Call Interface        │
├───────────────────────────────────────┤
│           Linux Kernel                │
│  ┌──────┬───────┬──────┬──────────┐  │
│  │Process│Memory │Files │Network   │  │
│  │Mgmt  │Mgmt   │System│Stack     │  │
│  └──────┴───────┴──────┴──────────┘  │
├───────────────────────────────────────┤
│           Hardware                    │
└───────────────────────────────────────┘
```

## Study Path

1. Start with **Linux Guide** for foundational concepts
2. Master **Linux Commands** for daily operations
3. Learn **Shell Scripting** for automation
4. Study **Administration** for system management

## Resources

- `man` pages (e.g., `man ls`, `man bash`)
- The Linux Documentation Project (tldp.org)
- Linux Journey (linuxjourney.com)
- OverTheWire: Bandit (wargames for Linux practice)
- `tldr pages` (`tldr` command for simplified man pages)

---

> **Tip**: The best way to learn Linux is by doing. Set up a virtual machine or use WSL2 to practice commands and scripts in a safe environment.
