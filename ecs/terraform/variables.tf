data "aws_caller_identity" "current" {}

locals {
  aws_account_id  = data.aws_caller_identity.current.account_id

  common_tags = {
    application_name = var.application_name
    created_by       = var.created_by
    created_with     = "Terraform"
  }
}

variable "application_name" {
  type        = string
  description = "The name of application that is being deployed, will be used in the naming of resources"
}

variable "aws_profile" {
  type        = string
  description = "The name of the AWS profile name as set in the shared credentials file."
}

variable "aws_region" {
  type        = string
  description = "The region in which the AWS resources will be deployed."
}

variable "created_by" {
  type        = string
  description = "The name of the user that created the resources, to be used in resource tagging"
}

variable "subnet_id" {
  type        = string
  description = "The subnet associated with the service"
}
