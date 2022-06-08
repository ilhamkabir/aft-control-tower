# Account Factory Terraform - Control Tower

Account Factory for Terraform is a Terraform module maintained by the AWS Control Tower (CT) team built to automate the process of account creation, provisioning, and governance.

## About This Repository

The script in this repository is used only once for initial installation and setup of AFT. Organization Units and Gaurdrails are created and provisioned by the repositories in Step 4 of the instructions below. 

AFT Diagram:
<img src="https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2021/11/12/aws-control-tower-account-factory-for-terraform-diagram.png" alt="aws-control-tower-account-factory-for-terraform-diagram" width="600"/>

## AWS Resource Glossary

| Name | Description |
|------|------|
| Control Tower | An AWS resource that allows you to set up and govern a multi-account (where each account is called an "Organizational Unit", or "OU") AWS environment. |
| Servcie Catalog | An AWS resource allows you to create and organize a curated catalog of other AWS resources (into "portfolios"), shared to specific OUs or permission levels. |
| Code Pipeline | |
| DynamoDB | |
| AWS Step Functions | |

## Setup

**Step 1**: Check IAM permissions

Control Tower will use the "AWSControlTowerAdmin" IAM role to set up the Landing Zone. Make sure that the following policies are available to that role:
- AWSControlTowerAdminPolicy
- AWSOrganizationsFullAccess
- AWSControlTowerServiceRolePolicy

> Note: These policies should be there as default but when I decomissioned the Landing Zone, it took off the policies: "AWSOrganizationsFullAccess" and "AWSControlTowerServiceRolePolicy".

**Step 2**: Launch your AWS Control Tower Landing Zone

Before launching AFT, you need to have a working AWS Control Tower Landing Zone from the AWS console. The "Landing Zone" is a baseline environment for creating other AWS accounts.

The initial set up will walk you through creating 2 news OUs: a required "Foundational" OU (default name is "Security") and an optional OU (default name is "Sandbox"). Change the optional OU name to "Management" because we can create an OU for sandbox whenever we want but we'll need a seperate dedicated OU for managing and orchestrating AFT instructions for the following steps. 

    Note: If you need to decommission the Landing Zone later on follow these steps to save yourself a ton of headache...
    
    Do the following BEFORE decommissioning (in order!):      
    1. Log into the managing accounts for one of the non-root OUs
    2. Add payment information 
    3. Verify phone number 
    4. Delete the "Provisioned Products" from AWS Service Catalog
    5. Deactivate account
    6. Remove account from the OU
    7. Delete the other non-root OUs (go through steps 1-7 for each OU)

    Do the following AFTER deecomissioning (some manual cleanup is required to launch a new Landing Zone):
    1. Delete the CloudWatch Logs log group: aws-controltower/CloudTrailLogs 
    2. The two S3 buckets with reserved names for logs must be removed, or renamed.
    3. Optional: delete the AWS Single Sign-On (AWS SSO) configuration for AWS Control Tower
    4. Optional: Remove the VPC created by AWS Control Tower, and remove the associated AWS CloudFormation stack set.
    5. Before you can set up an AWS Control Tower Landing Zone in a different home Region, you also must run the command `aws organizations disable-aws-service-access --service-principal controltower.amazonaws.com`.

    
**Step 3**: Create an Account for the Management OU via Service Catalog

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

**Step 4**: Create the following GitHub repositories

These can be empty repositories for now but the repositories need to exist to continue. 

| Name | Description |
|------|---------|
| [aft-account-requests](https://github.com/ilhamkabir/aft-account-requests) | Organizational units |
| [aft-global-customizations](https://github.com/ilhamkabir/aft-global-customizations) | Global guardrails |
| [aft-account-customizations](https://github.com/ilhamkabir/aft-account-customizations) | OU/Account specific guardrails |
 
**Step 5**: Ensure that the Terraform environment is available for deployment

Requirements:

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72, < 4.0.0 |

**Step 6**: Create Terraform variables and "apply"

> Note: Changes took about 20min to apply.

**Step 7**: Provide Code Pipeline access to the GitHub repos created above. 

- Step 7.1: Log into the Management OU with the account you created in step 3. 
- Step 7.1: Go to AWS Code Pipeline
- Step 7.2: Go to "Connections" under "Settings" in the left menu panel
- Step 7.3: Confirm the pending connection created in step 6.

**Step 8**: Grant the AFT service role permission to the Control Tower Service Catalog portfolio

> Note: When AFT creates a new OU or provisions existing OU, it will make a call to the Service Catalog in the root OU (from the "Management" OU), which creates/provisions the OU using the CT portfolio. 

- Step 8.1: Go to AWS Service Catalog (in your root account)
- Step 8.2: Go to "Portfolios" in the left menu panel
- Step 8.3: Select the "AWS Control Tower Account Factory" portfolio
- Step 8.4: Under the section "Groups, roles, and users", select "Add groups, roles, and users"
- Step 8.5: Under the "Roles" tab, select "AWSAFTExecution" role and select "Add access"
