# Script Comparison: Interactive vs Non-Interactive

Quick reference guide to help you choose between the two setup scripts.

## At a Glance

| Aspect | Interactive Script | Non-Interactive Script |
|--------|-------------------|------------------------|
| **File** | `setup-claude-structure-interactive.sh` | `setup-claude-structure.sh` |
| **Time to Complete** | ~2 minutes | ~30 seconds |
| **User Input** | Required throughout | None |
| **Customization** | Full control | None (all features) |
| **Best For** | Production projects | Quick prototyping |

## Feature Comparison

### ✅ Interactive Script Features

| Feature | Customizable? | Description |
|---------|--------------|-------------|
| Project Name | ✅ Yes | Enter your project name |
| Tech Stack | ✅ Yes | Choose from 6 options or custom |
| Package Manager | ✅ Yes | npm, yarn, pnpm, pip, go, etc. |
| Directory Structure | ✅ Yes | Choose which directories to create |
| Security Hooks | ✅ Yes | Enable/disable sensitive file protection |
| Auto-formatting | ✅ Yes | Enable/disable code formatting |
| Telemetry | ✅ Yes | Enable/disable token tracking |
| Logging | ✅ Yes | Enable/disable activity logging |
| Sandboxing | ✅ Yes | Enable/disable command isolation |
| Quality Commands | ✅ Yes | Choose which commands to install |
| TDD Workflow | ✅ Yes | Enable/disable TDD command |
| Planning Commands | ✅ Yes | Enable/disable planning tools |
| Git Workflow | ✅ Yes | Customize branch prefixes |
| CLAUDE.md | ✅ Customized | Generated with your project info |
| settings.json | ✅ Optimized | Generated based on selections |

### ✅ Non-Interactive Script Features

| Feature | Included? | Description |
|---------|-----------|-------------|
| Project Name | ⚠️ Template | Generic placeholder |
| Tech Stack | ⚠️ Generic | Not optimized for specific stack |
| Package Manager | ⚠️ Generic | Supports all, not optimized |
| Directory Structure | ✅ All | Creates all directories |
| Security Hooks | ✅ Always | All security features enabled |
| Auto-formatting | ✅ Always | All formatters configured |
| Telemetry | ✅ Always | Always enabled |
| Logging | ✅ Always | All logging enabled |
| Sandboxing | ✅ Always | Always enabled |
| Quality Commands | ✅ All | All commands installed |
| TDD Workflow | ✅ Always | Always installed |
| Planning Commands | ✅ All | All commands installed |
| Git Workflow | ⚠️ Fixed | feature/ and fix/ prefixes |
| CLAUDE.md | ⚠️ Template | Generic template with placeholders |
| settings.json | ✅ Complete | All features configured |

## When to Use Each Script

### Use Interactive Script When:

✅ **Starting a new production project**
- You want a lean, customized setup
- You know which features you need
- You want to avoid unnecessary bloat

✅ **Working in a team**
- Need consistent setup across team members
- Want to document team's tech stack choice
- Have specific git workflow conventions

✅ **Optimizing for a specific tech stack**
- TypeScript/JavaScript project with npm/yarn
- Python project with Black and isort
- Go project with gofmt
- Rust project with rustfmt

✅ **Resource-conscious development**
- Don't want telemetry overhead
- Don't need extensive logging
- Want minimal hook execution

✅ **Learning Claude Code**
- Want to understand each feature
- Prefer to enable features gradually
- Need to see what each component does

### Use Non-Interactive Script When:

✅ **Quick prototyping**
- Testing Claude Code for the first time
- Building a quick proof-of-concept
- Don't want to answer questions

✅ **Want everything**
- Need all features enabled
- Want maximum security and monitoring
- Prefer comprehensive setup

✅ **Exploring features**
- Want to try all features at once
- Can disable features later if needed
- Prefer to remove rather than add

✅ **Demo or training**
- Showing Claude Code capabilities
- Want consistent demo environment
- Need predictable setup

## Output Comparison

### Interactive Script Output

```
📊 Configuration Summary

Project Name:     my-react-app
Tech Stack:       TypeScript/JavaScript
Package Manager:  npm
Source Directory: src
Test Directory:   __tests__

Features:
  - Claude structure:    true
  - Dev workspace:       true
  - Docs structure:      true
  - Security hooks:      true
  - Auto-formatting:     true
  - Telemetry:          true
  - Sandboxing:         true

✅ Created .claude directory structure
✅ Created dev workspace
✅ Created docs structure
✅ Installed quality checkpoint commands
✅ Installed TDD workflow command
✅ Created customized CLAUDE.md
✅ Created .claude/settings.json

Next Steps:
1. Review CLAUDE.md
2. Install token tracking: npm install -g ccusage
3. Start using Claude Code: claude code
```

