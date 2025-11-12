Enhance the setup-claude-structure.sh with teh following enhanced practices

Based on the comprehensive research, here's an **enhanced project-specific settings.json** with token tracking setup and best practices:

## Complete .claude/settings.json

```json
{
  "//": "═══════════════════════════════════════════════════════════",
  "//": "  CLAUDE CODE PROJECT SETTINGS",
  "//": "  Version: 2.0",
  "//": "  Last Updated: 2025",
  "//": "═══════════════════════════════════════════════════════════",

  "//": "────────────────────────────────────────────────────────────",
  "//": "MODEL & PERFORMANCE CONFIGURATION",
  "//": "────────────────────────────────────────────────────────────",
  "model": "claude-sonnet-4-20250514",

  "//": "────────────────────────────────────────────────────────────",
  "//": "TELEMETRY & MONITORING",
  "//": "Enable these to support token tracking with external tools",
  "//": "Use 'npx ccusage@latest' or 'claude-monitor' to view usage",
  "//": "────────────────────────────────────────────────────────────",
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "16384",
    "BASH_DEFAULT_TIMEOUT_MS": "30000",
    "MCP_TIMEOUT": "60000",
    "ANTHROPIC_LOG": "info"
  },

  "//": "────────────────────────────────────────────────────────────",
  "//": "SECURITY & PERMISSIONS",
  "//": "NOTE: Due to known issues with deny rules, we use hooks",
  "//": "as the primary security mechanism (see hooks section)",
  "//": "────────────────────────────────────────────────────────────",
  "permissions": {
    "allow": [
      "Read",
      "Edit",
      "Write",
      "MultiEdit",
      "Grep",
      "LS",
      "Glob",
      "Task",
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(yarn *)",
      "Bash(pnpm *)",
      "Bash(node *)",
      "Bash(python *)",
      "Bash(pip *)",
      "Bash(docker *)",
      "Bash(npm run lint)",
      "Bash(npm run test*)",
      "Bash(npm run build)",
      "Bash(npm run type-check)",
      "WebSearch",
      "WebFetch"
    ],
    "deny": [
      "//": "Primary deny list (backed by hooks)",
      "Read(.env)",
      "Read(.env.*)",
      "Read(./secrets/**)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Read(./**/*credentials*.json)",
      "Read(./config/production.*)",
      "Write(.env*)",
      "Write(./secrets/**)",
      "Write(./**/*.pem)",
      "Write(./**/*.key)",
      "Write(./config/production.*)",
      "Write(.git/**)",
      "Edit(.env*)",
      "Edit(./secrets/**)",
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(ssh *)",
      "Bash(scp *)",
      "Bash(sudo *)"
    ]
  },

  "//": "────────────────────────────────────────────────────────────",
  "//": "HOOKS - Lifecycle Automation",
  "//": "These enforce quality, security, and tracking",
  "//": "────────────────────────────────────────────────────────────",
  "hooks": {
    "PreToolUse": [
      {
        "//": "Security: Block sensitive file access (primary protection)",
        "matcher": "Read|Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/protect-sensitive-files.py"
          }
        ]
      },
      {
        "//": "Logging: Track all bash commands before execution",
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '\"\\(.tool_input.command) - \\(.tool_input.description // \\\"No description\\\")\"' >> $CLAUDE_PROJECT_DIR/.claude/logs/bash-commands.log"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "//": "Auto-format code after edits",
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/auto-format.sh"
          },
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh"
          }
        ]
      },
      {
        "//": "Log all implementation steps for tracking",
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/log-implementation.py"
          }
        ]
      }
    ],
    "Notification": [
      {
        "//": "Desktop notifications when Claude waits (macOS only)",
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title 'Claude Code' -message 'Waiting for input' -sound default 2>/dev/null || true"
          }
        ]
      }
    ],
    "PrePromptSubmission": [
      {
        "//": "Inject skill activation suggestions",
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/skill-activation-prompt.sh"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "//": "Generate session summary and token report",
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-summary.sh"
          }
        ]
      }
    ]
  },

  "//": "────────────────────────────────────────────────────────────",
  "//": "SANDBOXING",
  "//": "Isolate bash commands for additional security",
  "//": "────────────────────────────────────────────────────────────",
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": [
      "docker",
      "git"
    ],
    "network": {
      "allowUnixSockets": [
        "/var/run/docker.sock"
      ],
      "allowLocalBinding": true
    }
  },

  "//": "────────────────────────────────────────────────────────────",
  "//": "UI CONFIGURATION",
  "//": "────────────────────────────────────────────────────────────",
  "spinnerTipsEnabled": true,
  "gitBylineEnabled": true,

  "//": "────────────────────────────────────────────────────────────",
  "//": "TEAM ANNOUNCEMENTS",
  "//": "Messages shown to team members on startup",
  "//": "────────────────────────────────────────────────────────────",
  "companyAnnouncements": [
    "📊 Track token usage: npx ccusage@latest daily",
    "🔒 Security: Never commit .env files or API keys",
    "✅ Quality: Use /qplan, /qcode, /qcheck before commits",
    "📖 Docs: Review CLAUDE.md for project conventions",
    "🎯 Workflow: Research → Plan → Implement → Test → Commit"
  ]
}
```

