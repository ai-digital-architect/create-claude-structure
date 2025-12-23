#!/bin/bash

# Interactive Setup GitHub Copilot Development Structure
# This script creates an optimal directory structure for GitHub Copilot development
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
print_header "GitHub Copilot Interactive Setup"
echo ""
echo "This script will set up an optimal GitHub Copilot development structure"
echo "with customizations specific to your project."
echo ""

# Collect project information
print_header "Project Information"
echo ""

prompt_with_default "Project name" "$(basename "$PROJECT_ROOT")" PROJECT_NAME

# Tech stack selection
echo ""
echo "Select your primary tech stack:"
echo "  1) TypeScript/JavaScript (Node.js, React, etc.)"
echo "  2) Python"
echo "  3) Go"
echo "  4) Java/Kotlin"
echo "  5) Rust"
echo "  6) Multiple/Other"
echo -ne "${CYAN}Enter number${NC} ${YELLOW}[1]${NC}: "
read tech_choice

case $tech_choice in
    2) TECH_STACK="Python"
       FORMATTERS="Black, isort"
       LINTERS="pylint, mypy"
       ;;
    3) TECH_STACK="Go"
       FORMATTERS="gofmt, goimports"
       LINTERS="golangci-lint"
       ;;
    4) TECH_STACK="Java/Kotlin"
       FORMATTERS="google-java-format"
       LINTERS="checkstyle"
       ;;
    5) TECH_STACK="Rust"
       FORMATTERS="rustfmt"
       LINTERS="clippy"
       ;;
    6) prompt_with_default "Specify your tech stack" "Multiple" TECH_STACK
       prompt_with_default "Formatters used" "Various" FORMATTERS
       prompt_with_default "Linters used" "Various" LINTERS
       ;;
    *) TECH_STACK="TypeScript/JavaScript"
       FORMATTERS="Prettier, ESLint"
       LINTERS="ESLint, TypeScript"
       ;;
esac

# Project description
echo ""
prompt_with_default "Brief project description" "AI-assisted development project" PROJECT_DESC

# Package manager
if [ "$TECH_STACK" = "TypeScript/JavaScript" ]; then
    echo ""
    echo "Select your package manager:"
    echo "  1) npm"
    echo "  2) yarn"
    echo "  3) pnpm"
    echo -ne "${CYAN}Enter number${NC} ${YELLOW}[1]${NC}: "
    read pkg_choice

    case $pkg_choice in
        2) PKG_MANAGER="yarn";;
        3) PKG_MANAGER="pnpm";;
        *) PKG_MANAGER="npm";;
    esac
elif [ "$TECH_STACK" = "Python" ]; then
    PKG_MANAGER="pip"
elif [ "$TECH_STACK" = "Go" ]; then
    PKG_MANAGER="go"
else
    prompt_with_default "Package manager" "npm" PKG_MANAGER
fi

# Directory structure customization
echo ""
print_header "Directory Structure Customization"
echo ""

prompt_yes_no "Create .github directory structure (Copilot)?" "Y" && CREATE_GITHUB=true || CREATE_GITHUB=false
prompt_yes_no "Create dev workspace (active/plans/scratch)?" "Y" && CREATE_DEV=true || CREATE_DEV=false
prompt_yes_no "Create docs structure?" "Y" && CREATE_DOCS=true || CREATE_DOCS=false
prompt_yes_no "Create test directory?" "Y" && CREATE_TESTS=true || CREATE_TESTS=false

# Source code directory
echo ""
prompt_with_default "Source code directory name" "src" SRC_DIR

if $CREATE_TESTS; then
    prompt_with_default "Test directory name" "tests" TEST_DIR
fi

# Copilot features
echo ""
print_header "GitHub Copilot Features"
echo ""

prompt_yes_no "Create project instructions (.github/copilot-instructions.md)?" "Y" && CREATE_INSTRUCTIONS=true || CREATE_INSTRUCTIONS=false
prompt_yes_no "Create context-specific instructions (backend, frontend, security)?" "Y" && CREATE_CONTEXT_INSTRUCTIONS=true || CREATE_CONTEXT_INSTRUCTIONS=false
prompt_yes_no "Create reusable prompts (code review, tests, refactor)?" "Y" && CREATE_PROMPTS=true || CREATE_PROMPTS=false
prompt_yes_no "Create agents (architect, security, devops, reviewer)?" "Y" && CREATE_AGENTS=true || CREATE_AGENTS=false
prompt_yes_no "Create skills framework?" "Y" && CREATE_SKILLS=true || CREATE_SKILLS=false

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
echo "    - GitHub structure:          $CREATE_GITHUB"
echo "    - Dev workspace:             $CREATE_DEV"
echo "    - Docs structure:            $CREATE_DOCS"
echo "    - Project instructions:      $CREATE_INSTRUCTIONS"
echo "    - Context instructions:      $CREATE_CONTEXT_INSTRUCTIONS"
echo "    - Reusable prompts:          $CREATE_PROMPTS"
echo "    - Agents:                    $CREATE_AGENTS"
echo "    - Skills:                    $CREATE_SKILLS"
echo ""

