provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory"
  # Required Vars
  ct_management_account_id    = var.ct_management_account_id
  log_archive_account_id      = var.log_archive_account_id
  audit_account_id            = var.audit_account_id
  aft_management_account_id   = var.aft_management_account_id
  ct_home_region              = var.aws_region
  tf_backend_secondary_region = var.tf_backend_secondary_region
  # VCS Vars
  vcs_provider                                  = "github"
  account_request_repo_name                     = "ExampleOrg/example-repo-1"
  global_customizations_repo_name               = "ExampleOrg/example-repo-2"
  account_customizations_repo_name              = "ExampleOrg/example-repo-3"
}
