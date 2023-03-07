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
gds aws <ENV> -- make <ENV> init-backend
gds aws <ENV> -- make <ENV> plan
```

Example ENVs are: `wifi`, `wifi-london` and `staging`.

## Running terraform

```
gds aws <ENV> -- make <ENV> plan
gds aws <ENV> -- make <ENV> apply
```

### Running terraform target

Terraform allows for ["resource targeting"](https://www.terraform.io/docs/cli/commands/plan.html#resource-targeting), or running `plan`/`apply` on specific modules.

We've incorporated this functionality into our `make` commands. **Note**: this should only be done in exceptional circumstances.

To retrieve a module name, run a `terraform plan` and copy the module name (EXCLUDING "module.") from the Terraform output:

```bash
$ gds aws <ENV> -- make staging plan
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
$ gds aws <ENV> -- make <ENV> plan modules="backend.some.resource api.some.resource"
$ gds aws <ENV> -- make <ENV> apply modules="frontend.some.resource"
```

If combining other Terraform commands (e.g., `-var` or `-replace`) with targeting a resource, use the `terraform_target` command:

```bash
$ gds aws <ENV> -- make <ENV> terraform_target terraform_cmd="<plan | apply> -replace <your command>"
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
You will need to run terraform in the **eu-west-2 (London) region** first. If you try to run terraform in the eu-west-1 region first, you will encounter errors because the Dublin Terraform looks up outputs from the London region statefile.

### Create The Access Logs S3 Bucket

This holds information related to the terraform state, and must be created manually before the initial terraform run in a new environment. You will need to create two S3 buckets. One in eu-west-1 and one in eu-west-2. The bucket name must match this naming convention:

`govwifi-<ENV>-<AWS-REGION-NAME>-accesslogs`

An example command for creating the bucket in the Staging environment for the London region would be:

```
gds aws govwifi-staging -- aws s3api create-bucket --bucket govwifi-staging-london-accesslogs --region eu-west-2 
```

### Setting Up Remote State
We use remote state, but there is a chicken and egg problem of creating a state bucket in which to store the remote state. When you are first creating a new environment (or migrating an environment not using remote state to use remote state) you will need to do the following

Comment out the section
```
terraform {
  backend          "s3"             {}
}
```
in the main.tf file of the environment to be migrated. Then comment out the lines related to replication configuration in govwifi-terraform/terraform-state/accesslogs.tf and govwifi-terraform/terraform-state/tfstate.tf.
```
replication_configuration{
  ....
}
```
The first time terraform is run in a new environment the replication configuration lines need to be commented out because the replication bucket in eu-west-1 will not yet exist. Leaving these lines uncommented will cause an error.

Now run

```
gds aws <ENV> -- make <ENV> plan
```
And then

```
gds aws <ENV> -- make <ENV> apply
```

This should create the remote state bucket for you if migrating, or create the
entire infrastructure with a local state file if creating a new env

Then uncomment the backend section in main.tf and run

```
gds aws <ENV> -- make <ENV> init-backend
```

Then run

```
gds aws <ENV> -- make <ENV> apply
```

This should then copy the state file to s3, which will be used for all operations. Once you have run terraform in both regions, and the S3 buckets used for the access log replication have been created, uncomment the replication configuration sections in govwifi-terraform/terraform-state/accesslogs.tf and govwifi-terraform/terraform-state/tfstate.tf.

### Manual Steps Needed to Set Up a New Environment

#### Add DKIM Authentication
Ensure you are in the eu-west-1 region (Ireland) and follow the instructions here(https://docs.aws.amazon.com/ses/latest/DeveloperGuide/send-email-authentication-dkim-easy-setup-domain.html) to verify your new subdomain (e.g. staging.wifi.service.gov.uk)

#### Activate SES Rulesets
The SES ruleset must be manually activated. 
1. Login to the AWS console and ensure you are in the eu-west-1 region (Ireland).
1. Go to the SES section and select "Email receiving”.
1. Select  “GovWifiRuleSet” from the list
1. Select the "Set as active" button

#### Setting Up Deployment Pipelines For A New GovWifi Environment

Our deploy pipelines exist in a separate account. You can access it with the following command:

` gds aws govwifi-tools -l`

In order to deploy applications you will need to create a new set of pipelines for that environment.
- There are set of template terraform files for creating pipelines for a new environment in govwifi-terraform/tools/pipeline-templates. You can copy these across manually and change the names or you can use the commands below. ** All commands are run from the govwifi-terraform root directory **
- Copy all the pipeline terraform template files in `govwifi-terraform/tools/pipeline-templates` to the govwifi-deploy directory:

```
for filename in tools/pipeline-templates/*your-env-name*;  do cp -Rp $filename ./govwifi-deploy/$(basename $filename) ; done

```

- Update the names of the terraform resources in the template files to match your new environment

```
for filename in ./govwifi-deploy/*your-env-name* ; do sed -i '' 's/your-env-name/<ENV_NAME>/g' $filename ; done
```

- Change the names of the files to match your new environment (change  **<NEW-ENV-NAME>** to your new environment name e.g. "dev")

```
for filename in ./govwifi-deploy/*your-env-name* ; do mv $filename ${filename/your-env-name/<NEW-ENV-NAME>}  ; done
```

##### Updating Other Pipeline files:

You will also need to do the following in the tools account: 

- Add the new environment's account number to AWS Secrets Manager, and then add it to terraform, [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-d94ff418330c275e25ef2b45b9d7d2dd4a9ef3720db62dd38073bd72773562d4). 
- Add your new AWS account ID as a local variable in the govwifi-deploy module, [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-80629d600c5574b9e7d4dc7ba991ce39068d32cabd1046130d5e8e4827460f77). 
- An ECR repository for your new environment,  [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-62eed9657e3fa19b6a5801b47b549ab70711b54c5997c50fb90a395653cccf9d).
- Give the GovWifi Tools account permission to deploy things in your new environment
  - Add appropriate S3 access: [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-d94ff418330c275e25ef2b45b9d7d2dd4a9ef3720db62dd38073bd72773562d4).
  - Add appropriate codepipeline permissions [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-02cf364873b2fce26391e6e2b6d9ed222ce8e8f23f7d745e5c8024b02a932389).
  - Allow your new environment to access the KMS keys used by Codepipeline [see here for an example](https://github.com/alphagov/govwifi-terraform/pull/777/commits/5482ac674b74b946b66040e158101bd4aa703a44#diff-8a01e39d3fd4d4d2ee124f9f0c45495bb36677f5384040c59ff023b3f517032d).
  


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
