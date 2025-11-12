# Interactive Setup Guide

Complete guide to using the interactive Claude Code setup script.

## Overview

The interactive setup script ([setup-claude-structure-interactive.sh](setup-claude-structure-interactive.sh)) provides a customizable way to create a Claude Code development environment tailored to your project's specific needs.

## Getting Started

### Prerequisites

- Bash shell (macOS, Linux, WSL on Windows)
- Git repository (recommended, but not required)
- Basic understanding of your project's tech stack

### Running the Script

```bash
# Navigate to your project directory
cd /path/to/your/project

# Run the interactive setup
/path/to/create-claude-structure/setup-claude-structure-interactive.sh
```

## Interactive Prompts Explained

### 1. Project Information

#### Project Name
```
Project name [my-project]:
```
- **Default**: Current directory name
- **What it does**: Used in CLAUDE.md and documentation
- **Example**: `my-react-app`, `api-service`, `ml-pipeline`

#### Tech Stack Selection
```
Select your primary tech stack:
  1) TypeScript/JavaScript (Node.js, React, etc.)
  2) Python
  3) Go
  4) Java/Kotlin
  5) Rust
  6) Multiple/Other
Enter number [1]:
```
- **What it does**: Optimizes CLAUDE.md, auto-formatting, and permissions
- **TypeScript/JS**: Adds Prettier/ESLint, npm/yarn/pnpm support
- **Python**: Adds Black/isort, pytest support
- **Go**: Adds gofmt, go test support
- **Other**: Allows custom specification

#### Project Description
```
Brief project description [AI-assisted development project]:
```
- **What it does**: Added to CLAUDE.md for context
- **Example**: "E-commerce API backend", "Data analysis pipeline", "React dashboard"

#### Package Manager (for TypeScript/JavaScript)
```
Select your package manager:
  1) npm
  2) yarn
  3) pnpm
Enter number [1]:
```
- **What it does**: Sets up bash permissions and CLAUDE.md commands
- **Affects**: Command examples in CLAUDE.md, allowed bash commands

### 2. Directory Structure Customization

#### .claude Directory
```
Create .claude directory structure? [Y]:
```
- **What it creates**: `.claude/skills/`, `.claude/hooks/`, `.claude/agents/`, `.claude/commands/`, `.claude/plugins/`, `.claude/logs/`
- **Recommendation**: **YES** - Core Claude Code configuration
- **Skip if**: You only want dev workspace or docs

#### Dev Workspace
```
Create dev workspace (active/plans/scratch)? [Y]:
```
- **What it creates**: `dev/active/`, `dev/plans/`, `dev/scratch/` with template files
- **Recommendation**: **YES** for collaborative projects
- **Skip if**: Solo project or have existing workflow docs

#### Docs Structure
```
Create docs structure? [Y]:
```
- **What it creates**: `docs/architecture/`, `docs/onboarding/`, `docs/decisions/`
- **Recommendation**: **YES** for team projects
- **Skip if**: Small prototype or personal project

#### Test Directory
```
Create test directory? [Y]:
Test directory name [tests]:
```
- **What it creates**: Directory for tests (name customizable)
- **Common names**: `tests`, `test`, `__tests__`, `spec`
- **Recommendation**: **YES** if writing tests

#### Source Directory
```
Source code directory name [src]:
```
- **What it does**: Referenced in CLAUDE.md architecture section
- **Common names**: `src`, `lib`, `app`, `pkg` (Go)
- **Note**: Directory not created, just documented

### 3. Features & Enhancements

#### Security Hooks
```
Enable security hooks (protect sensitive files)? [Y]:
```
- **What it does**: Creates `protect-sensitive-files.py` hook
- **Blocks access to**: `.env`, `.key`, `.pem`, `credentials.json`, etc.
- **Recommendation**: **YES** - Prevents accidental exposure
- **Skip if**: Don't want any access restrictions

#### Auto-formatting Hooks
```
Enable auto-formatting hooks? [Y]:
```
- **What it does**: Creates `auto-format.sh` hook
- **Formats**: TypeScript/JS (Prettier), Python (Black), Go (gofmt), Rust (rustfmt)
- **Requires**: Formatters installed on your system
- **Recommendation**: **YES** if you have formatters installed
- **Skip if**: Manual formatting preferred or formatters not installed