## Supporting Hook Scripts

### 1. Security Hook: `.claude/hooks/protect-sensitive-files.py`

```python
#!/usr/bin/env python3
"""
Security hook to protect sensitive files
Blocks access to credentials, keys, and environment files
"""
import sys
import json
from pathlib import Path

SENSITIVE_PATTERNS = {
    '.env', '.env.local', '.env.production', '.env.development',
    '.pem', '.key', '.credential', '.token',
    'credentials.json', 'google-credentials.json',
    'service-account.json', 'private-key.json',
    'id_rsa', 'id_ed25519', '.ssh',
    'secrets', 'password'
}

SENSITIVE_DIRS = {
    'secrets', '.ssh', '.gnupg', 'credentials'
}

def is_sensitive_file(file_path: str) -> bool:
    """Check if file path matches sensitive patterns"""
    path = Path(file_path)
    
    # Check filename and extension
    if path.name in SENSITIVE_PATTERNS:
        return True
    if path.suffix in {'.pem', '.key', '.credential'}:
        return True
    
    # Check if in sensitive directory
    for part in path.parts:
        if part in SENSITIVE_DIRS:
            return True
    
    # Check for common patterns
    name_lower = path.name.lower()
    if any(pattern in name_lower for pattern in SENSITIVE_PATTERNS):
        return True
    
    return False

def main():
    try:
        # Read input from stdin
        input_data = json.load(sys.stdin)
        
        # Extract file path
        tool_input = input_data.get('tool_input', {})
        file_path = tool_input.get('file_path', '')
        
        if not file_path:
            sys.exit(0)  # No file path, allow
        
        if is_sensitive_file(file_path):
            # Block access
            error_msg = f"""SECURITY_POLICY_VIOLATION: Access to sensitive file '{file_path}' is blocked.

Files containing credentials, keys, or environment variables should not be accessed.
Instead:
- Use environment variables for secrets
- Ask for specific configuration values
- Reference documentation for setup instructions
"""
            print(error_msg, file=sys.stderr)
            sys.exit(2)  # Exit code 2 blocks the tool
        
        sys.exit(0)  # Allow
        
    except Exception as e:
        print(f"Hook error: {e}", file=sys.stderr)
        sys.exit(0)  # On error, allow (fail open)

if __name__ == '__main__':
    main()
```

### 2. Auto-Format Hook: `.claude/hooks/auto-format.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Auto-format files after edits
# Reads file path from JSON input

# Extract file path from tool input
FILE_PATH=$(jq -r '.tool_input.file_path // ""')

if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# TypeScript/JavaScript files
if [[ "$FILE_PATH" =~ \.(ts|tsx|js|jsx)$ ]]; then
    if command -v prettier >/dev/null 2>&1; then
        prettier --write "$FILE_PATH" 2>/dev/null || true
    fi
    if command -v eslint >/dev/null 2>&1; then
        eslint --fix "$FILE_PATH" 2>/dev/null || true
    fi
fi

# Python files
if [[ "$FILE_PATH" =~ \.py$ ]]; then
    if command -v black >/dev/null 2>&1; then
        black "$FILE_PATH" 2>/dev/null || true
    fi
    if command -v isort >/dev/null 2>&1; then
        isort "$FILE_PATH" 2>/dev/null || true
    fi
fi

# Go files
if [[ "$FILE_PATH" =~ \.go$ ]]; then
    if command -v gofmt >/dev/null 2>&1; then
        gofmt -w "$FILE_PATH" 2>/dev/null || true
    fi
fi

exit 0
```

### 3. Session End Summary: `.claude/hooks/session-end-summary.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Generate session summary with token usage
echo "📊 Session Summary"
echo "=================="

# Display token usage if ccusage is available
if command -v npx >/dev/null 2>&1; then
    echo ""
    echo "Token Usage (Today):"
    npx --yes ccusage@latest daily 2>/dev/null | tail -n 5 || echo "Install ccusage: npm install -g ccusage"
    
    echo ""
    echo "Current 5-hour Block:"
    npx --yes ccusage@latest blocks 2>/dev/null | tail -n 5 || true
