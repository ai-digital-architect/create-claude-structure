




## 🗺️ Direct Feature Mapping

| GitHub Copilot (.github) | Claude Code (.claude) | Purpose | Key Differences |
|--------------------------|----------------------|---------|-----------------|
| **copilot-instructions.md** | **CLAUDE.md** (root) | Main project context & coding standards | Copilot instructions are in `.github/copilot-instructions.md` and automatically improve chat responses. Claude's CLAUDE.md is at project root and loaded into every session. |
| **instructions/*.instructions.md** | **skills/*/SKILL.md** | Context-specific rules that apply to file patterns | Copilot instructions specify coding practices and can auto-apply to current context. Claude skills auto-activate based on triggers in skill-rules.json. |
| **prompts/*.prompt.md** | **commands/*.md** | Reusable task-specific prompts | Copilot prompt files let you define reusable prompts for common tasks in Markdown files. Claude commands use `/command-name` syntax. |
| **chatmodes/*.chatmode.md** | **agents/*.md** | Specialized AI personas for specific roles | Copilot chat modes consist of instructions and tools applied when you switch to that mode. Claude agents are autonomous subagents with separate context. |
| **workflows/*.yml** | **hooks/** (scripts) | Automation & CI/CD | Copilot uses GitHub Actions. Claude uses shell scripts triggered at lifecycle events. |
| *(No direct equivalent)* | **settings.json** | Configuration & permissions | Claude-specific for tools, hooks, permissions, env vars |

## 📋 Structural Comparison

### GitHub Copilot Structure
Standard Copilot repository structure includes prompts, chatmodes, instructions folders within .github, plus copilot-instructions.md:

```
.github/
├── copilot-instructions.md          # Project-wide guidelines
├── instructions/                     # Contextual instructions
│   ├── backend.instructions.md      # Applies to backend files
│   ├── frontend.instructions.md     # Applies to frontend files
│   └── security.instructions.md     # Security standards
├── prompts/                          # Reusable task prompts
│   ├── code-review.prompt.md
│   ├── generate-tests.prompt.md
│   └── refactor-component.prompt.md
├── chatmodes/                        # AI personas
│   ├── architect.chatmode.md
│   ├── security-analyst.chatmode.md
│   └── devops-engineer.chatmode.md
└── workflows/                        # GitHub Actions
    └── ci.yml
├── docs/
│   ├── ai-instructions/              # Shared documentation
│   │   ├── coding-standards.md      # Reference for both tools
│   │   ├── architecture.md
│   │   └── workflows.md
│   └── README.md
├── README.md   
```



## 🔄  Mapping

### 1. **Main Instructions File**

**GitHub Copilot:**
```markdown
<!-- .github/copilot-instructions.md -->
# Project Guidelines

## Tech Stack
- Next.js 14 with TypeScript
- Tailwind CSS for styling
- Prisma ORM for database

## Coding Standards
- Use functional components
- Prefer TypeScript strict mode
- Follow ESLint configuration
```


### 2. **Context-Specific Instructions**

**GitHub Copilot:**
```markdown
<!-- .github/instructions/backend.instructions.md -->
---
applyTo:
  - "**/*.controller.ts"
  - "**/*.service.ts"
---

# Backend Development Guidelines

## Controller Standards
- Keep controllers thin
- Delegate to services
- Use DTOs for validation
```


```markdown
<!-- .claude/skills/backend-dev-guidelines/SKILL.md -->
---
name: Backend Development Guidelines
description: Standards for controller and service development
---

# Backend Guidelines

## When to Use
Auto-activates when working on controller or service files

## Controller Standards
- Keep controllers thin
- Delegate to services
- Use DTOs for validation
```

### 3. **Task Prompts/Commands**

**GitHub Copilot:**
```markdown
<!-- .github/prompts/code-review.prompt.md -->
# Code Review

Review the current changes for:
1. Security vulnerabilities
2. Performance issues
3. Code quality
4. Test coverage

Arguments: $ARGUMENTS
```

### 4. **Chat Modes/Agents**

**GitHub Copilot:**
```markdown
<!-- .github/chatmodes/security-analyst.chatmode.md -->
---
description: Security-focused code analysis
tools:
  - read
  - search
---

# Security Analyst Mode

You are a security expert focused on:
- Identifying vulnerabilities
- OWASP Top 10 compliance
- Secure coding practices
```





