# Account Factory Terraform - Control Tower

Account Factory for Terraform is a Terraform module maintained by the AWS Control Tower team built to automate the process of account creation, provisioning, and governance.

<img src="https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2021/11/12/aws-control-tower-account-factory-for-terraform-diagram.png" alt="aws-control-tower-account-factory-for-terraform-diagram" width="600"/>

## AWS Resource Glossary

| Name | Description |
|------|------|
| Control Tower | An AWS resource that allows you to set up and govern a multi-account (where each account is called an "Organizational Unit", or "OU") AWS environment. |
| Servcie Catalog | An AWS resource allows you to create and organize a curated catalog of other AWS resources (into "portfolios"), shared to specific OUs or permission levels. |
| Code Pipeline | |

## Setup

**Step 1**: Launch your AWS Control Tower landing zone

Before launching AFT, you need to have a working AWS Control Tower landing zone from the AWS console. The "landing zone" is a baseline environment for creating other AWS accounts.

The initial set up will walk you through creating 2 news OUs: a required "Foundational" OU (default name is "Security") and an optional OU (default name is "Sandbox"). Change the optional OU name to "Management" because we can create an OU for sandbox whenever we want but we'll need a seperate dedicated OU for managing and orchestrating AFT instructions for the following steps. 

> Note: If you need to decommission the landing zone later on, make sure you delete its child organizations and accounts before. Otherwise, you'll have to contact support to do it after!

**Step 2**: Create an Account for the Management OU via Service Catalog

- Step 2.1: Go to AWS Service Catalog
- Step 2.2: Go to "Products" on the left menu panel 
- Step 2.3: Select and launch "AWS Control Tower Account Factory"
- Step 2.4: Fill out the form:

    | Field | Value |
    |------|---------|
    | Provisioned product name | Controller |
    | AccountEmail | ***** |
    | AccountName | controller |
    | MangedOrganizationalUnit | Managment |
    | SSOUserEmail | ***** |
    | SSOUserFirstName | ***** |
    | SSOUserLastName | ***** |

**Step 3**: Create the following GitHub repositories

These can be empty repositories for now but the repositories need to exist to continue. 

| Name | Description |
|------|---------|
| [aft-account-requests](https://github.com/ilhamkabir/aft-account-requests) | Organizational units |
| [aft-global-customizations](https://github.com/ilhamkabir/aft-global-customizations) | Global guardrails |
| [aft-account-customizations](https://github.com/ilhamkabir/aft-account-customizations) | OU/Account specific guardrails |
 
**Step 4**: Ensure that the Terraform environment is available for deployment

Requirements:

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72, < 4.0.0 |

**Step 5**: Create Terraform variables and "apply"

> Note: Changes took about 20min to apply.

**Step 6**: Provide Code Pipeline access to the GitHub repos created above. 

- Step 6.1: Go to AWS Code Pipeline
- Step 6.2: Go to "Connections" under "Settings" in the left menu panel
- Step 6.3: Confirm the pending connection created in step 5.

**Step 7**: Grant the AFT service role permission to the Control Tower Service Catalog portfolio

- Step 7.1: Go to AWS Service Catalog
- Step 7.2: Go to "Portfolios" in the left menu panel
- Step 7.3: Select the "AWS Control Tower Account Factory" portfolio
- Step 7.4: Under the section "Groups, roles, and users", select "Add groups, roles, and users"
- Step 7.5: Under the "Roles" tab, select "AWSAFTExecution" role and select "Add access"