fi

# Show files modified this session
echo ""
echo "Files Modified:"
if [[ -f "$CLAUDE_PROJECT_DIR/.claude/logs/implementation-steps.jsonl" ]]; then
    tail -n 20 "$CLAUDE_PROJECT_DIR/.claude/logs/implementation-steps.jsonl" | \
        jq -r '.tool_input.file_path // empty' | \
        sort -u | \
        head -n 10 || echo "No files modified"
fi

echo ""
echo "📈 View full usage: npx ccusage@latest daily"
echo "🔍 Monitor live: npx ccusage@latest blocks --live"

exit 0
```

### 4. Implementation Logger: `.claude/hooks/log-implementation.py`

```python
#!/usr/bin/env python3
"""
Log all implementation steps to JSONL for tracking
"""
import json
import sys
import os
from datetime import datetime
from pathlib import Path

PROJECT_DIR = os.environ.get('CLAUDE_PROJECT_DIR', os.getcwd())
LOG_DIR = Path(PROJECT_DIR) / '.claude' / 'logs'
LOG_FILE = LOG_DIR / 'implementation-steps.jsonl'

def ensure_log_dir():
    LOG_DIR.mkdir(parents=True, exist_ok=True)

def log_step(input_data):
    ensure_log_dir()
    
    log_entry = {
        'timestamp': datetime.utcnow().isoformat(),
        'tool_name': input_data.get('tool_name', 'unknown'),
        'tool_input': input_data.get('tool_input', {}),
        'success': input_data.get('success', True)
    }
    
    with open(LOG_FILE, 'a') as f:
        f.write(json.dumps(log_entry) + '\n')

def main():
    try:
        input_data = json.load(sys.stdin)
        log_step(input_data)
    except Exception as e:
        print(f"Logging error: {e}", file=sys.stderr)
    
    sys.exit(0)

if __name__ == '__main__':
    main()
```

## Make Hooks Executable

```bash
chmod +x .claude/hooks/*.sh
chmod +x .claude/hooks/*.py
```

## Token Tracking Setup

While settings.json enables telemetry, **token counting requires external tools**:

### Option 1: ccusage (Recommended)
```bash
# Daily report
npx ccusage@latest daily

# Monthly summary
npx ccusage@latest monthly

# Live monitoring
npx ccusage@latest blocks --live

# JSON output for scripting
npx ccusage@latest daily --json
```

### Option 2: Claude Code Usage Monitor
```bash
# Install
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install claude-monitor

# Run
claude-monitor
```

### Option 3: Menu Bar Display (macOS)
Use xbar to display token usage in your macOS menu bar by running ccusage and showing the output.

## Additional Best Practice Settings

### User-Level Settings (`~/.claude/settings.json`)

```json
{
  "//": "Personal preferences across all projects",
  
  "theme": "dark",
  "gitBylineEnabled": false,
  
  "env": {
    "ANTHROPIC_LOG": "warn",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "false"
  },
  
  "permissions": {
    "deny": [
      "Read(~/.ssh/**)",
      "Read(~/.aws/**)",
      "Read(~/.config/**/credentials*)"
    ]
  }
}
```

## Monitoring & Alerts

### Create a monitoring command: `.claude/commands/usage.md`

```markdown
# Token Usage Report

Show comprehensive token usage statistics:

1. **Daily Usage**: Display today's token consumption
2. **Current Block**: Show usage in current 5-hour window
3. **Burn Rate**: Calculate tokens per hour
4. **Cost Estimate**: Approximate costs based on usage

Run: \`npx ccusage@latest daily && npx ccusage@latest blocks\`

Arguments: $ARGUMENTS
```

## Best Practices Summary

Settings can be configured at user level (~/.claude/settings.json) or project level (.claude/settings.json), with environment variables also supported for automation.

**Key Recommendations:**

1. **Security First**: Use hooks as primary protection (deny rules have known issues)
2. **Enable Telemetry**: Required for external token tracking tools
3. **Auto-Format**: Save time with post-edit formatters
4. **Log Everything**: Track implementation steps for debugging
5. **Monitor Usage**: Regular check with `npx ccusage@latest daily`
6. **Team Consistency**: Version control `.claude/settings.json`
7. **Personal Overrides**: Use `.claude/settings.local.json` (gitignored)
8. **Document Changes**: Update CLAUDE.md when modifying settings
9. **Test Hooks**: Manually test before committing
10. **Review Logs**: Check `.claude/logs/` periodically

This configuration provides comprehensive monitoring, security, and automation while enabling token tracking through external tools!