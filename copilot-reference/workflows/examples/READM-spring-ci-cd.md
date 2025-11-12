Key Features

Multiple Environment Pipeline: Development → Staging → Production ready flow
Complete Testing: Unit and integration tests with coverage reports
Code Quality Checks: Style checks, bug scans, and SonarCloud integration
Security Scanning: OWASP dependency checks for vulnerabilities
Docker Integration: Builds and pushes Docker images to GitHub Container Registry
Automated Releases: Creates GitHub releases when you tag your code

How to Use This File

Download the YAML file I've created
Save it to your project's .github/workflows/ directory
Make sure you have the following in your project:

A Java Spring Boot application
Maven as your build tool
Basic test coverage setup with JaCoCo
A Dockerfile in your root directory

Required Secrets
For the full workflow to function, you'll need to set up the following GitHub secrets:

SONAR_TOKEN: If you want to use SonarCloud analysis
GitHub will automatically provide GITHUB_TOKEN

The workflow file includes detailed comments explaining each section and step to help you understand and customize it for your specific needs.
Would you like me to explain any particular section of the workflow in more detail?RetryClaude can make mistakes. Please double-check responses.
