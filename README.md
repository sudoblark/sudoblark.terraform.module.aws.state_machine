# sudoblark.terraform.module.aws.state_machine
Terraform module to create N number of state machines with custom IAM policies.. - repo managed by sudoblark.terraform.github

## Developer documentation
The below documentation is intended to assist a developer with interacting with the Terraform module in order to add,
remove or update functionality.

### Pre-requisites
* terraform_docs

```sh
brew install terraform_docs
```

* tfenv
```sh
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

* Virtual environment with pre-commit installed

```sh
python3 -m venv venv
source venv/bin/activate
pip install pre-commit
```
### Pre-commit hooks
This repository utilises pre-commit in order to ensure a base level of quality on every commit. The hooks
may be installed as follows:

```sh
source venv/bin/activate
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

# Module documentation
The below documentation is intended to assist users in utilising the module, the main thing to note is the
[data structure](#data-structure) section which outlines the interface by which users are expected to interact with
the module itself, and the [examples](#examples) section which has examples of how to utilise the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_step_function_state_machine"></a> [step\_function\_state\_machine](#module\_step\_function\_state\_machine) | terraform-aws-modules/step-functions/aws | 4.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.attached_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application utilising resource. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Which environment this is being instantiated in. | `string` | n/a | yes |
| <a name="input_raw_state_machines"></a> [raw\_state\_machines](#input\_raw\_state\_machines) | Data structure<br>---------------<br>A list of dictionaries, where each dictionary has the following attributes:<br><br>REQUIRED<br>---------<br>- template\_file         : File path which this machine corresponds to<br>- template\_input        : A dictionary of key/value pairs, outlining in detail the inputs needed for a template to be instantiated<br>- suffix                : Friendly name for the state function<br>- iam\_policy\_statements : A list of dictionaries where each dictionary is an IAM statement defining glue job permissions<br>-- Each dictionary in this list must define the following attributes:<br>--- sid: Friendly name for the policy, no spaces or special characters allowed<br>--- actions: A list of IAM actions the state machine is allowed to perform<br>--- resources: Which resource(s) the state machine may perform the above actions against<br>--- conditions    : An OPTIONAL list of dictionaries, which each defines:<br>---- test         : Test condition for limiting the action<br>---- variable     : Value to test<br>---- values       : A list of strings, denoting what to test for<br><br><br>OPTIONAL<br>---------<br>- cloudwatch\_retention  : How many days logs should be retained for in Cloudwatch, defaults to 90 | <pre>list(<br>    object({<br>      template_file  = string,<br>      template_input = map(string),<br>      suffix         = string,<br>      iam_policy_statements = list(<br>        object({<br>          sid       = string,<br>          actions   = list(string),<br>          resources = list(string),<br>          conditions = optional(list(<br>            object({<br>              test : string,<br>              variable : string,<br>              values = list(string)<br>            })<br>          ), [])<br>        })<br>      ),<br>      cloudwatch_retention = optional(number, 90)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | AWS VPC ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Data structure
```
Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- template_file         : File path which this machine corresponds to
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
```

## Examples
See `examples` folder for an example setup.
