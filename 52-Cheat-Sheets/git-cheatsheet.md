# Git Cheat Sheet for DSA

Quick reference for Git commands, workflows, and best practices for collaborative development.

---

## Setup and Configuration

```bash
# Configure user info
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Check configuration
git config --list
git config user.name

# Set default editor
git config --global core.editor code  # VS Code
git config --global core.editor vim   # Vim
```

---

## Repository Operations

```bash
# Initialize new repository
git init

# Clone existing repository
git clone https://github.com/user/repo.git
git clone https://github.com/user/repo.git my-folder  # Custom name

# Check status
git status
git status -s  # Short format

# View remote
git remote -v
git remote add origin https://github.com/user/repo.git
```

---

## Basic Workflow

```bash
# Stage files
git add file.txt           # Single file
git add .                  # All changes
git add *.py              # Pattern matching
git add -p                # Interactive staging

# Commit
git commit -m "message"
git commit -am "message"  # Stage and commit tracked files

# View commits
git log
git log --oneline         # Compact view
git log --graph           # Visual branch graph
git log -n 5             # Last 5 commits
git log --author="name"  # Filter by author
```

---

## Branching

```bash
# List branches
git branch               # Local branches
git branch -r            # Remote branches
git branch -a            # All branches

# Create and switch
git branch new-branch     # Create
git checkout new-branch   # Switch
git checkout -b new-branch  # Create and switch
git switch new-branch     # Switch (modern)
git switch -c new-branch  # Create and switch (modern)

# Delete
git branch -d branch-name    # Delete merged branch
git branch -D branch-name    # Force delete

# Rename
git branch -m old-name new-name
```

---

## Merging and Rebasing

```bash
# Merge
git checkout main
git merge feature-branch

# Merge with commit
git merge --no-ff feature-branch  # Create merge commit

# Abort merge
git merge --abort

# Rebase
git checkout feature-branch
git rebase main

# Interactive rebase
git rebase -i HEAD~3  # Last 3 commits

# Abort rebase
git rebase --abort
```

---

## Stashing

```bash
# Stash changes
git stash
git stash push -m "work in progress"
git stash -u  # Include untracked files

# List stashes
git stash list

# Apply stash
git stash apply          # Keep stash
git stash pop            # Apply and remove

# Drop stash
git stash drop stash@{0}
git stash clear          # Remove all stashes
```

---

## Undoing Changes

```bash
# Working directory changes
git checkout -- file.txt     # Discard changes
git restore file.txt         # Modern way

# Unstage files
git reset HEAD file.txt      # Unstage
git restore --staged file.txt  # Modern way

# Amend last commit
git commit --amend -m "new message"
git commit --amend --no-edit  # Keep message

# Reset commits
git reset --soft HEAD~1    # Keep changes staged
git reset --mixed HEAD~1   # Keep changes unstaged
git reset --hard HEAD~1    # Discard changes

# Revert commit (creates new commit)
git revert commit-hash
```

---

## Remote Operations

```bash
# Fetch (download, don't merge)
git fetch origin

# Pull (fetch + merge)
git pull
git pull --rebase  # Fetch + rebase

# Push
git push
git push -u origin branch-name  # Set upstream
git push --force  # Force push (use carefully!)
git push --force-with-lease  # Safer force push

# Delete remote branch
git push origin --delete branch-name
```

---

## Viewing Changes

```bash
# Unstaged changes
git diff

# Staged changes
git diff --staged
git diff --cached

# Changes between commits
git diff commit1 commit2

# Changes in a branch
git diff main..feature-branch

# Show specific commit
git show commit-hash

# File history
git log -p file.txt
git log --follow -p file.txt  # Follow renames
```

---

## Tagging

```bash
# List tags
git tag

# Create tags
git tag v1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags
git push origin v1.0.0
git push origin --tags  # All tags

# Delete tags
git tag -d v1.0.0
git push origin --delete v1.0.0
```

---

## GitHub CLI Commands

```bash
# Clone
gh repo clone user/repo

# Create repository
gh repo create my-repo --public

# Create pull request
gh pr create --title "Feature" --body "Description"

# List pull requests
gh pr list

# View pull request
gh pr view 123

# Merge pull request
gh pr merge 123

# Create issue
gh issue create --title "Bug" --body "Description"

# List issues
gh issue list
```

---

## Common Workflows

### Feature Branch Workflow

```bash
# Start new feature
git checkout main
git pull
git checkout -b feature/new-thing

# Work on feature
git add .
git commit -m "feat: add new feature"

# Keep updated with main
git fetch origin
git rebase origin/main

# Push and create PR
git push -u origin feature/new-thing
gh pr create
```

### Hotfix Workflow

```bash
# Create hotfix branch from main
git checkout main
git checkout -b hotfix/critical-bug

# Fix the bug
git add .
git commit -m "fix: critical bug"

# Merge to main and develop
git checkout main
git merge hotfix/critical-bug
git push

# Delete hotfix branch
git branch -d hotfix/critical-bug
```

---

## Interactive Rebase Commands

```bash
git rebase -i HEAD~3

# Commands in editor:
pick   = use commit
reword = use commit, edit message
edit   = use commit, amend
squash = use commit, meld into previous
fixup  = like squash, discard commit message
drop   = remove commit
```

---

## Cherry-Picking

```bash
# Apply specific commit
git cherry-pick commit-hash

# Apply multiple commits
git cherry-pick commit1 commit2

# Apply without committing
git cherry-pick --no-commit commit-hash
```

---

## Useful Aliases

```bash
# Add aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.last "log -1 HEAD"
git config --global alias.unstage "reset HEAD --"
```

---

## Gitignore Patterns

```gitignore
# Files
*.log
*.pyc
node_modules/

# Directories
build/
dist/
.cache/

# Specific file
config.local.js

# Negation (include)
!important.log
```

---

## Common Scenarios

### Recover Deleted Branch

```bash
# Find the commit hash
git reflog

# Recreate branch
git checkout -b recovered-branch commit-hash
```

### Squash Last N Commits

```bash
git reset --soft HEAD~N
git commit -m "combined message"
```

### Split a Commit

```bash
git reset HEAD~1
git add -p  # Stage interactively
git commit -m "first part"
git add .
git commit -m "second part"
```

---

## Best Practices

```
COMMIT MESSAGES
□ Use imperative mood ("add" not "added")
□ Keep subject under 50 characters
□ Use body for detailed explanation
□ Reference issues/PRs

BRANCHES
□ Use descriptive names (feature/, fix/, hotfix/)
□ Keep branches short-lived
□ Delete merged branches

WORKFLOW
□ Pull before pushing
□ Don't force push shared branches
□ Review changes before committing
□ Use .gitignore appropriately
```

---

## Quick Reference

```bash
# Status
git status

# Add
git add .

# Commit
git commit -m "message"

# Push
git push

# Pull
git pull

# Branch
git branch -a

# Merge
git merge branch-name

# Stash
git stash
git stash pop

# Log
git log --oneline --graph
```