if ! prompt_yes_no "Proceed with setup?" "Y"; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
print_status "Setting up GitHub Copilot structure in: $PROJECT_ROOT"
echo ""

# Create .github directory structure
if $CREATE_GITHUB; then
    print_status "Creating .github directory structure..."

    mkdir -p .github/instructions
    mkdir -p .github/prompts
    mkdir -p .github/agents
    mkdir -p .github/skills
    mkdir -p .github/workflows

    # Copy CI/CD workflow examples if available
    WORKFLOW_SOURCE="./copilot-reference/workflows/examples"
    if [ -d "$WORKFLOW_SOURCE" ]; then
        print_status "Copying CI/CD workflow examples..."
        cp "$WORKFLOW_SOURCE"/*.yml .github/workflows/ 2>/dev/null || true
        if [ -f .github/workflows/python-ci-cd.yml ] || [ -f .github/workflows/react-typescript-vite-ci-cd.yml ]; then
            print_success "Copied CI/CD workflow examples to .github/workflows/"
        fi
    fi

    # Create README files
    cat > .github/instructions/README.md << 'EOF'
# Instructions Directory

## What are Instructions?
Instructions provide context-specific coding guidelines that automatically apply based on file patterns.

## Creating Custom Instructions
1. Create a new file: `.github/instructions/name.instructions.md`
2. Add YAML frontmatter with `applyTo` patterns
3. Write your guidelines in Markdown
4. Save and GitHub Copilot will apply them automatically
EOF

    cat > .github/prompts/README.md << 'EOF'
# Prompts Directory

## What are Prompts?
Prompts are reusable task-specific instructions that can be invoked in GitHub Copilot Chat.

## Creating Custom Prompts
1. Create a markdown file: `.github/prompts/prompt-name.prompt.md`
2. Add prompt instructions
3. Use `$ARGUMENTS` placeholder for user input
4. Reference the prompt in Copilot Chat with `@workspace /prompt-name`
EOF

    cat > .github/agents/README.md << 'EOF'
# Agents Directory

## What are Agents?
Agents are specialized AI personas with specific roles, expertise, and tool access configured for Claude Code and GitHub Copilot.

## Creating Custom Agents
Each agent should be defined in a markdown file with YAML frontmatter for configuration.
EOF

    cat > .github/skills/README.md << 'EOF'
# Skills Directory

## What are Skills?
Skills are reusable, composable capabilities that can be invoked by AI assistants to perform specific tasks.

## Creating Custom Skills
Create markdown files with `.skill.md` extension defining the skill's purpose, inputs, and execution steps.
EOF

    print_success "Created .github directory structure"
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

## Open Questions
- [Any questions or decisions needed]
EOF

    cat > dev/plans/tasks.md << 'EOF'
# Task List

## Current Sprint
- [ ] Task 1
- [ ] Task 2

## Backlog
- [ ] Future task 1

## Completed
- [x] Completed task 1
EOF

    cat > dev/scratch/SCRATCHPAD.md << 'EOF'
# Scratchpad

Planning space for working through ideas before implementation.
EOF

    print_success "Created dev workspace"
fi

# Create docs structure
if $CREATE_DOCS; then
    print_status "Creating docs structure..."

    mkdir -p docs/architecture
    mkdir -p docs/onboarding
    mkdir -p docs/decisions
    mkdir -p docs/ai-instructions

    cat > docs/decisions/ADR-template.md << 'EOF'
# ADR-[NUMBER]: [TITLE]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
[Describe the issue or decision that needs to be made]

## Decision
[Describe the decision that was made]

## Consequences
[Describe the resulting context]

## Date
[Date of decision]
EOF

    cat > docs/ai-instructions/coding-standards.md << 'EOF'
# Coding Standards

Shared coding standards for both GitHub Copilot and Claude Code.

## General Principles
- Write clean, readable code
- Follow SOLID principles
- Keep functions small and focused
- Use meaningful names
EOF

    print_success "Created docs structure"
fi

# Create test directory
if $CREATE_TESTS && [ -n "$TEST_DIR" ]; then
    print_status "Creating test directory..."
    mkdir -p "$TEST_DIR"
    print_success "Created test directory: $TEST_DIR"
fi

# Create project instructions
if $CREATE_INSTRUCTIONS; then
    print_status "Creating GitHub Copilot instructions..."

    cat > .github/copilot-instructions.md << EOF
# GitHub Copilot Project Instructions

## Project Overview
- **Name**: ${PROJECT_NAME}
- **Tech Stack**: ${TECH_STACK}
- **Description**: ${PROJECT_DESC}
- **Package Manager**: ${PKG_MANAGER}

## Architecture
- \`${SRC_DIR}/\` - Source code
EOF

    [ -n "$TEST_DIR" ] && echo "- \`${TEST_DIR}/\` - Test files" >> .github/copilot-instructions.md

    cat >> .github/copilot-instructions.md << 'EOF'

## Code Standards
- Follow consistent naming conventions
- Write clear, maintainable code
- Document complex logic
- Use TypeScript for type safety

## Testing Requirements
- Write tests for new functionality
- Maintain test coverage
- Test edge cases and error conditions

## Workflow Rules
- Always run tests before committing
- Follow code review checklist
- Write tests for new features

## Git Workflow
EOF

    cat >> .github/copilot-instructions.md << EOF
- Branch naming: \`${BRANCH_PREFIX_FEATURE}/description\`, \`${BRANCH_PREFIX_FIX}/description\`
- Commit messages: Clear, descriptive, present tense

## Security
- Never commit \`.env\` files
- Use environment variables for secrets
- Validate all user input

## Available Prompts
Reference these prompts in chat with \`@workspace /prompt-name\`:
- \`/review-code\` - Comprehensive code review
- \`/generate-tests\` - Generate unit tests
- \`/security-audit\` - Security vulnerability scan
- \`/plan-feature\` - Plan feature implementation

## CI/CD Workflows

This project includes GitHub Actions workflows for automated testing and deployment:

### Python CI/CD (\`.github/workflows/python-ci-cd.yml\`)
- **Linting & Formatting**: black, flake8, mypy
- **Testing**: pytest across Python 3.8, 3.9, 3.10, 3.11
- **Security**: bandit (SAST), safety (dependency scanning)
- **Deployment**: Automated PyPI publishing
- **Documentation**: Sphinx docs to GitHub Pages

**Required Secrets**:
- \`PYPI_API_TOKEN\` - PyPI publishing token

### React/TypeScript CI/CD (\`.github/workflows/react-typescript-vite-ci-cd.yml\`)
- **Code Quality**: ESLint, Prettier
- **Testing**: Unit tests, Component tests, E2E tests (Playwright)
- **Build**: Vite build with optimization
- **Preview**: Netlify deploy previews for PRs
- **Production**: Firebase Hosting deployment
- **Security**: Snyk vulnerability scanning, GitHub CodeQL

**Required Secrets**:
- \`NETLIFY_AUTH_TOKEN\` - Netlify authentication
- \`NETLIFY_SITE_ID\` - Netlify site identifier
- \`FIREBASE_SERVICE_ACCOUNT\` - Firebase service account JSON
- \`SNYK_TOKEN\` - Snyk API token

### Spring Boot CI/CD (\`.github/workflows/spring-ci-cd-workflow.yml\`)
- **Build**: Maven build with caching
- **Testing**: JUnit tests with JaCoCo coverage
- **Quality**: SonarCloud analysis
- **Security**: OWASP dependency check
- **Container**: Docker image build and push to GHCR
- **Deployment**: Multi-environment (dev → staging → prod)

**Required Secrets**:
- \`SONAR_TOKEN\` - SonarCloud authentication
- \`DOCKER_USERNAME\` - Docker registry username
- \`DOCKER_PASSWORD\` - Docker registry password
- \`KUBE_CONFIG_DEV\` - Kubernetes config (dev)
- \`KUBE_CONFIG_STAGING\` - Kubernetes config (staging)
- \`KUBE_CONFIG_PROD\` - Kubernetes config (production)

### Terraform CI/CD (\`.github/workflows/terraform-ci-cd.yml\`)
- **Validation**: Format check, validate, TFLint
- **Security**: tfsec, checkov scanning
- **Cost**: Infracost cost estimation
- **Planning**: Per-environment plan with artifacts
- **Apply**: Requires manual approval
- **Drift**: Scheduled drift detection

**Required Secrets**:
- \`AWS_ACCESS_KEY_ID\` - AWS authentication
- \`AWS_SECRET_ACCESS_KEY\` - AWS secret key
- \`INFRACOST_API_KEY\` - Infracost API key
- \`TF_VAR_*\` - Terraform variables per environment

### Configuring Workflows

1. Navigate to repository Settings → Secrets and variables → Actions
2. Add required secrets for each workflow
3. Review and customize workflow triggers in YAML files
4. Enable GitHub Actions in repository settings
5. Monitor workflow runs in the Actions tab

EOF

    print_success "Created .github/copilot-instructions.md"
fi

# Create context-specific instructions
if $CREATE_CONTEXT_INSTRUCTIONS; then
    print_status "Creating context-specific instructions..."

    # Backend instructions
    cat > .github/instructions/backend.instructions.md << 'EOF'
---
applyTo:
  - "**/*.controller.ts"
  - "**/*.service.ts"
