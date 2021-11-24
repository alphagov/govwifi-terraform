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

Example ENVs are: `wifi`, `wifi-london`, `staging-london-temp`, and `staging-dublin-temp`

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

### Setting Up Remote State
We use remote state, but there is a chicken and egg problem of creating
a state bucket in which to store the remote state. When you are first creating a
new environment (or migrating an environment not using remote state to use
remote state) you will need to do the following

Comment out the section
```
terraform {
  backend          "s3"             {}
}
```
in the main.tf file of the environment to be migrated

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

### Manual Steps Needed to Set Up a New Environment

#### Create RADIUS EIPs
We currently need to create the Radius EIPs manually and then import them into terraform using the following command:
```
make <environment-name> terraform terraform_cmd="import module.frontend.aws_eip.radius_eips[0] <ip_address>"
```
Create six new EIPs (see here for more information [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-allocating)). Three in the eu-west-1 region (Ireland) and three in the eu-west-2 (London) region. These values then need to be added to the govwifi-build repo under the `non-encrypted` directory for your environment (see [here](https://github.com/alphagov/govwifi-build/blob/21bf25b34ed12995b3246016b0193cf46e2c8d2d/non-encrypted/secrets-to-copy/govwifi/wifi-london/variables.auto.tfvars#L33-L37) for an example).

#### Create Prometheus & Grafana EIPs
Follow the process outlined above to create the Prometheus & Grafana EIPs manually. Create three new EIPs, one in the eu-west-1 region, two in the eu-west-2 region. These values then need to be added to the govwifi-build repo under the non-encrypted variables directory for your environment (see [here](https://github.com/alphagov/govwifi-build/blob/21bf25b34ed12995b3246016b0193cf46e2c8d2d/non-encrypted/secrets-to-copy/govwifi/staging-london-temp/variables.auto.tfvars#L29-L33) for an example).

After this is done import them into terraform using the following command:
```
make <environment-name> terraform terraform_cmd="import <name_of_terraform_resource> <ip_address>"
```

#### Confirm SNS subscriptions
At present confirming SNS subscriptions needs to be done manually. To do this follow the steps below:
1. Ensure you have fully created the infrastructure for the [Logging API](https://github.com/alphagov/govwifi-logging-api).
1. Ensure the Logging API app has been deployed to the new environment via our [CI/CD pipeline](https://govwifi-dev-docs.cloudapps.digital/infrastructure/continuous-delivery.html#govwifi-concourse).
1. Login to the AWS Console and navigate to the Cloudwatch section. Locate the Logging API logs group (this will be named <environment-name>-logging-api-docker-log-group).
1. Search the logs for the word "SubscriptionConfirmation"
1. The result will be a long string which begins similarly to:
```
{
  "Type" : "SubscriptionConfirmation",
  "MessageId" : "165545c9-2a5c-472c-8df2-7ff2be2b3b1b",
  "Token" : "2336412f37...",
```
1. Copy the value for `Token`
1. Go to SNS, select the subscription you need to confirm, select the "Confirm Subscription" button and paste the token into the input field.
1. You can find detailed information about this process in [AWS's documentation](https://docs.aws.amazon.com/sns/latest/dg/sns-message-and-json-formats.html).

#### Configure SES Rulesets
Terraform currently does not provide a way to do this for us.
1. Login to the AWS console and ensure you are in the eu-west-1 region (Ireland).
1. Go to the SES section and select "Email receiving”.
1. Select “Create rule set” and enter the name “GovWifiRuleSet”.

#### Configure SES to Send Email
Ensure you are in the eu-west-1 region (Ireland) and follow the instructions here(https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dkim-easy-setup-domain.html) to verify your new subdomain (e.g. staging.wifi.service.gov.uk)

## Rotating ELB Certificates

To rotate the ELB ACM certificates, you need to create a new certificate in the
aws console, with the domain name required, or by running the following from the
cli

```
AWS_DEFAULT_REGION=<region> aws acm request-certificate --domain-name <domain-name> --domain-validation-options DomainName=<domain-name>,ValidationDomain=<validation-domain>
```

Where validation-domain is wifi.service.gov.uk for prod, and wifi.staging.service.gov.uk for staging

Once this is created, you will need to validate the domain. There is some logic
to listen to emails on the required domain and copy them to an s3 bucket in the
govwifi-terraform repo. You can look in the `<ENV>-admin-emailbucket` to find
this - it will likely be the last modified file. You can also use the CLI

```
aws s3 ls s3://<ENV>-admin-emailbucket/
aws s3 cp s3://<ENV>-admin-emailbucket/<filename-of-last-modified-file> -
```

Find the validation link and load it in a browser

You can then update the `elb-ssl-cert-arn` secret value in the terraform secrets
file for the environment to be updated to be the arn of your newly requested
certificate, and apply terraform

Once you have applied terraform, you should clean up the unused certificates in
the console

## How to contribute

1. Create a feature or fix branch
2. Make your changes
3. Run `make format` to format Terraform code
4. Raise a pull request

### Style guide

Terraform's formatting tool takes care of much of the style, but there are some additional points.

#### Naming

When naming resources, data sources, variables, locals and outputs, only use underscores to separate words. For example:

```terraform
resource "aws_iam_user_policy" "backup_s3_read_buckets" {
  ...
```

#### Trailing newlines

All lines in a file should end in a terminating newline character, including the last line. This helps to avoid unnecessary diff noise where this newline is added after a file has been created.

## License

This codebase is released under [the MIT License][mit].

[mit]: LICENSE
