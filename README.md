# CE_private

### Problem Statement: 
Deploy a secure EC2 instance in a private subnet with SSH capability

### Goals:
- Provide sufficient resources for the workload
- Cost optimization
- Security
- SSH Access

### Solution
An optimized EC2 instance with policy based SSH access through AWS SSM deployed in a private subnet behind a NAT gateway in a public subnet and an S3 interface endpoint connected to a private S3 bucket

## Usage

### Requirements
  - Terraform

### Instructions
1. Clone the repo
2. Initialize terraform
    ```
    terraform init
    ```
3. Apply the configuration
    ```
    terraform apply
    ```