**Result**: Lean, customized setup with only selected features

### Non-Interactive Script Output

```
✨ Enhanced Features:
  🔒 Security hooks to protect sensitive files
  🎨 Auto-format hooks for code quality
  📊 Token usage tracking enabled (telemetry)
  📝 Implementation logging for audit trail
  🔔 Session summaries with usage reports
  🛡️  Sandboxing for safe command execution

Commands Available:
  /qplan        - Analyze plan consistency
  /qcode        - Implement with quality checks
  /qcheck       - Perform code review
  /tdd          - Test-driven development
  /usage        - View token usage report
  /create-prd   - Create product requirements
  /plan-feature - Plan feature implementation

Security Features Active:
  ✓ Sensitive file protection
  ✓ Bash command logging
  ✓ Sandboxed command execution
  ✓ Restricted permissions

Next Steps:
1. Review and customize CLAUDE.md
2. Install token tracking: npm install -g ccusage
3. Test hooks
4. Read docs/onboarding/CLAUDE_SETUP.md
```

**Result**: Complete setup with all features enabled

## File Size Comparison

| Script | Size | Lines of Code |
|--------|------|---------------|
| Interactive | ~35 KB | ~1,400 lines |
| Non-Interactive | ~40 KB | ~1,377 lines |

Both scripts are similar in size, but interactive script provides more flexibility.

## CLAUDE.md Comparison

### Interactive Script CLAUDE.md

```markdown
# CLAUDE.md

## Project Overview
- **Name**: my-react-app
- **Tech Stack**: TypeScript/JavaScript
- **Description**: React web application with TypeScript
- **Package Manager**: npm

## Architecture
- `src/` - Source code
- `__tests__/` - Test files
- `.claude/` - Claude Code configuration

## Key Commands
- `npm install` - Install dependencies
- `npm run test` - Run tests
- `npm run build` - Build project
- `npm run lint` - Run linter

## Code Standards
- **Formatters**: Prettier, ESLint
- **Linters**: ESLint, TypeScript
```

✅ **Customized** with actual project info

### Non-Interactive Script CLAUDE.md

```markdown
# CLAUDE.md

## Project Overview
- **Name**: [Your Project Name]
- **Tech Stack**: [List your technologies]
- **Description**: [Brief project description]

## Architecture
- `src/` - [Source code description]
- `tests/` - [Test files description]

## Key Commands
- `[command]` - [Description]
- Add your project-specific commands here

## Code Standards
- [Your coding standards]
- [Naming conventions]
```

⚠️ **Template** with placeholders to fill in

## settings.json Comparison

### Interactive Script (Minimal Selection)

```json
{
  "model": "claude-sonnet-4-20250514",
  "permissions": {
    "allow": ["Read", "Edit", "Write", "Grep", "Glob", "Task"],
    "deny": ["Read(.env)", "Write(.env*)"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Read|Edit|Write",
        "hooks": [{"type": "command", "command": "protect-sensitive-files.py"}]
      }
    ]
  },
  "sandbox": {
    "enabled": true
  }
}
```

✅ **Lean** - Only enabled features

### Non-Interactive Script

```json
{
  "model": "claude-sonnet-4-20250514",
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp"
  },
  "permissions": {
    "allow": ["Read", "Edit", "Write", "Grep", "Glob", "Task", "Bash(git *)", ...],
    "deny": ["Read(.env)", "Write(.env*)", "Bash(rm -rf *)", ...]
  },
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "SessionEnd": [...]
  },
  "sandbox": {
    "enabled": true
  }
}
```

✅ **Complete** - All features configured

## Performance Impact

### Interactive Script (Minimal Setup)

| Feature | Overhead | Impact |
|---------|----------|--------|
| Security Hook | Minimal | ~10ms per file operation |
| No Auto-format | None | No formatting delay |
| No Telemetry | None | No network calls |
| No Logging | None | No disk writes |
| **Total** | **Minimal** | **Fast operations** |

### Non-Interactive Script (Full Setup)

