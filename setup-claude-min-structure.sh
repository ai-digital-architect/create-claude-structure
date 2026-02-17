#!/bin/bash

# Interactive Setup Claude Code Development Structure
# This script creates an optimal directory structure for Claude Code development
# with project-specific customizations

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

print_header() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to prompt for input with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    echo -ne "${CYAN}${prompt}${NC} ${YELLOW}[${default}]${NC}: "
    read user_input

    if [ -z "$user_input" ]; then
        eval "$var_name='$default'"
    else
        eval "$var_name='$user_input'"
    fi
}

# Function to prompt for yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="$2"

    while true; do
        echo -ne "${CYAN}${prompt}${NC} ${YELLOW}[${default}]${NC}: "
        read yn

        # Use default if empty
        if [ -z "$yn" ]; then
            yn="$default"
        fi

        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Get project root
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

# Welcome message
clear
print_header "Claude Code Interactive Setup"
echo ""
echo "This script will set up an optimal Claude Code development structure"
echo "with customizations specific to your project."
echo ""

# Project Information - Auto-detected
PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Tech Stack - Defaulting to generic/multi
TECH_STACK="Multiple"
FORMATTERS="None"
LINTERS="None"

# Project Description - Default
PROJECT_DESC="AI-assisted development project"

# Package Manager - Default
PKG_MANAGER="npm"

# Directory Structure - Defaulting to Full Setup
CREATE_CLAUDE=true
CREATE_DEV=true
CREATE_DOCS=true
CREATE_TESTS=true

# Source/Test Directories - Defaults
SRC_DIR="src"
TEST_DIR="tests"
# Features and enhancements
echo ""
print_header "Features & Enhancements"
echo ""

prompt_yes_no "Enable security hooks (protect sensitive files)?" "Y" && ENABLE_SECURITY=true || ENABLE_SECURITY=false
prompt_yes_no "Enable auto-formatting hooks?" "Y" && ENABLE_AUTOFORMAT=true || ENABLE_AUTOFORMAT=false
prompt_yes_no "Enable telemetry (token usage tracking)?" "Y" && ENABLE_TELEMETRY=true || ENABLE_TELEMETRY=false
prompt_yes_no "Enable implementation logging?" "Y" && ENABLE_LOGGING=true || ENABLE_LOGGING=false
prompt_yes_no "Enable sandboxing?" "Y" && ENABLE_SANDBOX=true || ENABLE_SANDBOX=false

# Quality commands
echo ""
prompt_yes_no "Install quality checkpoint commands (/qplan, /qcode, /qcheck)?" "Y" && INSTALL_QUALITY_CMDS=true || INSTALL_QUALITY_CMDS=false
prompt_yes_no "Install TDD workflow command (/tdd)?" "Y" && INSTALL_TDD=true || INSTALL_TDD=false
prompt_yes_no "Install feature planning commands?" "Y" && INSTALL_PLANNING=true || INSTALL_PLANNING=false

# Git settings
echo ""
print_header "Git & Version Control"
echo ""

prompt_with_default "Git branch prefix for features" "feature" BRANCH_PREFIX_FEATURE
prompt_with_default "Git branch prefix for fixes" "fix" BRANCH_PREFIX_FIX

# Confirmation
echo ""
print_header "Configuration Summary"
echo ""
echo "  Project Name:     $PROJECT_NAME"
echo "  Tech Stack:       $TECH_STACK"
echo "  Package Manager:  $PKG_MANAGER"
echo "  Source Directory: $SRC_DIR"
[ -n "$TEST_DIR" ] && echo "  Test Directory:   $TEST_DIR"
echo ""
echo "  Features:"
echo "    - Claude structure:    $CREATE_CLAUDE"
echo "    - Dev workspace:       $CREATE_DEV"
echo "    - Docs structure:      $CREATE_DOCS"
echo "    - Security hooks:      $ENABLE_SECURITY"
echo "    - Auto-formatting:     $ENABLE_AUTOFORMAT"
echo "    - Telemetry:           $ENABLE_TELEMETRY"
echo "    - Sandboxing:          $ENABLE_SANDBOX"
echo ""

if ! prompt_yes_no "Proceed with setup?" "Y"; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
print_status "Setting up Claude Code structure in: $PROJECT_ROOT"
echo ""

