variable "github_username" {
  type    = string
  default = "ilhamkabir"
}

variable "ct_management_account_id" {}

variable "log_archive_account_id" {}

variable "audit_account_id" {}

variable "aft_management_account_id" {}

variable "ct_home_region" {
  type    = string
  default = "us-east-1"
}

variable "tf_backend_secondary_region" {
  type    = string
  default = "us-west-2"
}
