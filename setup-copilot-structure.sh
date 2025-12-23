#!/bin/bash

# Setup GitHub Copilot Development Structure
# This script creates an optimal directory structure for GitHub Copilot development
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

print_status "Setting up GitHub Copilot structure in: $PROJECT_ROOT"

# Create .github directory structure
print_status "Creating .github directory structure..."

mkdir -p .github/instructions
mkdir -p .github/prompts
mkdir -p .github/agents
mkdir -p .github/skills
mkdir -p .github/workflows

# Copy CI/CD workflow examples if source directory exists
WORKFLOW_SOURCE="./copilot-reference/workflows/examples"
if [ -d "$WORKFLOW_SOURCE" ]; then
    print_status "Copying CI/CD workflow examples..."
    cp "$WORKFLOW_SOURCE"/*.yml .github/workflows/ 2>/dev/null || true
    print_success "Copied workflow examples to .github/workflows/"
else
    print_warning "Workflow examples directory not found at $WORKFLOW_SOURCE"
fi

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
mkdir -p docs/ai-instructions

# Create README files for each major directory
print_status "Creating README files..."

# .github/instructions/README.md
cat > .github/instructions/README.md << 'EOF'
# Instructions Directory

## What are Instructions?
Instructions provide context-specific coding guidelines that automatically apply based on file patterns.

## Available Instructions
Add your custom instruction files here with `.instructions.md` extension.

## Creating Custom Instructions
1. Create a new file: `.github/instructions/name.instructions.md`
2. Add YAML frontmatter with `applyTo` patterns
3. Write your guidelines in Markdown
4. Save and GitHub Copilot will apply them automatically

## Instruction File Structure
```markdown
---
applyTo:
  - "src/backend/**/*.ts"
  - "**/*.controller.ts"
---

# Your Instructions Title

## Guidelines
- Guideline 1
- Guideline 2
```

## Example Instructions
- Backend development standards
- Frontend component guidelines
- API endpoint conventions
- Database schema rules
- Security best practices
EOF

# .github/prompts/README.md
cat > .github/prompts/README.md << 'EOF'
# Prompts Directory

## What are Prompts?
Prompts are reusable task-specific instructions that can be invoked in GitHub Copilot Chat.

## Available Prompts
Custom prompts will be listed here after creation.

## Creating Custom Prompts
1. Create a markdown file: `.github/prompts/prompt-name.prompt.md`
2. Add prompt instructions
3. Use `$ARGUMENTS` placeholder for user input
4. Reference the prompt in Copilot Chat with `@workspace /prompt-name`

## Example Prompts
- Code review checklist
- Generate unit tests
- Refactor component
- API documentation generator
- Security audit
EOF

# .github/agents/README.md
cat > .github/agents/README.md << 'EOF'
# Agents Directory

## What are Agents?
Agents are specialized AI personas with specific roles, expertise, and tool access configured for Claude Code and GitHub Copilot.

## Agent Catalog
Add your custom agent definitions here as markdown files.

## Creating Custom Agents
Each agent should be defined in a markdown file with:
- YAML frontmatter for configuration
- Description of the persona and role
- Specific expertise areas
- Available tools

## Agent Structure
```markdown
---
description: Brief description of the agent
tools:
  - read
  - search
  - edit
---

# Agent Name

You are a [role] specialized in [expertise].

Focus on:
- Expertise area 1
- Expertise area 2
```

## Example Agents
- Architect agent for system design
- Security analyst for vulnerability detection
- DevOps engineer for deployment
- Code reviewer for quality assurance
EOF

# .github/skills/README.md
cat > .github/skills/README.md << 'EOF'
# Skills Directory

## What are Skills?
Skills are reusable, composable capabilities that can be invoked by AI assistants to perform specific tasks.

## Available Skills
Custom skills will be listed here after creation.

## Creating Custom Skills
1. Create a markdown file: `.github/skills/skill-name.skill.md`
2. Define the skill's purpose and inputs
3. Specify the execution steps
4. Document outputs and side effects

## Skill Structure
```markdown
---
name: skill-name
description: Brief description of what this skill does
inputs:
  - name: input1
    type: string
    description: Description of input1
outputs:
  - name: output1
    type: string
    description: Description of output1
---

# Skill Name

## Purpose
What this skill accomplishes

## Execution Steps
1. Step 1
2. Step 2
3. Step 3

