# Claude Code Enhanced Setup Scripts

Production-ready setup scripts that create an optimal directory structure for Claude Code development with built-in security, monitoring, and automation. Choose between **interactive** (customizable) or **non-interactive** (full-featured) setup.

## 🌟 Features

### 🔒 Security
- Automatic protection of sensitive files (.env, keys, credentials)
- Command allowlist/blocklist for safe operations
- Sandboxed command execution
- Comprehensive audit logging

### 📊 Token Tracking & Monitoring
- Telemetry enabled for external monitoring tools
- Built-in `/usage` command
- Session-end usage summaries
- Integration with ccusage and claude-monitor

### 🎨 Code Quality
- Auto-format hooks (Prettier, ESLint, Black, isort, gofmt)
- Quality checkpoint commands (/qplan, /qcode, /qcheck)
- Test-driven development workflow
- Consistent code standards enforcement

### 📝 Activity Logging
- Complete audit trail of all actions
- Bash command logging
- Implementation step tracking (JSONL format)
- Tool usage analytics

### 📚 Documentation
- Comprehensive project memory (CLAUDE.md)
- Onboarding guides
- Architecture Decision Records (ADRs)
- Hook documentation

## 🚀 Quick Start

### Option 1: Interactive Setup (Recommended ⭐)

Customize the setup for your specific project needs:

```bash
# Navigate to your project directory
cd /path/to/your/project

# Run the interactive setup
/path/to/create-claude-structure/setup-claude-structure-interactive.sh

# Follow the prompts to customize:
# - Project name and tech stack
# - Directory structure
# - Features to enable/disable
# - Commands to install

# Optional: Install token tracking
npm install -g ccusage

# Start using Claude Code
claude code
```

### Option 2: Non-Interactive Setup

Get everything configured with all features enabled:

```bash
# Clone or download this repository
git clone <repository-url>
cd create-claude-structure

# Make the script executable
chmod +x setup-claude-structure.sh

# Run in your project directory
cd /path/to/your/project
/path/to/create-claude-structure/setup-claude-structure.sh

# Optional: Install token tracking
npm install -g ccusage

# Start using Claude Code
claude code
```

## 📊 Which Script Should You Use?

| Feature | Interactive | Non-Interactive |
|---------|-------------|-----------------|
| **Customization** | ✅ Full control over what gets created | ❌ Creates everything |
| **Tech Stack Optimization** | ✅ Optimized for your stack | ⚠️ Generic setup |
| **Feature Selection** | ✅ Choose only what you need | ✅ All features included |
| **CLAUDE.md** | ✅ Customized with your project info | ⚠️ Template with placeholders |
| **Setup Time** | ~2 minutes (interactive) | ~30 seconds |
| **Best For** | Production projects, teams | Quick prototypes, exploration |
| **Lean Setup** | ✅ Only what you need | ❌ Everything included |

**Recommendation**: Use **interactive** for real projects where you want lean, customized setup. Use **non-interactive** for quick testing or when you want all features.

## 📋 What Gets Created

```
your-project/
├── .claude/
│   ├── skills/              # Domain expertise definitions
│   ├── hooks/               # Automation scripts (6 pre-configured)
│   │   ├── protect-sensitive-files.py
│   │   ├── auto-format.sh
│   │   ├── log-implementation.py
│   │   └── ...
│   ├── agents/              # Custom AI agents
│   ├── commands/            # Slash commands (7 included)
│   │   ├── qplan.md
│   │   ├── qcode.md
│   │   ├── qcheck.md
│   │   ├── tdd.md
│   │   ├── usage.md
│   │   └── ...
│   ├── plugins/             # Plugin packages
│   ├── logs/                # Activity logs (NEW)
│   └── settings.json        # Enhanced configuration
│
├── dev/
│   ├── active/              # Current work context
│   │   └── context.md
│   ├── plans/               # Planning documents
│   │   └── tasks.md
│   └── scratch/             # Scratchpad
│       └── SCRATCHPAD.md
│
├── docs/
│   ├── architecture/        # Architecture documentation
│   ├── onboarding/          # Setup guides
│   │   ├── CLAUDE_SETUP.md
│   │   └── PROJECT_STRUCTURE.md
│   └── decisions/           # Architecture Decision Records
│       └── ADR-template.md
│
├── CLAUDE.md                # Project memory file
├── .claudeignore            # Files to exclude
├── .mcp.json               # MCP server configuration
└── .gitignore              # Updated with Claude Code entries
```

