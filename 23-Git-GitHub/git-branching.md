# Git Branching Strategies

## 1. Branching Fundamentals

### Why Branch?

- **Isolation**: Work on features without affecting main code
- **Parallel Development**: Multiple developers work simultaneously
- **Experimentation**: Try ideas safely
- **Release Management**: Maintain multiple versions
- **Hotfixes**: Fix production bugs without disrupting development

### Branch Types

| Branch | Purpose | Lifetime |
|--------|---------|----------|
| **main/master** | Production-ready code | Permanent |
| **develop** | Integration branch | Permanent |
| **feature/** | New features | Temporary |
| **bugfix/** | Non-critical fixes | Temporary |
| **hotfix/** | Critical production fixes | Temporary |
| **release/** | Prepare releases | Temporary |
| **support/** | Maintain older versions | Permanent |

---

## 2. GitFlow

The most popular branching model for projects with scheduled releases.

### Branch Structure

```
main:      A ─────────────── M1 ────────────── M2 ──────
           │                 ↑                  ↑
           │                 │                  │
release:   │           ┌─ D1 ──── D2 ──┐       │
           │           │               │       │
develop:   ─ B1 ─ B2 ─ M ─ F1 ─ F2 ─ R1 ─ R2 ──┘
                   ↑   ↑       ↑       ↑
                   │   │       │       │
feature1:      ── F1a ─┘       │       │
                               │       │
feature2:              ── F2a ──┘       │
                                       │
hotfix:                           ── H1 ┘
```

### Workflow

```bash
# 1. Start a feature
git checkout develop
git checkout -b feature/user-auth

# 2. Work on feature
git add .
git commit -m "Add login form"
git commit -m "Add JWT authentication"
git commit -m "Add password reset"

# 3. Finish feature (merge to develop)
git checkout develop
git merge --no-ff feature/user-auth
git push origin develop
git branch -d feature/user-auth

# 4. Start a release
git checkout develop
git checkout -b release/v1.2.0
git bump version  # update version files
git commit -m "Bump version to 1.2.0"

# 5. Finish release (merge to main + develop)
git checkout main
git merge --no-ff release/v1.2.0
git tag -a v1.2.0 -m "Release 1.2.0"

git checkout develop
git merge --no-ff release/v1.2.0
git branch -d release/v1.2.0

# 6. Hotfix
git checkout main
git checkout -b hotfix/critical-bug
git commit -m "Fix critical security vulnerability"
git commit -m "Bump version to 1.2.1"

git checkout main
git merge --no-ff hotfix/critical-bug
git tag -a v1.2.1 -m "Hotfix 1.2.1"

git checkout develop
git merge --no-ff hotfix/critical-bug
git branch -d hotfix/critical-bug
```

### When to Use GitFlow

| Pros | Cons |
|------|------|
| Clear release lifecycle | Complex for small projects |
| Supports multiple versions | Long-lived branches |
| Hotfix support | Merge conflicts accumulate |
| Well-defined roles | Slower development cycle |

---

## 3. GitHub Flow

A simplified, lightweight workflow for continuous deployment.

### Branch Structure

```
main:     A ──── M1 ──── M2 ──── M3
           │      ↑       ↑       ↑
           │      │       │       │
PR #1:  ── F1a ──┘       │       │
                          │       │
PR #2:             ── F2a ── F2b ─┘
```

### Workflow

```bash
# 1. Create feature branch from main
git checkout main
git pull
git checkout -b feature/new-button

# 2. Make commits
git add .
git commit -m "Add new button component"
git commit -m "Style new button"

# 3. Push and create Pull Request
git push -u origin feature/new-button
# Create PR on GitHub

# 4. Code review and iterate
git add .
git commit -m "Address review comments"
git push

# 5. Merge PR (after approval and CI passes)
# Merge via GitHub UI (Squash, Merge, or Rebase)

# 6. Delete branch
git branch -d feature/new-button
```

### When to Use GitHub Flow

| Pros | Cons |
|------|------|
| Simple and fast | No release management |
| Continuous deployment | Not for multiple versions |
| Easy to understand | Requires CI/CD maturity |
| Great for web apps | No hotfix branch concept |

---

## 4. GitLab Flow

A middle ground between GitFlow and GitHub Flow with environment branches.

### Branch Structure

```
main:           A ──── B ──── C ──── D
                       │       │       │
production:     ────── P1 ────── P2 ────── P3
                       ↑       ↑       ↑
staging:        ────── S1 ────── S2 ────── S3
                       ↑       ↑       ↑
feature:            ── F1      F2      F3
```

### Workflow

```bash
# 1. Feature branches from main
git checkout main
git checkout -b feature/payment

# 2. Merge to main via MR
# After review, merge to main

# 3. Deploy to staging automatically
# CI/CD pipeline deploys main → staging

# 4. Test on staging
# QA validates on staging environment

# 5. Promote to production
git checkout production
git merge main
git push origin production

# 6. Cherry-pick hotfix
git checkout main
git commit -m "Fix payment bug"
git cherry-pick <hash>
git push origin main

# Deploy to production
git checkout production
git cherry-pick <hash>
git push origin production
```

### When to Use GitLab Flow

| Pros | Cons |
|------|------|
| Environment-based deployment | More complex than GitHub Flow |
| Hotfix via cherry-pick | Requires CI/CD setup |
| Clear promotion path | Cherry-pick can be error-prone |
| Multi-environment support | Slower than GitHub Flow |

---

## 5. Trunk-Based Development

A highly simplified model where developers commit directly to main (or very short-lived branches).

### Branch Structure

```
main:     A ── B ── C ── D ── E ── F
               ↑       ↑   ↑
               │       │   │
short:     ── FB ──┘   │   │
                       │   │
short:              ── FC ──┘
```

### Key Practices

1. **Short-lived branches**: Less than 1-2 days
2. **Feature flags**: Toggle incomplete features
3. **Continuous integration**: Merge multiple times per day
4. **Automated testing**: Comprehensive test suite
5. **Code review**: Quick reviews before merge

### Feature Flags

```python
# Instead of long-lived feature branches,
# use feature flags in code:

if feature_enabled("new_checkout"):
    render_new_checkout()
else:
    render_old_checkout()
```

### When to Use Trunk-Based

| Pros | Cons |
|------|------|
| Fastest development speed | Requires mature CI/CD |
| Minimal merge conflicts | Feature flags add complexity |
| Simplest workflow | Requires comprehensive testing |
| Best for CI/CD | Risk of breaking main |

---

## 6. Forking Workflow

Used in open-source projects where external contributors don't have write access.

### Branch Structure

```
upstream/main:    A ──── M1 ──── M2
                       ↑       ↑
fork/main:       A ──── B ──── B1 ──── B2
                       ↑       ↑
contributor:    ── F1 ──┘   ── F2 ──┘
```

### Workflow

```bash
# 1. Fork repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR-USER/repo.git
cd repo

# 3. Add upstream remote
git remote add upstream https://github.com/ORIGINAL-USER/repo.git

# 4. Create feature branch
git checkout -b fix/typo-in-readme

# 5. Make changes and commit
git add .
git commit -m "Fix typo in README"

# 6. Push to your fork
git push origin fix/typo-in-readme

# 7. Create Pull Request on GitHub (from your fork → upstream)

# 8. Keep fork updated
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

---

## 7. Merge vs Rebase vs Squash

### Merge

```bash
git checkout main
git merge feature --no-ff
```

**Result**: Preserves branch history, creates merge commit.

```
main:    A ── B ── C ──── M
                  \      /
feature:          D ── E
```

### Rebase

```bash
git checkout feature
git rebase main
git checkout main
git merge feature
```

**Result**: Linear history, new commit hashes.

```
main:    A ── B ── C ──── D' ── E'
                  \     /
feature:          D' ── E'
```

### Squash Merge

```bash
git checkout main
git merge --squash feature
git commit -m "Implement user auth"
```

**Result**: Single commit with all changes, no branch history.

```
main:    A ── B ── C ──── S (squashed commit)
```

### Comparison

| Method | History | Conflicts | Auditability | Use Case |
|--------|---------|-----------|--------------|----------|
| **Merge** | Full branch history | Resolve once | High (see branch) | Feature branches |
| **Rebase** | Linear | Re-resolve each | Medium (replayed) | Clean up before merge |
| **Squash** | Single commit | Resolve once | Low (one commit) | Small features, PRs |

---

## 8. Handling Merge Conflicts

### Common Conflict Types

```bash
# Text conflict
<<<<<<< HEAD
current change
=======
incoming change
>>>>>>> feature

# Added on both sides
<<<<<<< HEAD
+new line in main
=======
+new line in feature
>>>>>>> feature

# Deleted on one side
<<<<<<< HEAD
(deleted in main)
=======
remaining text
>>>>>>> feature
```

### Resolution Steps

```bash
# 1. See which files have conflicts
git status

# 2. Open conflicted files and resolve markers

# 3. Stage resolved files
git add resolved-file.txt

# 4. Continue
# For merge:
git commit

# For rebase:
git rebase --continue

# 5. To abort if needed
git merge --abort
git rebase --abort
```

### Prevention Strategies

| Strategy | Description |
|----------|-------------|
| **Small, frequent merges** | Less divergence between branches |
| **Pull before push** | Get latest changes before pushing |
| **Feature isolation** | Don't change files others are working on |
| **Communication** | Coordinate on shared files |
| **Code review early** | Catch conflicts before they grow |

---

## 9. Branch Naming Conventions

| Pattern | Purpose | Example |
|---------|---------|---------|
| `feature/` | New feature | `feature/user-auth` |
| `bugfix/` | Bug fix | `bugfix/login-error` |
| `hotfix/` | Critical fix | `hotfix/security-patch` |
| `release/` | Release prep | `release/v2.0.0` |
| `chore/` | Maintenance | `chore/update-deps` |
| `docs/` | Documentation | `docs/api-guide` |
| `test/` | Testing | `test/unit-tests` |
| `fix/` | Bug fix (alt) | `fix/memory-leak` |
| `feat/` | Feature (alt) | `feat/dark-mode` |

### Convention Examples

```
feature/JIRA-123-user-authentication
bugfix/fix-null-pointer-in-login
hotfix/CVE-2024-1234-xss-vulnerability
release/v2.1.0
docs/update-readme
chore/upgrade-dependencies
```

---

## 10. Best Practices

| Practice | Description |
|----------|-------------|
| **Delete merged branches** | Keep repository clean |
| **Use descriptive names** | `feature/user-auth` not `my-branch` |
| **Keep branches short-lived** | Merge within days, not weeks |
| **Pull before push** | Reduce conflicts |
| **Use PRs for review** | Code quality and knowledge sharing |
| **Never force push main** | Preserve shared history |
| **Use `--force-with-lease`** | Safer than `--force` |
| **Tag releases** | Easy version identification |
| **Protect main branch** | Require PR reviews on GitHub |
| **Use conventional commits** | Consistent commit messages |

---

## Summary

| Strategy | Complexity | Best For |
|----------|-----------|----------|
| **GitFlow** | High | Software with scheduled releases |
| **GitHub Flow** | Low | Web apps, continuous deployment |
| **GitLab Flow** | Medium | Multi-environment deployment |
| **Trunk-Based** | Low | Mature teams with CI/CD |
| **Forking** | Medium | Open-source projects |

> **Key Insight**: The best branching strategy depends on your team size, release cadence, and CI/CD maturity. Start simple (GitHub Flow) and add complexity only when needed.