## Usage Example
Example of how to invoke this skill
```

## Example Skills
- Code refactoring automation
- Test generation and execution
- Documentation generation
- Deployment automation
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

This is a planning space for working through ideas before implementation.

## Current Planning
[Use this space to plan and think through problems]
EOF

# Create quality checkpoint prompts
print_status "Creating quality checkpoint prompts..."

cat > .github/prompts/review-code.prompt.md << 'EOF'
# Code Review

Review the current changes for:

## 1. Code Quality
- Follows project coding standards
- Proper naming conventions
- Code is readable and maintainable
- No code duplication

## 2. Security
- No security vulnerabilities
- Proper input validation
- Secure handling of sensitive data
- No hardcoded secrets

## 3. Performance
- Efficient algorithms
- No unnecessary computations
- Proper resource management
- Database queries optimized

## 4. Testing
- Adequate test coverage
- Edge cases covered
- Tests are maintainable
- No flaky tests

## 5. Documentation
- Code is well-commented
- API documentation updated
- README updated if needed

Provide specific, actionable feedback with code suggestions.

Arguments: $ARGUMENTS
EOF

cat > .github/prompts/generate-tests.prompt.md << 'EOF'
# Generate Tests

Generate comprehensive unit tests for: $ARGUMENTS

## Requirements
1. Test happy path scenarios
2. Test edge cases
3. Test error conditions
4. Test boundary conditions
5. Mock external dependencies
6. Ensure tests are isolated and independent

## Test Structure
- Clear test descriptions
- Arrange-Act-Assert pattern
- Meaningful assertions
- Easy to understand and maintain

## Coverage Goals
- Aim for high code coverage
- Focus on critical paths
- Include integration tests where needed
EOF

cat > .github/prompts/refactor-component.prompt.md << 'EOF'
# Refactor Component

Refactor the specified component: $ARGUMENTS

## Refactoring Goals
1. **Improve Readability**
   - Clear variable and function names
   - Logical code organization
   - Reduced complexity

2. **Enhance Maintainability**
   - Extract reusable logic
   - Remove duplication
   - Follow SOLID principles

3. **Optimize Performance**
   - Eliminate unnecessary re-renders
   - Optimize data structures
   - Reduce memory usage

4. **Preserve Functionality**
   - All tests must pass
   - No behavioral changes
   - Maintain backward compatibility

## Process
1. Analyze current implementation
2. Identify improvement opportunities
3. Propose refactoring plan
4. Implement changes incrementally
5. Verify tests pass
EOF

cat > .github/prompts/document-api.prompt.md << 'EOF'
# Document API

Generate comprehensive API documentation for: $ARGUMENTS

## Documentation Requirements

### Endpoint Information
- HTTP method and path
- Description of purpose
- Authentication requirements
- Rate limiting information

### Request Details
- Request parameters (path, query, body)
- Parameter types and validation
- Example request

### Response Details
- Response status codes
- Response body structure
- Example responses (success and error)

### Additional Information
- Related endpoints
- Usage examples
- Common error scenarios
- Best practices

## Format
Use clear, consistent formatting with code examples in appropriate languages.
EOF

cat > .github/prompts/security-audit.prompt.md << 'EOF'
# Security Audit

Perform a security audit on: $ARGUMENTS

## Security Checklist

### 1. Authentication & Authorization
- Proper authentication mechanisms
- Authorization checks in place
- Session management secure
- Password policies enforced

### 2. Input Validation
- All inputs validated
- Protection against injection attacks
- Proper sanitization
- File upload security

### 3. Data Protection
- Sensitive data encrypted
- Secure data transmission (HTTPS)
- No secrets in code
- Proper key management

### 4. API Security
- Rate limiting implemented
- CORS properly configured
- API keys secured
- Input size limits

### 5. Dependencies
- No known vulnerabilities in dependencies
- Regular security updates
- Minimal dependency usage

### 6. Error Handling
- No sensitive information in errors
- Proper logging
- Graceful error handling

Provide specific findings with severity levels and remediation steps.
EOF

cat > .github/prompts/plan-feature.prompt.md << 'EOF'
# Plan Feature Implementation

Plan the implementation of: $ARGUMENTS

## Planning Process

### 1. Research Phase
- Analyze existing codebase
- Understand current architecture
- Identify relevant patterns
- Review related features

### 2. Design Phase
- Define feature requirements
- Design data models
- Plan API contracts
- Consider edge cases

### 3. Implementation Strategy
- List files to create/modify
- Break down into subtasks
- Identify dependencies
- Estimate complexity

### 4. Testing Strategy
- Unit test requirements
- Integration test needs
- E2E test scenarios
- Performance testing

### 5. Risk Assessment
- Potential challenges
- Breaking changes
- Migration requirements
- Rollback strategy

Present a detailed plan with clear milestones before implementation.
EOF

# Create example instruction files
print_status "Creating example instruction files..."

cat > .github/instructions/backend.instructions.md << 'EOF'
---
applyTo:
  - "**/*.controller.ts"
  - "**/*.service.ts"
  - "src/backend/**/*.ts"
---

# Backend Development Guidelines

## Controller Standards
- Keep controllers thin - delegate business logic to services
- Use dependency injection
- Implement proper error handling with try-catch
- Return appropriate HTTP status codes
- Use DTOs for request/response validation

## Service Layer
- Encapsulate business logic in services
- Keep services focused and single-purpose
- Use repository pattern for data access
- Implement proper transaction management
- Log important operations

## API Design
- Follow RESTful conventions
- Use versioning (e.g., /api/v1)
- Implement pagination for list endpoints
- Return consistent error responses
- Document with OpenAPI/Swagger

## Error Handling
```typescript
try {
  // operation
} catch (error) {
  logger.error('Operation failed', error);
  throw new HttpException('User-friendly message', statusCode);
}
```

## Testing
- Write unit tests for services
- Mock external dependencies
- Test error scenarios
- Aim for >80% coverage
EOF

cat > .github/instructions/frontend.instructions.md << 'EOF'
---
applyTo:
  - "src/components/**/*.tsx"
  - "src/pages/**/*.tsx"
  - "**/*.component.tsx"
---

# Frontend Development Guidelines

## Component Standards
- Use functional components with hooks
- Keep components small and focused
- Extract reusable logic into custom hooks
- Use TypeScript for type safety
- Implement proper error boundaries

## State Management
- Use React hooks for local state (useState, useReducer)
- Consider Context API for shared state
- Implement proper loading and error states
- Avoid prop drilling - use context when needed

## Styling
- Use Tailwind CSS utility classes
- Follow mobile-first approach
- Maintain consistent spacing (4px grid)
- Use theme colors and variables
- Ensure accessibility (ARIA labels, keyboard navigation)

## Performance
- Lazy load routes and heavy components
- Memoize expensive computations (useMemo)
- Prevent unnecessary re-renders (useCallback, React.memo)
- Optimize images and assets
- Implement code splitting

## Component Structure
```tsx
// Props interface
interface ComponentProps {
  prop1: string;
  prop2?: number;
}

