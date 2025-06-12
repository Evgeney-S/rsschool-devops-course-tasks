# RS School DevOps course

## Terraform + GitHub Actions

**Terraform stores state remotly in S3 bucket (`rsschool-devops-course-terraform`).**

- Creates an S3 bucket (`rsschool-devops-course-terraform-test`)
- Creates IAM role `GithubActionsRole` for GitHub Actions
- Sets all required policies for the `GithubActionsRole` role
- Github Actions workflow for deployment via Terraform:
    - terraform-check with format checking using terraform fmt
    - terraform-plan for planning deployments terraform plan
    - terraform-apply for deploying terraform apply

### Usage

**Initialize Terraform**
Run once locally
```
terraform init
```

**View changes**
Shows what changes will be made on the next application
```
terraform plan
```

**Apply changes via Terraform**
(if necessary)
```
terraform apply
```
**Also, the changes will be applied via GitHub Actions on push or PR to the main branch**

**Cleanup**
To destroy the created resources:
```
terraform destroy
```
