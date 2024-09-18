locals {
  barebones_statemachine_statements = [
    {
      sid = "BarebonesEventActionsForStatemachine"
      actions = [
        "events:PutEvents",
        "events:DescribeRule",
        "events:PutRule",
        "events:PutTargets"
      ]
      resources = [
        "arn:aws:events:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:rule/default/StepFunctionsGetEventsForECSTaskRule",
        "arn:aws:events:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:rule/StepFunctionsGetEventsForECSTaskRule",
        "arn:aws:events:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:event-bus/default"
      ]
      conditions = []
    }
  ]
}