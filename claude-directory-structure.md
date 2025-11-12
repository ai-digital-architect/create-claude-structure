*
# Task

Generate a shell script in the scripts folder under project root that creates a directory structure for development with claude code and best practices

Here's the **enhanced project structure** :

## Enhanced Complete Project Structure

```
your-project/
├── .claude/
│   ├── skills/
│   │   ├── skill-name/
│   │   │   ├── SKILL.md
│   │   │   ├── scripts/
│   │   │   ├── references/
│   │   │   ├── assets/
│   │   │   └── README.md          # ✨ NEW: Skill documentation
│   │   └── skill-rules.json
│   │
│   ├── hooks/
│   │   ├── *.sh
│   │   ├── *.py
│   │   └── README.md               # ✨ NEW: Hook documentation
│   │
│   ├── agents/
│   │   ├── *.md
│   │   └── README.md               # ✨ NEW: Agent catalog
│   │
│   ├── commands/
│   │   ├── *.md
│   │   └── README.md               # ✨ NEW: Command reference
│   │
│   ├── plugins/                    # ✨ NEW: Plugin definitions
│   │   └── plugin-name/
│   │       ├── plugin.json
│   │       └── README.md
│   │
│   └── settings.json               # Project-specific settings
│
├── dev/                             # ✨ NEW: Development workspace
│   ├── active/                      # Active development docs
│   │   ├── current-feature.md
│   │   └── context.md
│   ├── plans/                       # Planning documents
│   │   ├── prd.md
│   │   └── tasks.md
│   └── scratch/                     # Scratchpads for Claude
│       └── SCRATCHPAD.md
│
├── docs/                            # ✨ NEW: Project documentation
│   ├── architecture/
│   ├── onboarding/
│   └── decisions/                   # Architecture Decision Records
│
├── CLAUDE.md                        # Root project memory
├── .claudeignore                    # ✨ NEW: Files to exclude
├── .mcp.json                        # ✨ NEW: MCP server config
└── .gitignore                       # Include .claude/settings.local.json
```

### 1. **Hierarchical CLAUDE.md Files**

CLAUDE.md files can be hierarchical, with one at project-level and nested ones in subdirectories that get prioritized when relevant.

```
your-project/
├── CLAUDE.md                    # Project-wide context
├── src/
│   └── CLAUDE.md               # Source code conventions
├── tests/
│   └── CLAUDE.md               # Testing-specific guidance
└── docs/
    └── CLAUDE.md               # Documentation standards
```

**Best Practice:** Use CLAUDE.md in subdirectories to provide context specific to that part of the project.

### 2. **Dev Docs Pattern** (Critical for Complex Projects)

A dev/active directory pattern for preserving knowledge across context resets.

```
dev/
├── active/
│   ├── current-feature-context.md    # What Claude is working on
│   ├── architecture-notes.md         # Design decisions
│   └── implementation-log.md         # Progress tracking
├── plans/
│   ├── prd.md                        # Product requirements
│   └── tasks.md                      # Task breakdowns
└── scratch/
    └── SCRATCHPAD.md                 # Claude's planning space
```

**Why:** This solves the context reset problem. When Claude loses context, it can read these files to understand what was happening.

### 3. **User-Level Configuration**

User memory at ~/.claude/CLAUDE.md provides personal preferences that apply to all projects.

```
~/.claude/
├── CLAUDE.md                    # Personal preferences
├── commands/                    # Global slash commands
│   ├── review.md
│   └── debug.md
└── settings.json               # User-wide settings
```

**Configuration Strategy:**

- **User-level** (`~/.claude/`): Personal preferences, global commands
- **Project-level** (`.claude/`): Team-shared, version-controlled
- **Local overrides** (`.claude/settings.local.json`): Git-ignored personal tweaks

### 4. **Quality Checkpoint Commands**

Custom shortcuts like qcheck, qplan, and qcode instruct Claude to review its code changes against best practices checklists.

