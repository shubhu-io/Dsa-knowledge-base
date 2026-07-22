# AGENTS.md - Repository Guide

## Repository Purpose

This is a **Computer Science & Software Engineering Knowledge Base** - a documentation-only repository containing educational content, code examples, and learning resources. It is NOT a software project with builds, tests, or deployments.

## Structure

- **55 numbered directories** (`00-Getting-Started/` through `54-Resources/`) organized by topic
- **Markdown files** for documentation and explanations
- **Code examples** in multiple languages (C, C++, Java, Python, JavaScript)
- **No build system, tests, or CI/CD** - this is pure documentation

## Adding/Modifying Content

### File Naming
- Markdown: lowercase with hyphens: `topic-name.md`
- Code files: follow language conventions (`.py`, `.java`, `.cpp`, `.c`, `.js`)

### Code Examples Order
When adding multi-language examples, use this order:
1. C
2. C++
3. Java
4. Python
5. JavaScript

### Code Style
- Include problem description as comments at top
- Add docstrings/comments explaining approach
- Include time/space complexity in comments
- Add example usage with `if __name__ == "__main__":`

### Markdown Formatting
- Use proper heading hierarchy
- Code fences with language specifiers
- Tables for comparisons
- Blockquotes for important notes
- Keep lines under 100 characters

## Key Files

- `README.md` - Main repository overview
- `CONTRIBUTING.md` - Contribution guidelines
- `SUMMARY.md` - Content summary
- `00-Getting-Started/how-to-use.md` - Usage guide

## Commands

No build/test commands - this is documentation only. Content is edited directly.
