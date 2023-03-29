# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------

# terraform {
#   required_version = "~>0.12"
# }

terraform {
  required_version = "~>1.4.2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# provider "aws" {
#   region  = var.aws_region
#   profile = var.aws_profile
# }