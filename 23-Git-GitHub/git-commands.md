# Git Commands Reference

## 1. Setup and Configuration

| Command | Description |
|---------|-------------|
| `git init` | Initialize new repository |
| `git clone <url>` | Clone remote repository |
| `git config --global user.name "name"` | Set username |
| `git config --global user.email "email"` | Set email |
| `git config --list` | Show all configuration |
| `git config --global core.editor vim` | Set default editor |

---

## 2. Creating Snapshots (Staging & Committing)

### Staging

| Command | Description |
|---------|-------------|
| `git add <file>` | Stage specific file |
| `git add .` | Stage all changes |
| `git add -A` | Stage all changes (whole repo) |
| `git add -p` | Stage interactively (hunks) |
| `git add -i` | Interactive staging menu |
| `git restore --staged <file>` | Unstage a file |

### Committing

| Command | Description |
|---------|-------------|
| `git commit -m "message"` | Commit staged changes |
| `git commit -am "message"` | Stage tracked files + commit |
| `git commit --amend` | Modify last commit |
| `git commit --amend -m "new"` | Amend commit message |
| `git commit --amend --no-edit` | Amend without changing message |
| `git commit --amend --author="Name <email>"` | Amend author |
| `git commit -S` | GPG signed commit |

### Commit Examples

```bash
# Quick commit
git add file.txt && git commit -m "Add file"

# Stage all and commit
git commit -am "Fix login bug"

# Amend last commit with new message
git commit --amend -m "Fix login validation bug"

# Add co-author
git commit -m "Add feature

Co-authored-by: Jane <jane@example.com>"
```

---

## 3. Branching

| Command | Description |
|---------|-------------|
| `git branch` | List local branches |
| `git branch -a` | List all branches |
| `git branch -r` | List remote branches |
| `git branch <name>` | Create branch |
| `git branch -d <name>` | Delete merged branch |
| `git branch -D <name>` | Force delete branch |
| `git branch -m <old> <new>` | Rename branch |
| `git branch -v` | Show last commit on each branch |
| `git branch --merged` | Show merged branches |
| `git branch --no-merged` | Show unmerged branches |

### Switching

| Command | Description |
|---------|-------------|
| `git checkout <branch>` | Switch branch (legacy) |
| `git checkout -b <branch>` | Create + switch (legacy) |
| `git switch <branch>` | Switch branch (modern) |
| `git switch -c <branch>` | Create + switch (modern) |
| `git switch -` | Switch to previous branch |

---

## 4. Viewing History

| Command | Description |
|---------|-------------|
| `git log` | Show commit history |
| `git log --oneline` | Compact one-line log |
| `git log --graph` | ASCII graph of branches |
| `git log --all --oneline --graph` | Full graph |
| `git log -n 5` | Last 5 commits |
| `git log --author="John"` | Filter by author |
| `git log --grep="fix"` | Filter by message |
| `git log --since="2 weeks ago"` | Filter by date |
| `git log -- file.txt` | History of specific file |
| `git log -p` | Show diffs |
| `git log --stat` | Show file changes |

### Show and Diff

| Command | Description |
|---------|-------------|
| `git show <commit>` | Show commit details |
| `git show HEAD` | Show latest commit |
| `git diff` | Working dir vs staging |
| `git diff --staged` | Staging vs last commit |
| `git diff HEAD` | Working dir vs last commit |
| `git diff branch1..branch2` | Compare branches |
| `git diff HEAD~3` | Compare with 3 commits ago |
| `git diff --stat` | Summary of changes |

### Advanced Log Formats

```bash
# Custom format
git log --pretty=format:"%h %s (%an, %ar)" -10

# %h = short hash, %s = subject, %an = author name
# %ar = relative date, %ad = date, %D = refs

# Prettier graph
git log --oneline --graph --all --decorate

# Count commits
git rev-list --count HEAD

# Find who changed a line
git blame file.txt
git blame -L 10,20 file.txt    # Lines 10-20 only
```

---

## 5. Merging

| Command | Description |
|---------|-------------|
| `git merge <branch>` | Merge branch into current |
| `git merge --no-ff <branch>` | Merge with merge commit |
| `git merge --squash <branch>` | Squash merge |
| `git merge --abort` | Abort current merge |
| `git merge --no-commit <branch>` | Merge without auto-commit |

### Merge Types

```bash
# Fast-forward merge (if possible)
git checkout main
git merge feature

# No fast-forward (always create merge commit)
git merge --no-ff feature

# Squash merge (combine all changes into one commit)
git checkout main
git merge --squash feature
git commit -m "Implement feature X"

# Abort merge on conflict
git merge --abort
```

---

## 6. Rebase

| Command | Description |
|---------|-------------|
| `git rebase <branch>` | Rebase current branch onto branch |
| `git rebase -i HEAD~5` | Interactive rebase last 5 commits |
| `git rebase --abort` | Abort current rebase |
| `git rebase --continue` | Continue after resolving conflict |
| `git rebase --skip` | Skip current commit |

### Interactive Rebase Commands

| Command | Effect |
|---------|--------|
| `pick` | Use commit as-is |
| `reword` | Use commit, edit message |
| `edit` | Pause to amend commit |
| `squash` | Combine with previous, keep both messages |
| `fixup` | Combine with previous, discard this message |
| `drop` | Remove commit entirely |
| `exec` | Run shell command after this commit |

### Rebase Examples

```bash
# Rebase feature onto main
git checkout feature
git rebase main

# Squash last 3 commits
git rebase -i HEAD~3

# Rebase onto a different branch
git rebase --onto main old-base feature
```

---

## 7. Remote Operations

