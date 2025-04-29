terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Random provider might be needed if module uses it (e.g., for unique names)
    # It wasn't strictly needed by the SQS module itself, but good practice
    # if sub-components might need randomness. Let's assume it might be needed.
     random = {
       source = "hashicorp/random"
       version = "~> 3.1"
     }
  }
}

provider "aws" {
  region = "us-west-2" // Ensure correct region
}

module "secure_queue_test" {
  source = "./modules/sqs-secure" # Relative path to local module within lab02

  queue_name_prefix = "adv-tf-lab02-test"
  enable_dlq        = true # Explicitly enable for testing
  tags = {
    Environment = "lab02-test"
    Project     = "Advanced TF Course"
  }
}

output "test_main_queue_arn" {
  description = "Output from the test module call: Main Queue ARN"
  value       = module.secure_queue_test.main_queue_arn
}

output "test_main_queue_url" {
  description = "Output from the test module call: Main Queue URL"
  value       = module.secure_queue_test.main_queue_url
}

output "test_dlq_arn" {
  description = "Output from the test module call: DLQ ARN"
  value       = module.secure_queue_test.dlq_arn
}

output "test_kms_key_arn" {
  description = "Output from the test module call: KMS Key ARN"
  value       = module.secure_queue_test.kms_key_arn
}