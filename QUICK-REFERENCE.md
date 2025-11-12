# Claude Code Enhanced Setup - Quick Reference

## 🚀 Quick Start

```bash
# Run the enhanced setup
./setup-claude-structure.sh

# Install token tracking (optional)
npm install -g ccusage

# Start Claude Code
claude code
```

## 📊 Token Usage Commands

```bash
# View today's usage
npx ccusage@latest daily

# Monitor current 5-hour block
npx ccusage@latest blocks

# Monthly summary
npx ccusage@latest monthly

# Within Claude Code
/usage
```

## 🔒 Security Features

### Protected Files (Auto-blocked)
- `.env`, `.env.*` (all environment files)
- `*.pem`, `*.key` (keys and certificates)
- `credentials.json`, `service-account.json`
- `id_rsa`, `id_ed25519` (SSH keys)
- `secrets/`, `.ssh/`, `.gnupg/` directories

### Blocked Commands
- `rm -rf *` (destructive deletion)
- `curl`, `wget` (arbitrary downloads)
- `ssh`, `scp` (remote access)
- `sudo` (privilege escalation)

## 📝 Activity Logs

```bash
# View bash command history
cat .claude/logs/bash-commands.log

# View implementation steps (JSONL)
tail -f .claude/logs/implementation-steps.jsonl

# View tool usage
cat .claude/logs/tool-usage.log

# View all logs
ls -la .claude/logs/
```

## 🎨 Auto-Formatting

Automatically runs after edits:

| Language       | Tools              | Install Command                    |
|----------------|--------------------|------------------------------------|
| TypeScript/JS  | Prettier + ESLint  | `npm install -g prettier eslint`   |
| Python         | Black + isort      | `pip install black isort`          |
| Go             | gofmt              | (Built-in with Go)                 |

## 💻 Custom Commands

```bash
/qplan         # Analyze plan consistency
/qcode         # Implement with quality checks
/qcheck        # Skeptical code review
/tdd           # Test-driven development
/usage         # Token usage report
/create-prd    # Create product requirements doc
/plan-feature  # Plan feature implementation
```

## 🛠️ Installed Hooks

### PreToolUse (Before Actions)
- **protect-sensitive-files.py** - Security checks
- **bash-commands logger** - Command logging

### PostToolUse (After Actions)
- **auto-format.sh** - Code formatting
- **post-tool-use-tracker.sh** - Usage tracking
- **log-implementation.py** - Action logging

### Session Events
- **session-end-summary.sh** - Usage summary at end

## 📂 Directory Structure

```
.claude/
├── skills/                  # Domain expertise
├── hooks/                   # Automation scripts
├── agents/                  # Custom AI agents
├── commands/                # Slash commands
├── plugins/                 # Plugin packages
├── logs/                    # Activity logs (NEW)
└── settings.json           # Enhanced config

dev/
├── active/                  # Current work context
├── plans/                   # Planning documents
└── scratch/                 # Scratchpad

docs/
├── architecture/            # Architecture docs
├── onboarding/             # Setup guides
└── decisions/              # Architecture Decision Records
```

## ⚙️ Configuration Files

| File | Purpose | Git |
|------|---------|-----|
| `.claude/settings.json` | Project-wide settings | ✅ Commit |
| `.claude/settings.local.json` | Personal overrides | ❌ Ignore |
| `CLAUDE.md` | Project memory | ✅ Commit |
| `.claudeignore` | Excluded files | ✅ Commit |
| `.mcp.json` | MCP servers | ✅ Commit |

## 🔧 Common Customizations

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

### Add Allowed Command
Edit `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "Bash(your-command *)"
    ]
  }
}
```

### Personal Override
Create `.claude/settings.local.json`:
```json
{
  "hooks": {
    "PostToolUse": []
  }
}
```

## 🧪 Testing the Setup

