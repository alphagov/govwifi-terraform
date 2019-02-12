# govwifi-terraform

## Purpose

A collection of Terraform modules to provision the GovWiFi infrastructure on AWS.

To see this in context of _all_ the GovWifi repos, take a look at [govwifi-build][govwifi-build].

## Usage

These modules are to be consumed by another Terraform config.
Currently the main configs for GovWiFi are contained in the [`govwifi-build`][govwifi-build] repo.
Please refer to this repo for execution instructions.

In the future, each module should contain documentation around its inputs and outputs.

## What's missing

Currently there are some key pieces of the infrastructure missing from these modules, as they
are managed in the private [`govwifi-build`][govwifi-build] repo.

### Security Groups

Currently, all security groups are managed in the private repo.

These group relate to:

- communication between services and their database
- inter-service communication (RADIUS to backend services)
- ensuring service ports (SSH) are only accessible via the bastion servers
- ensuring the bastion servers are only accessible via known locations

At a future data, these will be moved into this repo.

[govwifi-build]: https://github.com/alphagov/govwifi-build
