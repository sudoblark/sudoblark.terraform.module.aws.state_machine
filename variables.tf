# Input variable definitions
variable "environment" {
  description = "Which environment this is being instantiated in."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be either dev, test or prod"
  }
}

variable "application_name" {
  description = "Name of the application utilising resource."
  type        = string
}

variable "vpc_config" {
  description = "AWS VPC ID"
  type        = string
}

variable "raw_state_machines" {
  description = <<EOF

Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- template_file         : Which file under application/state_machine_definition this machine corresponds to
- template_input        : A dictionary of key/value pairs, outlining in detail the inputs needed for a template to be instantiated
- suffix                : Friendly name for the state function
- iam_policy_statements : A list of dictionaries where each dictionary is an IAM statement defining glue job permissions
-- Each dictionary in this list must define the following attributes:
--- sid: Friendly name for the policy, no spaces or special characters allowed
--- actions: A list of IAM actions the state machine is allowed to perform
--- resources: Which resource(s) the state machine may perform the above actions against
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for


OPTIONAL
---------
- cloudwatch_retention  : How many days logs should be retained for in Cloudwatch, defaults to 90
EOF
  type = list(
    object({
      template_file  = string,
      template_input = map(string),
      suffix         = string,
      iam_policy_statements = list(
        object({
          sid       = string,
          actions   = list(string),
          resources = list(string),
          conditions = optional(list(
            object({
              test : string,
              variable : string,
              values = list(string)
            })
          ), [])
        })
      ),
      cloudwatch_retention = optional(number, 90)
    })
  )
  validation {
    condition = alltrue([
      for state_machine in var.raw_state_machines : (tonumber(state_machine.cloudwatch_retention) >= 0)
    ])
    error_message = "cloudwatch_retention for each state machine should be a valid integer greater than or equal to 0"
  }
}