# Create .claude directory structure
if $CREATE_CLAUDE; then
    print_status "Creating .claude directory structure..."

    mkdir -p .claude/skills
    mkdir -p .claude/hooks
    mkdir -p .claude/agents
    mkdir -p .claude/commands
    mkdir -p .claude/plugins
    mkdir -p .claude/logs

    # Create README files
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
EOF

    cat > .claude/hooks/README.md << 'EOF'
# Hooks Directory

## What are Hooks?
Hooks are shell scripts or programs that execute automatically in response to Claude Code events.

## Common Hook Types
- **PreToolUse**: Runs before Claude uses a tool (security checks)
- **PostToolUse**: Runs after Claude uses a tool (formatting, logging)
- **PrePromptSubmission**: Runs before sending prompt to Claude
- **SessionEnd**: Runs when session ends (summaries)
- **Notification**: Runs when Claude waits for input
EOF

    cat > .claude/agents/README.md << 'EOF'
# Agents Directory

## What are Agents?
Agents are specialized AI assistants with specific roles and capabilities.

## Agent Catalog
Add your custom agent definitions here as markdown files.
EOF

    cat > .claude/commands/README.md << 'EOF'
# Commands Directory

## What are Commands?
Slash commands provide quick shortcuts for common tasks.

## Creating Custom Commands
1. Create a markdown file: `.claude/commands/command-name.md`
2. Add command instructions
3. Use `$ARGUMENTS` placeholder for user input
4. Use the command with `/command-name [arguments]`
EOF

    print_success "Created .claude directory structure"
fi

# Create dev workspace
if $CREATE_DEV; then
    print_status "Creating dev workspace..."

    mkdir -p dev/active
    mkdir -p dev/plans
    mkdir -p dev/scratch

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

    print_success "Created dev workspace"
fi

# Create docs structure
if $CREATE_DOCS; then
    print_status "Creating docs structure..."

    mkdir -p docs/architecture
    mkdir -p docs/onboarding
    mkdir -p docs/decisions

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

    print_success "Created docs structure"
fi

# Create test directory
if $CREATE_TESTS && [ -n "$TEST_DIR" ]; then
    print_status "Creating test directory..."
    mkdir -p "$TEST_DIR"
    print_success "Created test directory: $TEST_DIR"
fi

# Install quality commands
if $INSTALL_QUALITY_CMDS; then
    print_status "Installing quality checkpoint commands..."

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

    print_success "Installed quality checkpoint commands"
fi

# Install TDD command
if $INSTALL_TDD; then
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
    print_success "Installed TDD workflow command"
fi

# Install planning commands
if $INSTALL_PLANNING; then
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

    print_success "Installed feature planning commands"
fi

# Create security hooks
if $ENABLE_SECURITY && $CREATE_CLAUDE; then
    print_status "Creating security hooks..."

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

    chmod +x .claude/hooks/protect-sensitive-files.py
    print_success "Created security hooks"
fi

# Create auto-format hooks
if $ENABLE_AUTOFORMAT && $CREATE_CLAUDE; then
    print_status "Creating auto-format hooks..."

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

# Rust files
if [[ "$FILE_PATH" =~ \.rs$ ]]; then
    if command -v rustfmt >/dev/null 2>&1; then
        rustfmt "$FILE_PATH" 2>/dev/null || true
    fi
fi

exit 0
EOF

    chmod +x .claude/hooks/auto-format.sh
    print_success "Created auto-format hooks"
fi

# Create logging hooks
if $ENABLE_LOGGING && $CREATE_CLAUDE; then
    print_status "Creating implementation logger..."

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

    chmod +x .claude/hooks/log-implementation.py

    # Create session end summary
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

    chmod +x .claude/hooks/session-end-summary.sh

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

    chmod +x .claude/hooks/post-tool-use-tracker.sh

    print_success "Created logging hooks"
fi

# Create .claudeignore
print_status "Creating .claudeignore..."

cat > .claudeignore << EOF
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

print_success "Created .claudeignore"

# Update .gitignore
print_status "Updating .gitignore..."

if [ -f .gitignore ]; then
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

# Create customized CLAUDE.md
print_status "Creating customized CLAUDE.md..."

cat > CLAUDE.md << EOF
# CLAUDE.md

