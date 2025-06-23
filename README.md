# AWS Control Tower Landing Zone with Terraform

This repository provisions an AWS Control Tower Landing Zone along with a multi-account AWS Organization using Terraform. It is designed to be modular, with a clear separation between initialization and main deployment steps.

---

## 📁 Key Files

```
.
├── init/
│   ├── main.tf          # Creates IAM roles and backend S3 bucket
│   └── iam.tf           # IAM roles for Control Tower
├── modules/
│   └── control-tower-landing-zone/ # Control Tower and Landing Zone creation
│   └── aws-organization/  # Organization and account creation
│   └── controls-validation  #  Module for validating guardrails via test resources
├── main.tf              # Root module using control tower module
├── backend.tf           # Backend configuration for Terraform state
├── variables.tf         # Variables for account emails and configuration
├── terraform.tfvars     # User-specific values (excluded from version control)
├── terraform.tfvars.example  # Example variables file
└── README.md
```

---

## ⚙️ Prerequisites

### Step 1: Run `init/` Configuration

This step sets up:

* IAM roles required by AWS Control Tower
* An S3 bucket for storing Terraform state

```bash
cd init
terraform init
terraform apply
```

> - Once complete, copy the `terraform_state` S3 bucket name from the output and use it to configure your root-level `backend.tf`.
> - Copy the ARNs for the IAM roles for the Control Tower as you will need them in Step 2

### Step 2: User Permissions

The IAM user or role used for executing Terraform must have permission to assume the roles created for Control Tower. Attach the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:aws:iam::REPLACE_WITH_AWS_ACCOUNT_ID:role/service-role/AWSControlTower*"
      ]
    }
  ]
}
```

---

## 🚀 Deploy the Control Tower Landing Zone

After completing the `init` step and configuring the backend:

1. Return to the root directory.
2. Populate `terraform.tfvars` with required values (see example below).
3. Run Terraform:

```bash
terraform init
terraform apply
```

---

## 🔐 terraform.tfvars Configuration

To avoid committing sensitive data, populate a local `terraform.tfvars` file. Use the provided `terraform.tfvars.example` as a template:

```hcl
security_account_email    = "user+security@email.com"
logging_account_email     = "user+logging@email.com"
production_account_email  = "user+production@email.com"
```

Optional fields:

```hcl
governed_regions                 = ["us-east-1"]
backup_enabled                   = true
backup_account_email             = "user+backup@email.com"
central_backup_account_email     = "user+centralbackup@email.com"
validate_controls                = true
```

---

## 📆 Features

* Deploys a governed AWS Control Tower landing zone.
* Creates multiple AWS accounts:

  * Security
  * Production
  * Centralized Logging
  * Optional Backup accounts
* Enables AWS governance services (CloudTrail, Config, etc).
* IAM roles for Control Tower admin and StackSets.
* Regional governance via `governed_regions` variable.
* (Optional) Enables Control Tower guardrails based on user-defined controls via `enable_controls` flag.
    * Guardrails are mapped dynamically using OU ARNs provided by the Organization module.
* (Optional) Validates enabled Control Tower guardrails using test Lambda/API resources in the production account via `validate_controls`.
---

## 🧠 How Control Tower Controls Work

If enable_controls = true, Terraform will:
- Loop through the provided controls map.
- Match each control’s target_ou_key with the corresponding OU ARN from the Organization module.
- Apply the specified control to that OU using the aws_controltower_control resource.

This allows flexible governance configuration without hardcoding OUs or ARNs.

---

## 📃 Validation

After successful deployment, validate that Control Tower is set up correctly by logging into the [AWS Control Tower Console](https://console.aws.amazon.com/controltower/home).

> Note: It can take the AWS Control Tower up to 60 mins to deploy.

Look for:

* Landing Zone status: **"Active"**
* Enrolled Accounts
* Organizational Units
* Guardrails and governance configurations

> See [Troubleshooting AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/troubleshooting.html) if you face any errors.

---

## 📂 References

* [AWS Control Tower Documentation](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## 🛡️ License

This project is licensed under the MIT License.
