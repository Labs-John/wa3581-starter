variables {
  queue_name_prefix = "lab03-test-defaults"
  # enable_dlq defaults to true in the module
  # tags default to {} in the module
}


run "plan_default_settings" {
    command = plan
    # No assert needed; success means plan executes without errors
}


run "apply_and_check_outputs" {
  command = apply

  assert {
    condition     = output.main_queue_arn != null && substr(output.main_queue_arn, 0, 12) == "arn:aws:sqs:"
    error_message = "Main queue ARN should be a valid SQS ARN."
  }
  assert {
    condition     = output.kms_key_arn != null && substr(output.kms_key_arn, 0, 12) == "arn:aws:kms:"
    error_message = "KMS key ARN should be a valid KMS ARN."
  }
  assert {
    # DLQ is enabled by default, so its ARN should be present
    condition     = output.dlq_arn != null && substr(output.dlq_arn, 0, 12) == "arn:aws:sqs:"
    error_message = "DLQ ARN should be a valid SQS ARN when DLQ is enabled."
  }
}


run "fail_on_empty_prefix" {
  variables {
    queue_name_prefix = ""
  }
  command = plan

  expect_failures = [
    var.queue_name_prefix
  ]
}