---

# Backend Development Guidelines

## Controller Standards
- Keep controllers thin
- Delegate business logic to services
- Use DTOs for validation
- Return appropriate HTTP status codes

## Service Layer
- Encapsulate business logic in services
- Use repository pattern for data access
- Implement proper error handling
EOF

    # Frontend instructions
    cat > .github/instructions/frontend.instructions.md << 'EOF'
---
applyTo:
  - "src/components/**/*.tsx"
  - "**/*.component.tsx"
---

# Frontend Development Guidelines

## Component Standards
- Use functional components with hooks
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use TypeScript for type safety

## State Management
- Use React hooks for local state
- Consider Context API for shared state
- Implement proper loading and error states
EOF

    # Security instructions
    cat > .github/instructions/security.instructions.md << 'EOF'
---
applyTo:
  - "**/*.ts"
  - "**/*.tsx"
---

# Security Best Practices

## Authentication & Authorization
- Never store passwords in plain text
- Use bcrypt/argon2 for password hashing
- Implement proper session management

## Input Validation
- Validate all user inputs
- Sanitize inputs to prevent XSS
- Use parameterized queries to prevent SQL injection
EOF

    # Testing instructions
    cat > .github/instructions/testing.instructions.md << 'EOF'
---
applyTo:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---

# Testing Guidelines

