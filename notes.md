# Terraform notes

## Terraform state and commands

- `.terraform.lock.hcl` only cares and related to the "providers" section (not "required_providers" section).
- `tfstate` should be stored remotely and no one should have access to it
- `terraform.tfstate.backup` is incremented by changes in the value of "serial field"
- `terraform show` (shows everything about all resources)
- `terraform state list` (show a list of resources deployed)
- `terraform state show $resource name` (show resource metadata)
- `terraform apply -refresh-only` (when you add data block or outputs which is not a resource)
- `terraform providers` shows a tree of all providers used and modules underneath
- `terraform output` (show outputs , you can add `terraform output $outputName`)
- `terraform console` (ex: `var.host.os` can be run to query variables and values)
- `terraform.tfvars`: sensitive file do not send it to the repository accept in certain cases
- `terraform --refresh-only`: terraform will correct your state file to match your infrastructure

## Provisioners

* Install software, edit files, and provision machines created with Terraform.
* It uses 2 different provisioners: "cloud init" and "Packer".
    * Cloud-init: a startup script.
    * Packer: build and push the image to a repository (it's cloud-agnostic).

## Note:
Terraform cannot model the actions of provisioners as part of a plan because they can, in principle, take any action. Successful use of provisioners requires coordinating many more details than Terraform usage usually requires: direct network access to your servers, issuing Terraform credentials to log in, making sure that all of the necessary external software is installed, etc.

### Local exec provisioner

- Allows you to execute local commands after a resource is provisioned (commands are executed where `terraform apply` is run).

### Remote exec provisioner

- Execute commands on the target resource after it is provisioned.

### File provisioner

- Copy a file or directory to the newly created resource, so it has block for ssh connection.

### Null resources

- A placeholder for resources that have no specific association for a provider resource.

## Data sources

- Allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

## Templates

## Variables

- If not set a default value, it will prompt to fill the value at destroy, plan, or apply.
- It's better to optimize Terraform files to work on Linux and Windows machines at the same time, achieved by conditionals.
- None of the argument(s) is required when declaring a terraform variable (NO type, description, default ...)

### Environment variables

- Can be read from pipelines.
- Not the same as input variables and starts with `TF_VAR`.
- E.g.: `export TF_VAR_image_id = imageName`.

### Input variables

- Will be autoloaded automatically if the name is `terraform.tfvars`.
- Will NOT be autoloaded automatically if the name is `dev.tfvars`, `prod.tfvars`... => specify them with the command line: `-var-file dev.tfvar`.
- Will be autoloaded automatically if the name ends with `auto.tfvars` e.g.: `dev.auto.tfvars`, `prod.auto.tfvars`.
- Override variables with the command line e.g.: `-var az-vm-name="az_vm"`.

### Overriding order in variables

- Environment variables < `terraform.tfvars` < `terraform.tfvars.json` < `*.auto.tfvars` or `*.auto.tfvars.json` < `-var` and `-var-file`.

## Output values

- You can output vars as JSON with `terraform output -json`.

## Local values

Assign a name to an expression so you can use it multiple time without repetition.
You can reference a local within a local eg:

```bash
locals
   service_name = "forum"
   owner
                = "Community Team"
 }
 locals
   # Ids for multiple sets of EC2 instances, merged together
   instance_ids = concat(aws_instance. blue.*.id, aws_instance.green.t.id)
 }
locals {
  # Common tags to be assigned to all resources
  common_tags = {
     Service = local. service_name
     Owner
             = local. owner

```

When you reference a local use: local.name NOT locals.name (singular not plural)

DATA SOURCES: allows terraform to use data defined outside of terraform (defined by other terraform configs, or modified by functions)

PROVISIONERS:
install software, edit files, and provision machines created with terraform. It uses 2 different provisioners: "cloud init" and "Packer"
* Cloud init: a startup script 
* Packer: build and push image to a repository (it's cloud agnostic)
	
Firstly, Terraform cannot model the actions of provisioners as part of a plan because they can in principle take any action. Secondly, successful use of provisioners requires coordinating many more details than Terraform usage usually requires: direct network access to your servers, issuing Terraform credentials to log in, making sure that all of the necessary external software is installed, etc.

	LOCAL EXEC provisioner:
	allows you to execute local commands after a resource is provisioned (commands are executed where terraform apply is ran) 

	REMOTE EXEC provisioner:
	execute commands on the target resource after it is provisioned

	FILE provisioner:
	copy a file or directory to the newly created resource so it has a block for ssh connection

	NULL_RESOURCES:
	a placeholder for resources that have no specific association for a provider resource

Terraform modules allow you to publish private modules within the terraform cloud private registry (connect version control git).

## Terraform lock
Terraform's lock feature is used to prevent concurrent updates to the same infrastructure. When a Terraform operation, such as apply, is run, Terraform acquires a lock on the state file to ensure that no other operations are modifying the same state at the same time.

The force-unlock releases the lock:
```bash
terraform force-unlock [options] LOCK_ID
```

## Providers
* you can set an alias for providers and reference them in both child and parents modules
* We can use providers to supply variable values (vault for example).
## Terraform modules
A Terrform module is a group of configuration files that provide common configuration functionality.
* Enforces best practices
* reduce the amount of code
* Reduce time to develop scripts


eg: For creating a simple virtaul machine in Azure: you can use **Compute and network module**.

## the splat and interpolation style
If var.list is a list of objects that all have an attribute id, then a list of the ids could be produced with the following for expression:
```bash
[for o in var.list : o.id]

```
This is equivalent to the following splat expression:
```bash
var.list[*].id
```

The special [*] symbol iterates over all of the elements of the list given to its left and accesses from each one the attribute name given on its right. A splat expression can also be used to access attributes and indexes from lists of complex types by extending the sequence of operations to the right of the symbol:
```bash
var.list[*].interfaces[0].name
```
The above expression is equivalent to the following for expression:
```bash
[for o in var.list : o.interfaces[0].name]
```
## Dynamic blocs
it is supported in resource, data, provider, and provisioner blocks.
Used for dynamic nested blocks:
```bash
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name = "tf-test-name" # can use expressions here

  setting {
    # but the "setting" block is always a literal block
  }
}

```
A dynamic block acts much like a for expression, but produces nested blocks instead of a complex typed value. It iterates over a given complex value, and generates a nested block for each element of that complex value.
```bash
resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = "${aws_elastic_beanstalk_application.tftest.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.4 running Go 1.12.6"

  dynamic "setting" {
    for_each = var.settings
    content {
      namespace = setting.value["namespace"]
      name = setting.value["name"]
      value = setting.value["value"]
    }
  }
}
```
* it is supported in resource, data, provider, and provisioner blocks.
* we recommend using them only when you need to hide details in order to build a clean user interface for a re-usable module. Always write nested blocks out literally where possible.

## terraform HCL
terraform {} : terraform configuration block type is used to configure some behaviours of terraform itself