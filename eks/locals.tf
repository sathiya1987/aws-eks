locals{
  # eks_cluster_subnets_id                                 = var.endpoint_public_access  ? var.public_subnets_cidr : var.private_subnets_cidr
   public_access_cidr                         = var.endpoint_public_access ? var.public_access_cidrs : null
#   key_arn                                    = length(var.kms_key_arn) > 0  ? var.kms_key_arn : null
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    #  version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
  #skip_credentials_validation = true
}