locals {
  actual_iam_policy_documents = {
    for state_machine in var.raw_state_machines :
    state_machine.suffix => {
      statements = concat(state_machine.iam_policy_statements, local.barebones_statemachine_statements,
        [
          {
            sid = "ListOwnExecutions",
            actions = [
              "states:ListExecutions"
            ]
            resources = [
              format(
                "arn:aws:states:%s:%s:stateMachine:%s-%s-%s-stepfunction",
                lower(data.aws_region.current_region.name),
                lower(data.aws_caller_identity.current_account.id),
                lower(var.environment),
                lower(var.application_name),
                lower(state_machine.suffix)
              )
            ]
            conditions = []
          },
          {
            sid = "AllowCloudwatchStreamAccess",
            actions = [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            resources = [
              "arn:aws:logs:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:log-group:/aws/stepfunction/${format("%s-%s-%s-stepfunction", var.environment, var.application_name, state_machine.suffix)}",
              "arn:aws:logs:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:log-group:/aws/stepfunction/${format("%s-%s-%s-stepfunction", var.environment, var.application_name, state_machine.suffix)}:*"
            ]
            conditions = []
          },
          {
            sid = "AllowCloudwatchLogDelivery",
            actions = [
              "logs:CreateLogDelivery",
              "logs:PutResourcePolicy",
              "logs:UpdateLogDelivery",
              "logs:DeleteLogDelivery",
              "logs:DescribeResourcePolicies",
              "logs:GetLogDelivery",
              "logs:ListLogDeliveries",
              "logs:DescribeLogGroups"
            ],
            resources  = ["*"]
            conditions = []
          }
        ]
      )
    }
  }
}

data "aws_iam_policy_document" "attached_policies" {
  for_each = local.actual_iam_policy_documents

  dynamic "statement" {
    for_each = each.value["statements"]

    content {
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]

      dynamic "condition" {
        for_each = statement.value["conditions"]

        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}