```bash
# Test security hook (should be blocked)
claude code
> Read the .env file

# Test auto-format (if formatters installed)
echo "const x={a:1}" > test.js
claude code
> Format test.js
cat test.js  # Should be formatted

# Test token tracking
npx ccusage@latest daily

# Check logs
cat .claude/logs/bash-commands.log
```

## 📋 Daily Workflow

### 1. Starting Work
```bash
# Check current context
cat dev/active/context.md

# Check token usage
npx ccusage@latest blocks

# Start Claude Code
claude code
```

### 2. During Development
```
1. Plan: /qplan <feature>
2. Implement: /qcode
3. Review: /qcheck
4. Update: dev/active/context.md
```

### 3. Ending Session
```bash
# Review session summary (auto-shown)
# Check files modified
cat .claude/logs/implementation-steps.jsonl | jq -r '.tool_input.file_path' | sort -u

# Check daily usage
npx ccusage@latest daily
```

## 🆘 Troubleshooting

### Hooks Not Running
```bash
# Check executable permissions
ls -la .claude/hooks/

# Make executable
chmod +x .claude/hooks/*.sh .claude/hooks/*.py

# Check CLAUDE_PROJECT_DIR
echo $CLAUDE_PROJECT_DIR
```

### Token Tracking Not Working
```bash
# Install ccusage
npm install -g ccusage

# Check telemetry enabled
grep TELEMETRY .claude/settings.json

# Test ccusage
npx ccusage@latest daily
```

### Auto-Format Not Working
```bash
# Install formatters
npm install -g prettier eslint
pip install black isort

# Check hook
cat .claude/hooks/auto-format.sh

# Test manually
prettier --write yourfile.js
```

### Security Hook Too Strict
```bash
# Edit patterns
nano .claude/hooks/protect-sensitive-files.py

# Modify SENSITIVE_PATTERNS or SENSITIVE_DIRS
# Remove patterns you want to allow
```

## 📚 Documentation

| Doc | Purpose |
|-----|---------|
| `ENHANCEMENTS.md` | Complete enhancement guide |
| `ENHANCEMENT-SUMMARY.md` | Quick overview |
| `QUICK-REFERENCE.md` | This file - command reference |
| `CLAUDE.md` | Project-specific memory |
| `docs/onboarding/CLAUDE_SETUP.md` | Detailed setup guide |
| `.claude/hooks/README.md` | Hooks documentation |

## 🔗 Useful Links

- [Claude Code Docs](https://docs.claude.com/claude-code)
- [ccusage Repository](https://github.com/anthropics/ccusage)
- [Claude Code Usage Monitor](https://github.com/yourusername/claude-monitor)

## 💡 Pro Tips

1. **Check usage frequently**: `npx ccusage@latest blocks --live`
2. **Review logs daily**: Understand patterns and optimize
3. **Customize hooks**: Adapt to your specific workflow
4. **Use quality commands**: /qplan → /qcode → /qcheck
5. **Keep context updated**: Update dev/active/context.md
6. **Document decisions**: Use docs/decisions/ for ADRs
7. **Test in scratchpad**: Use dev/scratch/ for experimentation
8. **Commit settings**: Share config with team
9. **Personal overrides**: Use .claude/settings.local.json
10. **Monitor costs**: Track token usage trends

## 🎯 Common Tasks

```bash
# View today's token usage
npx ccusage@latest daily

# Check what files were modified today
tail -100 .claude/logs/implementation-steps.jsonl | jq -r '.tool_input.file_path' | sort -u

# View recent bash commands
tail -20 .claude/logs/bash-commands.log

# Monitor live usage (5-hour blocks)
watch -n 60 'npx ccusage@latest blocks'

# Generate daily report
npx ccusage@latest daily --json > usage-report-$(date +%Y-%m-%d).json

# Check which hooks are active
jq '.hooks' .claude/settings.json

# Test a hook manually
echo '{"tool_name":"Read","tool_input":{"file_path":".env"}}' | python3 .claude/hooks/protect-sensitive-files.py
```

---

**💪 You're all set!** The enhanced setup provides security, monitoring, and automation out of the box.
