locals {
  actual_state_machines = {
    for state_machine in var.raw_state_machines :
    state_machine.suffix => merge(state_machine, {
      state_machine_definition = templatefile(state_machine.template_file, state_machine.template_input)
      policy_json              = data.aws_iam_policy_document.attached_policies[state_machine.suffix].json
      state_machine_name       = format("%s-%s-%s-stepfunction", var.environment, var.application_name, state_machine.suffix)
    })
  }
}

module "step_function_state_machine" {
  for_each = local.actual_state_machines

  depends_on = [
    data.aws_iam_policy_document.attached_policies
  ]


  source  = "terraform-aws-modules/step-functions/aws"
  version = "4.2.0"

  name         = each.value["state_machine_name"]
  create_role  = true
  policy_jsons = [each.value["policy_json"]]

  definition = each.value["state_machine_definition"]

  logging_configuration = {
    "include_execution_data" = true
    "level"                  = "ALL"
  }
  cloudwatch_log_group_name              = "/aws/vendedlogs/states/${each.value["state_machine_name"]}"
  cloudwatch_log_group_retention_in_days = each.value["cloudwatch_retention"]

  service_integrations = {
    stepfunction_Sync = {
      # Set to true to use the default events (otherwise, set this to a list of ARNs; see the docs linked in locals.tf
      # for more information). Without events permissions, you will get an error similar to this:
      #   Error: AccessDeniedException: 'arn:aws:iam::xxxx:role/step-functions-role' is not authorized to
      #   create managed-rule
      events = true
    }
  }
}