// Component
export const Component: React.FC<ComponentProps> = ({ prop1, prop2 }) => {
  // Hooks
  // Event handlers
  // Render
};
```

## Testing
- Write tests for all components
- Test user interactions
- Test edge cases
- Use React Testing Library
EOF

cat > .github/instructions/security.instructions.md << 'EOF'
---
applyTo:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
---

# Security Best Practices

## Authentication & Authorization
- Never store passwords in plain text
- Use bcrypt/argon2 for password hashing
- Implement proper session management
- Use JWT for stateless authentication
- Always verify authorization before operations

## Input Validation
- Validate all user inputs
- Use schema validation libraries (Zod, Yup)
- Sanitize inputs to prevent XSS
- Protect against SQL injection (use parameterized queries)
- Implement rate limiting

## Sensitive Data
- Never commit secrets (.env files)
- Use environment variables for config
- Encrypt sensitive data at rest
- Use HTTPS for all communications
- Implement proper logging (avoid logging secrets)

## API Security
```typescript
// Always validate input
const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});

// Always check authorization
if (user.id !== requestedUserId && !user.isAdmin) {
  throw new UnauthorizedException();
}

// Rate limiting
@Throttle(10, 60) // 10 requests per minute
```

## Dependency Security
- Regularly update dependencies
- Run security audits (npm audit)
- Review dependency licenses
- Minimize dependency count
- Pin dependency versions
EOF

cat > .github/instructions/testing.instructions.md << 'EOF'
---
applyTo:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
---

# Testing Guidelines

## Test Structure
- Use Arrange-Act-Assert pattern
- One assertion per test (when possible)
- Clear, descriptive test names
- Group related tests with describe blocks

## Unit Tests
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = { email: 'test@example.com', name: 'Test' };
      
      // Act
      const user = await userService.createUser(userData);
      
      // Assert
      expect(user).toBeDefined();
      expect(user.email).toBe(userData.email);
    });

    it('should throw error for duplicate email', async () => {
      // Arrange
      const userData = { email: 'existing@example.com', name: 'Test' };
      
      // Act & Assert
      await expect(userService.createUser(userData))
        .rejects
        .toThrow('Email already exists');
    });
  });
});
```

## Test Coverage
- Aim for >80% coverage
- Focus on critical business logic
- Test happy paths and error cases
- Test edge cases and boundary conditions

## Mocking
- Mock external dependencies
- Use dependency injection for testability
- Mock API calls and database operations
- Keep mocks simple and maintainable

## Best Practices
- Tests should be fast
- Tests should be independent
- Tests should be deterministic
- Clean up after tests
- Use test fixtures for common data
EOF

# Create example agents
print_status "Creating example agents..."

cat > .github/agents/architect.agent.md << 'EOF'
---
description: System architecture and design specialist
tools:
  - read
  - search
  - list
---

# Software Architect Mode

You are an experienced software architect specializing in:
- System design and architecture
- Scalability and performance
- Design patterns and best practices
- Technology selection
- Microservices architecture
- Database design

## Your Approach
1. **Analyze Requirements**: Understand functional and non-functional requirements
2. **Design Solutions**: Create scalable, maintainable architectures
3. **Consider Trade-offs**: Evaluate options and explain pros/cons
4. **Best Practices**: Apply industry-standard patterns and principles

## Focus Areas
- SOLID principles
- Clean Architecture
- Domain-Driven Design
- Event-Driven Architecture
- API design (REST, GraphQL, gRPC)
- Caching strategies
- Database selection and optimization

When designing systems, always consider:
- Scalability (horizontal/vertical)
- Performance and latency
- Security and compliance
- Maintainability and extensibility
- Cost efficiency
- Team expertise

Provide architectural diagrams when helpful (using Mermaid or ASCII).
EOF

cat > .github/agents/security-analyst.agent.md << 'EOF'
---
description: Security-focused code analysis and vulnerability detection
tools:
  - read
  - search
  - grep
---

# Security Analyst Mode

You are a cybersecurity expert focused on:
- Identifying security vulnerabilities
- OWASP Top 10 compliance
- Secure coding practices
- Threat modeling
- Security testing
- Compliance requirements

## Your Approach
1. **Vulnerability Scanning**: Identify security weaknesses
2. **Risk Assessment**: Evaluate severity and impact
3. **Remediation**: Provide specific fixes
4. **Prevention**: Suggest proactive security measures

## Security Checklist
- [ ] Authentication and authorization
- [ ] Input validation and sanitization
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Secure session management
- [ ] Encryption of sensitive data
- [ ] Secure dependencies
- [ ] Error handling (no info leakage)
- [ ] Rate limiting and DDoS protection

## Common Vulnerabilities to Check
- Hardcoded secrets
- Insecure direct object references
- Missing authentication/authorization
- Unvalidated redirects
- Insecure deserialization
- XXE (XML External Entities)
- Security misconfiguration

Provide findings with:
- Severity level (Critical, High, Medium, Low)
- Affected code location
- Explanation of the vulnerability
- Specific remediation steps
- Code examples of fixes
EOF

cat > .github/agents/devops-engineer.agent.md << 'EOF'
---
description: DevOps and infrastructure specialist
tools:
  - read
  - search
  - edit
---

# DevOps Engineer Mode

You are a DevOps engineer specializing in:
- CI/CD pipelines
- Infrastructure as Code
- Container orchestration
- Cloud platforms (AWS, Azure, GCP)
- Monitoring and observability
- Deployment strategies

## Your Approach
1. **Automation First**: Automate repetitive tasks
2. **Infrastructure as Code**: Everything in version control
3. **Observability**: Implement proper monitoring and logging
4. **Reliability**: Focus on uptime and resilience

## Expertise Areas
- Docker and containerization
- Kubernetes orchestration
- Terraform/CloudFormation
- GitHub Actions/Jenkins/GitLab CI
- Prometheus, Grafana monitoring
- ELK/EFK logging stacks
- Blue-green and canary deployments

## Best Practices
- Implement proper CI/CD pipelines
- Use environment-specific configurations
- Implement health checks and readiness probes
- Set up proper logging and monitoring
- Implement backup and disaster recovery
- Use secrets management (Vault, AWS Secrets Manager)
- Implement auto-scaling
- Follow security best practices

