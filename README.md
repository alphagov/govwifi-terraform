# Govwifi build

This repository contains instructions on how to build GovWifi end-to-end - the sites, services and infrastructure.

## Table of Contents

- [Overview](#overview)
- [Secrets](#secrets)
  - [Getting access to secrets](#getting-access-to-secrets)
  - [Adding secrets to the repo](#adding-secrets-to-the-repo)
- [Runnning terraform](#runnning-terraform)
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
- An [admin platform](https://github.com/alphagov/govwifi-admin) for organiations to self-serve changes to their GovWifi installation
- [Technical documentation](https://github.com/alphagov/govwifi-tech-docs), explaining GovWifi in more detail
- A [redirection service](https://github.com/alphagov/govwifi-redirect) to handle "www" requests to these sites

Our services include:
- [Frontend servers](https://github.com/alphagov/govwifi-frontend), instances of freeRADIUS that act as authentication servers
- An [authentication API](https://github.com/alphagov/govwifi-authentication-api), which the frontend calls to help authenticate GovWifi requests
- A [logging API](https://github.com/alphagov/govwifi-logging-api), which the frontend calls to record each GovWifi request
- A [user signup API](https://github.com/alphagov/govwifi-user-signup-api), which handles incoming sign-up texts and e-mails (with a little help from AWS)

We manage our infrastructure via:
- Terraform, split across this repository and [govwifi-terraform](https://github.com/alphagov/govwifi-terraform)
- [Ansible](https://github.com/alphagov/govwifi-ansible) to update our frontend servers in place
- [Jenkins-specific Ansible](https://github.com/alphagov/govwifi-jenkins-ansible) to update our build server in place.
- The [safe restarter](https://github.com/alphagov/govwifi-safe-restarter), which uses a [CanaryRelease](https://martinfowler.com/bliki/CanaryRelease.html) strategy to increase the stability of the frontends

Other repositories:
- [Acceptance tests](https://github.com/alphagov/govwifi-acceptance-tests), which pulls together GovWifi end-to-end, from the various repositories, and runs tests against it.

## Secrets

The secrets are encrypted using [password store](https://www.passwordstore.org/)
in the `.private/passwords` subdirectory. There is a make target to run terraform, which
will temporarily unencrypt the secrets, run terraform and clean up after so the
secrets are not saved on disk.

These are also kept within a private repo, to further reduce the potential of secrets
being exposed.

### Getting access to secrets

You need to give your gpg key id to someone on the team with access to the
secrets,

To publish a key to a keyserver use

```
gpg --send-keys --keyserver hkp://pgp.mit.edu
```

And then let them know the fingerprint - the long hex digits after the following command

```
gpg -K --fingerprint
```

Then ask them to run

```
PASSWORD_STORE_DIR=passwords pass init <keyids>
```

Where `<keyids>` is a space separated list of GPG key ids.  You can see the
current list in `passwords/.gpg-id`.

And commit the changes. This will re encrypt the password store dir. They will
need to import and sign your key first


### Adding secrets to the repo

The Makefile assumes there is a file in the password store with the path
`$env/secrets.tf`.

```
PASSWORD_STORE_DIR=passwords pass edit terraform/$env/secrets.tf
```

The format of the file is a [terraform vars file](https://www.terraform.io/intro/getting-started/variables.html#from-a-file)

You can also insert a secret to be copied during the build proccess - for this
use the `scripts/insert-secret.sh $pathandfilename` - this will add the secret to the
correct place in the password store, so it can be copied back in the required
place.

## Runnning terraform

```
make <ENV> plan
make <ENV> apply
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

## Performance Testing

In order to understand the capabilities of our new infrastructure and applications we performance test it first.

### Infrastructure

The Terraform provisioning scripts for this are contained in the `performance-testing` module.
Call this module, passing in all the required arguments in your `main.tf` file.
You can find an example of this in `performance-london/main.tf`

### Testing

In order to generate realistic traffic, you will need list of fake user details.
These will be used to generate UDP requests to radius servers, one per user.

The scripts for running performance tests are contained in `scripts/performance`

Copy the `scripts/performance` onto the performance testing instance that you created.
This can be run locally too if you have eapol_test installed, but it is recommended to run it from an AWS instance to minimise potential throttling.
#### Caveat
These scripts do not gradually increase traffic, which is the recommended way by AWS.  This is to allow the Loadbalancer to scale and not start throttling requests.
Our initial performance testing was a work in progress, so these scripts will improve over time.

#### Testing scripts

##### config_template.conf

This dynamic template is used for each request by substituting the username and password with username and password found in `users.csv`.
Copy this file unmodified onto the performance testing server.

##### runperftest.sh

This script is used to call `stress.rb` with different parameters.
You can control how many threads you want to run the tests on and also how many requests.

##### stress.rb

This file iterates over `users.csv` and creates a request to all the frontend servers specified.
Populate the `radius_server_ips` with the radius server IPs that you would like to send traffic to.
Ensure that the shared secret being sent across is updated to one that the radius servers will accept (ie one that exists in the database for a specific organisation, currently we are using the HeatlCheck user organisation).

##### users.csv

Populate this file with test users from the staging database, exporting only usernames and passwords as a CSV.
Some example values exist for guidance.

#### Running the tests

Run `sh runperftest.sh`
You should see this generating traffic and exercising the full stack.
