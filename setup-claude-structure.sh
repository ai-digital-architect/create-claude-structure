#!/bin/bash

# Setup Claude Code Development Structure
# This script creates an optimal directory structure for Claude Code development
# Based on best practices and enhanced project structure

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Get project root (script should be run from project root or scripts folder)
if [ -d ".git" ]; then
    PROJECT_ROOT="."
elif [ -d "../.git" ]; then
    PROJECT_ROOT=".."
else
    print_warning "Not in a git repository. Using current directory as project root."
    PROJECT_ROOT="."
fi

cd "$PROJECT_ROOT"
PROJECT_ROOT=$(pwd)

print_status "Setting up Claude Code structure in: $PROJECT_ROOT"

# Create .claude directory structure
print_status "Creating .claude directory structure..."

mkdir -p .claude/skills
mkdir -p .claude/hooks
mkdir -p .claude/agents
mkdir -p .claude/commands
mkdir -p .claude/plugins
mkdir -p .claude/logs

# Create dev directory structure
print_status "Creating dev workspace..."

mkdir -p dev/active
mkdir -p dev/plans
mkdir -p dev/scratch

# Create docs directory structure
print_status "Creating docs structure..."

mkdir -p docs/architecture
mkdir -p docs/onboarding
mkdir -p docs/decisions

# Create README files for each major directory
print_status "Creating README files..."

# .claude/skills/README.md
cat > .claude/skills/README.md << 'EOF'
# Skills Directory

## What are Skills?
Skills provide domain expertise that activates automatically when Claude detects relevant context.

## Available Skills
Add your custom skills here by creating subdirectories with SKILL.md files.

## Adding New Skills
1. Create a new directory: `.claude/skills/skill-name/`
2. Add `SKILL.md` with skill definition
3. Optionally add `scripts/`, `references/`, and `assets/` subdirectories
4. Configure `skill-rules.json` if needed
5. Test activation by working on relevant tasks

## Skill Structure
```
skill-name/
├── SKILL.md          # Main skill definition
├── scripts/          # Helper scripts
├── references/       # Reference materials
├── assets/           # Images, diagrams, etc.
└── README.md        # Skill documentation
```
EOF

# .claude/hooks/README.md
cat > .claude/hooks/README.md << 'EOF'
# Hooks Directory

## What are Hooks?
Hooks are shell scripts or programs that execute automatically in response to Claude Code events.

## Installed Hooks

This project includes pre-configured hooks for security, quality, and monitoring:

### Security Hooks (PreToolUse)
- **protect-sensitive-files.py** - Blocks access to .env, .key, .pem, and credential files
- **bash-commands logger** - Logs all bash commands to `.claude/logs/bash-commands.log`

### Quality Hooks (PostToolUse)
- **auto-format.sh** - Automatically formats code after edits
  - TypeScript/JavaScript: Prettier + ESLint
  - Python: Black + isort
  - Go: gofmt
- **post-tool-use-tracker.sh** - Tracks tool usage
- **log-implementation.py** - Logs all actions to JSONL for audit trail

### Session Hooks
- **session-end-summary.sh** - Displays token usage and file modifications at session end
- **skill-activation-prompt.sh** - (Placeholder) Can inject context-based suggestions

## Common Hook Types
- **PreToolUse**: Runs before Claude uses a tool (security checks)
- **PostToolUse**: Runs after Claude uses a tool (formatting, logging)
- **PrePromptSubmission**: Runs before sending prompt to Claude
- **SessionEnd**: Runs when session ends (summaries)
- **Notification**: Runs when Claude waits for input

## Creating Custom Hooks
1. Create a script file (e.g., `custom-hook.sh`)
2. Make it executable: `chmod +x .claude/hooks/custom-hook.sh`
3. Add to `.claude/settings.json` hooks configuration
4. Test your hook

## Viewing Hook Logs
All hook activity is logged to `.claude/logs/`:
```bash
# View bash command history
cat .claude/logs/bash-commands.log

# View implementation steps (JSON lines)
tail -f .claude/logs/implementation-steps.jsonl

# View tool usage
cat .claude/logs/tool-usage.log
```

## Disabling Hooks
To temporarily disable hooks, comment them out in `.claude/settings.json` or create a `.claude/settings.local.json` file with modified hook configuration.
EOF

# .claude/agents/README.md
cat > .claude/agents/README.md << 'EOF'
# Agents Directory

## What are Agents?
Agents are specialized AI assistants with specific roles and capabilities.

## Agent Catalog
Add your custom agent definitions here as markdown files.

## Creating Custom Agents
Each agent should be defined in a markdown file with:
- Agent purpose and role
- Specific capabilities
- When to activate
- Example usage

## Example Agents
- Code reviewer agent
- Documentation writer agent
- Test generator agent
- Debugging specialist agent
EOF

# .claude/commands/README.md
cat > .claude/commands/README.md << 'EOF'
# Commands Directory

## What are Commands?
Slash commands provide quick shortcuts for common tasks.

## Available Commands
Custom commands will be listed here after creation.

## Creating Custom Commands
1. Create a markdown file: `.claude/commands/command-name.md`
2. Add command instructions
3. Use `$ARGUMENTS` placeholder for user input
4. Use the command with `/command-name [arguments]`

## Example Commands
- `/qplan` - Analyze plan consistency
- `/qcode` - Implement with quality checks
- `/qcheck` - Skeptical code review
- `/tdd` - Test-driven development workflow
EOF

# .claude/plugins/README.md
cat > .claude/plugins/README.md << 'EOF'
# Plugins Directory

## What are Plugins?
Plugins package complete configurations (commands, skills, hooks) for distribution across teams or projects.

## Plugin Structure
```
plugin-name/
├── plugin.json       # Plugin configuration
├── commands/         # Plugin commands
├── skills/          # Plugin skills
├── hooks/           # Plugin hooks
└── README.md        # Plugin documentation
```

## Installing Plugins
Plugins can be shared across teams to standardize workflows and best practices.
EOF

# Create dev workspace files
print_status "Creating dev workspace templates..."

cat > dev/active/context.md << 'EOF'
# Current Context