## 🎯 Pre-configured Commands

```bash
/qplan         # Analyze plan consistency before implementation
/qcode         # Implement with automatic quality checks
/qcheck        # Perform skeptical code review
/tdd           # Test-driven development workflow
/usage         # View token usage report
/create-prd    # Create Product Requirements Document
/plan-feature  # Plan feature implementation
```

## 🔧 Pre-configured Hooks

### Security (PreToolUse)
- **protect-sensitive-files.py** - Blocks access to .env, keys, credentials
- **bash-commands logger** - Logs all bash commands

### Quality (PostToolUse)
- **auto-format.sh** - Auto-formats code (Prettier, Black, gofmt)
- **log-implementation.py** - Logs all actions to JSONL
- **post-tool-use-tracker.sh** - Tracks tool usage

### Session
- **session-end-summary.sh** - Shows usage summary at session end

## 📊 Token Tracking

The script enables telemetry for external monitoring tools:

```bash
# Daily usage
npx ccusage@latest daily

# Current 5-hour block
npx ccusage@latest blocks

# Monthly summary
npx ccusage@latest monthly

# Within Claude Code
/usage
```

## 🔒 Security Features

### Protected Files (Auto-blocked)
- Environment files: `.env`, `.env.*`
- Keys: `*.pem`, `*.key`, `*.credential`
- Credentials: `credentials.json`, `service-account.json`
- SSH keys: `id_rsa`, `id_ed25519`
- Directories: `secrets/`, `.ssh/`, `.gnupg/`

### Blocked Commands
- `rm -rf *` (destructive)
- `curl`, `wget` (downloads)
- `ssh`, `scp` (remote access)
- `sudo` (privilege escalation)

### Sandboxing
- Enabled by default
- Safe isolation for command execution
- Network restrictions

## 📚 Documentation

| File | Description |
|------|-------------|
| [ENHANCEMENTS.md](./ENHANCEMENTS.md) | Complete guide to all enhancements |
| [ENHANCEMENT-SUMMARY.md](./ENHANCEMENT-SUMMARY.md) | Quick overview of changes |
| [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) | Command reference card |
| `CLAUDE.md` | Project-specific memory (created in your project) |

## 🎨 Code Formatting

Auto-formatting runs after edits for these languages:

| Language | Tools | Install Command |
|----------|-------|----------------|
| TypeScript/JavaScript | Prettier + ESLint | `npm install -g prettier eslint` |
| Python | Black + isort | `pip install black isort` |
| Go | gofmt | Built-in with Go |

## 📝 Activity Logs

All actions are logged to `.claude/logs/`:

```bash
# Bash commands
cat .claude/logs/bash-commands.log

# Implementation steps (JSONL)
tail -f .claude/logs/implementation-steps.jsonl

# Tool usage
cat .claude/logs/tool-usage.log
```

## 🧪 Testing the Setup

After running the script:

```bash
# 1. Test security hook (should block)
claude code
> Read the .env file

# 2. Test auto-format (if formatters installed)
echo "const x={a:1}" > test.js
claude code
> Format test.js
cat test.js

# 3. Check token tracking
npx ccusage@latest daily

# 4. View logs
cat .claude/logs/bash-commands.log
```

## ⚙️ Customization

### Disable a Hook
Edit `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      // Comment out the hook you want to disable
    ]
  }
}
```

### Personal Overrides
Create `.claude/settings.local.json` (gitignored):
```json
{
  "hooks": {
    "PostToolUse": []
  }
}
```

### Add Custom Hook
1. Create script in `.claude/hooks/`
2. Make executable: `chmod +x .claude/hooks/my-hook.sh`
3. Add to `.claude/settings.json`

## 🔄 Version History

### v2.0 (2025) - Enhanced
- ✅ Security hooks
- ✅ Token tracking & monitoring
- ✅ Auto-formatting
- ✅ Activity logging
- ✅ Session summaries
- ✅ Sandboxing
- ✅ Enhanced documentation

### v1.0 (2024) - Original
- Basic directory structure
- Quality commands
- Template files

## 🤝 Contributing

Contributions welcome! Please:
1. Test your changes
2. Update documentation
3. Follow existing code style
4. Submit a PR with clear description

