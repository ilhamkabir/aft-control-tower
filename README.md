# Account Factory Terraform - Control Tower

Account Factory for Terraform is a Terraform module maintained by the AWS Control Tower (CT) team built to automate the process of account creation, provisioning, and governance.

## Introduction

### Purpose

The script in this repository is used only once for initial setup of AFT. Once setup is complete, account requests and customizations are created and managed by the companion repos below (created in Step 4 of "Setup"). 

### Documentation

[Manage AWS Accounts Using Control Tower Account Factory for Terraform](https://learn.hashicorp.com/tutorials/terraform/aws-control-tower-aft)
[Decommission an AWS Control Tower Landing Zone](https://docs.aws.amazon.com/controltower/latest/userguide/decommission-landing-zone.html)

AFT Diagram:

<img src="https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2021/11/12/aws-control-tower-account-factory-for-terraform-diagram.png" alt="aws-control-tower-account-factory-for-terraform-diagram" width="600"/>

### Companion Repos

| Name | Description |
|------|------|
| [aft-account-provisioning-customizations](https://github.com/ilhamkabir/aft-account-provisioning-customizations) |  |
| [aft-account-requests](https://github.com/ilhamkabir/aft-account-requests) |  |
| [aft-global-customizations](https://github.com/ilhamkabir/aft-global-customizations) |  |
| [aft-account-customizations](https://github.com/ilhamkabir/aft-account-customizations) |  |

## Setup

The "Manage AWS Accounts Using Control Tower Account Factory for Terraform" documentation above goes through the setup process and is sufficient if this is your first time you're doing anything with AWS Control Tower. However, if you're not starting from scratch (you've decomissioned a Landing Zone in Control Tower previously or already have other Organization Units), there are some additional steps that need to be followed for AFT to work:

**Step 1**: Check IAM permissions

Control Tower will use the "AWSControlTowerAdmin" IAM role to set up the Landing Zone. Make sure that the following policies are available to that role:
- AWSControlTowerAdminPolicy
- AWSOrganizationsFullAccess
- AWSControlTowerServiceRolePolicy

> `126789op[]oiuytre    1230-=
'0  `: These policies should be there as default but when I decomissioned the Landing Zone, it took off the policies: "AWSOrganizationsFullAccess" and "AWSControlTowerServiceRolePolicy".

**Step 2**: Launch your AWS Control Tower Landing Zone

Before launching AFT, you need to have a working AWS Control Tower Landing Zone from the AWS console. The "Landing Zone" is a baseline environment for creating other AWS accounts.

The initial set up will walk you through creating 2 news OUs: a required foundational OU (default name is "Security") and an optional OU (default name is "Sandbox"). Change the optional OU name to "Management" because we can create the sandbox OU later on but we'll need the Management OU for managing and orchestrating AFT instructions for the following steps. 

> Why the Management OU?: AFT requests for creating and managing other accounts and customizations are created from the "Management" OU and sent to the Control Tower in the root OU to actually run. (This also means that Control Tower will need permissions to execute those AFT requests, which we'll grant in step 8) 

    Note: If you aleady have a Landing Zone and need to decommission it, follow these steps to save yourself headache later on...
    
    Do the following BEFORE decommissioning (in order!):      
    1. Log into the managing accounts for one of the non-root OUs
    2. Add payment information in the Billing Dashboard
    3. Verify your phone number [Documentation](https://aws.amazon.com/premiumsupport/knowledge-center/phone-verify-no-call/)
    4. Delete any "Provisioned Products" from AWS Service Catalog
    5. Deactivate your account from Settings
    6. Remove account from the OU
    7. Delete the other non-root OUs (repeat for all the other non-root OUs)

    Do the following AFTER deecomissioning (some manual cleanup is required to launch a new Landing Zone, as described in the "Decomissioning an AWS Control Tower Landing Zone" documentation) above:
    1. Delete the CloudWatch Logs log group: aws-controltower/CloudTrailLogs 
    2. The two S3 buckets with reserved names for logs must be removed, or renamed.
    3. Optional: Delete the AWS Single Sign-On (AWS SSO) configuration for AWS Control Tower
    4. Optional: Remove the VPC created by AWS Control Tower, and remove the associated AWS CloudFormation stack set.
    5. Before you can set up an AWS Control Tower Landing Zone in a different home Region, you also must run the command `aws organizations disable-aws-service-access --service-principal controltower.amazonaws.com`.

**Step 3**: Create an Account for the Management OU via Service Catalog

> Note: You'll log into the Managment OU with this account.

- Step 2.1: Go to AWS Service Catalog
- Step 2.2: Go to "Products" on the left menu panel 
- Step 2.3: Select and launch "AWS Control Tower Account Factory"
- Step 2.4: Fill out the form:

    | Field | Value |
    |------|---------|
    | Provisioned product name | Controller |
    | AccountEmail | ***** |
    | AccountName | Controller |
    | MangedOrganizationalUnit | Managment |
    | SSOUserEmail | ***** |
    | SSOUserFirstName | ***** |
    | SSOUserLastName | ***** |

**Step 4**: Fork the companion GitHub repositories

Fork the companion GitHub repos described above for creating and provisioning all future accounts and resources.

> Note: We don't have to do anything with these repositories now but they need to exist to continue. 
 
**Step 5**: Ensure that the Terraform environment is available for deployment

Requirements:

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72, < 4.0.0 |

**Step 6**: Apply Terraform 

Set values for the variables in the ```variables.tf``` file, then run:
```
terraform plan -out my-plan.tfplan
terraform apply "my-plan.tfplan"
```

> Note: Changes took about 20min to apply. This is the last time we'll work with this repo.

**Step 7**: Provide Code Pipeline access to the GitHub repos created above. 

- Step 7.1: Log into the Management OU with the account you created in step 3. 
- Step 7.2: Go to AWS Code Pipeline
- Step 7.3: Go to "Connections" under "Settings" in the left menu panel
- Step 7.4: Confirm the pending connection created in step 6.

**Step 8**: Grant the AFT service role permission to the Control Tower Service Catalog portfolio

- Step 8.1: Go to AWS Service Catalog (in your root account)
- Step 8.2: Go to "Portfolios" in the left menu panel
- Step 8.3: Select the "AWS Control Tower Account Factory" portfolio
- Step 8.4: Under the section "Groups, roles, and users", select "Add groups, roles, and users"
- Step 8.5: Under the "Roles" tab, select "AWSAFTExecution" role and select "Add access"

AFT and Control Tower should be ready to create and provision other account requests and customizations described in the companion repos now.   