## Test Structure
- Use Arrange-Act-Assert pattern
- Clear, descriptive test names
- One assertion per test (when possible)

## Test Coverage
- Aim for >80% coverage
- Test happy paths and error cases
- Test edge cases and boundary conditions
EOF

    print_success "Created context-specific instructions"
fi

# Create reusable prompts
if $CREATE_PROMPTS; then
    print_status "Creating reusable prompts..."

    cat > .github/prompts/review-code.prompt.md << 'EOF'
# Code Review

Review the current changes for:

## 1. Code Quality
- Follows project coding standards
- Proper naming conventions
- Code is readable and maintainable

## 2. Security
- No security vulnerabilities
- Proper input validation
- No hardcoded secrets

## 3. Performance
- Efficient algorithms
- Proper resource management

## 4. Testing
- Adequate test coverage
- Edge cases covered

Arguments: $ARGUMENTS
EOF

    cat > .github/prompts/generate-tests.prompt.md << 'EOF'
# Generate Tests

Generate comprehensive unit tests for: $ARGUMENTS

## Requirements
1. Test happy path scenarios
2. Test edge cases
3. Test error conditions
4. Mock external dependencies
5. Ensure tests are isolated

## Test Structure
- Clear test descriptions
- Arrange-Act-Assert pattern
- Meaningful assertions
EOF

    cat > .github/prompts/security-audit.prompt.md << 'EOF'
# Security Audit

Perform a security audit on: $ARGUMENTS

## Security Checklist

### Authentication & Authorization
- Proper authentication mechanisms
- Authorization checks in place
- Secure session management

### Input Validation
- All inputs validated
- Protection against injection attacks
- Proper sanitization

### Data Protection
- Sensitive data encrypted
- Secure data transmission (HTTPS)
- No secrets in code

Provide specific findings with severity levels.
EOF

    cat > .github/prompts/plan-feature.prompt.md << 'EOF'
# Plan Feature Implementation

Plan the implementation of: $ARGUMENTS

## Planning Process

### 1. Research Phase
- Analyze existing codebase
- Understand current architecture
- Identify relevant patterns

### 2. Design Phase
- Define feature requirements
- Design data models
- Plan API contracts

### 3. Implementation Strategy
- List files to create/modify
- Break down into subtasks
- Identify dependencies

### 4. Testing Strategy
- Unit test requirements
- Integration test needs

Present a detailed plan before implementation.
EOF

    cat > .github/prompts/refactor-component.prompt.md << 'EOF'
# Refactor Component

Refactor the specified component: $ARGUMENTS

## Refactoring Goals
1. Improve Readability
2. Enhance Maintainability
3. Optimize Performance
4. Preserve Functionality

## Process
1. Analyze current implementation
2. Identify improvement opportunities
3. Propose refactoring plan
4. Implement changes incrementally
5. Verify tests pass
EOF

    print_success "Created reusable prompts"
fi

# Create agents
if $CREATE_AGENTS; then
    print_status "Creating agents..."

    cat > .github/agents/architect.agent.md << 'EOF'
---
description: System architecture and design specialist
tools:
  - read
  - search
---

# Software Architect Mode

You are an experienced software architect specializing in:
- System design and architecture
- Scalability and performance
- Design patterns and best practices

## Focus Areas
- SOLID principles
- Clean Architecture
- Domain-Driven Design
- API design
- Database optimization
EOF

    cat > .github/agents/security-analyst.agent.md << 'EOF'
---
description: Security-focused code analysis
tools:
  - read
  - search
---

# Security Analyst Mode

You are a cybersecurity expert focused on:
- Identifying security vulnerabilities
- OWASP Top 10 compliance
- Secure coding practices

## Security Checklist
- Authentication and authorization
- Input validation
- SQL injection prevention
- XSS prevention
- Secure data handling
EOF

    cat > .github/agents/devops-engineer.agent.md << 'EOF'
---
description: DevOps and infrastructure specialist
tools:
  - read
  - edit
---

# DevOps Engineer Mode

You are a DevOps engineer specializing in:
- CI/CD pipelines
- Infrastructure as Code
- Container orchestration
- Cloud platforms

## Expertise Areas
- Docker and Kubernetes
- Terraform
- GitHub Actions
- Monitoring and observability
EOF

    cat > .github/agents/code-reviewer.agent.md << 'EOF'
---
description: Code review and quality assurance
tools:
  - read
  - search
---

# Code Reviewer Mode

You are a senior code reviewer focused on:
- Code quality and maintainability
- Best practices
- Bug detection
- Performance optimization

## Review Criteria
1. Code Quality
2. Functionality
3. Performance
4. Security
5. Testing
6. Documentation
EOF

    print_success "Created agents"
fi

# Create skills
if $CREATE_SKILLS; then
    print_status "Creating skills framework..."

    cat > .github/skills/example-skill.skill.md << 'EOF'