#### Telemetry (Token Tracking)
```
Enable telemetry (token usage tracking)? [Y]:
```
- **What it does**: Sets `CLAUDE_CODE_ENABLE_TELEMETRY=1` in settings
- **Enables**: Token tracking via `ccusage` tool
- **Recommendation**: **YES** to monitor usage and costs
- **Skip if**: Privacy concerns or don't care about usage

#### Implementation Logging
```
Enable implementation logging? [Y]:
```
- **What it does**: Creates hooks to log all actions
- **Logs to**: `.claude/logs/` directory
- **Creates**: `implementation-steps.jsonl`, `bash-commands.log`, `tool-usage.log`
- **Recommendation**: **YES** for audit trail
- **Skip if**: Don't want detailed logging

#### Sandboxing
```
Enable sandboxing? [Y]:
```
- **What it does**: Isolates command execution
- **Recommendation**: **YES** for security
- **Skip if**: Need unrestricted bash access (not recommended)

### 4. Commands

#### Quality Checkpoint Commands
```
Install quality checkpoint commands (/qplan, /qcode, /qcheck)? [Y]:
```
- **Creates**: `/qplan.md`, `/qcode.md`, `/qcheck.md`
- **Use for**: Planning, implementation, and review workflows
- **Recommendation**: **YES** for quality-focused development
- **Skip if**: Don't use structured workflows

#### TDD Workflow Command
```
Install TDD workflow command (/tdd)? [Y]:
```
- **Creates**: `/tdd.md`
- **Use for**: Test-driven development workflow
- **Recommendation**: **YES** if practicing TDD
- **Skip if**: Don't write tests first

#### Feature Planning Commands
```
Install feature planning commands? [Y]:
```
- **Creates**: `/create-prd.md`, `/plan-feature.md`, `/usage.md`
- **Use for**: PRD creation, feature planning, usage tracking
- **Recommendation**: **YES** for structured planning
- **Skip if**: Informal planning preferred

### 5. Git Settings

#### Branch Prefixes
```
Git branch prefix for features [feature]:
Git branch prefix for fixes [fix]:
```
- **What it does**: Sets branch naming convention in CLAUDE.md
- **Common patterns**:
  - Features: `feature`, `feat`, `story`
  - Fixes: `fix`, `bugfix`, `hotfix`
- **Recommendation**: Match your team's convention

### 6. Confirmation

```
Configuration Summary:
  Project Name:     my-react-app
  Tech Stack:       TypeScript/JavaScript
  Package Manager:  npm
  ...

Proceed with setup? [Y]:
```
- Review all settings before proceeding
- Type `N` to cancel and start over
- Type `Y` to execute setup

## Decision Guide

### Minimal Setup (Fast Prototyping)

```
✓ Create .claude directory
✗ Create dev workspace
✗ Create docs structure
✗ Create test directory
✓ Enable security hooks
✗ Enable auto-formatting
✗ Enable telemetry
✗ Enable logging
✓ Enable sandboxing
✗ Install quality commands
✗ Install TDD workflow
✗ Install planning commands
```

**Result**: Basic Claude Code setup with security only

### Balanced Setup (Most Projects)

```
✓ Create .claude directory
✓ Create dev workspace
✓ Create docs structure
✓ Create test directory
✓ Enable security hooks
✓ Enable auto-formatting
✓ Enable telemetry
✗ Enable logging
✓ Enable sandboxing
✓ Install quality commands
✗ Install TDD workflow
✗ Install planning commands
```

**Result**: Good balance of features without bloat

### Full Setup (Production/Team)

```
✓ All options enabled
```

**Result**: Complete setup with all features (same as non-interactive script)

## Common Scenarios

### Scenario 1: React Web App

```bash
# Setup choices:
- Project: my-web-app
- Tech Stack: TypeScript/JavaScript
- Package Manager: npm
- Enable: Security, Auto-format, Telemetry
- Install: Quality commands
- Skip: Logging, TDD, Planning
```

**Reasoning**: Web apps need formatting and quality checks, but logging adds overhead

### Scenario 2: Python ML Pipeline

