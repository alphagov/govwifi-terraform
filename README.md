# Govwifi terraform

This repository contains instructions on how to build GovWifi end-to-end - the sites, services and infrastructure.

## Table of Contents

- [Overview](#overview)
- [Secrets](#secrets)
- [Running terraform for the first time](#running-terraform-for-the-first-time)
- [Running terraform](#running-terraform)
- [Bootstrapping terraform](#bootstrapping-terraform)
- [Rotating ELB Certificates](#rotating-ELB-certificates)
- [Performance Testing](#performance-testing)
  - [Infrastructure](#infrastructure)
  - [Testing](#testing)
    - [Caveat](#caveat)
  - [Testing scripts](#testing-scripts)
  - [Running the tests](#running-the-tests)

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

Please see: [GovWifi build](https://github.com/alphagov/govwifi-build)

## Running terraform for the first time

Initialise terraform if running for the first time:

```
make <ENV> init-backend
make <ENV> plan
```

## Running terraform

```
make <ENV> plan
make <ENV> apply
```

Use the `terraform_target` command to run a targeted `plan | apply`:

```bash
$ make <env> terraform_target terraform_cmd="<plan | apply> -target=<module name>"
```

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
make <env> plan
```
And then

```
make <env> apply
```

This should create the remote state bucket for you if migrating, or create the
entire infrastructure with a local state file if creating a new env

Then uncomment the backend section and run

```
make <env> init-backend
```

Then run

```
make <env> apply
```

This should then copy the state file to s3 and use this for all operations


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
govwifi-terraform repo. You can look in the `<env>-admin-emailbucket` to find
this - it will likely be the last modified file. You can also use the CLI

```
aws s3 ls s3://<env>-admin-emailbucket/
aws s3 cp s3://<env>-admin-emailbucket/<filename-of-last-modified-file> -
```

Find the validation link and load it in a browser

You can then update the `elb-ssl-cert-arn` secret value in the terraform secrets
file for the environment to be updated to be the arn of your newly requested
certificate, and apply terraform

Once you have applied terraform, you should clean up the unused certificates in
the console

## How to contribute

1. Fork the project
2. Create a feature or fix branch
3. Make your changes (with tests if applicable)
4. Run `terraform fmt` to ensure code is formatted correctly
5. Raise a pull request

## License

This codebase is released under [the MIT License][mit].

[mit]: LICENSE