---
name: example-skill
description: Example skill demonstrating the skill structure
inputs:
  - name: target
    type: string
    description: Target for the skill to operate on
outputs:
  - name: result
    type: string
    description: Result of the skill execution
---

# Example Skill

## Purpose
Demonstrates how to structure a reusable skill for AI assistants.

## Execution Steps
1. Validate input parameters
2. Perform the operation
3. Return the result

## Usage Example
This skill can be invoked by agents to perform specific tasks in a consistent way.
EOF

    print_success "Created skills framework"
fi

# Update .gitignore
print_status "Updating .gitignore..."

if [ -f .gitignore ]; then
    if ! grep -q ".github/copilot-instructions.local.md" .gitignore; then
        cat >> .gitignore << 'EOF'

# GitHub Copilot - User-specific settings
.github/copilot-instructions.local.md

# Development workspace
dev/scratch/
*.scratchpad.md
EOF
        print_success "Added GitHub Copilot entries to .gitignore"
    else
        print_warning ".gitignore already contains GitHub Copilot entries"
    fi
else
    cat > .gitignore << 'EOF'
# GitHub Copilot - User-specific settings
.github/copilot-instructions.local.md

# Development workspace
dev/scratch/
*.scratchpad.md
EOF
    print_success "Created .gitignore with GitHub Copilot entries"
fi

# Create comprehensive AGENTS.md
print_status "Creating comprehensive AGENTS.md..."

cat > AGENTS.md << 'EOF'
# AGENTS.md - GitHub Copilot Agent & Chat Mode Catalog

## Overview
This document catalogs all available chat modes and AI assistance patterns in GitHub Copilot. Chat modes are specialized AI personas that provide expert assistance in specific domains.

## Built-in Chat Modes

### 1. Software Architect Mode
**Usage**: Switch to architect mode for system design questions

**Description**: Experienced software architect specializing in system design and architecture.

**Expertise Areas**:
- System design and architecture
- Scalability and performance optimization
- Design patterns and best practices
- Technology selection and evaluation
- Microservices architecture
- Database design and optimization

**When to Use**:
- Designing new system architectures
- Evaluating technology choices
- Scaling existing systems
- Refactoring for better architecture
- API design decisions
- Database schema design

**Example Questions**:
```
"In architect mode, design a microservices architecture for our e-commerce platform"
"How should I structure a scalable real-time notification system?"
"What's the best way to implement event-driven architecture for our use case?"
```

**Best Practices**:
- Provide clear requirements and constraints
- Specify scalability needs
- Mention team expertise levels
- Include budget/time constraints
- Ask about trade-offs between approaches

---

### 2. Security Analyst Mode
**Usage**: Switch to security-analyst mode for security reviews

**Description**: Cybersecurity expert focused on identifying vulnerabilities and ensuring secure coding practices.

**Expertise Areas**:
- Security vulnerability detection
- OWASP Top 10 compliance
- Secure coding practices
- Threat modeling
- Security testing methodologies
- Compliance requirements (GDPR, HIPAA, etc.)

**When to Use**:
- Reviewing code for security issues
- Auditing authentication/authorization
- Evaluating third-party dependencies
- Implementing security best practices
- Responding to security incidents
- Compliance verification

**Security Checklist**:
- [ ] Authentication and authorization
- [ ] Input validation and sanitization
- [ ] SQL injection prevention
- [ ] XSS (Cross-Site Scripting) prevention
- [ ] CSRF (Cross-Site Request Forgery) protection
- [ ] Secure session management
- [ ] Encryption of sensitive data
- [ ] Secure dependency management
- [ ] Error handling (no info leakage)
- [ ] Rate limiting and DDoS protection

**Example Questions**:
```
"In security-analyst mode, review this authentication module for vulnerabilities"
"What security issues exist in this API endpoint?"
"How can I protect against SQL injection in this query?"
```

**Finding Severity Levels**:
- **Critical**: Immediate security threat requiring urgent fix
- **High**: Significant vulnerability needing prompt attention
- **Medium**: Security issue that should be addressed
- **Low**: Minor security concern or best practice improvement

---

### 3. DevOps Engineer Mode
**Usage**: Switch to devops-engineer mode for infrastructure and deployment

**Description**: DevOps specialist focused on CI/CD, infrastructure, and deployment automation.

**Expertise Areas**:
- CI/CD pipeline design and implementation
- Infrastructure as Code (Terraform, CloudFormation)
- Container orchestration (Docker, Kubernetes)
- Cloud platforms (AWS, Azure, GCP)
- Monitoring and observability
- Deployment strategies and automation

**When to Use**:
- Setting up CI/CD pipelines
- Configuring infrastructure
- Containerizing applications
- Kubernetes deployment and management
- Setting up monitoring and alerting
- Optimizing deployment processes
- Troubleshooting infrastructure issues

**Best Practices**:
- Automation first - automate repetitive tasks
- Infrastructure as Code - everything in version control
- Observability - implement proper monitoring and logging
- Security - implement least privilege access
- Reliability - focus on uptime and resilience
- Cost optimization - monitor and optimize resource usage

**Example Questions**:
```
"In devops-engineer mode, help me set up a CI/CD pipeline for this Node.js app"
"How should I structure my Kubernetes deployment for high availability?"
"What's the best way to implement blue-green deployment?"
```

