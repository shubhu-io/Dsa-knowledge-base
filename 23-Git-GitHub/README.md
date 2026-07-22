# 23 - Git & GitHub

## Overview

Git is a distributed version control system created by Linus Torvalds in 2005 for Linux kernel development. GitHub is a cloud-based platform built around Git for collaboration, code review, project management, and CI/CD. Together, they form the backbone of modern software development workflows.

## What You'll Learn

| Topic | File | Description |
|-------|------|-------------|
| Git Guide | [git-guide.md](git-guide.md) | Core concepts, internals, and workflows |
| Git Commands | [git-commands.md](git-commands.md) | Complete command reference with examples |
| Git Branching | [git-branching.md](git-branching.md) | Branching strategies and merge/rebase |
| GitHub Collaboration | [github-collaboration.md](github-collaboration.md) | PRs, issues, actions, and team workflows |

## Why Git & GitHub Matter

- **Industry Standard**: Used by >90% of developers worldwide
- **Collaboration**: Work with teams of any size across the globe
- **History**: Complete history of every change with blame/annotation
- **Branching**: Experiment safely without affecting production
- **Code Review**: Pull requests enable quality assurance
- **CI/CD**: GitHub Actions automates testing and deployment
- **Open Source**: Host and contribute to millions of projects

## Git vs GitHub

| Feature | Git | GitHub |
|---------|-----|--------|
| **Type** | Version control tool | Cloud platform |
| **Runs** | Local machine | Web + API |
| **Created by** | Linus Torvalds (2005) | Tom Preston-Werner (2008) |
| **Core function** | Track code changes | Collaboration & hosting |
| **Branching** | Local branches | Pull requests |
| **Issues** | N/A | Issue tracking |
| **CI/CD** | N/A | GitHub Actions |
| **Cost** | Free (open source) | Free tier + paid plans |

## Key Concepts

```
┌─────────────────────────────────────────────┐
│                 GitHub                       │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │   Repos   │ │   PRs    │ │  Actions   │  │
│  │          │ │          │ │  (CI/CD)   │  │
│  └──────────┘ └──────────┘ └────────────┘  │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │  Issues   │ │  Pages   │ │  Projects  │  │
│  │          │ │          │ │            │  │
│  └──────────┘ └──────────┘ └────────────┘  │
├─────────────────────────────────────────────┤
│                   Git                        │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │  Commits  │ │ Branches │ │   Remotes  │  │
│  │          │ │          │ │            │  │
│  └──────────┘ └──────────┘ └────────────┘  │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │   Tags   │ │  Merging │ │  Stashing  │  │
│  │          │ │          │ │            │  │
│  └──────────┘ └──────────┘ └────────────┘  │
└─────────────────────────────────────────────┘
```

## Study Path

1. Start with **Git Guide** for foundational concepts
2. Master **Git Commands** for daily operations
3. Learn **Git Branching** for team workflows
4. Study **GitHub Collaboration** for platform features

## Resources

- Git Official Documentation (git-scm.com)
- GitHub Docs (docs.github.com)
- Pro Git Book (git-scm.com/book) - Free!
- Oh Shit, Git!? (ohshitgit.com) - Git crisis recovery
- Git Cheat Sheet (education.github.com/git-cheat-sheet)

---

> **Tip**: Practice Git in a safe environment. Create a test repository and experiment with branches, merges, and rebase before using them on production code.