## What We're Working On
[Describe the current feature or task]

## Recent Changes
- [List recent significant changes]

## Next Steps
- [ ] [Next task]
- [ ] [Following task]

## Open Questions
- [Any questions or decisions needed]
EOF

cat > dev/plans/tasks.md << 'EOF'
# Task List

## Current Sprint/Iteration
- [ ] Task 1
- [ ] Task 2

## Backlog
- [ ] Future task 1
- [ ] Future task 2

## Completed
- [x] Completed task 1
EOF

cat > dev/scratch/SCRATCHPAD.md << 'EOF'
# Scratchpad

This is Claude's planning space for working through ideas before implementation.

## Current Planning
[Claude can use this space to plan and think through problems]
EOF

# Create quality checkpoint commands
print_status "Creating quality checkpoint commands..."

cat > .claude/commands/qplan.md << 'EOF'
Analyze similar parts of the codebase and determine whether your plan:

1. **Consistency Check**
   - Is consistent with existing architecture patterns
   - Follows established naming conventions
   - Uses existing utilities and helpers where applicable

2. **Minimal Changes**
   - Introduces the minimum necessary changes
   - Avoids unnecessary refactoring
   - Preserves existing functionality

3. **Code Reuse**
   - Identifies existing code that can be reused
   - Avoids duplication
   - Leverages established patterns

4. **Impact Analysis**
   - Lists all files that will be modified
   - Identifies potential side effects
   - Notes any breaking changes

Present your analysis before proceeding with implementation.
EOF

cat > .claude/commands/qcode.md << 'EOF'
Implement your plan following these quality standards:

1. **Implementation**
   - Follow the established plan
   - Make incremental changes
   - Test after each significant change

2. **Testing**
   - Write tests for new functionality
   - Ensure all tests pass
   - Verify no regressions

3. **Code Quality**
   - Run formatter on new/modified files
   - Run linter and fix issues
   - Run type checker

4. **Verification**
   - All tests pass
   - No type errors
   - No lint errors
   - Code builds successfully

Report any issues encountered during implementation.
EOF

cat > .claude/commands/qcheck.md << 'EOF'
You are a SKEPTICAL senior software engineer performing a thorough code review.

For every MAJOR code change, analyze:

1. **Code Quality Review**
   - Review against project CLAUDE.md standards
   - Check for code smells and anti-patterns
   - Verify proper error handling
   - Ensure adequate logging

2. **Testing Review**
   - Are edge cases covered?
   - Are error conditions tested?
   - Is test coverage adequate?
   - Are tests maintainable?

3. **Bug Detection**
   - Identify potential runtime errors
   - Check for memory leaks or resource issues
   - Verify thread safety (if applicable)
   - Look for security vulnerabilities

4. **Architecture Review**
   - Does this fit the existing architecture?
   - Are abstractions appropriate?
   - Is the code maintainable?
   - Are dependencies reasonable?

Provide specific, actionable feedback with line-level suggestions.
EOF

cat > .claude/commands/tdd.md << 'EOF'
Test-Driven Development workflow for: $ARGUMENTS

Follow these steps:

1. **Write Failing Tests**
   - Write comprehensive tests for the feature
   - Cover happy path and edge cases
   - Include error conditions
   - Run tests and verify they fail correctly

2. **Implement Minimal Code**
   - Write just enough code to pass tests
   - Keep implementation simple
   - Avoid premature optimization
   - Run tests frequently

3. **Refactor**
   - Clean up implementation
   - Improve code structure
   - Ensure tests still pass
   - Update documentation

4. **Review**
   - Verify all tests pass
   - Check test coverage
   - Review code quality
   - Update CLAUDE.md if needed

Report on test results and implementation progress.
EOF

cat > .claude/commands/usage.md << 'EOF'
# Token Usage Report

Show comprehensive token usage statistics:

1. **Daily Usage**: Display today's token consumption
2. **Current Block**: Show usage in current 5-hour window
3. **Burn Rate**: Calculate tokens per hour
4. **Cost Estimate**: Approximate costs based on usage

Run: `npx ccusage@latest daily && npx ccusage@latest blocks`

Arguments: $ARGUMENTS
EOF

cat > .claude/commands/create-prd.md << 'EOF'
Create a Product Requirements Document for: $ARGUMENTS

Include the following sections:

## Problem Statement
[What problem are we solving?]

## Goals and Objectives
[What are we trying to achieve?]

## User Stories
[Who will use this and how?]

## Requirements
### Functional Requirements
- [Specific features and functionality]

### Non-Functional Requirements
- [Performance, security, scalability requirements]

## Success Metrics
[How will we measure success?]

## Technical Considerations
[Technology choices, dependencies, constraints]