**Deployment Checklist**:
- [ ] Automated tests in CI
- [ ] Container images optimized
- [ ] Environment variables configured
- [ ] Secrets properly managed
- [ ] Health checks implemented
- [ ] Monitoring and alerting set up
- [ ] Rollback strategy defined
- [ ] Load balancing configured
- [ ] Backup and disaster recovery plan
- [ ] Documentation updated

---

### 4. Code Reviewer Mode
**Usage**: Switch to code-reviewer mode for thorough code reviews

**Description**: Senior code reviewer focused on quality, maintainability, and best practices.

**Expertise Areas**:
- Code quality and maintainability
- Best practices and conventions
- Performance optimization
- Bug detection and prevention
- Test coverage analysis
- Documentation quality

**Review Criteria**:

#### 1. Code Quality
- Readability and clarity
- Proper naming conventions
- Code organization and structure
- No code duplication (DRY principle)
- Single Responsibility Principle
- Appropriate use of design patterns

#### 2. Functionality
- Logic correctness
- Edge case handling
- Error handling and recovery
- Input validation
- Expected behavior verification

#### 3. Performance
- Algorithm efficiency (time/space complexity)
- Resource management
- Database query optimization
- Caching opportunities
- Memory usage optimization

#### 4. Security
- Input validation and sanitization
- Authorization checks
- No security vulnerabilities
- Secure data handling
- Proper use of cryptography

#### 5. Testing
- Adequate test coverage
- Edge cases tested
- Tests are maintainable
- No flaky tests
- Integration tests where needed

#### 6. Documentation
- Code comments for complex logic
- API documentation
- README updates
- Inline documentation for public APIs

**Example Questions**:
```
"In code-reviewer mode, review this pull request"
"What issues do you see in this implementation?"
"How can I improve the quality of this code?"
```

**Feedback Format**:
- **Critical**: Must be fixed before merge (security, bugs)
- **Major**: Should be addressed (performance, maintainability)
- **Minor**: Nice to have improvements (style, clarity)
- **Nitpick**: Style/preference suggestions
- **Praise**: Recognize good code and practices

---

## Using GitHub Copilot Chat Modes

### Activating Chat Modes

1. **In VS Code**:
   - Open GitHub Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I)
   - Type the mode name at the start of your question
   - Example: "architect mode: design a caching layer"

2. **Mode Persistence**:
   - Once activated, the mode persists for the conversation
   - Switch modes by explicitly mentioning a new mode
   - Reset to default by starting a new chat

### Effective Mode Usage

**Be Specific**:
```
❌ "In architect mode, help with my app"
✅ "In architect mode, design a scalable architecture for a real-time chat app supporting 100k concurrent users"
```

**Provide Context**:
```
❌ "In security-analyst mode, check this code"
✅ "In security-analyst mode, review this authentication function for OWASP Top 10 vulnerabilities. We're handling user login for a healthcare app."
```

**Ask Follow-ups**:
```
"What are the trade-offs of approach A vs B?"
"Can you explain why you recommend X?"
"What security risks should I consider?"
```

---

## Reusable Prompts Integration

Chat modes work seamlessly with reusable prompts:

```
@workspace /review-code (uses code-reviewer mode internally)
@workspace /security-audit (uses security-analyst mode internally)
@workspace /plan-feature (uses architect mode for design)
```

---

## Context-Specific Instructions Integration

Chat modes automatically apply context-specific instructions from `.github/instructions/`:
- Backend instructions apply in architect and code-reviewer modes
- Security instructions always apply in security-analyst mode
- Testing instructions apply in code-reviewer mode

---

## Best Practices for Chat Mode Usage

### 1. Choose the Right Mode
- **Architecture questions** → Architect mode
- **Security concerns** → Security analyst mode
- **Infrastructure/deployment** → DevOps engineer mode
- **Code quality** → Code reviewer mode

### 2. Provide Complete Context
- Current system state
- Constraints (time, budget, team size)
- Requirements and goals
- Technology stack
- Previous attempts or decisions

### 3. Iterate and Refine
- Start with high-level questions
- Drill down into specifics
- Ask for alternatives
- Request explanations
- Verify understanding

### 4. Combine with Other Features
- Use `@workspace` to reference project files
- Reference prompts with `/prompt-name`
- Apply context-specific instructions
- Review generated code carefully

---

## Advanced Usage Patterns

### Multi-Mode Consultation

For complex problems, consult multiple modes:

```
1. "Architect mode: Design the system architecture"
2. "Security-analyst mode: Review this design for security issues"
3. "DevOps-engineer mode: How should I deploy this?"
4. "Code-reviewer mode: Review the implementation"
```

### Mode-Specific Workflows

**Feature Development Workflow**:
```
1. Architect mode → Design feature architecture
2. Code-reviewer mode → Review implementation approach
3. Security-analyst mode → Verify security considerations
4. DevOps-engineer mode → Plan deployment strategy
```

**Bug Fix Workflow**:
```
1. Code-reviewer mode → Analyze the bug
2. Security-analyst mode → Check if it's a security issue
3. Code-reviewer mode → Review the fix
4. DevOps-engineer mode → Plan hotfix deployment
```

