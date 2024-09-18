locals {
  raw_state_machines = [
    {
      suffix : "hello-world",
      template_file : "${path.module}/files/step-function.json",
      template_input : {
        "lambda-arn" : "arn:aws:lambda:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:function:hello-world-function"
      },
      iam_policy_statements : [
        {
          sid : "AllowLambdaExecution",
          actions : [
            "lambda:InvokeFunction",
            "lambda:InvokeAsync",
          ],
          resources : [
            "arn:aws:lambda:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:function:hello-world-function"
          ]
        }
      ]
    }
  ]
}