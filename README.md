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
│   └── control-tower-landing-zone/
│       └── organization.tf  # Organization and account creation
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
        "arn:aws:iam::REPLACE_WITH_AWS_ACCOUNT_ID:role/service-role/AWSControlTowerAdmin",
        "arn:aws:iam::REPLACE_WITH_AWS_ACCOUNT_ID:role/service-role/AWSControlTowerStackSetRole",
        "arn:aws:iam::REPLACE_WITH_AWS_ACCOUNT_ID:role/service-role/AWSControlTowerConfigAggregatorRoleForOrganizations",
        "arn:aws:iam::REPLACE_WITH_AWS_ACCOUNT_ID:role/service-role/AWSControlTowerCloudTrailRole"
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
security_account_email = "user+security@email.com"
sandbox_account_email  = "user+sandbox@email.com"
logging_account_email  = "user+logging@email.com"
```

Optional fields:

```hcl
backup_enabled                 = true
backup_account_email           = "user+backup@email.com"
central_backup_account_email  = "user+centralbackup@email.com"
```

---

## 📆 Features

* Deploys a governed AWS Control Tower landing zone.
* Creates multiple AWS accounts:

  * Security
  * Sandbox
  * Centralized Logging
  * Optional Backup accounts
* Enables AWS governance services (CloudTrail, Config, etc).
* IAM roles for Control Tower admin and StackSets.
* Regional governance via `governed_regions` variable.

---

## 📃 Validation

After successful deployment, validate that Control Tower is set up correctly by logging into the [AWS Control Tower Console](https://console.aws.amazon.com/controltower/home).

> Note: It can take the AWS Control Tower up to 30 mins to deploy.

Look for:

* Landing Zone status: **"Active"**
* Enrolled Accounts
* Organizational Units
* Guardrails and governance configurations

---

## 📂 References

* [AWS Control Tower Documentation](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html)
* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## 🛡️ License

This project is licensed under the MIT License.
