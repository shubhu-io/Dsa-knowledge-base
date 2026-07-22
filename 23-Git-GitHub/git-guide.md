# Git Guide - Core Concepts

## 1. What is Git?

Git is a **distributed version control system** that tracks changes in source code during development. It allows multiple developers to work on the same project simultaneously while maintaining a complete history of all changes.

### Key Properties

- **Distributed**: Every clone has full history
- **Snapshots**: Stores snapshots, not diffs
- **Integrity**: SHA-1/SHA-256 checksums for all objects
- **Speed**: Most operations are local
- **Branching**: Lightweight, instant branching

---

## 2. Git Internals

### The Three Areas

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Working     │───>│  Staging     │───>│  Repository  │
│  Directory   │    │  Area (Index)│    │  (.git/)     │
│              │    │              │    │              │
│ Your files   │    │ Ready to     │    │ Permanent    │
│ as they are  │    │ commit       │    │ history      │
└──────────────┘    └──────────────┘    └──────────────┘
     git add              git commit
```

| Area | Description | Location |
|------|-------------|----------|
| **Working Directory** | Your project files | Current directory |
| **Staging Area (Index)** | Changes prepared for next commit | `.git/index` |
| **Repository (.git)** | Complete project history | `.git/` directory |

### Git Objects

Git stores everything as objects with SHA-1 hash IDs:

| Object | Purpose | Content |
|--------|---------|---------|
| **blob** | File content | Raw file data |
| **tree** | Directory structure | List of blobs and sub-trees |
| **commit** | Snapshot + metadata | Tree, parent(s), author, message |
| **tag** | Named reference to commit | Annotated tag with metadata |

```
commit (abc123)
  ├── tree (def456)
  │   ├── blob (789abc)  → file1.txt
  │   ├── blob (456def)  → file2.txt
  │   └── tree (111aaa)  → subdir/
  │       └── blob (222bbb)  → file3.txt
  └── parent (prev123)   → previous commit
```

### HEAD

`HEAD` is a pointer to the current commit (or current branch).

```
HEAD → main → commit C → commit B → commit A
```

---

## 3. Git Configuration

### Configuration Levels

| Level | File | Scope |
|-------|------|-------|
| `--system` | `/etc/gitconfig` | All users on system |
| `--global` | `~/.gitconfig` | Current user |
| `--local` | `.git/config` | Current repository |

### Essential Configuration

```bash
# Identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Default branch name
git config --global init.defaultBranch main

# Editor
git config --global core.editor vim

# Diff tool
git config --global diff.tool vimdiff

# Push behavior
git config --global push.default current
git config --global push.autoSetupRemote true

# Pull behavior (recommended)
git config --global pull.rebase true

# Merge tool
git config --global merge.tool vimdiff

# Color output
git config --global color.ui auto

# View all configuration
git config --list
git config --list --show-origin
```

---

## 4. The Git Workflow

### Basic Workflow

```bash
# 1. Create/clone repository
git init                      # New repository
git clone https://github.com/user/repo.git  # Clone existing

# 2. Make changes
echo "Hello" > file.txt

# 3. Stage changes
git add file.txt              # Specific file
git add .                     # All changes
git add -p                    # Interactive staging (hunks)

# 4. Commit
git commit -m "Add greeting file"

# 5. Push to remote
git push origin main
```

### Workflow Diagram

```
  Edit files ──> git add ──> git commit ──> git push
     │              │             │              │
     ▼              ▼             ▼              ▼
  Working      Staging      Local Repo     Remote Repo
  Directory     Area         (.git)        (GitHub)
```

---

## 5. Commits

### Anatomy of a Commit

```
commit 7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b
Author: John Doe <john@example.com>
Date:   Mon Jan 1 12:00:00 2024 +0000

    Add user authentication module

    - Implement login/logout functionality
    - Add JWT token generation
    - Create user model with bcrypt hashing

    Closes #42
```

### Commit Messages

**Good commit messages:**
- Use imperative mood ("Add feature" not "Added feature")
- First line is ≤ 50 characters (subject)
- Blank line after subject
- Body wraps at 72 characters
- Explain **what** and **why**, not how

```bash
# Bad
git commit -m "fixed stuff"
git commit -m "updates"

# Good
git commit -m "Add input validation for user registration"
git commit -m "Fix memory leak in connection pool

    The connection pool was not properly releasing connections
    when the timeout was exceeded. This caused memory to grow
    unboundedly under high load.

    Fixes #123"
```

### Commit Options

```bash
git commit -m "message"           # With message
git commit -am "message"          # Stage all tracked + commit
git commit --amend                # Modify last commit
git commit --amend -m "new msg"   # Amend message
git commit --amend --no-edit      # Amend without changing message
git commit --allow-empty          # Empty commit
git commit -S                     # GPG signed commit
```

---

## 6. Branching

### What is a Branch?

A branch is a lightweight, movable pointer to a commit. Creating a branch creates a new pointer; it doesn't duplicate any code.

```
main:     A ─ B ─ C ─ D
                       ↑
feature:             E ─ F
```

### Branch Commands

```bash
git branch                     # List local branches
git branch -a                  # List all branches (local + remote)
git branch feature             # Create branch
git checkout feature           # Switch to branch
git checkout -b feature        # Create + switch (shortcut)
git switch feature             # Switch (modern command)
git switch -c feature          # Create + switch (modern)
git branch -d feature          # Delete (merged only)
git branch -D feature          # Force delete
git branch -m old new          # Rename branch
```

---

## 7. Merging

### Fast-Forward Merge

When the target branch has no new commits since the source branched off:

```
Before:
main:    A ─ B ─ C
                   ↑