## 📄 License

MIT License - See LICENSE file for details

## 🙏 Credits

Based on best practices from:
- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [ccusage tool](https://github.com/anthropics/ccusage)
- Community feedback and real-world usage

## 💬 Support

- **Documentation**: See [ENHANCEMENTS.md](./ENHANCEMENTS.md)
- **Quick Reference**: See [QUICK-REFERENCE.md](./QUICK-REFERENCE.md)
- **Issues**: Create an issue in the repository
- **Discussions**: Use GitHub Discussions

## 🎯 Use Cases

### Individual Developers
- Protection from accidental secret exposure
- Understand and control token usage
- Automatic code formatting
- Complete audit trail

### Teams
- Consistent environment across members
- Track team-wide token consumption
- Audit compliance
- Enforce security policies

### Organizations
- Cost visibility and control
- Security policy enforcement
- Compliance audit trails
- Standardized best practices

## 🚦 Next Steps

After running the setup:

1. ✅ Customize `CLAUDE.md` with project specifics
2. ✅ Install formatters for your languages
3. ✅ Install ccusage: `npm install -g ccusage`
4. ✅ Test security hooks
5. ✅ Review and adjust permissions
6. ✅ Share with team

## 🎯 Interactive Setup Examples

### Example 1: TypeScript React Project

```bash
./setup-claude-structure-interactive.sh

# Interactive prompts and responses:
Project name [my-project]: my-react-app
Select tech stack [1]: 1 (TypeScript/JavaScript)
Select package manager [1]: 1 (npm)
Brief description: React web application with TypeScript

Create .claude directory? [Y]: Y
Create dev workspace? [Y]: Y
Create docs structure? [Y]: Y
Create test directory? [Y]: Y
Test directory name [tests]: __tests__

Enable security hooks? [Y]: Y
Enable auto-formatting? [Y]: Y
Enable telemetry? [Y]: Y
Enable logging? [Y]: Y
Enable sandboxing? [Y]: Y

Install quality commands? [Y]: Y
Install TDD workflow? [Y]: Y
Install planning commands? [Y]: Y

Feature branch prefix [feature]: feature
Fix branch prefix [fix]: fix

Proceed? [Y]: Y
```

Result: Optimized for React with npm, Prettier/ESLint auto-formatting, full telemetry

### Example 2: Python ML Project (Lean Setup)

```bash
./setup-claude-structure-interactive.sh

# Minimal setup for data science:
Project name: ml-pipeline
Select tech stack: 2 (Python)
Brief description: Machine learning data pipeline

Create .claude directory? [Y]: Y
Create dev workspace? [Y]: N  # Skip - using Jupyter notebooks
Create docs structure? [Y]: Y
Create test directory? [Y]: Y
Test directory name: tests

Enable security hooks? [Y]: Y  # Protect API keys
Enable auto-formatting? [Y]: Y # Black + isort
Enable telemetry? [Y]: N       # Skip
Enable logging? [Y]: N         # Skip
Enable sandboxing? [Y]: Y

Install quality commands? [Y]: Y
Install TDD workflow? [Y]: N
Install planning commands? [Y]: N
```

Result: Lean setup with security, auto-format, and quality checks only

### Example 3: Go Microservice (Production)

```bash
./setup-claude-structure-interactive.sh

# Production-ready Go service:
Project name: auth-service
Select tech stack: 3 (Go)
Brief description: Authentication microservice

# All Yes for production readiness
Enable all security, logging, and monitoring features

Feature branch prefix: feature
Fix branch prefix: hotfix
```

Result: Full production setup with comprehensive logging and monitoring

## 💡 Pro Tips

1. **Interactive Setup**: Use interactive mode for new projects to avoid bloat
2. Check usage frequently: `npx ccusage@latest blocks --live`
3. Review logs daily to understand patterns
4. Customize hooks to fit your workflow
5. Use quality commands: /qplan → /qcode → /qcheck
6. Keep dev/active/context.md updated
7. Document decisions in docs/decisions/
8. Test in dev/scratch/ first
9. Commit settings to share with team
10. Use settings.local.json for personal overrides
11. Monitor token usage trends
12. **Start lean**: You can always add features later, harder to remove them

---

**Made with ❤️ for the Claude Code community**

Ready to enhance your Claude Code development workflow!