| Feature | Overhead | Impact |
|---------|----------|--------|
| Security Hook | Minimal | ~10ms per file operation |
| Auto-format | Moderate | ~100-500ms per file |
| Telemetry | Minimal | Background network calls |
| Logging | Small | ~5ms per operation |
| **Total** | **Moderate** | **Slightly slower** |

## Disk Usage Comparison

### Interactive Script (Minimal)

```
.claude/
├── hooks/              (~10 KB)
│   └── protect-sensitive-files.py
├── commands/           (0 KB - none installed)
└── settings.json       (~2 KB - minimal)

Total: ~12 KB
```

### Interactive Script (Full)

```
.claude/
├── hooks/              (~25 KB)
├── commands/           (~15 KB)
├── logs/               (grows over time)
└── settings.json       (~8 KB)

Total: ~48 KB + logs
```

### Non-Interactive Script

```
.claude/
├── hooks/              (~25 KB)
├── commands/           (~15 KB)
├── logs/               (grows over time)
└── settings.json       (~8 KB)

dev/                    (~5 KB)
docs/                   (~10 KB)

Total: ~63 KB + logs
```

## Migration Path

### From Non-Interactive to Interactive

```bash
# Backup current setup
mv .claude .claude.backup
mv CLAUDE.md CLAUDE.md.backup

# Run interactive with minimal selections
./setup-claude-structure-interactive.sh

# Restore custom configurations
cp .claude.backup/commands/my-custom.md .claude/commands/
```

### From Interactive to Non-Interactive

```bash
# Backup current setup
mv .claude .claude.backup

# Run non-interactive
./setup-claude-structure.sh

# Merge custom configurations
# (Manual merge required)
```

## Recommendations by Project Type

### Web Applications (React, Vue, Angular)

**Use**: Interactive Script

**Select**:
- Tech Stack: TypeScript/JavaScript
- Package Manager: npm/yarn/pnpm
- Enable: Security, Auto-format, Telemetry
- Install: Quality commands

**Why**: Web apps benefit from formatting and quality checks, lean setup

### APIs and Microservices (Node, Go, Rust)

**Use**: Interactive Script (Production) or Non-Interactive (Full monitoring)

**Select**:
- Tech Stack: Go/Rust/TypeScript
- Enable: All security, logging, monitoring
- Install: All commands

**Why**: Production services need full observability

### Data Science / ML (Python)

**Use**: Interactive Script

**Select**:
- Tech Stack: Python
- Package Manager: pip
- Enable: Security, Auto-format (Black)
- Install: Quality commands, Planning
- Skip: TDD, Telemetry (long-running jobs)

**Why**: ML projects have different workflow, notebooks over tests

### CLI Tools and Libraries

**Use**: Interactive Script

**Select**:
- Minimal directories (skip dev, docs)
- Enable: Security, Auto-format
- Install: Quality commands, TDD
- Skip: Planning, Telemetry

**Why**: Libraries need tests and quality, not extensive planning

### Quick Prototypes

**Use**: Non-Interactive Script OR Interactive (minimal)

**Why**: Get started fast without decisions

## Decision Tree

```
Need to choose?
│
├─ Want customization?
│  │
│  ├─ Yes → Use Interactive Script
│  │        │
│  │        ├─ Know what you need? → Select features
│  │        └─ Not sure? → Start minimal, add later
│  │
│  └─ No → Use Non-Interactive Script
│           └─ Get everything, disable later if needed
│
└─ Time constraint?
   │
   ├─ Have 2 minutes → Use Interactive
   └─ Need it now → Use Non-Interactive
```

## Final Recommendation

### Choose Interactive Script if:
- ✅ You want a lean, customized setup
- ✅ You know your tech stack and requirements
- ✅ You're starting a production project
- ✅ You're working in a team with standards
- ✅ You want to understand each feature

### Choose Non-Interactive Script if:
- ✅ You want everything configured
- ✅ You're exploring Claude Code
- ✅ You're building a quick prototype
- ✅ You prefer to disable rather than enable features
- ✅ You want maximum security and monitoring

**Most users should start with the Interactive Script** for a lean, customized setup.

---

**Still not sure? Try both!**
- Run interactive in a test directory
- See what gets created
- Compare with non-interactive output
- Choose what fits your workflow

**See also**:
- [Interactive Setup Guide](INTERACTIVE-SETUP-GUIDE.md) - Detailed usage guide
- [Enhancements Summary](ENHANCEMENTS-SUMMARY.md) - What was enhanced
- [README.md](README.md) - Complete documentation