feature:         D ─ E

After (fast-forward):
main:    A ─ B ─ C ─ D ─ E
                         ↑
feature:               (same as main)
```

### Three-Way Merge

When both branches have diverged:

```
Before:
main:    A ─ B ─ C ─ F
                   ↑     \
feature:         D ─ E    M (merge commit)
                         /
                   G ─ H
                   (another branch)

After:
main:    A ─ B ─ C ─ F ─ M
                   \     / \
feature:           D ─ E    G ─ H
```

### Merge Conflicts

When Git can't automatically merge changes:

```
<<<<<<< HEAD
Current branch content
=======
Incoming branch content
>>>>>>> feature
```

**Resolution:**
1. Edit the file to resolve conflicts
2. Remove conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
3. Stage the resolved file: `git add file.txt`
4. Commit: `git commit`

---

## 8. Rebase

Rebase replays commits from one branch onto another, creating a linear history.

```bash
git checkout feature
git rebase main
```

```
Before:
main:    A ─ B ─ C
                   ↑
feature:         D ─ E

After rebase:
main:    A ─ B ─ C
                   \
feature:           D' ─ E'
                    (replayed commits with new hashes)
```

### Interactive Rebase

```bash
git rebase -i HEAD~5    # Rebase last 5 commits
```

Options in the editor:
- `pick` - Use commit as-is
- `reword` - Use commit, edit message
- `edit` - Pause to modify commit
- `squash` - Combine with previous commit
- `fixup` - Like squash, discard message
- `drop` - Remove commit

### Rebase vs Merge

| Feature | Rebase | Merge |
|---------|--------|-------|
| History | Linear | Branching |
| Clarity | Cleaner | Shows branch structure |
| Safety | Rewrites history | Preserves history |
| Conflicts | Re-solve on each replayed commit | Solve once |
| Use case | Clean up before merge | Preserve branch history |

---

## 9. Remote Repositories

### Remote Concepts

```
Local Repository                    Remote Repository
┌──────────────┐                   ┌──────────────┐
│   origin     │ ─── fetch ────>  │   GitHub     │
│   (remote)   │ <── push ─────   │   (server)   │
└──────────────┘                   └──────────────┘
```

### Remote Commands

```bash
git remote -v                     # List remotes
git remote add origin URL         # Add remote
git remote remove origin          # Remove remote
git remote rename old new         # Rename remote
git remote set-url origin URL     # Change URL

# Fetch (download, don't merge)
git fetch origin
git fetch --all

# Pull (fetch + merge)
git pull origin main

# Pull with rebase
git pull --rebase origin main

# Push
git push origin main
git push -u origin main           # Set upstream
git push --force-with-lease       # Safe force push
```

---

## 10. Stashing

Stashing temporarily shelves changes for later use.

```bash
git stash                         # Stash all changes
git stash push -m "WIP feature"   # Named stash
git stash list                    # List stashes
git stash pop                     # Apply + remove latest stash
git stash apply stash@{2}        # Apply specific stash (keep)
git stash drop stash@{0}         # Delete stash
git stash clear                   # Delete all stashes
git stash show -p                 # Show stash diff
```

---

## 11. Undoing Changes

| Scenario | Command |
|----------|---------|
| Undo working dir changes | `git checkout -- file` or `git restore file` |
| Unstage a file | `git reset HEAD file` or `git restore --staged file` |
| Amend last commit | `git commit --amend` |
| Revert a commit (safe) | `git revert <commit>` |
| Reset to commit (destructive) | `git reset --hard <commit>` |
| Undo a merge (before push) | `git reset --hard HEAD~1` |
| Undo a merge (after push) | `git revert -m 1 <merge-commit>` |
| Reflog (recover lost commits) | `git reflog` then `git checkout <hash>` |

### reset Modes

```bash
# --soft: Move HEAD, keep staging + working dir
git reset --soft HEAD~1

# --mixed (default): Move HEAD + unstage, keep working dir
git reset HEAD~1

# --hard: Move HEAD + unstage + discard working dir (DANGEROUS!)
git reset --hard HEAD~1
```

---

## 12. Tags

```bash
git tag                          # List tags
git tag v1.0.0                   # Lightweight tag
git tag -a v1.0.0 -m "Release 1.0"  # Annotated tag
git tag -a v1.0.0 <commit-hash>  # Tag older commit
git push origin v1.0.0           # Push specific tag
git push origin --tags           # Push all tags
git tag -d v1.0.0                # Delete local tag
git push origin :refs/tags/v1.0.0  # Delete remote tag
```

---

## 13. Gitignore

The `.gitignore` file specifies untracked files Git should ignore.

```gitignore
# Dependencies
node_modules/
vendor/

# Build output
dist/
build/
*.o
*.exe

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Coverage
coverage/
htmlcov/
```

### Global Gitignore

```bash
# Set global gitignore
git config --global core.excludesfile ~/.gitignore_global
```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| Three Areas | Working Dir → Staging → Repository |
| Objects | blob (file), tree (dir), commit (snapshot) |
| HEAD | Pointer to current commit |
| Commits | Immutable snapshots with SHA-1 IDs |
| Branches | Lightweight pointers to commits |
| Merge | Combine branches (fast-forward or 3-way) |
| Rebase | Replay commits for linear history |
| Remote | `fetch`, `pull`, `push` for synchronization |
| Stash | Temporarily shelve changes |
| Undo | `restore`, `revert`, `reset`, `reflog` |

> **Key Insight**: Git stores snapshots, not diffs. Every commit is a complete snapshot of the entire project at that point in time. This is what makes Git fast and enables powerful features like branching and history rewriting.
