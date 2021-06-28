# 変数定義
variable aws_access_key {}
variable aws_secret_key {}
variable aws_region {}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"  //tfenv 2.2.2
    }
  }
}

provider "aws" {
  region  = var.aws_region
}