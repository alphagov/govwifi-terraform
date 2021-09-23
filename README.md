# Govwifi terraform

This repository contains instructions on how to build GovWifi end-to-end - the sites, services and infrastructure.

## Table of Contents

- [Overview](#overview)
- [Secrets](#secrets)
- [Running terraform for the first time](#running-terraform-for-the-first-time)
- [Running terraform](#running-terraform)
- [Bootstrapping terraform](#bootstrapping-terraform)
- [Rotating ELB Certificates](#rotating-ELB-certificates)

## Overview
Our public-facing websites are:
- A [product page](https://github.com/alphagov/govwifi-product-page) explaining the benefits of GovWifi
- An [admin platform](https://github.com/alphagov/govwifi-admin) for organisations to self-serve changes to their GovWifi installation
- [Technical documentation](https://github.com/alphagov/govwifi-tech-docs), explaining GovWifi in more detail
- A [redirection service](https://github.com/alphagov/govwifi-redirect) to handle "www" requests to these sites

Our services include:
- [Frontend servers](https://github.com/alphagov/govwifi-frontend), instances of FreeRADIUS that act as authentication servers and use [FreeRADIUS Prometheus Exporter](https://github.com/bvantagelimited/freeradius_exporter) to measure server stats
- An [authentication API](https://github.com/alphagov/govwifi-authentication-api), which the frontend calls to help authenticate GovWifi requests
- A [logging API](https://github.com/alphagov/govwifi-logging-api), which the frontend calls to record each GovWifi request
- A [user signup API](https://github.com/alphagov/govwifi-user-signup-api), which handles incoming sign-up texts and e-mails (with a little help from AWS)
- A Prometheus server to scrape metrics from the FreeRADIUS Prometheus Exporters which exposes FreeRADIUS server data

We manage our infrastructure via:
- Terraform, split across this repository and [govwifi-terraform](https://github.com/alphagov/govwifi-terraform)
- The [safe restarter](https://github.com/alphagov/govwifi-safe-restarter), which uses a [CanaryRelease](https://martinfowler.com/bliki/CanaryRelease.html) strategy to increase the stability of the frontends

Other repositories:
- [Acceptance tests](https://github.com/alphagov/govwifi-acceptance-tests), which pulls together GovWifi end-to-end, from the various repositories, and runs tests against it.

## Secrets

Sensitive credentials are stored in AWS Secrets Manager in the format of `<service>/<item>` (`<item>` must be hyphenated not underscored).

`service` will be the GovWifi service (admin, radius, user-signup, logging) related to that secret. If the secret is not specific to a GovWifi service, use the AWS service or product it relates to (e.g., rds, s3, grafana).

For historical use of secrets please see: [GovWifi build](https://github.com/alphagov/govwifi-build)

## Running terraform for the first time

Initialise terraform if running for the first time:

```
make <ENV> init-backend
make <ENV> plan
```

Example ENVs are: wifi, wifi-london, staging-london-temp and staging-dublin-temp

## Running terraform

```
make <ENV> plan
make <ENV> apply
```

### Running terraform target

Terraform allows for ["resource targeting"](https://www.terraform.io/docs/cli/commands/plan.html#resource-targeting), or running `plan`/`apply` on specific modules. 

We've incorporated this functionality into our `make` commands. **Note**: this should only be done in exceptional circumstances.

To retrieve a module name, run a `terraform plan` and copy the module name (EXCLUDING "module.") from the Terraform output:

```bash
$ make staging plan
...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.api.aws_iam_role_policy.some_policy  <-- module name
...
```

In this case, the module name would be `api.aws_iam_role_policy.some_policy`

To `plan`/`apply` a specific resource use the standard `make <ENV> plan | apply` followed by a space separated list of one or more modules:

```
$ make <ENV> plan modules="backend.some.resource api.some.resource"
$ make <ENV> apply modules="frontend.some.resource"
```

If combining other Terraform commands (e.g., `-var` or `-replace`) with targeting a resource, use the `terraform_target` command:

```bash
$ make <ENV> terraform_target terraform_cmd="<plan | apply> -replace <your command>"
```

#### Deriving module names

You can also derive the `module` by combining elements from the module declaration, the AWS resource type, and the resource name.

Module names are made up of four main parts: `module` (default AWS naming convention), `module name` (found in `govwifi/*/main.tf` files), the AWS resource type, and the AWS resource name.

Modules are declared in `main.tf`, like this example from `govwifi/staging/main.tf`:

```text
module "backend" {
    // A bunch of variables being set
}
```

For example, to derive the bastion instance module name:

1. Find where the instance resource is declared (in this case `govwifi-backend/management.tf`).
2. Note the resource type for that component (`aws_instance`) and the resource name (`management`) in `govwifi-backend/management.tf`. 
3. Find where the module is declared in `govwifi/*/main.tf`; typically the module name matches the name of the directory where the resource is declared minus the `govwifi` prefix. So for `govwifi-backend`, there's a module declaration for `backend` in each of the `main.tf` files in `govwifi/*`.
4. Build the `module` using the components: `module`, `backend`, `aws_instance`, `management`.

It should look like this, `module.backend.aws_instance.management`:

| AWS default | module declaration name | AWS resource type | AWS resource name | 
| :----: | :----: | :----: | :----: |
| module  | backend | aws_instance | management |

## Bootstrapping terraform

Because we use remote state, but there is a chicken and egg problem of creating
a state bucket in which to store the remote state, when you are first creating a
new environment or migrating and environment not using remote state to use
remote state, you will need to do the following

Comment out the section
```
terraform {
  backend          "s3"             {}
}
```
in the main.tf file of the new environment / environment to be migrated

Run

```
make <ENV> plan
```
And then

```
make <ENV> apply
```

This should create the remote state bucket for you if migrating, or create the
entire infrastructure with a local state file if creating a new env

Then uncomment the backend section and run

```
make <ENV> init-backend
```

Then run

```
make <ENV> apply
```

This should then copy the state file to s3 and use this for all operations

## How to contribute

1. Create a feature or fix branch
2. Make your changes
3. Run `make format` to format Terraform code
4. Raise a pull request

### Style guide

Terraform's formatting tool takes care of much of the style, but there are some additional points.

#### Naming resources

When naming resources, only use underscores to separate words. For example:

```terraform
resource "aws_iam_user_policy" "backup_s3_read_buckets" {
  ...
```

#### Trailing newlines

All lines in a file should end in a terminating newline character, including the last line. This helps to avoid unnecessary diff noise where this newline is added after a file has been created.

## License

This codebase is released under [the MIT License][mit].

[mit]: LICENSE
