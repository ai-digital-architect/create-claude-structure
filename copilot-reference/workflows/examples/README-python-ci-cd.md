Code Quality: Runs linters and formatters (Black, isort, flake8, mypy) to ensure your code meets quality standards
Testing: Tests your code across multiple Python versions (3.8-3.11) and operating systems (Ubuntu, Windows, macOS)
Security: Performs security scanning with Bandit and Safety to identify vulnerabilities
Deployment: Builds and publishes your package to PyPI when appropriate
Documentation: Generates and deploys documentation to GitHub Pages

Each section includes detailed comments explaining the purpose of each step and configuration choice.
To use this workflow:

Save this file to .github/workflows/python-ci.yml in your repository
Customize as needed for your specific project requirements
For PyPI deployment, add a PYPI_API_TOKEN secret in your repository settings

Would you like me to explain any specific section in more detail or modify any part of the workflow?RetryClaude can make mistakes. Please double-check responses. 3.7 Sonnet
