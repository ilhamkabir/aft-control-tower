variable "github_username" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "account_id" {}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ct_management_account_id" {}

variable "log_archive_account_id" {}

variable "audit_account_id" {}

variable "aft_management_account_id" {}

variable "tf_backend_secondary_region" {
  type    = string
  default = "us-west-2"
}