| Command | Description |
|---------|-------------|
| `git remote -v` | List remotes |
| `git remote add <name> <url>` | Add remote |
| `git remote remove <name>` | Remove remote |
| `git remote rename <old> <new>` | Rename remote |
| `git remote set-url <name> <url>` | Change URL |
| `git fetch <remote>` | Download (no merge) |
| `git fetch --all` | Fetch all remotes |
| `git pull <remote> <branch>` | Fetch + merge |
| `git pull --rebase` | Fetch + rebase |
| `git push <remote> <branch>` | Push branch |
| `git push -u <remote> <branch>` | Push + set upstream |
| `git push --force` | Force push (DANGEROUS) |
| `git push --force-with-lease` | Safe force push |
| `git push origin --tags` | Push all tags |
| `git push origin :branch` | Delete remote branch |

---

## 8. Stashing

| Command | Description |
|---------|-------------|
| `git stash` | Stash all changes |
| `git stash push -m "msg"` | Stash with message |
| `git stash -u` | Include untracked files |
| `git stash -a` | Include all (ignored too) |
| `git stash list` | List all stashes |
| `git stash pop` | Apply + remove latest |
| `git stash apply` | Apply without removing |
| `git stash apply stash@{2}` | Apply specific stash |
| `git stash drop stash@{0}` | Delete specific stash |
| `git stash clear` | Delete all stashes |
| `git stash show -p` | Show stash diff |
| `git stash branch <name>` | Create branch from stash |

---

## 9. Undoing Changes

| Scenario | Command |
|----------|---------|
| Discard working dir changes | `git restore <file>` |
| Unstage file | `git restore --staged <file>` |
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo last commit (unstage) | `git reset HEAD~1` |
| Undo last commit (discard) | `git reset --hard HEAD~1` |
| Revert commit (safe) | `git revert <hash>` |
| Revert merge commit | `git revert -m 1 <hash>` |
| Recover deleted branch | `git reflog` then `git checkout <hash>` |
| Recover dropped stash | `git fsck --unreachable` |

### reset vs revert vs restore

| Command | Scope | Safety | Effect |
|---------|-------|--------|--------|
| `restore` | Working dir / staging | Safe | Discard changes |
| `reset` | HEAD + staging + (optionally) working dir | Destructive | Move HEAD, discard changes |
| `revert` | Commits | Safe | Create new commit that undoes changes |

---

## 10. Tags

| Command | Description |
|---------|-------------|
| `git tag` | List tags |
| `git tag <name>` | Create lightweight tag |
| `git tag -a <name> -m "msg"` | Create annotated tag |
| `git tag -a <name> <hash>` | Tag older commit |
| `git tag -d <name>` | Delete local tag |
| `git push origin <tag>` | Push tag |
| `git push origin --tags` | Push all tags |
| `git push origin :refs/tags/<name>` | Delete remote tag |
| `git checkout <tag>` | Checkout tag (detached HEAD) |
| `git describe --tags` | Describe current position by tag |

---

## 11. Inspection and Debugging

| Command | Description |
|---------|-------------|
| `git show <commit>` | Show commit details |
| `git blame <file>` | Who changed what and when |
| `git bisect start` | Start binary search for bug |
| `git bisect good <hash>` | Mark good commit |
| `git bisect bad <hash>` | Mark bad commit |
| `git bisect reset` | End bisect session |
| `git reflog` | Show all HEAD movements |
| `git fsck` | Check repository integrity |
| `git gc` | Garbage collection |
| `git prune` | Remove unreachable objects |

### bisect Example

```bash
git bisect start
git bisect bad              # Current commit is bad
git bisect good v1.0        # v1.0 was good

# Git checks out a middle commit
# Test it, then mark:
git bisect good    # or git bisect bad

# Repeat until Git finds the first bad commit
# Then:
git bisect reset
```

---

## 12. Cleanup

| Command | Description |
|---------|-------------|
| `git clean -f` | Remove untracked files |
| `git clean -fd` | Remove untracked files + directories |
| `git clean -fdi` | Interactive clean |
| `git clean -fX` | Remove only ignored files |
| `git clean -fx` | Remove untracked + ignored files |
| `git gc` | Garbage collect + optimize |
| `git gc --aggressive` | Deep clean |
| `git prune` | Remove unreachable objects |

---

## 13. Advanced Commands

| Command | Description |
|---------|-------------|
| `git cherry-pick <hash>` | Apply specific commit |
| `git cherry-pick <hash1>..<hash2>` | Apply range of commits |
| `git cherry-pick --abort` | Abort cherry-pick |
| `git worktree add ../dir branch` | Create linked working tree |
| `git submodule add <url> <path>` | Add submodule |
| `git submodule update --init` | Initialize submodules |
| `git archive --format=zip HEAD` | Create archive |
| `git shortlog -sn` | Count commits per author |
| `git count-objects` | Repository size info |

### cherry-pick Example

```bash
# Apply a single commit from another branch
git checkout main
git cherry-pick abc1234

# Apply range (excluding start)
git cherry-pick abc1234..def5678

# Apply multiple commits
git cherry-pick abc1234 def5678 ghi9012
```

---

## Quick Reference Card

| Task | Command |
|------|---------|
| Start new project | `git init && git add . && git commit -m "Initial commit"` |
| Clone project | `git clone <url>` |
| Save changes | `git add . && git commit -m "message"` |
| Upload changes | `git push` |
| Download changes | `git pull` |
| Create branch | `git switch -c feature` |
| Merge branch | `git checkout main && git merge feature` |
| View history | `git log --oneline --graph --all` |
| Undo changes | `git restore <file>` |
| Undo commit | `git revert <hash>` |
| Temporarily shelve | `git stash` |
| Apply stashed changes | `git stash pop` |
| Find bug | `git bisect start` |
| See who changed line | `git blame <file>` |