## Project Overview
- **Name**: ${PROJECT_NAME}
- **Tech Stack**: ${TECH_STACK}
- **Description**: ${PROJECT_DESC}
- **Package Manager**: ${PKG_MANAGER}

## Architecture
- \`${SRC_DIR}/\` - Source code
EOF

if [ -n "$TEST_DIR" ]; then
    echo "- \`${TEST_DIR}/\` - Test files" >> CLAUDE.md
fi

cat >> CLAUDE.md << 'EOF'
- `.claude/` - Claude Code configuration
- `dev/` - Development workspace
- `docs/` - Project documentation

## Key Commands
EOF

# Add tech-stack specific commands
case $TECH_STACK in
    "TypeScript/JavaScript")
        cat >> CLAUDE.md << EOF
- \`${PKG_MANAGER} install\` - Install dependencies
- \`${PKG_MANAGER} run test\` - Run tests
- \`${PKG_MANAGER} run build\` - Build project
- \`${PKG_MANAGER} run lint\` - Run linter
EOF
        ;;
    "Python")
        cat >> CLAUDE.md << EOF
- \`${PKG_MANAGER} install -r requirements.txt\` - Install dependencies
- \`pytest\` - Run tests
- \`black .\` - Format code
- \`pylint ${SRC_DIR}/\` - Run linter
EOF
        ;;
    "Go")
        cat >> CLAUDE.md << EOF
- \`go mod download\` - Download dependencies
- \`go test ./...\` - Run tests
- \`go build\` - Build project
- \`golangci-lint run\` - Run linter
EOF
        ;;
esac

cat >> CLAUDE.md << EOF

## Code Standards
- **Formatters**: ${FORMATTERS}
- **Linters**: ${LINTERS}
- Follow consistent naming conventions
- Write descriptive comments for complex logic
- Keep functions small and focused

## Testing Requirements
- Write tests for new functionality
- Maintain test coverage
- Test edge cases and error conditions
- Keep tests maintainable and readable

## Workflow Rules
- Always run tests before committing
EOF

if $INSTALL_QUALITY_CMDS; then
    echo "- Use quality checkpoint commands (/qplan, /qcode, /qcheck)" >> CLAUDE.md
fi

if $INSTALL_TDD; then
    echo "- Follow TDD approach for new features" >> CLAUDE.md
fi

cat >> CLAUDE.md << EOF

## Git Workflow
- Branch naming: \`${BRANCH_PREFIX_FEATURE}/description\`, \`${BRANCH_PREFIX_FIX}/description\`
- Commit messages: Clear, descriptive, present tense
- Always pull before pushing
- Review changes before committing

## Security
- Never commit sensitive files (.env, .key, .pem, etc.)
- Use environment variables for secrets
- Validate all user input
- Follow security best practices

## When Starting Work
1. Review dev/active/*.md for current context
2. Check dev/plans/*.md for roadmap
3. Ask questions before making assumptions
4. Plan in dev/scratch/SCRATCHPAD.md first

EOF

# Add custom commands section if applicable
if $INSTALL_QUALITY_CMDS || $INSTALL_TDD || $INSTALL_PLANNING; then
    echo "## Custom Commands Available" >> CLAUDE.md
    $INSTALL_QUALITY_CMDS && cat >> CLAUDE.md << 'EOF'
- `/qplan` - Analyze plan consistency
- `/qcode` - Implement with quality checks
- `/qcheck` - Skeptical code review
EOF
    $INSTALL_TDD && echo "- \`/tdd\` - Test-driven development workflow" >> CLAUDE.md
    $INSTALL_PLANNING && cat >> CLAUDE.md << 'EOF'
- `/create-prd` - Generate PRD from description
- `/plan-feature` - Plan feature implementation
- `/usage` - View token usage report
EOF
    echo "" >> CLAUDE.md
fi

# Add features section
cat >> CLAUDE.md << EOF
## Enhanced Features
EOF

if $ENABLE_SECURITY; then
    echo "- **Security Hooks**: Automatic protection of sensitive files" >> CLAUDE.md
fi

if $ENABLE_AUTOFORMAT; then
    echo "- **Auto-Format**: Code formatting after edits" >> CLAUDE.md
fi

if $ENABLE_TELEMETRY; then
    cat >> CLAUDE.md << 'EOF'
- **Token Tracking**: Telemetry enabled for usage monitoring
  - Track usage: `npx ccusage@latest daily`
  - Monitor blocks: `npx ccusage@latest blocks`
EOF
fi

if $ENABLE_LOGGING; then
    cat >> CLAUDE.md << 'EOF'
- **Implementation Logging**: All actions logged to `.claude/logs/`
  - `bash-commands.log` - Command history
  - `implementation-steps.jsonl` - Detailed action log
  - `tool-usage.log` - Tool usage tracking
EOF
fi

if $ENABLE_SANDBOX; then
    echo "- **Sandboxing**: Safe command execution environment" >> CLAUDE.md
fi

print_success "Created customized CLAUDE.md"

# Create .claude/settings.json with selected features
if $CREATE_CLAUDE; then
    print_status "Creating .claude/settings.json..."

    # Start building settings.json
    cat > .claude/settings.json << 'EOF'
{
  "model": "claude-sonnet-4-20250514",
EOF

    # Add telemetry if enabled
    if $ENABLE_TELEMETRY; then
        cat >> .claude/settings.json << 'EOF'
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "16384"
  },
EOF
    fi

    # Add permissions
    cat >> .claude/settings.json << 'EOF'
  "permissions": {
    "allow": [
      "Read",
      "Edit",
      "Write",
      "Grep",
      "Glob",
      "Task",
EOF

    # Add package manager specific permissions
    case $PKG_MANAGER in
        npm|yarn|pnpm)
            cat >> .claude/settings.json << EOF
      "Bash(git *)",
      "Bash(${PKG_MANAGER} *)",
      "Bash(node *)",
      "Bash(${PKG_MANAGER} run test*)",
      "Bash(${PKG_MANAGER} run build)",
      "Bash(${PKG_MANAGER} run lint)",
EOF
            ;;
        pip)
            cat >> .claude/settings.json << 'EOF'
      "Bash(git *)",
      "Bash(python *)",
      "Bash(pip *)",
      "Bash(pytest *)",
EOF
            ;;
        go)
            cat >> .claude/settings.json << 'EOF'
      "Bash(git *)",
      "Bash(go *)",
EOF
            ;;
    esac

    cat >> .claude/settings.json << 'EOF'
      "WebSearch",
      "WebFetch"
    ],
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(./secrets/**)",
      "Read(./**/*.pem)",
      "Read(./**/*.key)",
      "Write(.env*)",
      "Write(./secrets/**)",
      "Write(./**/*.pem)",
      "Write(./**/*.key)",
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(sudo *)"
    ]
  },
EOF

    # Add hooks if any are enabled
    if $ENABLE_SECURITY || $ENABLE_AUTOFORMAT || $ENABLE_LOGGING; then
        cat >> .claude/settings.json << 'EOF'
  "hooks": {
EOF

        # PreToolUse hooks
        if $ENABLE_SECURITY || $ENABLE_LOGGING; then
            cat >> .claude/settings.json << 'EOF'
    "PreToolUse": [
EOF
            if $ENABLE_SECURITY; then
                cat >> .claude/settings.json << 'EOF'
      {
        "matcher": "Read|Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/protect-sensitive-files.py"
          }
        ]
      },
EOF
            fi

            if $ENABLE_LOGGING; then
                cat >> .claude/settings.json << 'EOF'
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '\"\\(.tool_input.command) - \\(.tool_input.description // \\\"No description\\\")\"' >> $CLAUDE_PROJECT_DIR/.claude/logs/bash-commands.log"
          }
        ]
      }
EOF
            fi

            # Remove trailing comma from last item
            sed -i '' -e ':a' -e 'N' -e '$!ba' -e 's/,\([^,]*\)$/\1/' .claude/settings.json 2>/dev/null || sed -i -e ':a' -e 'N' -e '$!ba' -e 's/,\([^,]*\)$/\1/' .claude/settings.json

            cat >> .claude/settings.json << 'EOF'
    ],
EOF
        fi

        # PostToolUse hooks
        if $ENABLE_AUTOFORMAT || $ENABLE_LOGGING; then
            cat >> .claude/settings.json << 'EOF'
    "PostToolUse": [
EOF
            if $ENABLE_AUTOFORMAT; then
                cat >> .claude/settings.json << 'EOF'
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/auto-format.sh"
          }
        ]
      },
EOF
            fi

            if $ENABLE_LOGGING; then
                cat >> .claude/settings.json << 'EOF'
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/log-implementation.py"
          },
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use-tracker.sh"
          }
        ]
      }
EOF
            fi

            # Remove trailing comma from last item
            sed -i '' -e ':a' -e 'N' -e '$!ba' -e 's/,\([^,]*\)$/\1/' .claude/settings.json 2>/dev/null || sed -i -e ':a' -e 'N' -e '$!ba' -e 's/,\([^,]*\)$/\1/' .claude/settings.json

            cat >> .claude/settings.json << 'EOF'
    ],
EOF
        fi

        # SessionEnd hook
        if $ENABLE_LOGGING; then
            cat >> .claude/settings.json << 'EOF'
    "SessionEnd": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-summary.sh"
          }
        ]
      }
    ]
EOF
        fi

        cat >> .claude/settings.json << 'EOF'
  },
EOF
    fi

    # Add sandbox configuration
    if $ENABLE_SANDBOX; then
        cat >> .claude/settings.json << 'EOF'
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker", "git"],
    "network": {
      "allowLocalBinding": true
    }
  },
EOF
    fi

    # Add UI configuration
    cat >> .claude/settings.json << 'EOF'
  "spinnerTipsEnabled": true,
  "gitBylineEnabled": true
}
EOF

    print_success "Created .claude/settings.json"
fi

# Create .mcp.json
print_status "Creating .mcp.json..."

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

print_success "Created .mcp.json"

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

cat > README.md << EOF
# 🚀 ${PROJECT_NAME}

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

${PROJECT_DESC}

### ✨ Key Features

EOF

# Add enabled features
[ "$ENABLE_SECURITY" = true ] && echo "- 🔒 **Security**: Automatic protection of sensitive files" >> README.md
[ "$ENABLE_TELEMETRY" = true ] && echo "- 📊 **Token Tracking**: Built-in usage monitoring" >> README.md
[ "$ENABLE_AUTOFORMAT" = true ] && echo "- 🎨 **Auto-Formatting**: Automatic code formatting on save" >> README.md
[ "$ENABLE_LOGGING" = true ] && echo "- 📝 **Activity Logging**: Complete audit trail" >> README.md
echo "- 🤖 **AI Agents**: Specialized agents for different tasks" >> README.md
[ "$INSTALL_QUALITY_CMDS" = true ] && echo "- ✅ **Quality Commands**: Built-in quality checkpoints" >> README.md

cat >> README.md << EOF

## 🚀 Quick Start

### Prerequisites

- [Claude Code](https://docs.claude.com/claude-code) installed
EOF

# Add tech-stack specific prerequisites
case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "- Node.js and ${PKG_MANAGER}" >> README.md
        ;;
    "Python")
        echo "- Python 3.x and pip" >> README.md
        ;;
    "Go")
        echo "- Go 1.x" >> README.md
        ;;
esac

echo "- Git configured" >> README.md

cat >> README.md << EOF

### Installation

\`\`\`bash
# Clone the repository
git clone <your-repo-url>
cd ${PROJECT_NAME}

# Install dependencies
EOF

# Add tech-stack specific installation
case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "${PKG_MANAGER} install" >> README.md
        ;;
    "Python")
        echo "pip install -r requirements.txt" >> README.md
        ;;
    "Go")
        echo "go mod download" >> README.md
        ;;
esac

[ "$ENABLE_TELEMETRY" = true ] && cat >> README.md << 'EOF'

# Optional: Install token tracking
npm install -g ccusage
EOF

cat >> README.md << 'EOF'

# Start using Claude Code
claude code
```