---

## Troubleshooting

### Mode Not Responding as Expected
- Be more specific in your question
- Provide more context about your situation
- Rephrase your question
- Start a new chat and try again

### Getting Generic Responses
- Explicitly mention the mode name
- Provide technical details
- Ask specific questions rather than general ones
- Include code snippets or examples

### Mode Seems Wrong for the Task
- Double-check mode selection
- Consider if a different mode is more appropriate
- Try combining insights from multiple modes

---

## Custom Chat Mode Development

While GitHub Copilot has built-in modes, you can simulate custom modes using `.github/chatmodes/`:

### Creating Custom Mode Definitions

1. Create file: `.github/chatmodes/custom-mode.chatmode.md`
2. Define role and expertise
3. Specify tools and approach
4. Document usage examples

**Example Custom Mode**:
```markdown
---
description: Database optimization specialist
tools:
  - read
  - search
---

# Database Optimizer Mode

You are a database optimization expert specializing in:
- Query optimization
- Index strategy
- Performance tuning
- Schema design

## Approach
1. Analyze query patterns
2. Identify bottlenecks
3. Recommend optimizations
4. Verify improvements
```

---

## Integration with GitHub Actions

Chat modes complement CI/CD workflows:
- **Architect mode** - Design workflow structure
- **Security-analyst mode** - Review workflow security
- **DevOps-engineer mode** - Implement and optimize workflows
- **Code-reviewer mode** - Review workflow YAML files

---

## Resources

### Documentation
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Copilot Chat Documentation](https://docs.github.com/en/copilot/github-copilot-chat)

### Learning Resources
- Project instructions: `.github/copilot-instructions.md`
- Context-specific guidelines: `.github/instructions/`
- Reusable prompts: `.github/prompts/`
- Chat mode definitions: `.github/chatmodes/`

---

## Changelog

### Version 1.0 (Initial)
- Documented all built-in chat modes
- Added usage patterns and best practices
- Included troubleshooting guide
- Created integration guidelines

---

**This catalog is maintained as part of the GitHub Copilot enhanced setup.**
**Last Updated**: Auto-generated during setup
**Maintainer**: Project Team

For questions or suggestions, update this file and share with the team.
EOF

print_success "Created comprehensive AGENTS.md"

# Create onboarding documentation
if $CREATE_DOCS; then
    print_status "Creating onboarding documentation..."

    cat > docs/onboarding/COPILOT_SETUP.md << 'EOF'
# Setting Up GitHub Copilot for This Project

## 1. Prerequisites
- GitHub Copilot subscription
- VS Code with GitHub Copilot extension
- Git configured

## 2. Review Project Instructions

```bash
cat .github/copilot-instructions.md
```

## 3. Explore Features

### Instructions
Context-specific guidelines in `.github/instructions/`

### Prompts
Reusable tasks in `.github/prompts/`
- Use with `@workspace /prompt-name`

### Chat Modes
Specialized personas in `.github/chatmodes/`

## 4. Start Working

Ask Copilot: "What is the project structure?"

## 5. Development Workflow

1. Check `dev/active/context.md` for current work
2. Use `@workspace /plan-feature [name]` to plan
3. Implement with Copilot suggestions
4. Use `@workspace /review-code` to review
5. Update context.md with progress
EOF

    cat > docs/onboarding/PROJECT_STRUCTURE.md << EOF
# Project Structure

## Directory Layout

\`\`\`
project-root/
├── .github/              GitHub & Copilot configuration
│   ├── copilot-instructions.md
│   ├── instructions/    Context-specific guidelines
│   ├── prompts/        Reusable task prompts
│   └── chatmodes/      Specialized AI personas
├── dev/                 Development workspace
│   ├── active/         Current work context
│   ├── plans/          Planning documents
│   └── scratch/        Scratchpad files
├── docs/                Project documentation
├── ${SRC_DIR}/                 Source code
EOF

    [ -n "$TEST_DIR" ] && echo "└── ${TEST_DIR}/               Test files" >> docs/onboarding/PROJECT_STRUCTURE.md

    cat >> docs/onboarding/PROJECT_STRUCTURE.md << 'EOF'
```

## Key Files

### .github/copilot-instructions.md
Main project instructions for GitHub Copilot

### dev/active/context.md
Current work context
EOF

    print_success "Created onboarding documentation"
fi

# Create comprehensive README
print_status "Creating comprehensive README..."

cat > README.md << EOF
# 🚀 ${PROJECT_NAME}

> 📝 **Quick Start**: This project is configured with [GitHub Copilot](https://github.com/features/copilot) for AI-assisted development.

## 🎯 Overview

${PROJECT_DESC}

### ✨ Key Features

- 📝 **Project Instructions**: Automatic context loading
- 🎯 **Context-Specific Guidelines**: Auto-applying instructions
- 🤖 **Reusable Prompts**: Task-specific workflows
- 👥 **Specialized Chat Modes**: Expert AI personas

## 🚀 Quick Start

### Prerequisites

- GitHub Copilot subscription
- VS Code with GitHub Copilot extension
EOF

case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "- Node.js and ${PKG_MANAGER}" >> README.md
        ;;
    "Python")
        echo "- Python 3.x" >> README.md
        ;;
    "Go")
        echo "- Go 1.x" >> README.md
        ;;