## Deployment Checklist
- [ ] Automated tests in CI
- [ ] Docker images optimized
- [ ] Environment variables configured
- [ ] Secrets properly managed
- [ ] Health checks implemented
- [ ] Monitoring and alerting set up
- [ ] Rollback strategy defined
- [ ] Documentation updated
EOF

cat > .github/agents/code-reviewer.agent.md << 'EOF'
---
description: Thorough code review and quality assurance
tools:
  - read
  - search
---

# Code Reviewer Mode

You are a senior code reviewer focused on:
- Code quality and maintainability
- Best practices and conventions
- Bug detection
- Performance optimization
- Test coverage

## Review Criteria

### 1. Code Quality
- Readability and clarity
- Proper naming conventions
- Code organization
- No code duplication (DRY)
- Single Responsibility Principle

### 2. Functionality
- Logic correctness
- Edge case handling
- Error handling
- Input validation
- Expected behavior

### 3. Performance
- Algorithm efficiency
- Resource management
- Database query optimization
- Caching opportunities
- Memory usage

### 4. Security
- Input validation
- Authorization checks
- No security vulnerabilities
- Secure data handling

### 5. Testing
- Adequate test coverage
- Edge cases tested
- Tests are maintainable
- No flaky tests

### 6. Documentation
- Code comments for complex logic
- API documentation
- README updates
- Architecture decision records

## Review Process
1. Understand the change and its purpose
2. Review the code systematically
3. Identify issues with severity levels
4. Suggest specific improvements
5. Acknowledge good practices

## Feedback Format
- **Critical**: Must be fixed before merge
- **Major**: Should be addressed
- **Minor**: Nice to have improvements
- **Nitpick**: Style/preference suggestions
- **Praise**: Recognize good code

Be constructive and specific in all feedback.
EOF

# Create .gitignore updates
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

# Create GitHub Copilot instructions file
print_status "Creating .github/copilot-instructions.md..."

cat > .github/copilot-instructions.md << 'EOF'
# GitHub Copilot Project Instructions

## Project Overview
- **Name**: [Your Project Name]
- **Tech Stack**: [List your technologies]
- **Description**: [Brief project description]

## Architecture
- `src/` - [Source code description]
- `tests/` - [Test files description]
- [Add other important directories]

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
- Follow code review checklist
- Write tests for new features
- Update documentation

## Git Workflow
- Branch naming: `feature/description`, `fix/description`
- Commit messages: [Your convention]
- Always create pull requests
- Require code reviews

## Security
- Never commit `.env` files
- Use environment variables for secrets
- Validate all user input
- Follow OWASP guidelines

## CI/CD Workflows
This project includes GitHub Actions workflows for automated testing and deployment:

### Available Workflows
- **Python CI/CD** (`python-ci-cd.yml`) - Code quality, testing, security scanning, PyPI deployment
- **React/TypeScript** (`react-typescript-vite-ci-cd.yml`) - Linting, testing, building, preview & production deployment
- **Spring Boot** (`spring-ci-cd-workflow.yml`) - Build, test, security scan, Docker build & deployment
- **Terraform** (`terraform-ci-cd.yml`) - Format, validate, security scan, plan & apply infrastructure

### Workflow Features
- Automated code quality checks
- Multi-environment testing
- Security vulnerability scanning
- Automated deployment to dev/staging/production
- Cost estimation (Terraform)
- Documentation generation

### Required Secrets
Configure these in repository settings for full CI/CD functionality:
- `PYPI_API_TOKEN` - For Python package deployment
- `NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID` - For preview deployments
- `FIREBASE_SERVICE_ACCOUNT`, `FIREBASE_PROJECT_ID` - For production deployment
- `SONAR_TOKEN` - For code quality analysis
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` - For AWS/Terraform deployments
- `INFRACOST_API_KEY` - For Terraform cost estimation

Customize workflows in `.github/workflows/` to match your project needs.

## When Starting Work
1. Review dev/active/*.md for current context
2. Check dev/plans/*.md for roadmap
3. Ask questions before making assumptions
4. Plan before implementing

## Available Prompts
Reference these prompts in chat with `@workspace /prompt-name`:
- `/review-code` - Comprehensive code review
- `/generate-tests` - Generate unit tests
- `/refactor-component` - Refactor with best practices
- `/document-api` - Generate API documentation
- `/security-audit` - Security vulnerability scan
- `/plan-feature` - Plan feature implementation

## Agents
Use specialized agents for specific tasks:
- `architect` - System design and architecture
- `security-analyst` - Security analysis
- `devops-engineer` - Infrastructure and deployment
- `code-reviewer` - Code quality review

## Skills
Reusable capabilities available in `.github/skills/`:
- Custom automation workflows
- Code generation templates
- Testing utilities
- Deployment scripts

## Code Patterns

### Component Structure (React/TypeScript)
```typescript
interface ComponentProps {
  prop1: string;
  prop2?: number;
}

export const Component: React.FC<ComponentProps> = ({ prop1, prop2 }) => {
  // Hooks
  const [state, setState] = useState<Type>();
  
  // Event handlers
  const handleEvent = useCallback(() => {
    // logic
  }, [dependencies]);
  
  // Effects
  useEffect(() => {
    // side effects
  }, [dependencies]);
  
  // Render
  return (
    <div>
      {/* JSX */}
    </div>
  );
};
```

### API Controller (Node.js/TypeScript)
```typescript
@Controller('/api/v1/resource')
export class ResourceController {
  constructor(private readonly service: ResourceService) {}
  
