# GitHub Collaboration Guide

## 1. GitHub Overview

GitHub is a cloud platform for version control and collaboration built on Git. It adds a rich layer of features on top of Git for teamwork, project management, and automation.

### Core Features

| Feature | Description |
|---------|-------------|
| **Repositories** | Hosted Git repositories with web UI |
| **Pull Requests** | Code review and merge workflow |
| **Issues** | Bug tracking and feature requests |
| **Actions** | CI/CD automation workflows |
| **Projects** | Kanban boards for project management |
| **Pages** | Static website hosting |
| **Packages** | Package hosting (npm, Docker, etc.) |
| **Discussions** | Community forums |
| **Security** | Code scanning, dependency alerts |

---

## 2. Pull Requests (PRs)

### Creating a Pull Request

```bash
# 1. Create a branch and make changes
git checkout -b feature/new-feature
git add .
git commit -m "Add new feature"

# 2. Push to remote
git push -u origin feature/new-feature

# 3. Create PR on GitHub
# - Navigate to repo → "Pull requests" → "New pull request"
# - Select base branch (main) and compare branch (feature/new-feature)
# - Fill in title and description
# - Assign reviewers
# - Create pull request
```

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Changes
- Added new authentication endpoint
- Implemented JWT token validation
- Added unit tests for auth module

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here.

## Related Issues
Closes #123
Fixes #456
```

### PR Best Practices

| Practice | Description |
|----------|-------------|
| **Keep PRs small** | < 400 lines changed preferred |
| **One concern per PR** | Don't mix features and fixes |
| **Write good descriptions** | Explain what and why |
| **Link related issues** | Use `Closes #123` |
| **Add tests** | Cover new functionality |
| **Request specific reviewers** | People who know the code |
| **Respond to feedback promptly** | Don't let PRs go stale |
| **Use draft PRs** | For work-in-progress visibility |

### Code Review Checklist

```markdown
## Code Review Checklist

### Functionality
- [ ] Does the code do what it claims?
- [ ] Are edge cases handled?
- [ ] Is error handling appropriate?

### Code Quality
- [ ] Is the code readable and well-structured?
- [ ] Are there any code smells?
- [ ] Are naming conventions consistent?

### Testing
- [ ] Are there adequate tests?
- [ ] Do tests cover edge cases?
- [ ] Are tests readable?

### Security
- [ ] No hardcoded secrets?
- [ ] Input validation present?
- [ ] SQL injection prevented?

### Performance
- [ ] No obvious performance issues?
- [ ] Database queries optimized?
- [ ] Memory usage reasonable?
```

---

## 3. Issues

### Creating Issues

| Type | When to Use |
|------|-------------|
| **Bug Report** | Something is broken |
| **Feature Request** | New functionality needed |
| **Enhancement** | Improve existing functionality |
| **Documentation** | Docs need updating |
| **Question** | Need clarification |

### Bug Report Template

```markdown
## Bug Description
A clear description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- OS: [e.g., Windows 11]
- Browser: [e.g., Chrome 120]
- Version: [e.g., v2.1.0]

## Additional Context
Any other context about the problem.
```

### Issue Management

```markdown
# Labels
bug          - Something isn't working
enhancement  - New feature or improvement
documentation - Improvements to docs
good first issue - Good for newcomers
help wanted  - Extra attention needed
priority/high - High priority
status/in-progress - Currently being worked on

# Milestones
v1.0         - Features for version 1.0
v1.1         - Features for version 1.1

# Assignees
@john        - Assigned to John
@jane        - Assigned to Jane
```

---

## 4. GitHub Actions (CI/CD)

### Basic Workflow File

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run tests
        run: npm test
      
      - name: Build
        run: npm run build
```

### Deployment Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Your deployment script here
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
          API_TOKEN: ${{ secrets.API_TOKEN }}
```

### Common Actions

```yaml
# Matrix testing
strategy:
  matrix:
    node-version: [18, 20, 22]
    os: [ubuntu-latest, windows-latest]

# Caching
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

# Artifacts
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/

# Environment secrets
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

---

## 5. GitHub Pages

### Setting Up GitHub Pages

```yaml
# .github/workflows/pages.yml
name: Deploy to Pages

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
    steps:
      - uses: actions/deploy-pages@v4
```

---

## 6. Repository Management

### README Best Practices

```markdown
# Project Name

Brief description of what the project does.

## Features
- Feature 1
- Feature 2
- Feature 3

## Installation
```bash
git clone https://github.com/user/repo.git
cd repo
npm install
```

## Usage
```bash
npm start
```

## API Reference
Link to API docs.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
[MIT](LICENSE)
```

### CONTRIBUTING.md

```markdown
# Contributing

## How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

## Development Setup

1. Install dependencies: `npm install`
2. Run tests: `npm test`
3. Run linter: `npm run lint`

## Code Style

- Use ESLint configuration
- Follow existing code patterns
- Write meaningful commit messages

## Reporting Bugs

Use the bug report template when creating an issue.
```

### LICENSE

Common licenses:

| License | Description |
|---------|-------------|
| **MIT** | Permissive, minimal restrictions |
| **Apache 2.0** | Permissive with patent protection |
| **GPL v3** | Copyleft, derivative works must be open source |
| **BSD 3-Clause** | Permissive, no trademark rights |
| **Unlicense** | Public domain |

---

## 7. GitHub CLI (gh)

### Installation

```bash
# macOS
brew install gh

# Windows
winget install GitHub.cli