```bash
# Setup choices:
- Project: ml-pipeline
- Tech Stack: Python
- Package Manager: pip
- Enable: Security, Auto-format, Logging
- Install: Quality commands, Planning
- Skip: Telemetry (long-running jobs), TDD
```

**Reasoning**: ML projects benefit from logging, planning, but tests come later

### Scenario 3: Go Microservice

```bash
# Setup choices:
- Project: auth-service
- Tech Stack: Go
- Package Manager: go
- Enable: All security, logging, monitoring
- Install: All commands
```

**Reasoning**: Production services need full observability and quality gates

### Scenario 4: Quick Prototype

```bash
# Setup choices:
- Enable: Security only
- Install: Nothing
- Skip: Everything else
```

**Reasoning**: Minimal setup for quick experimentation

## After Setup

### 1. Verify Installation

```bash
# Check created structure
ls -la .claude/
ls -la dev/
ls -la docs/

# Review CLAUDE.md
cat CLAUDE.md

# Check settings
cat .claude/settings.json | jq .
```

### 2. Install Dependencies (if needed)

```bash
# Token tracking (if telemetry enabled)
npm install -g ccusage

# Formatters (if auto-format enabled)
# TypeScript/JavaScript:
npm install -g prettier eslint

# Python:
pip install black isort

# Go: Already included
# Rust: Already included
```

### 3. Test Features

```bash
# Test security hook (should block)
claude code
> Read .env

# Test auto-format (if enabled)
claude code
> Format this file: myfile.ts

# Check token usage (if telemetry enabled)
npx ccusage@latest daily

# Use quality commands (if installed)
/qplan
/qcode
/qcheck
```

### 4. Customize

```bash
# Edit project-specific details
nano CLAUDE.md

# Adjust permissions
nano .claude/settings.json

# Add custom commands
nano .claude/commands/my-command.md
```

## Tips & Best Practices

1. **Start Lean**: Only enable what you need now, add features later
2. **Match Your Workflow**: Choose commands that fit how you work
3. **Team Consistency**: Use same setup across team for consistency
4. **Test Before Committing**: Try the setup in a test directory first
5. **Document Choices**: Add comments in CLAUDE.md about why you chose settings
6. **Iterate**: Re-run setup in new branch to test different configurations

## Troubleshooting

### Script Not Running

```bash
# Make executable
chmod +x setup-claude-structure-interactive.sh

# Check bash availability
which bash
```

### Formatters Not Working

```bash
# Install formatters first
npm install -g prettier eslint  # TypeScript/JS
pip install black isort         # Python
```

### Hooks Not Executing

```bash
# Make hooks executable
chmod +x .claude/hooks/*.sh
chmod +x .claude/hooks/*.py

# Test hook manually
echo '{"tool_input":{"file_path":".env"}}' | .claude/hooks/protect-sensitive-files.py
```

### Settings Invalid

```bash
# Validate JSON
cat .claude/settings.json | jq .

# If invalid, re-run setup or fix manually
```

## Advanced Customization

### Add Custom Tech Stack

Edit the script to add your tech stack:

```bash
# Around line 80 in setup-claude-structure-interactive.sh
7) TECH_STACK="Ruby"
   FORMATTERS="RuboCop"
   LINTERS="RuboCop"
   PKG_MANAGER="gem"
   ;;
```

### Custom Default Values

Edit defaults in script:

```bash
prompt_with_default "Project name" "$(basename "$PROJECT_ROOT")" PROJECT_NAME
# Change to:
prompt_with_default "Project name" "my-default-name" PROJECT_NAME
```

### Preset Configurations

Create wrapper scripts:

```bash
# minimal-setup.sh
#!/bin/bash
echo -e "n\nn\nn\ny\nn\nn\nn\ny\nn\nn\nn\ny\n" | ./setup-claude-structure-interactive.sh
```

## Resources

- [Non-Interactive Setup](setup-claude-structure.sh) - Full-featured version
- [Main README](README.md) - Complete documentation
- [Claude Code Docs](https://docs.claude.com/claude-code)
- [ccusage Tool](https://www.npmjs.com/package/ccusage)

## Getting Help

- Review this guide
- Check [README.md](README.md) for examples
- Read [CLAUDE.md](CLAUDE.md) after setup
- Check logs in `.claude/logs/`

---

**Ready to create your customized Claude Code setup!** 🚀