  @Get()
  async findAll(@Query() query: QueryDto): Promise<ResourceDto[]> {
    try {
      return await this.service.findAll(query);
    } catch (error) {
      logger.error('Failed to fetch resources', error);
      throw new InternalServerErrorException('Failed to fetch resources');
    }
  }
}
```

## Documentation Standards
- Use JSDoc for functions and classes
- Update README.md for major changes
- Document API endpoints
- Create ADRs for significant decisions

## Performance Guidelines
- Optimize database queries
- Implement caching where appropriate
- Use lazy loading for heavy components
- Monitor and profile performance
- Set performance budgets

## Accessibility Requirements
- Use semantic HTML
- Include ARIA labels
- Ensure keyboard navigation
- Maintain color contrast ratios
- Test with screen readers
EOF

# Create comprehensive AGENTS.md
print_status "Creating comprehensive AGENTS.md..."

cat > AGENTS.md << 'EOF'
# AGENTS.md - AI Agent & Skill Catalog

## Overview
This document catalogs all available agents and skills for AI-assisted development. Agents are specialized AI personas that provide expert assistance in specific domains, while skills are reusable capabilities that can be invoked to perform specific tasks.

## Built-in Agents

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

## Using AI Agents

### Activating Agents

1. **In VS Code with GitHub Copilot**:
   - Open GitHub Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I)
   - Type the agent name at the start of your question
   - Example: "architect mode: design a caching layer"

2. **With Claude Code**:
   - Reference agents defined in `.github/agents/`
   - Agents provide context-specific assistance

3. **Agent Persistence**:
   - Once activated, the agent persists for the conversation
   - Switch agents by explicitly mentioning a new agent
   - Reset to default by starting a new chat

### Effective Agent Usage

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

Agents work seamlessly with reusable prompts:

```
@workspace /review-code (uses code-reviewer agent internally)
@workspace /security-audit (uses security-analyst agent internally)
@workspace /plan-feature (uses architect agent for design)
```

---

## Skills Integration

Skills are reusable capabilities that agents can invoke:
- Defined in `.github/skills/`
- Can be composed together for complex workflows
- Provide consistent execution patterns
- Enable automation of common tasks

---

## Context-Specific Instructions Integration

Agents automatically apply context-specific instructions from `.github/instructions/`:
- Backend instructions apply in architect and code-reviewer agents
- Security instructions always apply in security-analyst agent
- Testing instructions apply in code-reviewer agent

---

## Best Practices for Agent Usage

### 1. Choose the Right Agent
- **Architecture questions** → Architect agent
- **Security concerns** → Security analyst agent
- **Infrastructure/deployment** → DevOps engineer agent
- **Code quality** → Code reviewer agent

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

### Multi-Agent Consultation

For complex problems, consult multiple agents:

```
1. "Architect mode: Design the system architecture"
2. "Security-analyst mode: Review this design for security issues"
3. "DevOps-engineer mode: How should I deploy this?"
4. "Code-reviewer mode: Review the implementation"
```

### Agent-Specific Workflows

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

### Agent Not Responding as Expected
- Be more specific in your question
- Provide more context about your situation
- Rephrase your question
- Start a new chat and try again

### Getting Generic Responses
- Explicitly mention the agent name
- Provide technical details
- Ask specific questions rather than general ones
- Include code snippets or examples

### Agent Seems Wrong for the Task
- Double-check agent selection
- Consider if a different agent is more appropriate
- Try combining insights from multiple agents

---

## Custom Agent Development

You can create custom agents using `.github/agents/`:

### Creating Custom Agent Definitions

1. Create file: `.github/agents/custom-agent.agent.md`
2. Define role and expertise
3. Specify tools and approach
4. Document usage examples

**Example Custom Agent**:
```markdown
---
description: Database optimization specialist
tools:
  - read
  - search
---

# Database Optimizer Agent

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

## Custom Skill Development

You can create custom skills using `.github/skills/`:

### Creating Custom Skill Definitions

1. Create file: `.github/skills/custom-skill.skill.md`
2. Define purpose and inputs
3. Specify execution steps
4. Document outputs

**Example Custom Skill**:
```markdown
---
name: database-migration
description: Automated database schema migration
inputs:
  - name: migration_script
    type: path
    description: Path to migration script
outputs:
  - name: migration_status
    type: string
    description: Success or failure status
---

# Database Migration Skill

## Purpose
Safely execute database migrations with rollback capability

## Execution Steps
1. Backup current database state
2. Validate migration script
3. Execute migration in transaction
4. Verify schema changes
5. Commit or rollback based on validation
```

---

## Integration with GitHub Actions

Agents complement CI/CD workflows:
- **Architect agent** - Design workflow structure
- **Security-analyst agent** - Review workflow security
- **DevOps-engineer agent** - Implement and optimize workflows
- **Code-reviewer agent** - Review workflow YAML files

Skills can automate CI/CD tasks:
- Deployment automation
- Test execution
- Code quality checks
- Security scanning

---

## Resources