```markdown
# .claude/commands/qplan.md
Analyze similar parts of the codebase and determine whether your plan:
- Is consistent with rest of codebase
- Introduces minimal changes
- Reuses existing code
```

```markdown
# .claude/commands/qcode.md
Implement your plan and make sure your new tests pass.
Always run tests to make sure you didn't break anything else.
Always run `prettier` on newly created files.
Always run `turbo typecheck lint`.
```

```markdown
# .claude/commands/qcheck.md
You are a SKEPTICAL senior software engineer.
Perform this analysis for every MAJOR code change:
1. Review against CLAUDE.md Writing Functions checklist
2. Review against CLAUDE.md Writing Tests checklist
3. Identify potential bugs or edge cases
```

### 5. **Task-Based Development Commands**

Commands for AI task-based development include /create-prd, /generate-tasks, and /process-task-list.

```markdown
# .claude/commands/create-prd.md
Create a Product Requirements Document based on: $ARGUMENTS

Include:
- Problem statement
- User stories
- Success metrics
- Technical considerations
```

### 6. **MCP Configuration**

MCP servers can be configured via .mcp.json to give Claude capabilities like database queries or external API access.

```json
// .mcp.json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp"
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://..."]
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

### 7. **Context Management Strategy**

**Token Optimization:**
Keep CLAUDE.md concise using short, declarative bullet points instead of long narrative paragraphs to manage token consumption.

```markdown
# CLAUDE.md - DO THIS ✅
## Commands
- `npm run dev` - Start development
- `npm test` - Run tests
- `npm run lint` - Run linter

## Code Style
- Use TypeScript strict mode
- Prefer functional components
- Max 200 lines per component

# DON'T DO THIS ❌
## Commands
The development server can be started by running the npm run dev command,
which will compile your TypeScript files and start watching for changes...
[Don't write long explanatory paragraphs]
```

**Context Commands:**

```markdown
# .claude/commands/compact.md
Summarize the conversation focusing on: $ARGUMENTS
Preserve only essential context for continued work.
```

### 8. **Testing Workflows**

Test-driven development becomes more powerful with Claude by having it write tests first, then implementation.

```markdown
# .claude/commands/tdd.md
1. Write failing tests for: $ARGUMENTS
2. Verify tests fail correctly
3. Implement minimal code to pass tests
4. Refactor while keeping tests green
5. Update documentation
```

### 9. **Version Control Best Practices**

**`.claudeignore`** (similar to .gitignore):

```
# Sensitive data
.env
.env.local
*.key
*.pem

# Large files
node_modules/
dist/
build/
*.log

# Temporary files
.cache/
tmp/
*.tmp
```

**`.gitignore` additions:**

```
# User-specific Claude settings
.claude/settings.local.json

# Claude working directories
dev/scratch/
*.scratchpad.md
```

### 10. **Documentation README Pattern**

Each major directory should have a README explaining its purpose:

```markdown
# .claude/skills/README.md
# Skills Directory

## What are Skills?
Skills provide domain expertise that activates automatically.

## Available Skills
- `backend-dev-guidelines` - API development standards
- `frontend-dev-guidelines` - React/UI best practices
- `skill-developer` - For creating new skills

## Adding New Skills
1. Copy skill template
2. Update SKILL.md
3. Configure skill-rules.json
4. Test activation
```

### 11. **Plugin Structure** (For Distribution)

Plugins package complete configurations across teams or projects for team standardization.

```json
// .claude/plugins/company-standards/plugin.json
{
  "name": "company-standards",
  "version": "1.0.0",
  "description": "Company coding standards and workflows",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "./hooks/format-and-lint.sh"
          }
        ]
      }
    ]
  },
  "commands": [
    {
      "name": "review",
      "file": "./commands/review.md"
    }
  ],
  "skills": [
    {
      "name": "coding-standards",
      "path": "./skills/coding-standards"
    }
  ]
}
```

### 12. **Planning and Review Workflows**

```markdown
# .claude/commands/plan-feature.md
For feature: $ARGUMENTS

1. **Research Phase**
   - Read relevant files
   - Understand current architecture
   - Identify dependencies