# Linux
sudo apt install gh
```

### Common Commands

```bash
# Authentication
gh auth login
gh auth status

# Repositories
gh repo create my-project --public
gh repo clone user/repo
gh repo view
gh repo fork user/repo

# Pull Requests
gh pr create --title "New Feature" --body "Description"
gh pr list
gh pr checkout 123
gh pr merge 123
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Need changes"

# Issues
gh issue create --title "Bug" --body "Description"
gh issue list
gh issue close 456
gh issue reopen 456

# Actions
gh run list
gh run view 12345
gh run rerun 12345

# Gists
gh gist create file.txt
gh gist list
```

### gh Aliases

```bash
# Create useful aliases
gh alias set prc 'pr create --fill'
gh alias set prs 'pr list --state open'
gh alias set pr checkout
gh alias set co 'pr checkout'
```

---

## 8. Collaboration Workflows

### Team Workflow

```
1. Assign Issues
   ├── Team lead assigns issues
   ├── Developer picks up issue
   └── Creates feature branch

2. Development
   ├── Create branch from main
   ├── Make changes
   ├── Write tests
   └── Push to remote

3. Code Review
   ├── Create Pull Request
   ├── Request reviewers
   ├── Address feedback
   └── Get approval

4. Merge
   ├── CI passes
   ├── Review approved
   ├── Squash or merge
   └── Delete feature branch

5. Deploy
   ├── Main branch updated
   ├── CI/CD pipeline runs
   └── Changes deployed
```

### Protecting Main Branch

Settings → Branches → Add rule:

```
Branch name pattern: main

☑ Require pull request reviews before merging
  └── Required approving reviews: 1
  └── Dismiss stale reviews on new pushes
☑ Require status checks before merging
  └── Require branches to be up to date
  └── Status checks: ci/test, ci/lint
☑ Require conversation resolution before merging
☑ Require linear history (squash or rebase only)
☑ Do not allow bypassing the above settings
```

---

## 9. GitHub Security Features

### Dependabot

Automatically monitors dependencies for vulnerabilities.

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    labels:
      - "dependencies"
```

### Secret Scanning

- Automatically detects exposed secrets (API keys, tokens)
- Alerts repository owners
- Can auto-revoke detected secrets

### Code Scanning (CodeQL)

```yaml
# .github/workflows/codeql.yml
name: CodeQL Analysis

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript
      - uses: github/codeql-action/analyze@v3
```

---

## 10. GitHub Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `.` | Open file in web editor |
| `t` | File finder |
| `s` or `/` | Search |
| `g n` | Go to notifications |
| `g c` | Go to code |
| `g i` | Go to issues |
| `g p` | Go to pull requests |
| `g a` | Go to Actions |

### Markdown Shortcuts in GitHub

| Syntax | Result |
|--------|--------|
| `` `code` `` | Inline code |
| ``` ```code``` ``` | Code block |
| `**bold**` | **Bold** |
| `*italic*` | *Italic* |
| `~~strike~~` | ~~Strike~~ |
| `- [ ] task` | Task list |
| `@username` | Mention user |
| `#123` | Link to issue |
| `user/repo#123` | Link to issue in another repo |
| `:emoji:` | Emoji (`:rocket:`, `:bug:`, `:white_check_mark:`) |

---

## 11. GitHub API

### REST API Examples

```bash
# Get repo info
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/owner/repo

# Create issue
curl -X POST -H "Authorization: token YOUR_TOKEN" \
  -d '{"title":"Bug report","body":"Description"}' \
  https://api.github.com/repos/owner/repo/issues

# List PRs
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/owner/repo/pulls?state=open
```

### GraphQL API

```graphql
query {
  repository(owner: "user", name: "repo") {
    pullRequests(first: 10, states: OPEN) {
      nodes {
        title
        author { login }
        createdAt
        reviewDecision
      }
    }
  }
}
```

---

## 12. GitHub Tips and Tricks

| Tip | Description |
|-----|-------------|
| **Quick file edit** | Press `.` on any file to open web editor |
| **Compare references** | `main...feature` to compare branches |
| **Keyboard shortcuts** | Press `?` for shortcut list |
| **Notifications** | Customize in Settings → Notifications |
| **Custom domains** | Use CNAME for GitHub Pages |
| **Templates** | Create issue and PR templates |
| **CODEOWNERS** | Auto-assign reviewers by file path |
| **Stale bot** | Auto-close inactive issues |

### CODEOWNERS File

```
# .github/CODEOWNERS

# Default owners for everything
* @team-leads

# Frontend code
/src/frontend/ @frontend-team

# API code
/src/api/ @backend-team

# Documentation
/docs/ @docs-team

# CI/CD
/.github/ @devops-team
```

---

## Summary

| Topic | Key Takeaway |
|-------|-------------|
| **Pull Requests** | Code review + merge workflow; keep PRs small and focused |
| **Issues** | Track bugs, features, and tasks with templates and labels |
| **Actions** | Automate CI/CD with YAML workflows |
| **Pages** | Host static sites from repositories |
| **CLI (gh)** | Powerful command-line interface for GitHub |
| **Security** | Dependabot, secret scanning, CodeQL |
| **Branch Protection** | Require reviews, status checks, and linear history |
| **CODEOWNERS** | Auto-assign reviewers based on file paths |

> **Key Insight**: GitHub is more than just code hosting. It's a complete development platform. Leverage Issues for planning, PRs for code quality, Actions for automation, and Projects for workflow management.