## Out of Scope
[What we're explicitly not doing]

## Timeline and Milestones
[Key dates and deliverables]

Save the PRD to dev/plans/prd.md
EOF

cat > .claude/commands/plan-feature.md << 'EOF'
Plan feature implementation for: $ARGUMENTS

Follow this workflow:

## 1. Research Phase
- Read relevant existing code
- Understand current architecture
- Identify dependencies and integrations
- Document findings

## 2. Planning Phase
- Write detailed plan to dev/plans/feature-plan.md
- List all files to create/modify
- Identify potential risks and challenges
- Estimate complexity

## 3. Review Checkpoint
- Present plan for approval
- Address any concerns
- Adjust plan as needed
- Wait for user confirmation

## 4. Implementation Phase
- Follow TDD approach
- Implement incrementally
- Run tests after each change
- Commit frequently with clear messages

## 5. Verification Phase
- Run full test suite
- Check type safety
- Verify no regressions
- Update documentation

Present the plan and wait for approval before starting implementation.
EOF

# Create .claudeignore
print_status "Creating .claudeignore..."

cat > .claudeignore << 'EOF'
# Sensitive data
.env
.env.local
.env.*.local
*.key
*.pem
secrets/
credentials/

# Large files
node_modules/
dist/
build/
*.log
*.logs

# Temporary files
.cache/
tmp/
*.tmp
*.swp
.DS_Store

# IDE files
.vscode/
.idea/
*.sublime-*

# Build artifacts
*.pyc
__pycache__/
*.class
*.o
*.so
EOF

# Create/Update .gitignore
print_status "Updating .gitignore..."

# Check if .gitignore exists
if [ -f .gitignore ]; then
    # Add Claude-specific entries if they don't exist
    if ! grep -q ".claude/settings.local.json" .gitignore; then
        cat >> .gitignore << 'EOF'

# Claude Code - User-specific settings
.claude/settings.local.json

# Claude Code - Working directories
dev/scratch/
*.scratchpad.md
EOF
        print_success "Added Claude Code entries to .gitignore"
    else
        print_warning ".gitignore already contains Claude Code entries"
    fi
else
    cat > .gitignore << 'EOF'
# Claude Code - User-specific settings
.claude/settings.local.json

# Claude Code - Working directories
dev/scratch/
*.scratchpad.md
EOF
    print_success "Created .gitignore with Claude Code entries"
fi

# Create CLAUDE.md template
print_status "Creating CLAUDE.md template..."

cat > CLAUDE.md << 'EOF'
# CLAUDE.md

## Project Overview
- **Name**: [Your Project Name]
- **Tech Stack**: [List your technologies]
- **Description**: [Brief project description]

## Architecture
- `src/` - [Source code description]
- `tests/` - [Test files description]
- [Add other important directories]

## Key Commands
- `[command]` - [Description]
- Add your project-specific commands here

## Code Standards
- [Your coding standards]
- [Naming conventions]
- [File organization rules]

## Testing Requirements
- [Coverage requirements]
- [Testing practices]
- [Test naming conventions]

## Workflow Rules
- Always run tests before committing
- Use quality checkpoint commands (qplan, qcode, qcheck)
- Follow TDD approach for new features

## Git Workflow
- Branch naming: `feature/description`, `fix/description`
- Commit messages: [Your convention]

## Security
- Never commit `.env` files
- Use environment variables for secrets
- Validate all user input

## When Starting Work
1. Review dev/active/*.md for current context
2. Check dev/plans/*.md for roadmap
3. Ask questions before making assumptions
4. Plan in dev/scratch/SCRATCHPAD.md first

## Custom Commands Available
- `/qplan` - Analyze plan consistency
- `/qcode` - Implement with quality checks
- `/qcheck` - Skeptical code review
- `/tdd` - Test-driven development workflow
- `/usage` - View token usage report
- `/create-prd` - Generate PRD from description
- `/plan-feature` - Plan feature implementation

## Security & Monitoring
This project uses enhanced Claude Code settings with:
- **Security Hooks**: Automatic protection of sensitive files (.env, .key, etc.)
- **Auto-Format**: Code formatting after edits (Prettier, ESLint, Black)
- **Token Tracking**: Telemetry enabled for usage monitoring
- **Implementation Logging**: All actions logged to `.claude/logs/`
- **Sandboxing**: Safe command execution environment

View logs: `.claude/logs/`
- `bash-commands.log` - All bash commands executed
- `implementation-steps.jsonl` - Detailed action log
- `tool-usage.log` - Tool usage tracking

## Token Usage Monitoring
Track your Claude Code usage:
```bash
npx ccusage@latest daily    # Daily summary
npx ccusage@latest blocks   # Current 5-hour block
npx ccusage@latest monthly  # Monthly breakdown
```
Or use the `/usage` command within Claude Code.
EOF

# Create enhanced .claude/settings.json
print_status "Creating enhanced .claude/settings.json with telemetry and security..."

cat > .claude/settings.json << 'EOF'
{
  "//": "═══════════════════════════════════════════════════════════",
  "//": "  CLAUDE CODE PROJECT SETTINGS",
  "//": "  Version: 2.0",
  "//": "═══════════════════════════════════════════════════════════",

  "//": "────────────────────────────────────────────────────────────",
  "//": "MODEL & PERFORMANCE CONFIGURATION",
  "//": "────────────────────────────────────────────────────────────",
  "model": "claude-sonnet-4-20250514",

  "//": "────────────────────────────────────────────────────────────",
  "//": "TELEMETRY & MONITORING",
  "//": "Enable these to support token tracking with external tools",
  "//": "Use 'npx ccusage@latest' to view usage",
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
  "//": "NOTE: Hooks provide primary security protection",
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
EOF

# Create hook scripts
print_status "Creating security and automation hooks..."

# 1. Security Hook: protect-sensitive-files.py
cat > .claude/hooks/protect-sensitive-files.py << 'EOF'
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
EOF

# 2. Auto-Format Hook
cat > .claude/hooks/auto-format.sh << 'EOF'
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
EOF

# 3. Post Tool Use Tracker
cat > .claude/hooks/post-tool-use-tracker.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Track tool usage for monitoring
LOG_FILE="$CLAUDE_PROJECT_DIR/.claude/logs/tool-usage.log"

# Extract tool name and timestamp
TOOL_NAME=$(jq -r '.tool_name // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Log the usage
echo "$TIMESTAMP - $TOOL_NAME" >> "$LOG_FILE"

exit 0
EOF

# 4. Session End Summary
cat > .claude/hooks/session-end-summary.sh << 'EOF'
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
EOF

# 5. Implementation Logger
cat > .claude/hooks/log-implementation.py << 'EOF'
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
EOF

# 6. Skill Activation Prompt (placeholder)
cat > .claude/hooks/skill-activation-prompt.sh << 'EOF'
#!/usr/bin/env bash
# Placeholder for skill activation suggestions
# Can be customized to inject context based on current task
exit 0
EOF

# Make all hooks executable
print_status "Making hooks executable..."
chmod +x .claude/hooks/*.sh 2>/dev/null || true
chmod +x .claude/hooks/*.py 2>/dev/null || true

# Create .mcp.json template
print_status "Creating .mcp.json template..."

cat > .mcp.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "."]
    }
  }
}
EOF

# Create onboarding documentation
print_status "Creating onboarding documentation..."

cat > docs/onboarding/CLAUDE_SETUP.md << 'EOF'
# Setting Up Claude Code for This Project

## 1. Prerequisites
- Claude Code installed (`npm install -g @anthropic-ai/claude-code`)
- Node.js and npm installed
- Git configured

## 2. Initial Setup

Navigate to the project directory:
```bash
cd your-project
```

## 3. Review Project Context

Read the project CLAUDE.md:
```bash
cat CLAUDE.md
```

This file contains:
- Project architecture
- Code standards
- Available commands
- Workflow rules

## 4. Explore Available Commands

Claude Code custom commands are in `.claude/commands/`:
- `/qplan` - Analyze plan before implementation
- `/qcode` - Implement with quality checks
- `/qcheck` - Perform code review
- `/tdd` - Test-driven development
- `/create-prd` - Create product requirements
- `/plan-feature` - Plan feature implementation

## 5. Understand the Directory Structure

```
.claude/          - Claude Code configuration
dev/active/       - Current work context
dev/plans/        - Planning documents
dev/scratch/      - Scratchpad for planning
docs/             - Project documentation
```

## 6. Start Working

Ask Claude: "What is the project structure?" or "Show me the current tasks"

## 7. Development Workflow

1. Check `dev/active/context.md` for current work
2. Use `/plan-feature [feature-name]` to plan
3. Use `/qcode` to implement with quality checks
4. Use `/qcheck` to review changes
5. Update `dev/active/context.md` with progress

## 8. Best Practices

- Always review CLAUDE.md before starting work
- Use quality checkpoint commands
- Keep dev/active/ updated
- Document decisions in docs/decisions/
- Ask questions before making assumptions

## 9. Enhanced Features

### Security Hooks
The project includes automatic security protection:
- Sensitive files (.env, .key, .pem) are automatically blocked
- All bash commands are logged for audit
- Sandboxed command execution for safety

Test it: Try to read a .env file - it should be blocked!

### Auto-Formatting
Code is automatically formatted after edits:
- TypeScript/JavaScript: Prettier + ESLint
- Python: Black + isort
- Go: gofmt

### Token Usage Monitoring
Track your Claude Code usage:
```bash
# View daily usage
npx ccusage@latest daily

# Monitor current 5-hour block
npx ccusage@latest blocks

# Use the /usage command in Claude Code
/usage
```

### Activity Logs
All actions are logged to `.claude/logs/`:
- `bash-commands.log` - Command history
- `implementation-steps.jsonl` - Detailed action log
- `tool-usage.log` - Tool usage tracking

### Session Summaries
At the end of each session, you'll get:
- Token usage summary
- Files modified
- Links to view detailed usage
EOF

cat > docs/onboarding/PROJECT_STRUCTURE.md << 'EOF'
# Project Structure

## Overview
This document explains the organization of this project.

## Directory Layout

```
project-root/
├── .claude/              Claude Code configuration
│   ├── skills/          Domain expertise definitions
│   ├── hooks/           Event-driven scripts
│   ├── agents/          Custom AI agents
│   ├── commands/        Slash commands
│   ├── plugins/         Plugin packages
│   └── settings.json    Project settings
│
├── dev/                 Development workspace
│   ├── active/         Current work context
│   ├── plans/          Planning documents
│   └── scratch/        Scratchpad files
│
├── docs/                Project documentation
│   ├── architecture/   Architecture docs
│   ├── onboarding/     Setup guides
│   └── decisions/      Architecture Decision Records
│
├── CLAUDE.md           Root project memory
├── .claudeignore       Files to exclude from Claude
└── .mcp.json          MCP server configuration
```

## Key Files

### CLAUDE.md
The primary context file for Claude Code. Contains:
- Project overview
- Architecture
- Code standards
- Workflow rules
- Available commands

### dev/active/context.md
Current work context. Update this file to help Claude understand:
- What you're working on
- Recent changes
- Next steps
- Open questions

### .claude/commands/
Custom slash commands for common tasks:
- Quality checkpoints (qplan, qcode, qcheck)
- TDD workflow
- Feature planning

## Working with the Structure

1. **Before Starting Work**
   - Review CLAUDE.md
   - Check dev/active/context.md
   - Read relevant docs/

2. **During Development**
   - Use /qplan to verify approach
   - Update dev/active/ as you progress
   - Use /qcode for implementation

3. **After Completing Work**
   - Use /qcheck for review
   - Update context.md
   - Document decisions in docs/decisions/
EOF

# Create Architecture Decision Records template
cat > docs/decisions/ADR-template.md << 'EOF'
# ADR-[NUMBER]: [TITLE]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
[Describe the issue or decision that needs to be made]

## Decision
[Describe the decision that was made]

## Consequences
[Describe the resulting context, including positive and negative consequences]

## Alternatives Considered
[List other options that were considered]

## Date
[Date of decision]
EOF

# Create comprehensive AGENTS.md
print_status "Creating comprehensive AGENTS.md..."

cat > AGENTS.md << 'EOF'
# AGENTS.md - Claude Code Agent Catalog

## Overview
This document catalogs all available agents in the Claude Code ecosystem. Agents are specialized AI assistants with specific roles, capabilities, and expertise areas. They can be invoked using the Task tool with the appropriate `subagent_type` parameter.

## Built-in Agents

### 1. General-Purpose Agent
**Subagent Type**: `general-purpose`

**Description**: Multi-faceted agent for complex, multi-step tasks requiring broad capabilities.

**Capabilities**:
- Research complex questions across multiple files
- Search for code patterns and implementations
- Execute multi-step workflows autonomously
- Access to all available tools

**When to Use**:
- Investigating unfamiliar codebases
- Multi-step refactoring tasks
- Complex feature implementation requiring research
- Tasks requiring iteration and discovery

**Example Invocations**:
```
Use the Task tool to launch a general-purpose agent to:
- "Find all API endpoints and document their authentication requirements"
- "Research how error handling works across the codebase and suggest improvements"
- "Implement user authentication with OAuth2, researching existing patterns first"
```

**Best Practices**:
- Provide clear, detailed task descriptions
- Specify what information to return in the final report
- Use when you need autonomous multi-step execution
- Launch in parallel when possible for independent tasks

---

### 2. Explore Agent
**Subagent Type**: `Explore`

**Description**: Fast, specialized agent for codebase exploration and discovery.

**Capabilities**:
- Quick file pattern matching (e.g., "src/components/**/*.tsx")
- Keyword searches across the codebase
- Understanding code organization and structure
- Finding specific implementations or patterns
- Access to all tools with focus on search and analysis

**Thoroughness Levels**:
- `quick`: Basic searches, single-pass exploration (fastest)
- `medium`: Moderate exploration, checks multiple locations
- `very thorough`: Comprehensive analysis across all relevant areas

**When to Use**:
- Understanding codebase structure
- Finding specific code patterns or implementations
- Locating where features are implemented
- Quick discovery without modification needs
- Answering "where" and "how" questions about code

**Example Invocations**:
```
Use the Task tool with subagent_type=Explore:
- "Find all React components that use the useAuth hook (quick)"
- "Locate error handling patterns in the API layer (medium)"
- "Comprehensively map all database query patterns (very thorough)"
```

**Best Practices**:
- Specify thoroughness level based on task needs
- Use "quick" for simple lookups
- Use "medium" for moderate complexity
- Use "very thorough" for comprehensive audits
- Prefer Explore over direct Grep/Glob for open-ended searches

---

### 3. Plan Agent
**Subagent Type**: `Plan`

**Description**: Specialized agent for planning and architectural design.

**Capabilities**:
- Analyze codebase to understand architecture
- Design implementation plans
- Identify files and components to modify
- Assess impact and risks
- Create detailed roadmaps
- Access to all tools with focus on analysis

**Thoroughness Levels**:
- `quick`: High-level planning, basic approach
- `medium`: Detailed planning with impact analysis
- `very thorough`: Comprehensive planning with all considerations

**When to Use**:
- Planning new features before implementation
- Designing refactoring approaches
- Architecture decisions requiring analysis
- Creating implementation roadmaps
- Risk assessment for changes

**Example Invocations**:
```
Use the Task tool with subagent_type=Plan:
- "Plan the implementation of a real-time notification system (medium)"
- "Design a migration strategy from REST to GraphQL (very thorough)"
- "Create a quick plan for adding dark mode support (quick)"
```

**Best Practices**:
- Use before starting complex implementations
- Request specific deliverables (files to modify, steps, risks)
- Specify thoroughness based on change complexity
- Review plan output before proceeding with implementation

---

### 4. Statusline Setup Agent
**Subagent Type**: `statusline-setup`

**Description**: Specialized agent for configuring Claude Code's status line settings.

**Capabilities**:
- Read current status line configuration
- Edit status line settings
- Configure display options
- Troubleshoot status line issues

**Tools Available**:
- Read
- Edit

**When to Use**:
- Configuring status line appearance
- Customizing information displayed
- Troubleshooting status line problems
- Setting up status line for first time

**Example Invocations**:
```
Use the Task tool with subagent_type=statusline-setup:
- "Configure the status line to show git branch and token usage"
- "Fix status line not displaying properly"
- "Customize status line colors and format"
```

**Best Practices**:
- Provide specific requirements for status line display
- Test changes after configuration
- Keep status line configuration minimal for performance

---

## Custom Agent Development

### Creating Custom Agents

You can define custom agents in `.claude/agents/` to specialize Claude's behavior for your project needs.

**Agent Definition Template**:
```markdown
# Agent Name

## Role
[Define the agent's primary role]

## Expertise Areas
- [Area 1]
- [Area 2]
- [Area 3]

## Activation Triggers
- [When this agent should be used]
- [Specific keywords or contexts]

## Capabilities
- [What the agent can do]
- [Specific tools or knowledge]

## Example Usage
[Provide example scenarios and invocations]

## Limitations
[What the agent should not do]
```

**Example Custom Agents**:

### Code Review Agent
```markdown
# Code Review Agent

## Role
Perform comprehensive code reviews with focus on quality, security, and best practices.

## Expertise Areas
- Security vulnerability detection
- Performance optimization
- Code maintainability
- Test coverage analysis

## Activation Triggers
- Use when: code review requested
- Keywords: "review", "audit", "check quality"

## Capabilities
- Static code analysis
- Security scanning
- Performance profiling suggestions
- Test coverage assessment

## Example Usage
"Review the authentication module for security vulnerabilities and performance issues"

## Limitations
Does not execute code or run tests, focuses on static analysis only.
```

### Documentation Agent
```markdown
# Documentation Agent

## Role
Create and maintain comprehensive project documentation.

## Expertise Areas
- API documentation
- README files
- Architecture diagrams
- Onboarding guides

## Activation Triggers
- Use when: documentation needed
- Keywords: "document", "explain", "write guide"

## Capabilities
- Generate API documentation from code
- Create architecture documentation
- Write user guides
- Update README files

## Example Usage
"Document all API endpoints in the user service with examples"

## Limitations
Relies on existing code; cannot infer undocumented business logic.
```

---

## Agent Selection Guide

### Decision Tree

```
Is this a multi-step research task?
├─ Yes → Use general-purpose agent
└─ No
    ├─ Need to explore/find code?
    │   └─ Use Explore agent (specify thoroughness)
    ├─ Need to plan implementation?
    │   └─ Use Plan agent (specify thoroughness)
    ├─ Configuring status line?
    │   └─ Use statusline-setup agent
    └─ Other specialized task?
        └─ Check custom agents or use appropriate tool directly
```

### Quick Reference Table

| Task Type | Agent | Thoroughness | Typical Duration |
|-----------|-------|--------------|------------------|
| Find specific code | Explore | quick | < 30 sec |
| Understand architecture | Explore | medium | 1-2 min |
| Full codebase audit | Explore | very thorough | 3-5 min |
| Quick feature plan | Plan | quick | 1-2 min |
| Detailed planning | Plan | medium | 2-4 min |
| Complex architecture | Plan | very thorough | 5-10 min |
| Multi-step research | general-purpose | N/A | Variable |
| Status line config | statusline-setup | N/A | < 1 min |

---

## Best Practices

### 1. Agent Invocation
- **Be specific**: Provide clear, detailed task descriptions
- **Set expectations**: Specify what information you want returned
- **Use thoroughness wisely**: Balance speed vs completeness
- **Parallel execution**: Launch multiple agents in parallel when tasks are independent

### 2. Agent Selection
- **Explore vs General-Purpose**: Use Explore for searches; general-purpose for complex workflows
- **Plan before Execute**: Use Plan agent before complex implementations
- **Right tool for job**: Don't use agents when direct tools are more appropriate

### 3. Performance Optimization
- **Minimize agent use**: Direct tools are faster for simple tasks
- **Parallel agents**: Send single message with multiple Task calls
- **Appropriate thoroughness**: Don't use "very thorough" when "quick" suffices
- **Cache awareness**: Agents don't share context between invocations

### 4. Effective Communication
- **Detailed prompts**: Include all necessary context in initial prompt
- **Specify deliverables**: Tell agent exactly what to return
- **Stateless design**: Each invocation is independent; include all info needed
- **Trust output**: Agent outputs are generally reliable

---

## Common Patterns

### Pattern 1: Comprehensive Feature Implementation
```
1. Launch Plan agent (medium thoroughness)
   - Research existing patterns
   - Design implementation approach
   - Identify files to modify

2. Review plan output

3. Launch general-purpose agent with implementation task
   - Reference the plan
   - Specify quality requirements
   - Include testing requirements

4. Review implementation
```

### Pattern 2: Codebase Discovery
```
1. Launch Explore agent (quick)
   - Find initial patterns
   - Understand structure

2. If needed, launch Explore agent (medium)
   - Deeper investigation
   - Multiple locations

3. If comprehensive needed, launch Explore (very thorough)
   - Complete mapping
   - All variations
```

### Pattern 3: Parallel Investigation
```
Launch multiple Explore agents in parallel:
- Agent 1: "Find all API endpoints (quick)"
- Agent 2: "Find all database queries (quick)"
- Agent 3: "Find all authentication code (quick)"

Process results concurrently for fast overview.
```

### Pattern 4: Iterative Refinement
```
1. Explore agent (quick): Get initial understanding
2. Review results
3. Plan agent (medium): Design based on findings
4. Review plan
5. general-purpose agent: Implement with iterations
```

---

## Troubleshooting

### Agent Not Finding Code
- **Issue**: Explore agent returns no results
- **Solutions**:
  - Increase thoroughness level
  - Broaden search terms
  - Check if code exists in expected locations
  - Use general-purpose for more flexible search

### Agent Taking Too Long
- **Issue**: Agent exceeds expected duration
- **Solutions**:
  - Reduce thoroughness level
  - Narrow the scope of the task
  - Break into smaller, parallel sub-tasks
  - Use more specific search criteria

### Agent Missing Context
- **Issue**: Agent doesn't have necessary information
- **Solutions**:
  - Include all context in the prompt (agents are stateless)
  - Reference specific files or locations
  - Provide examples of expected output
  - Break task into smaller steps with explicit context

### Unclear Agent Output
- **Issue**: Agent returns vague or incomplete results
- **Solutions**:
  - Specify exactly what information to return
  - Request specific format (list, table, code, etc.)
  - Ask for examples in output
  - Increase thoroughness level

---

## Integration with Claude Code

### Using Agents in Workflows

**Quality Checkpoint Workflow** (with `/qplan`, `/qcode`, `/qcheck`):
```
1. /qplan → Uses Plan agent to analyze approach
2. /qcode → May use general-purpose for implementation
3. /qcheck → Manual review or custom review agent
```

**TDD Workflow** (with `/tdd`):
```
1. Plan agent: Design test strategy
2. general-purpose agent: Implement tests and code
3. Explore agent: Verify coverage
```

**Feature Planning** (with `/plan-feature`):
```
1. Explore agent: Understand current implementation
2. Plan agent: Design new feature
3. Review and approval
4. general-purpose agent: Implementation
```

### Agent Hooks Integration

Agents respect all configured hooks:
- **Security hooks**: Sensitive file protection applies
- **Auto-format hooks**: Code modifications are formatted
- **Logging hooks**: Agent actions are logged
- **Session hooks**: Included in session summaries

---

## Advanced Topics

### Agent Performance Tuning

**For Speed**:
- Use "quick" thoroughness
- Narrow scope with specific paths
- Use Explore for searches (not general-purpose)
- Direct tools when possible

**For Completeness**:
- Use "very thorough" thoroughness
- Broad scope with multiple patterns
- Use general-purpose for complex tasks
- Allow more time for execution

### Multi-Agent Orchestration

**Serial Execution** (when dependent):
```
1. Wait for Agent 1 to complete
2. Use Agent 1 output in Agent 2 prompt
3. Use Agent 2 output in Agent 3 prompt
```

**Parallel Execution** (when independent):
```
Send single message with multiple Task calls:
- All agents launch simultaneously
- Process results concurrently
- Combine outputs
```

### Custom Agent Development

**Steps**:
1. Create `.claude/agents/agent-name.md`
2. Define role, capabilities, activation triggers
3. Document usage examples
4. Test with various scenarios
5. Add to this catalog

**Considerations**:
- Keep scope focused and specific
- Clear activation criteria
- Document limitations
- Provide usage examples

---

## Resources

### Documentation
- Claude Code Docs: https://docs.claude.com/claude-code
- Task Tool Documentation: See system prompts
- Agent Development: `.claude/agents/README.md`

### Examples
- See `.claude/agents/` for custom agent definitions
- Check `docs/onboarding/` for workflow examples
- Review `CLAUDE.md` for project-specific patterns

### Community
- Share custom agents in team documentation
- Document lessons learned
- Contribute patterns back to this catalog

---

## Changelog

### Version 1.0 (Initial)
- Documented all built-in agents
- Added custom agent development guide
- Included best practices and patterns
- Created troubleshooting section

---

**This catalog is maintained as part of the Claude Code enhanced setup.**
**Last Updated**: Auto-generated during setup
**Maintainer**: Project Team

For questions or additions, update this file and share with the team.
EOF

print_success "Created comprehensive AGENTS.md"

# Create comprehensive README.md
print_status "Creating comprehensive README.md..."

cat > README.md << 'EOF'
# 🚀 Project Name

> 📝 **Quick Start**: This project is configured with [Claude Code](https://docs.claude.com/claude-code) for AI-assisted development.

## 📋 Table of Contents

- [Overview](#-overview)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [Claude Code Integration](#-claude-code-integration)
- [Available Commands](#-available-commands)
- [Quality Workflows](#-quality-workflows)
- [Security & Monitoring](#-security--monitoring)
- [Documentation](#-documentation)
- [Contributing](#-contributing)

## 🎯 Overview

<!-- Add your project description here -->
This is a Claude Code enhanced project with built-in security, monitoring, and quality automation.

### ✨ Key Features

- 🔒 **Security**: Automatic protection of sensitive files
- 📊 **Token Tracking**: Built-in usage monitoring
- 🎨 **Auto-Formatting**: Automatic code formatting on save
- 📝 **Activity Logging**: Complete audit trail
- 🤖 **AI Agents**: Specialized agents for different tasks
- ✅ **Quality Commands**: Built-in quality checkpoints

## 🚀 Quick Start

### Prerequisites

- [Claude Code](https://docs.claude.com/claude-code) installed
- Node.js and npm (for JavaScript/TypeScript projects)
- Python 3.x (for Python projects)
- Git configured

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd <your-project>

# Install dependencies
npm install  # or pip install -r requirements.txt

# Optional: Install token tracking
npm install -g ccusage

# Start using Claude Code
claude code
```

### First Steps

1. 📖 Read [CLAUDE.md](CLAUDE.md) for project-specific guidelines
2. 🤖 Review [AGENTS.md](AGENTS.md) to understand available AI agents
3. 📚 Check [docs/onboarding/](docs/onboarding/) for detailed setup guides
4. ✅ Run tests to verify setup: `npm test` (or equivalent)

## 📁 Project Structure

```
.
├── .claude/              # 🤖 Claude Code configuration
│   ├── agents/          # AI agent definitions
│   ├── commands/        # Slash commands
│   ├── hooks/           # Automation scripts
│   ├── logs/            # Activity logs
│   ├── skills/          # Domain expertise
│   └── settings.json    # Configuration
│
├── dev/                 # 🛠️ Development workspace
│   ├── active/         # Current work context
│   ├── plans/          # Planning documents
│   └── scratch/        # Scratchpad for ideas
│
├── docs/                # 📚 Documentation
│   ├── architecture/   # Architecture docs
│   ├── decisions/      # ADRs (Architecture Decision Records)
│   └── onboarding/     # Setup & onboarding guides
│
├── src/                 # 💻 Source code
├── tests/               # 🧪 Test files
│
├── AGENTS.md            # 🤖 AI agent catalog
├── CLAUDE.md            # 📋 Project memory for Claude
└── README.md            # 📖 This file
```

## 💻 Development

### Running the Project

```bash
# Development mode
npm run dev

# Build
npm run build

# Run tests
npm test

# Linting
npm run lint

# Format code
npm run format
```

### Development Workflow

1. **Check Context**: Review `dev/active/context.md` for current work
2. **Plan**: Use `/plan-feature` or write plans in `dev/plans/`
3. **Implement**: Use quality commands (`/qplan`, `/qcode`, `/qcheck`)
4. **Test**: Run tests after each change
5. **Commit**: Use clear, descriptive commit messages

## 🤖 Claude Code Integration

### What is Claude Code?

Claude Code is an AI-powered development assistant that helps with:
- 🔍 Code exploration and understanding
- 📝 Planning and architecture
- ✍️ Implementation and refactoring
- 🐛 Debugging and troubleshooting
- 📚 Documentation generation

### Available AI Agents

This project includes specialized AI agents for different tasks:

| Agent | Use Case | Example |
|-------|----------|---------|
| 🔍 **Explore** | Find code patterns | `"Find all API endpoints (quick)"` |
| 📋 **Plan** | Design features | `"Plan authentication system (medium)"` |
| 🛠️ **General-Purpose** | Complex tasks | `"Research and implement OAuth2"` |
| ⚙️ **Statusline** | Configure UI | `"Setup status line with git info"` |

📖 **See [AGENTS.md](AGENTS.md) for complete agent documentation**

## 🎯 Available Commands

### Slash Commands

Run these commands in Claude Code with `/command-name`:

| Command | Description | Usage |
|---------|-------------|-------|
| `/qplan` | 📋 Analyze plan consistency | Plan validation before coding |
| `/qcode` | ✅ Implement with quality checks | Quality-focused implementation |
| `/qcheck` | 🔍 Skeptical code review | Comprehensive code review |
| `/tdd` | 🧪 Test-driven development | TDD workflow automation |
| `/create-prd` | 📄 Create PRD | Generate product requirements |
| `/plan-feature` | 🗺️ Plan feature | Complete feature planning |
| `/usage` | 📊 Token usage report | View Claude Code usage stats |

### Quick Command Reference

```bash
# Plan a feature
/plan-feature "user authentication"

# Implement with quality checks
/qcode

# Review code
/qcheck

# Check token usage
/usage
```

## ✨ Quality Workflows

### 1. Feature Development Workflow

```
📋 /qplan          → Validate approach
    ↓
✍️  /qcode         → Implement with quality
    ↓
🔍 /qcheck        → Review & verify
    ↓
✅ Commit         → Ship with confidence
```

### 2. Test-Driven Development

```
🧪 /tdd           → Write tests first
    ↓
✅ Implement      → Make tests pass
    ↓
♻️  Refactor      → Clean up code
    ↓
🔍 /qcheck        → Final review
```

### 3. Planning Workflow

```
🔍 Explore        → Understand codebase
    ↓
📋 /plan-feature  → Design solution
    ↓
👀 Review         → Get approval
    ↓
🛠️ Implement      → Build feature
```

## 🔒 Security & Monitoring

### Security Features

This project includes automatic security protections:

- 🚫 **Sensitive File Protection**: `.env`, `.key`, `.pem` files blocked
- 📝 **Command Logging**: All bash commands logged
- 🔐 **Sandboxed Execution**: Safe command isolation
- ⛔ **Restricted Commands**: `curl`, `wget`, `sudo` blocked

### Monitoring & Logging

Track all activity in `.claude/logs/`:

```bash
# View bash command history
cat .claude/logs/bash-commands.log

# View implementation steps (JSON)
tail -f .claude/logs/implementation-steps.jsonl

# View tool usage
cat .claude/logs/tool-usage.log
```

### Token Usage Tracking

Monitor your Claude Code usage:

```bash
# Daily usage summary
npx ccusage@latest daily

# Current 5-hour block
npx ccusage@latest blocks

# Monthly breakdown
npx ccusage@latest monthly

# Or use the slash command
/usage
```

## 📚 Documentation

### Key Documentation Files

| File | Purpose |
|------|---------|
| [CLAUDE.md](CLAUDE.md) | 📋 Project memory & guidelines for Claude |
| [AGENTS.md](AGENTS.md) | 🤖 AI agent catalog & usage guide |
| [docs/onboarding/CLAUDE_SETUP.md](docs/onboarding/CLAUDE_SETUP.md) | 🚀 Setup guide |
| [docs/onboarding/PROJECT_STRUCTURE.md](docs/onboarding/PROJECT_STRUCTURE.md) | 📁 Structure overview |

### Creating Documentation

```bash
# Architecture Decision Record
cp docs/decisions/ADR-template.md docs/decisions/ADR-001-my-decision.md

# Update project context
vim dev/active/context.md

# Add planning docs
vim dev/plans/feature-name-plan.md
```

## 🤝 Contributing

### Before Contributing

1. 📖 Read [CLAUDE.md](CLAUDE.md) for project standards
2. 🤖 Familiarize yourself with [AGENTS.md](AGENTS.md)
3. ✅ Ensure all tests pass: `npm test`
4. 🎨 Code is auto-formatted on save

### Contribution Workflow

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Use quality commands
/qplan          # Validate approach
/qcode          # Implement
/qcheck         # Review

# 3. Ensure tests pass
npm test

# 4. Commit with clear message
git commit -m "feat: add user authentication"

# 5. Push and create PR
git push origin feature/my-feature
```

### Commit Message Convention

```
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Format code
refactor: Refactor code
test: Add tests
chore: Maintenance tasks
```

## 🛠️ Customization

### Disabling Features

Edit `.claude/settings.json` to customize:

```json
{
  "hooks": {
    "PostToolUse": [
      // Comment out hooks you don't want
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

## 📊 Project Stats

<!-- Add badges here -->

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

## 📞 Support

- 📖 **Documentation**: Check [docs/](docs/) folder
- 🐛 **Issues**: [GitHub Issues](../../issues)
- 💬 **Discussions**: [GitHub Discussions](../../discussions)
- 📧 **Contact**: [Add your contact]

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**🚀 Built with [Claude Code](https://docs.claude.com/claude-code)**

*Enhance your development workflow with AI-powered assistance*

</div>
EOF

print_success "Created comprehensive README.md"

# Summary
print_success "Enhanced Claude Code structure setup complete!"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Directory Structure Created:${NC}"
echo ""
echo "  .claude/          - Claude Code configuration"
echo "    ├── skills/     - Domain expertise"
echo "    ├── hooks/      - Event-driven scripts (✨ with security & automation)"
echo "    ├── agents/     - Custom AI agents"
echo "    ├── commands/   - Slash commands"
echo "    ├── plugins/    - Plugin packages"
echo "    └── logs/       - Activity logs & tracking"
echo ""
echo "  dev/              - Development workspace"
echo "    ├── active/     - Current work context"
echo "    ├── plans/      - Planning documents"
echo "    └── scratch/    - Scratchpad"
echo ""
echo "  docs/             - Documentation"
echo "    ├── architecture/"
echo "    ├── onboarding/"
echo "    └── decisions/  - ADRs"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✨ Enhanced Features:${NC}"
echo "  🔒 Security hooks to protect sensitive files"
echo "  🎨 Auto-format hooks for code quality"
echo "  📊 Token usage tracking enabled (telemetry)"
echo "  📝 Implementation logging for audit trail"
echo "  🔔 Session summaries with usage reports"
echo "  🛡️  Sandboxing for safe command execution"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Review and customize CLAUDE.md"
echo "  2. Install token tracking: npm install -g ccusage"
echo "  3. Test hooks: Read a .env file (should be blocked)"
echo "  4. Read docs/onboarding/CLAUDE_SETUP.md"
echo "  5. Start using quality commands: /qplan, /qcode, /qcheck"
echo ""
echo -e "${GREEN}Commands Available:${NC}"
echo "  /qplan        - Analyze plan consistency"
echo "  /qcode        - Implement with quality checks"
echo "  /qcheck       - Perform code review"
echo "  /tdd          - Test-driven development"
echo "  /usage        - View token usage report"
echo "  /create-prd   - Create product requirements"
echo "  /plan-feature - Plan feature implementation"
echo ""
echo -e "${BLUE}Monitor Token Usage:${NC}"
echo "  npx ccusage@latest daily   - Daily usage summary"
echo "  npx ccusage@latest blocks  - Current 5-hour block"
echo "  npx ccusage@latest monthly - Monthly breakdown"
echo ""
echo -e "${GREEN}Security Features Active:${NC}"
echo "  ✓ Sensitive file protection (.env, .key, .pem, etc.)"
echo "  ✓ Bash command logging"
echo "  ✓ Sandboxed command execution"
echo "  ✓ Restricted permissions (curl, wget, sudo blocked)"
echo ""
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "  • Customize README.md with your project details"
echo "  • Customize CLAUDE.md with your project specifics"
echo "  • Review AGENTS.md to understand available agents"
echo "  • Review .claude/settings.json and adjust permissions"
echo "  • Test hooks are working: claude code (in project dir)"
echo "  • Check logs in .claude/logs/ for activity tracking"
echo ""
