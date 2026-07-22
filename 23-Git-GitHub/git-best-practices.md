# Git Best Practices

This document outlines best practices for using Git effectively in team environments.

## Branch Naming Conventions

### Standard Branch Names
- `main` or `master` - Production-ready code
- `develop` - Integration branch for features
- `release/*` - Release preparation branches
- `hotfix/*` - Emergency fixes for production
- `feature/*` - New feature development

### Feature Branch Naming
```
feature/user-authentication
feature/payment-integration
feature/api-rate-limiting
```

### Branch Naming Rules
- Use lowercase letters
- Use hyphens to separate words
- Be descriptive but concise
- Include ticket/issue numbers when applicable

## Commit Message Conventions

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code formatting, whitespace
- `refactor` - Code refactoring
- `test` - Adding or fixing tests
- `chore` - Maintenance tasks

### Examples
```
feat(auth): add password reset functionality

Add password reset endpoint and email template.
Users can now reset their password via email link.

Closes #123
```

```
fix(api): handle null response in user endpoint

Added null check to prevent 500 error when user
data is missing from database response.
```

## Workflow Best Practices

### Feature Branch Workflow
1. Create a feature branch from `develop`
2. Make small, focused commits
3. Write meaningful commit messages
4. Push to remote regularly
5. Create a Pull Request
6. Address review feedback
7. Merge into `develop`

### Code Review Process
- Review code before merging
- Keep PRs small and focused
- Use descriptive PR titles
- Link to relevant issues
- Test the code locally before approving

### Merge Strategies
- **Squash and merge**: Combine all commits into one (clean history)
- **Rebase and merge**: Apply commits on top of target branch
- **Merge commit**: Create a merge commit (preserves history)

## Repository Management

### .gitignore Best Practices
- Ignore build artifacts (`dist/`, `build/`, `*.pyc`)
- Ignore dependencies (`node_modules/`, `vendor/`)
- Ignore environment files (`.env`, `.env.local`)
- Ignore IDE files (`.vscode/`, `.idea/`)
- Ignore OS files (`.DS_Store`, `Thumbs.db`)

### Tagging Releases
```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags
git push origin v1.0.0
git push origin --tags
```

### Repository Cleanup
- Regularly prune stale branches
- Remove merged branches
- Archive old repositories
- Review and update .gitignore

## Collaboration Guidelines

### Pull Request Template
```
## Description
Brief description of changes

## Changes
- List of changes made
- Breaking changes (if any)

## Testing
- How to test these changes
- Any test cases added

## Related Issues
Fixes #123
```

### Code Review Checklist
- [ ] Code follows project style guidelines
- [ ] Tests are added or updated
- [ ] Documentation is updated
- [ ] No security vulnerabilities
- [ ] Performance considerations addressed
- [ ] Error handling is appropriate

### Conflict Resolution
```bash
# Fetch latest changes
git fetch origin

# Rebase feature branch on main
git rebase origin/main

# Resolve conflicts in files
# Then continue rebase
git add .
git rebase --continue

# Or abort if needed
git rebase --abort
```

## Advanced Git Techniques

### Interactive Rebasing
```bash
# Rebase last 3 commits
git rebase -i HEAD~3

# Squash commits, edit messages, reorder
```

### Cherry-Picking
```bash
# Apply a specific commit
git cherry-pick <commit-hash>

# Apply without committing
git cherry-pick -n <commit-hash>
```

### Stashing
```bash
# Save uncommitted changes
git stash

# Save with message
git stash save "WIP: feature work"

# List stashes
git stash list

# Apply stash
git stash apply

# Apply and drop
git stash pop
```

### Git Hooks
- `pre-commit`: Run before commit (linting, tests)
- `pre-push`: Run before push (integration tests)
- `commit-msg`: Validate commit message format
- `post-merge`: Run after merge (install dependencies)

## Security Best Practices

### Credential Management
- Use credential helpers (SSH keys, credential store)
- Never commit credentials or secrets
- Use environment variables for sensitive data
- Rotate credentials regularly

### SSH Key Setup
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Signed Commits
```bash
# Enable GPG signing
git config --global commit.gpgsign true

# Sign a specific commit
git commit -S -m "Signed commit"
```

## Performance Optimization

### Shallow Clones
```bash
# Clone only the latest commit
git clone --depth 1 <repo-url>
```

### Sparse Checkout
```bash
# Checkout only specific directories
git sparse-checkout init --cone
git sparse-checkout set src/
```

### Git Configuration
```bash
# Set default branch name
git config --global init.defaultBranch main

# Set line endings
git config --global core.autocrlf input

# Set editor
git config --global core.editor "code --wait"
```

## See Also

- [[git-commands]]
- [[git-guide]]
- [[github-collaboration]]