2. **Planning Phase**
   - Write plan to dev/plans/feature-plan.md
   - List files to modify
   - Identify potential risks
   
3. **Review Checkpoint**
   - Wait for user approval before coding
   - Address concerns
   
4. **Implementation Phase**
   - Follow TDD approach
   - Implement incrementally
   - Run tests after each change

5. **Verification Phase**
   - Run full test suite
   - Check type safety
   - Verify no regressions
```

### 13. **Onboarding Support**

```markdown
# docs/onboarding/CLAUDE_SETUP.md
# Setting Up Claude for This Project

## 1. Initial Setup
\`\`\`bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Navigate to project
cd your-project

# Initialize Claude
claude /init
\`\`\`

## 2. Review CLAUDE.md
Read `CLAUDE.md` to understand project conventions.

## 3. Install MCP Servers
\`\`\`bash
npm install -g @modelcontextprotocol/server-postgres
\`\`\`

## 4. Test Setup
Ask Claude: "What is the project structure?"
```

## Complete CLAUDE.md Template

Here's an enhanced template:

```markdown
# CLAUDE.md

## Project Overview
- **Name**: Your Project
- **Tech Stack**: Next.js 14, TypeScript 5.3, Tailwind CSS 3.4
- **Database**: PostgreSQL with Prisma ORM
- **Testing**: Jest, React Testing Library

## Architecture
- `src/app` - Next.js app router pages
- `src/components` - Reusable React components
- `src/lib` - Business logic and utilities
- `src/hooks` - Custom React hooks
- `prisma/` - Database schema and migrations

## Key Commands
- `npm run dev` - Start development server (localhost:3000)
- `npm run build` - Production build
- `npm test` - Run test suite
- `npm run lint` - ESLint check
- `npm run type-check` - TypeScript verification
- `npm run db:push` - Push Prisma schema changes

## Code Standards
- Use TypeScript strict mode
- Prefer functional components over class components
- Components max 200 lines
- Use custom hooks for complex state logic
- Add JSDoc for public functions
- No single-letter variables (except loop indices)

## Testing Requirements
- 80% minimum coverage
- Test edge cases and error states
- Use descriptive test names: `it('should handle empty cart gracefully')`

## Workflow Rules
- Always run `npm run type-check` before committing
- Run `npm test` to verify no regressions
- Use `/qplan` before major changes
- Use `/qcode` to implement with quality checks
- Use `/qcheck` after significant code changes

## Git Workflow
- Branch naming: `feature/description`, `fix/description`
- Commit messages: Conventional Commits format
- Always rebase, never merge from main

## Security
- Never commit `.env` files
- Use environment variables for secrets
- Validate all user input
- Use parameterized queries

## When Starting Work
1. Review dev/active/*.md for current context
2. Check dev/plans/*.md for roadmap
3. Ask questions before making assumptions
4. Plan in dev/scratch/SCRATCHPAD.md first

## Custom Commands Available
- `/qplan` - Analyze plan consistency
- `/qcode` - Implement with quality checks
- `/qcheck` - Skeptical code review
- `/create-prd` - Generate PRD from description
- `/generate-tasks` - Break PRD into tasks
```

## Implementation Checklist

When setting up this structure:

- [ ] Create `.claude/` directory structure
- [ ] Add root `CLAUDE.md` with project context
- [ ] Configure hooks for formatting/linting
- [ ] Set up quality checkpoint commands (qplan, qcode, qcheck)
- [ ] Create `dev/active/` for context preservation
- [ ] Add subdirectory-specific `CLAUDE.md` files
- [ ] Configure `.claudeignore` for sensitive files
- [ ] Set up `.mcp.json` for external integrations
- [ ] Add README files to each major directory
- [ ] Configure `.gitignore` for local settings
- [ ] Create onboarding documentation
- [ ] Set up user-level `~/.claude/` preferences
- [ ] Document team workflows

This enhanced structure transforms Claude Code from a basic assistant into a fully integrated team member with persistent memory, quality controls, and automated workflows.
