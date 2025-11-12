've created a comprehensive GitHub Actions workflow file for Terraform development. This workflow covers the entire infrastructure-as-code lifecycle with detailed comments explaining the purpose of each section.
The workflow includes:

Format and Validate: Ensures code is properly formatted and syntactically valid
Linting: Uses TFLint to check for best practices and potential errors
Security Scanning: Implements both tfsec and checkov to identify security vulnerabilities
Cost Estimation: Analyzes infrastructure changes to estimate cost impact (using Infracost)
Planning: Creates execution plans for multiple environments (dev, staging, prod)
Applying: Deploys changes to production (with approval gates)
Documentation: Automatically generates and updates documentation
Drift Detection: Identifies when infrastructure has changed outside of Terraform

Each section includes detailed comments that explain:

Why each step is important
What each tool does
How different components work together
Security considerations

To use this workflow:

Save the file to .github/workflows/terraform-ci.yml in your repository
Configure the required secrets in your repository settings:

TF_API_TOKEN (if using Terraform Cloud)
AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
INFRACOST_API_KEY

Update the TERRAFORM_DIRECTORY environment variable if your Terraform files are located elsewhere
Ensure your repository has the expected directory structure with environment-specific configurations

Would you like me to explain any specific section in more detail or modify any part of the workflow?RetryClaude can make mistakes. Please double-check responses.
/
