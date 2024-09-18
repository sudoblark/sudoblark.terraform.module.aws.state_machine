terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "step_function" {
  source = "github.com/sudoblark/sudoblark.terraform.module.aws.state_machine?ref=1.0.0"

  application_name   = var.application_name
  environment        = var.environment
  raw_state_machines = local.raw_state_machines
}