# NOTE: The contents of this file are hashed and used as a cache key.
#       Please do not add additional resources and only configure terraform and provider versions.
terraform {
  required_version = "=1.3.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.39.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }
  }
}