esac

cat >> README.md << EOF

### Installation

\`\`\`bash
# Clone the repository
git clone <your-repo-url>
cd ${PROJECT_NAME}

# Install dependencies
EOF

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

cat >> README.md << 'EOF'
```

### First Steps

1. 📖 Read [.github/copilot-instructions.md](.github/copilot-instructions.md)
2. 📚 Check [docs/onboarding/](docs/onboarding/)
EOF

case $TECH_STACK in
    "TypeScript/JavaScript")
        echo "3. ✅ Run tests: \`${PKG_MANAGER} test\`" >> README.md
        ;;
    "Python")
        echo "3. ✅ Run tests: \`pytest\`" >> README.md
        ;;
    "Go")
        echo "3. ✅ Run tests: \`go test ./...\`" >> README.md
        ;;
esac

cat >> README.md << 'EOF'

## 📁 Project Structure

```
.github/          - GitHub Copilot configuration
dev/              - Development workspace
docs/             - Documentation
EOF

echo "${SRC_DIR}/              - Source code" >> README.md
[ -n "$TEST_DIR" ] && echo "${TEST_DIR}/             - Test files" >> README.md

cat >> README.md << 'EOF'
```

## 🎯 Available Prompts

Use in Copilot Chat with `@workspace /prompt-name`:

| Prompt | Description |
|--------|-------------|
| `/review-code` | Comprehensive code review |
| `/generate-tests` | Generate unit tests |
| `/security-audit` | Security scan |
| `/plan-feature` | Plan implementation |

## 👥 Chat Modes

- **Architect**: System design
- **Security Analyst**: Vulnerability detection
- **DevOps Engineer**: Infrastructure
- **Code Reviewer**: Quality assurance

## 📚 Documentation

- [Copilot Setup](docs/onboarding/COPILOT_SETUP.md)
- [Project Structure](docs/onboarding/PROJECT_STRUCTURE.md)

## 🤝 Contributing

1. Read `.github/copilot-instructions.md`
2. Create feature branch: `${BRANCH_PREFIX_FEATURE}/my-feature`
3. Use `@workspace /plan-feature` to plan
4. Implement with Copilot
5. Use `@workspace /review-code` before committing

---

**Built with GitHub Copilot** 🤖
EOF

print_success "Created comprehensive README"

# Final summary
echo ""
print_header "Setup Complete!"
echo ""
print_success "GitHub Copilot structure has been set up successfully!"
echo ""

echo -e "${GREEN}Directory Structure:${NC}"
[ "$CREATE_GITHUB" = true ] && echo "  ✓ .github/ (instructions, prompts, chatmodes)"
[ "$CREATE_DEV" = true ] && echo "  ✓ dev/ (active, plans, scratch)"
[ "$CREATE_DOCS" = true ] && echo "  ✓ docs/ (architecture, onboarding, decisions)"
[ "$CREATE_TESTS" = true ] && [ -n "$TEST_DIR" ] && echo "  ✓ $TEST_DIR/"
echo ""

echo -e "${GREEN}Features Created:${NC}"
[ "$CREATE_INSTRUCTIONS" = true ] && echo "  ✓ Project instructions (.github/copilot-instructions.md)"
[ "$CREATE_CONTEXT_INSTRUCTIONS" = true ] && echo "  ✓ Context-specific instructions (backend, frontend, security)"
[ "$CREATE_PROMPTS" = true ] && echo "  ✓ Reusable prompts (review, tests, security, planning)"
[ "$CREATE_AGENTS" = true ] && echo "  ✓ Agents (architect, security, devops, reviewer)"
[ "$CREATE_SKILLS" = true ] && echo "  ✓ Skills framework"
echo ""

echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Review and customize .github/copilot-instructions.md"
echo "  2. Explore context-specific instructions in .github/instructions/"
echo "  3. Try reusable prompts with @workspace /prompt-name"
echo "  4. Read docs/onboarding/ for setup guides"
echo "  5. Start using GitHub Copilot in VS Code"
echo ""

echo -e "${BLUE}Using AI Assistants:${NC}"
echo "  - Instructions auto-apply based on file patterns"
echo "  - Use @workspace /review-code for code reviews"
echo "  - Use @workspace /generate-tests to create tests"
echo "  - Use specialized agents for expert assistance"
echo "  - Leverage skills for automation"
echo ""

echo -e "${YELLOW}Configuration Summary:${NC}"
echo "  - .github/copilot-instructions.md (project context)"
echo "  - .github/instructions/ (context-specific guidelines)"
echo "  - .github/prompts/ (reusable task prompts)"
echo "  - .github/agents/ (specialized AI agent personas)"
echo "  - .github/skills/ (reusable capabilities)"
echo "  - .github/workflows/ (CI/CD pipelines)"
echo "  - .gitignore (updated with Copilot entries)"
echo "  - AGENTS.md (agent & skill catalog)"
echo "  - README.md (comprehensive project guide)"
echo ""

print_success "Happy coding with AI-assisted development! 🎉"