### First Steps

1. 📖 Read [CLAUDE.md](CLAUDE.md) for project-specific guidelines
2. 🤖 Review [AGENTS.md](AGENTS.md) to understand available AI agents
3. 📚 Check [docs/onboarding/](docs/onboarding/) for detailed setup guides
EOF

# Add tech-stack specific test command
case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "4. ✅ Run tests to verify setup: \`${PKG_MANAGER} test\`" >> README.md
        ;;
    "Python")
        echo "4. ✅ Run tests to verify setup: \`pytest\`" >> README.md
        ;;
    "Go")
        echo "4. ✅ Run tests to verify setup: \`go test ./...\`" >> README.md
        ;;
esac

cat >> README.md << EOF

## 📁 Project Structure

\`\`\`
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
├── ${SRC_DIR}/                 # 💻 Source code
EOF

[ "$CREATE_TESTS" = true ] && [ -n "$TEST_DIR" ] && echo "├── ${TEST_DIR}/               # 🧪 Test files" >> README.md

cat >> README.md << 'EOF'
│
├── AGENTS.md            # 🤖 AI agent catalog
├── CLAUDE.md            # 📋 Project memory for Claude
└── README.md            # 📖 This file
```

## 💻 Development

### Running the Project

```bash
EOF

# Add tech-stack specific commands
case $TECH_STACK in
    "TypeScript/JavaScript")
        cat >> README.md << EOF
# Development mode
${PKG_MANAGER} run dev

# Build
${PKG_MANAGER} run build

# Run tests
${PKG_MANAGER} test

# Linting
${PKG_MANAGER} run lint

# Format code
${PKG_MANAGER} run format
EOF
        ;;
    "Python")
        cat >> README.md << 'EOF'
# Development mode
python main.py

# Run tests
pytest

# Linting
pylint src/

# Format code
black . && isort .
EOF
        ;;
    "Go")
        cat >> README.md << 'EOF'
# Development mode
go run main.go

# Build
go build

# Run tests
go test ./...

# Format code
gofmt -w . && goimports -w .
EOF
        ;;
esac

cat >> README.md << 'EOF'
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
EOF

# Add commands section if quality commands are installed
if $INSTALL_QUALITY_CMDS || $INSTALL_TDD || $INSTALL_PLANNING; then
cat >> README.md << 'EOF'

### Slash Commands

Run these commands in Claude Code with `/command-name`:

| Command | Description | Usage |
|---------|-------------|-------|
EOF

    $INSTALL_QUALITY_CMDS && cat >> README.md << 'EOF'
| `/qplan` | 📋 Analyze plan consistency | Plan validation before coding |
| `/qcode` | ✅ Implement with quality checks | Quality-focused implementation |
| `/qcheck` | 🔍 Skeptical code review | Comprehensive code review |
EOF

    $INSTALL_TDD && cat >> README.md << 'EOF'
| `/tdd` | 🧪 Test-driven development | TDD workflow automation |
EOF

    $INSTALL_PLANNING && cat >> README.md << 'EOF'
| `/create-prd` | 📄 Create PRD | Generate product requirements |
| `/plan-feature` | 🗺️ Plan feature | Complete feature planning |
| `/usage` | 📊 Token usage report | View Claude Code usage stats |
EOF

cat >> README.md << 'EOF'

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
EOF
fi

cat >> README.md << 'EOF'

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
EOF

if $ENABLE_SECURITY; then
cat >> README.md << 'EOF'

### Security Features

This project includes automatic security protections:

- 🚫 **Sensitive File Protection**: `.env`, `.key`, `.pem` files blocked
- 📝 **Command Logging**: All bash commands logged
- 🔐 **Sandboxed Execution**: Safe command isolation
- ⛔ **Restricted Commands**: `curl`, `wget`, `sudo` blocked
EOF
fi

if $ENABLE_LOGGING; then
cat >> README.md << 'EOF'

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
EOF
fi

if $ENABLE_TELEMETRY; then
cat >> README.md << 'EOF'

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
EOF
fi

cat >> README.md << 'EOF'

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
EOF

# Add tech-stack specific test command
case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "3. ✅ Ensure all tests pass: \`${PKG_MANAGER} test\`" >> README.md
        ;;
    "Python")
        echo "3. ✅ Ensure all tests pass: \`pytest\`" >> README.md
        ;;
    "Go")
        echo "3. ✅ Ensure all tests pass: \`go test ./...\`" >> README.md
        ;;
esac

[ "$ENABLE_AUTOFORMAT" = true ] && echo "4. 🎨 Code is auto-formatted on save" >> README.md

cat >> README.md << EOF

### Contribution Workflow

\`\`\`bash
# 1. Create feature branch
git checkout -b ${BRANCH_PREFIX_FEATURE}/my-feature

# 2. Use quality commands
/qplan          # Validate approach
/qcode          # Implement
/qcheck         # Review

# 3. Ensure tests pass
EOF

# Add tech-stack specific test command
case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "${PKG_MANAGER} test" >> README.md
        ;;
    "Python")
        echo "pytest" >> README.md
        ;;
    "Go")
        echo "go test ./..." >> README.md
        ;;
esac

cat >> README.md << EOF

# 4. Commit with clear message
git commit -m "feat: add user authentication"

# 5. Push and create PR
git push origin ${BRANCH_PREFIX_FEATURE}/my-feature
\`\`\`

### Commit Message Convention

\`\`\`
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Format code
refactor: Refactor code
test: Add tests
chore: Maintenance tasks
\`\`\`

## 🛠️ Customization

### Disabling Features

Edit \`.claude/settings.json\` to customize:

\`\`\`json
{
  "hooks": {
    "PostToolUse": [
      // Comment out hooks you don't want
    ]
  }
}
\`\`\`

### Personal Overrides

Create \`.claude/settings.local.json\` (gitignored):

\`\`\`json
{
  "hooks": {
    "PostToolUse": []
  }
}
\`\`\`

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

# Final summary
echo ""
print_header "Setup Complete!"
echo ""
print_success "Claude Code structure has been set up successfully!"
echo ""

echo -e "${GREEN}Directory Structure:${NC}"
[ "$CREATE_CLAUDE" = true ] && echo "  ✓ .claude/ (skills, hooks, agents, commands, plugins, logs)"
[ "$CREATE_DEV" = true ] && echo "  ✓ dev/ (active, plans, scratch)"
[ "$CREATE_DOCS" = true ] && echo "  ✓ docs/ (architecture, onboarding, decisions)"
[ "$CREATE_TESTS" = true ] && [ -n "$TEST_DIR" ] && echo "  ✓ $TEST_DIR/"
echo ""

echo -e "${GREEN}Features Enabled:${NC}"
[ "$ENABLE_SECURITY" = true ] && echo "  ✓ Security hooks (sensitive file protection)"
[ "$ENABLE_AUTOFORMAT" = true ] && echo "  ✓ Auto-formatting hooks"
[ "$ENABLE_TELEMETRY" = true ] && echo "  ✓ Telemetry (token usage tracking)"
[ "$ENABLE_LOGGING" = true ] && echo "  ✓ Implementation logging"
[ "$ENABLE_SANDBOX" = true ] && echo "  ✓ Sandboxing"
echo ""

if $INSTALL_QUALITY_CMDS || $INSTALL_TDD || $INSTALL_PLANNING; then
    echo -e "${GREEN}Commands Installed:${NC}"
    [ "$INSTALL_QUALITY_CMDS" = true ] && echo "  ✓ /qplan, /qcode, /qcheck"
    [ "$INSTALL_TDD" = true ] && echo "  ✓ /tdd"
    [ "$INSTALL_PLANNING" = true ] && echo "  ✓ /create-prd, /plan-feature, /usage"
    echo ""
fi

echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Customize README.md with your project details"
echo "  2. Review and customize CLAUDE.md for your project"
echo "  3. Review AGENTS.md to understand available agents"
echo "  4. Read docs/onboarding/ for setup guides"

STEP_NUM=5
if $ENABLE_TELEMETRY; then
    echo "  ${STEP_NUM}. Install token tracking: npm install -g ccusage"
    STEP_NUM=$((STEP_NUM + 1))
fi

if $ENABLE_SECURITY; then
    echo "  ${STEP_NUM}. Test security hooks by trying to read a .env file"
    STEP_NUM=$((STEP_NUM + 1))
fi

echo "  ${STEP_NUM}. Start using Claude Code: claude code"
echo ""

if $ENABLE_TELEMETRY; then
    echo -e "${BLUE}Monitor Token Usage:${NC}"
    echo "  npx ccusage@latest daily   - Daily usage summary"
    echo "  npx ccusage@latest blocks  - Current 5-hour block"
    echo ""
fi

echo -e "${YELLOW}Configuration Summary saved to:${NC}"
echo "  - README.md (project documentation with emojis)"
echo "  - CLAUDE.md (project context)"
echo "  - AGENTS.md (agent catalog and usage guide)"
echo "  - .claude/settings.json (Claude Code settings)"
echo "  - .claudeignore (files to exclude)"
echo "  - .gitignore (updated with Claude entries)"
echo ""

print_success "Happy coding with Claude! 🎉"