### Documentation
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Copilot Chat Documentation](https://docs.github.com/en/copilot/github-copilot-chat)

### Learning Resources
- Project instructions: `.github/copilot-instructions.md`
- Context-specific guidelines: `.github/instructions/`
- Reusable prompts: `.github/prompts/`
- Agent definitions: `.github/agents/`
- Skill definitions: `.github/skills/`

---

## Changelog

### Version 1.0 (Initial)
- Documented all built-in agents
- Added agent usage patterns and best practices
- Included troubleshooting guide
- Created integration guidelines
- Added skills framework documentation

---

**This catalog is maintained as part of the AI-assisted development setup.**
**Last Updated**: Auto-generated during setup
**Maintainer**: Project Team

For questions or suggestions, update this file and share with the team.
EOF

print_success "Created comprehensive AGENTS.md"

# Create onboarding documentation
print_status "Creating onboarding documentation..."

cat > docs/onboarding/COPILOT_SETUP.md << 'EOF'
# Setting Up GitHub Copilot for This Project

## 1. Prerequisites
- GitHub Copilot subscription (Individual or Business)
- VS Code with GitHub Copilot extension
- Git configured

## 2. Initial Setup

Navigate to the project directory:
```bash
cd your-project
```

## 3. Review Project Context

Read the project instructions:
```bash
cat .github/copilot-instructions.md
```

This file contains:
- Project architecture
- Code standards
- Available prompts
- Agents and skills
- Workflow rules

## 4. Explore Available Features

### Instructions
Context-specific guidelines in `.github/instructions/`:
- Backend development standards
- Frontend component guidelines
- Security best practices
- Testing conventions

### Prompts
Reusable task prompts in `.github/prompts/`:
- `@workspace /review-code` - Code review
- `@workspace /generate-tests` - Test generation
- `@workspace /security-audit` - Security scan
- `@workspace /plan-feature` - Feature planning

### Agents
Specialized AI personas in `.github/agents/`:
- Architect agent for system design
- Security analyst for vulnerability detection
- DevOps engineer for deployment
- Code reviewer for quality assurance

### Skills
Reusable capabilities in `.github/skills/`:
- Automation workflows
- Code generation templates
- Testing utilities
- Deployment scripts

## 5. Understand the Directory Structure

```
.github/              - GitHub Copilot configuration
  copilot-instructions.md  - Main project instructions
  instructions/       - Context-specific guidelines
  prompts/           - Reusable task prompts
  agents/            - AI agent personas
  skills/            - Reusable capabilities
dev/active/          - Current work context
dev/plans/           - Planning documents
dev/scratch/         - Scratchpad for planning
docs/                - Project documentation
```

## 6. Start Working

Ask Copilot: "What is the project structure?" or "Show me the current tasks"

## 7. Development Workflow

1. Check `dev/active/context.md` for current work
2. Use `@workspace /plan-feature [feature-name]` to plan
3. Implement with Copilot suggestions
4. Use `@workspace /review-code` to review changes
5. Update `dev/active/context.md` with progress

## 8. Best Practices

- Always review `.github/copilot-instructions.md` before starting work
- Use appropriate prompts for common tasks
- Switch to specialized agents when needed
- Leverage skills for automation
- Keep dev/active/ updated
- Document decisions in docs/decisions/
- Ask questions before making assumptions

## 9. Using Context-Specific Instructions

Instructions automatically apply based on file patterns:
- Working on a controller? Backend instructions apply
- Working on a component? Frontend instructions apply
- All files get security guidelines

## 10. Custom Prompts Usage

Reference prompts in Copilot Chat:
```
@workspace /review-code
@workspace /generate-tests for UserService
@workspace /security-audit on authentication module
@workspace /plan-feature real-time notifications
```

## 11. Using Agents

To use a specialized agent:
1. Open GitHub Copilot Chat or Claude Code
2. Reference the agent (e.g., "architect mode")
3. Ask your question in that context

## 12. Using Skills

Skills are reusable capabilities defined in `.github/skills/`:
- Reference skills in agent workflows
- Compose skills for complex automation
- Customize skills for project-specific needs

## 13. Tips for Effective Use

- Be specific in your requests
- Provide context in your prompts
- Use `@workspace` to reference the project
- Review and test all generated code
- Iterate on suggestions if needed
- Combine with manual coding best practices
EOF

cat > docs/onboarding/PROJECT_STRUCTURE.md << 'EOF'
# Project Structure

## Overview
This document explains the organization of this project with GitHub Copilot integration.

## Directory Layout

```
project-root/
├── .github/              GitHub configuration & Copilot
│   ├── copilot-instructions.md  Main project instructions
│   ├── instructions/    Context-specific guidelines
│   ├── prompts/        Reusable task prompts
│   ├── agents/         Specialized AI agent personas
│   ├── skills/         Reusable capabilities
│   └── workflows/      GitHub Actions CI/CD
│
├── dev/                 Development workspace
│   ├── active/         Current work context
│   ├── plans/          Planning documents
│   └── scratch/        Scratchpad files
│
├── docs/                Project documentation
│   ├── architecture/   Architecture docs
│   ├── onboarding/     Setup guides
│   ├── decisions/      Architecture Decision Records
│   └── ai-instructions/ Shared AI guidelines
│
├── src/                 Source code
└── tests/               Test files
```

## Key Files

### .github/copilot-instructions.md
The primary instructions file for GitHub Copilot. Contains:
- Project overview
- Architecture
- Code standards
- Workflow rules
- Available prompts and chat modes

### dev/active/context.md
Current work context. Update this file to help Copilot understand:
- What you're working on
- Recent changes
- Next steps
- Open questions

### .github/instructions/
Context-specific guidelines that automatically apply based on file patterns:
- `backend.instructions.md` - Backend development
- `frontend.instructions.md` - Frontend components
- `security.instructions.md` - Security practices
- `testing.instructions.md` - Test conventions

### .github/prompts/
Reusable task prompts:
- `review-code.prompt.md` - Code review checklist
- `generate-tests.prompt.md` - Test generation
- `security-audit.prompt.md` - Security scanning
- `plan-feature.prompt.md` - Feature planning

## Working with the Structure

1. **Before Starting Work**
   - Review `.github/copilot-instructions.md`
   - Check `dev/active/context.md`
   - Read relevant `docs/`

2. **During Development**
   - Use `@workspace /plan-feature` to plan
   - Let instructions auto-apply
   - Update `dev/active/` as you progress

3. **After Completing Work**
   - Use `@workspace /review-code` for review
   - Update context.md
   - Document decisions in `docs/decisions/`
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

# Create shared AI instructions
cat > docs/ai-instructions/coding-standards.md << 'EOF'
# Coding Standards

This document contains coding standards that apply to both GitHub Copilot and Claude Code.

## General Principles
- Write clean, readable code
- Follow SOLID principles
- Keep functions small and focused
- Use meaningful names
- Write self-documenting code

## Naming Conventions
- Variables: camelCase
- Functions: camelCase (verbs)
- Classes: PascalCase (nouns)
- Constants: UPPER_SNAKE_CASE
- Files: kebab-case or PascalCase (consistent per project)

## Code Organization
- Group related functionality
- Separate concerns
- Use modules/namespaces
- Keep file lengths reasonable (<500 lines)
- One class/component per file

## Documentation
- Document complex logic
- Use JSDoc/TypeDoc for public APIs
- Keep comments up to date
- README for each major module
- Architecture decision records for big changes

## Testing
- Write tests for all new code
- Follow Arrange-Act-Assert pattern
- Test edge cases and errors
- Maintain test coverage >80%
- Keep tests independent

## Error Handling
- Fail fast and explicitly
- Use appropriate error types
- Log errors with context
- Never swallow exceptions
- Provide user-friendly messages

## Performance
- Profile before optimizing
- Avoid premature optimization
- Consider time and space complexity
- Use appropriate data structures
- Implement caching wisely

## Security
- Validate all inputs
- Never trust user data
- Use parameterized queries
- Implement proper authentication
- Follow OWASP guidelines
EOF

# Create comprehensive README
print_status "Creating comprehensive README..."

cat > README.md << 'EOF'
# 🚀 Project Name

> 📝 **Quick Start**: This project is configured with [GitHub Copilot](https://github.com/features/copilot) for AI-assisted development.

## 📋 Table of Contents

- [Overview](#-overview)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [GitHub Copilot Integration](#-github-copilot-integration)
- [Available Prompts](#-available-prompts)
- [Chat Modes](#-chat-modes)
- [Quality Workflows](#-quality-workflows)
- [Documentation](#-documentation)
- [Contributing](#-contributing)

## 🎯 Overview

[Add your project description here]

This is a GitHub Copilot enhanced project with:
- 📝 **Project Instructions**: Automatic context loading
- 🎯 **Context-Specific Guidelines**: Auto-applying instructions
- 🤖 **Reusable Prompts**: Task-specific workflows
- 👥 **Specialized Chat Modes**: Expert AI personas
- ✅ **Quality Automation**: Built-in best practices

## 🚀 Quick Start

### Prerequisites

- [GitHub Copilot](https://github.com/features/copilot) subscription
- VS Code with GitHub Copilot extension
- Node.js and npm (for JavaScript/TypeScript projects)
- Git configured

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd <your-project>

# Install dependencies
npm install  # or pip install -r requirements.txt

# Start development
npm run dev
```

### First Steps

1. 📖 Read [.github/copilot-instructions.md](.github/copilot-instructions.md) for project guidelines
2. 📚 Check [docs/onboarding/](docs/onboarding/) for detailed setup guides
3. ✅ Run tests to verify setup: `npm test`

## 📁 Project Structure

```
.
├── .github/              # 🤖 GitHub & Copilot configuration
│   ├── copilot-instructions.md  # Main project instructions
│   ├── instructions/    # Context-specific guidelines
│   ├── prompts/        # Reusable task prompts
│   ├── agents/         # Specialized AI agent personas
│   ├── skills/         # Reusable capabilities
│   └── workflows/      # GitHub Actions CI/CD
│
├── dev/                 # 🛠️ Development workspace
│   ├── active/         # Current work context
│   ├── plans/          # Planning documents
│   └── scratch/        # Scratchpad for ideas
│
├── docs/                # 📚 Documentation
│   ├── architecture/   # Architecture docs
│   ├── decisions/      # ADRs (Architecture Decision Records)
│   ├── onboarding/     # Setup & onboarding guides
│   └── ai-instructions/ # Shared AI guidelines
│
├── src/                 # 💻 Source code
└── tests/               # 🧪 Test files
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
2. **Plan**: Use `@workspace /plan-feature` or write plans in `dev/plans/`
3. **Implement**: Use Copilot with auto-applying instructions
4. **Test**: Run tests after each change
5. **Review**: Use `@workspace /review-code` before committing
6. **Commit**: Use clear, descriptive commit messages

## 🤖 GitHub Copilot Integration

### Project Instructions

The `.github/copilot-instructions.md` file contains project-wide guidelines that GitHub Copilot automatically uses to improve suggestions and chat responses.

### Context-Specific Instructions

Instructions in `.github/instructions/` automatically apply based on file patterns:

| Instruction File | Applies To | Purpose |
|-----------------|------------|---------|
| `backend.instructions.md` | Controllers, Services | Backend development standards |
| `frontend.instructions.md` | Components, Pages | Frontend component guidelines |
| `security.instructions.md` | All code files | Security best practices |
| `testing.instructions.md` | Test files | Testing conventions |

### Auto-Applying Instructions

Instructions activate automatically when you:
- Open a file matching the pattern
- Ask Copilot about code in those files
- Use Copilot suggestions in those contexts

## 🎯 Available Prompts

Use these prompts in GitHub Copilot Chat with `@workspace /prompt-name`:

| Prompt | Description | Usage |
|--------|-------------|-------|
| `/review-code` | Comprehensive code review | `@workspace /review-code` |
| `/generate-tests` | Generate unit tests | `@workspace /generate-tests for UserService` |
| `/refactor-component` | Refactor with best practices | `@workspace /refactor-component Header` |
| `/document-api` | Generate API documentation | `@workspace /document-api for /api/users` |
| `/security-audit` | Security vulnerability scan | `@workspace /security-audit on auth module` |
| `/plan-feature` | Plan feature implementation | `@workspace /plan-feature user notifications` |

### Example Usage

```
User: @workspace /review-code

Copilot: I'll review the current changes for:
1. Code Quality
2. Security
3. Performance
4. Testing
5. Documentation

[Provides detailed review with specific suggestions]
```

## 👥 AI Agents

Switch to specialized AI agent personas for expert assistance:

### 🏗️ Architect Agent
System design and architecture specialist
- Use for: Design decisions, scalability planning
- Example: "In architect mode, design a microservices architecture for our API"

### 🔒 Security Analyst Agent
Security-focused code analysis
- Use for: Vulnerability detection, security reviews
- Example: "In security-analyst mode, audit the authentication system"

### 🚀 DevOps Engineer Agent
Infrastructure and deployment specialist
- Use for: CI/CD, containerization, cloud deployment
- Example: "In devops-engineer mode, set up a CI/CD pipeline"

### 👨‍💻 Code Reviewer Agent
Code quality and best practices
- Use for: Pull request reviews, refactoring suggestions
- Example: "In code-reviewer mode, review this pull request"

## 🔧 Skills

Reusable capabilities for automation:
- Defined in [.github/skills/](.github/skills/)
- Composable for complex workflows
- Customizable for project needs
- Example skills: Code generation, testing automation, deployment scripts

## ✅ Quality Workflows

### Feature Development Workflow

1. **Plan**
   ```
   @workspace /plan-feature user authentication
   ```

2. **Implement**
   - Write code with Copilot suggestions
   - Auto-applying instructions ensure standards
   
3. **Test**
   ```
   @workspace /generate-tests for AuthService
   ```

4. **Review**
   ```
   @workspace /review-code
   ```

5. **Security Check**
   ```
   @workspace /security-audit
   ```

### Code Review Workflow

Before submitting a pull request:
1. Run `@workspace /review-code`
2. Run `@workspace /security-audit`
3. Ensure all tests pass
4. Update documentation
5. Request human review

## 📚 Documentation

- [Copilot Setup Guide](docs/onboarding/COPILOT_SETUP.md)
- [Project Structure](docs/onboarding/PROJECT_STRUCTURE.md)
- [Architecture Docs](docs/architecture/)
- [Decision Records](docs/decisions/)
- [API Documentation](docs/api/)

## 🤝 Contributing

### Before Contributing

1. Read `.github/copilot-instructions.md`
2. Review existing instructions in `.github/instructions/`
3. Understand available prompts, agents, and skills
4. Check `dev/active/context.md` for current work

### Contribution Workflow

1. Create a feature branch
2. Use `@workspace /plan-feature` to plan your changes
3. Implement with Copilot assistance
4. Use `@workspace /generate-tests` for test coverage
5. Use `@workspace /review-code` before committing
6. Use `@workspace /security-audit` for security check
7. Submit pull request with clear description
8. Request code review from team

### Pull Request Checklist

- [ ] Code follows project standards
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Security audit passed
- [ ] No secrets committed
- [ ] Breaking changes documented

## 📊 Project Statistics

- Language: [Your language]
- Framework: [Your framework]
- Test Coverage: [Coverage %]
- Build Status: [Status badge]

## 📄 License

[Your license]

## 🙏 Acknowledgments

- GitHub Copilot for AI-assisted development
- [Other acknowledgments]

---

**Built with GitHub Copilot** 🤖

EOF

print_success "Created comprehensive README"

# Final summary
echo ""
print_header "✅ Setup Complete!"
echo ""
print_success "GitHub Copilot structure has been set up successfully!"
echo ""

echo -e "${GREEN}📁 Directory Structure Created:${NC}"
echo "  ✓ .github/ (instructions, prompts, agents, skills, workflows)"
echo "  ✓ dev/ (active, plans, scratch)"
echo "  ✓ docs/ (architecture, onboarding, decisions)"
echo "  ✓ src/"
echo "  ✓ tests/"
echo ""

echo -e "${GREEN}📄 Key Files Created:${NC}"
echo "  ✓ .github/copilot-instructions.md (main project instructions)"
echo "  ✓ .github/instructions/ (context-specific guidelines)"
echo "  ✓ .github/prompts/ (reusable task prompts)"
echo "  ✓ .github/agents/ (specialized AI agent personas)"
echo "  ✓ .github/skills/ (reusable capabilities)"
echo "  ✓ .github/workflows/ (CI/CD pipelines)"
echo "  ✓ AGENTS.md (comprehensive agent & skill catalog)"
echo "  ✓ README.md (project documentation)"
echo "  ✓ .gitignore (updated with Copilot entries)"
echo ""

echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "  1. Review and customize .github/copilot-instructions.md"
echo "  2. Explore context-specific instructions in .github/instructions/"
echo "  3. Try reusable prompts with @workspace /prompt-name"
echo "  4. Read AGENTS.md to understand available agents and skills"
echo "  5. Configure GitHub Actions secrets for CI/CD workflows"
echo "  6. Read docs/onboarding/ for detailed setup guides"
echo "  7. Start using GitHub Copilot in VS Code or Claude Code"
echo ""

echo -e "${BLUE}💡 Quick Tips:${NC}"
echo "  • Instructions auto-apply based on file patterns"
echo "  • Use @workspace /review-code for comprehensive code reviews"
echo "  • Use @workspace /generate-tests to create tests"
echo "  • Use specialized agents for expert assistance:"
echo "    - 'architect mode' for system design"
echo "    - 'security-analyst mode' for security reviews"
echo "    - 'devops-engineer mode' for infrastructure"
echo "    - 'code-reviewer mode' for code quality"
echo "  • Leverage skills for automation and code generation"
echo ""

echo -e "${YELLOW}📦 CI/CD Workflows Available:${NC}"
if [ -f .github/workflows/python-ci-cd.yml ]; then
    echo "  ✓ Python CI/CD (lint, test, security, PyPI deploy)"
fi
if [ -f .github/workflows/react-typescript-vite-ci-cd.yml ]; then
    echo "  ✓ React/TypeScript CI/CD (test, build, preview, deploy)"
fi
if [ -f .github/workflows/spring-ci-cd-workflow.yml ]; then
    echo "  ✓ Spring Boot CI/CD (build, test, Docker, deploy)"
fi
if [ -f .github/workflows/terraform-ci-cd.yml ]; then
    echo "  ✓ Terraform CI/CD (validate, plan, apply, drift detection)"
fi
echo ""

print_success "🎉 Happy coding with GitHub Copilot!"
echo ""
