# RS School DevOps course

## Task 2: Basic Infrastructure Configuration

### Description

Created basic infrastructure:

- VPC with 4 subnets in 2 different availability zones:  

    - 2 public subnets in different AZs 
    - 2 private subnets in different AZs

- Internet Gateway

- Bastion host - configured to be an access point for other instances inside VPC

- NAT by EC2 instance

- 3 EC2 instances (1 in public subnet, 2 in different private subnets)

- Routing configuration:

    - Instances in all subnets can reach each other
    - Instances in public subnets can reach addresses outside VPC and vice-versa


### Created infrastructure

```
/---[VPC (main)] ---------------------------------------------------------\
|                                                                         |
|   [Internet Gateway (main-igw)]                                         |
|                                                                         |
|   [Public Subnet (public-subnet-1)]                                     |
|       [Route table (public-rt)]                                         |
|       [Basion :: EC2 (bastion-host)] - [Sucurity Group (bastion-sg)]    |
|       [NAT :: EC2 (nat-instance)] - [Sucurity Group (nat-sg)]           |
|                                                                         |
|                                                                         |
|   [Private Subnet (private-subnet-1)]                                   |
|       [Route table (private-rt)]                                        |
|       [EC2 (test-private-1)] - [Sucurity Group (private-sg)]            |
|                                                                         |
|                                                                         |
|   [Public Subnet (public-subnet-2)]                                     |
|       [Route table (public-rt)]                                         |
|       [EC2 (test-public-1)] - [Sucurity Group (public-sg)]              |
|                                                                         |
|                                                                         |
|   [Private Subnet (private-subnet-2)]                                   |
|       [Route table (private-rt)]                                        |
|       [EC2 (test-private-2)] - [Sucurity Group (private-sg)]            |
|                                                                         |
\ ------------------------------------------------------------------------/
```

### Security groups:

- **private-sg** - Allow all traffic from VPC
- **public-sg** - Allow all traffic from anywhere
- **bastion-sg** - Allow SSH from anywhere
- **nat-sg** - Allow HTTP/HTTPS from private subnets


### Usage

**Used Terraform v1.12.2 with AWS provider v6.0.0 (the Latest)**

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
