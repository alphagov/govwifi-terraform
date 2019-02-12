# govwifi-terraform

## Purpose

A collection of Terraform modules to provision the GovWiFi infrastructure on AWS.

To see this in context of _all_ the GovWifi repos, take a look at [govwifi-build][govwifi-build].

## Usage

These modules are to be consumed by another Terraform config.
Currently the main configs for GovWiFi are contained in the [`govwifi-build`][govwifi-build] repo.
Please refer to this repo for execution instructions.

## What's missing

Currently there are some key pieces of the infrastructure missing from these modules, as they
are managed in the private [`govwifi-build`][govwifi-build] repo.

### Main Terraform config

This ties all the modules together. In short, it:

- Provides ann AWS provider to the modules, tied to a specific region
- Configures any sensitive details, mainly around non-region specific values (e.g., RADIUS IP Addresses)
- Controls which parts of the infrastructure go in which region

### Security Groups

Currently, all security groups are managed in the private repo.

These group relate to:

- communication between services and their database
- inter-service communication (RADIUS to backend services)
- ensuring service ports (SSH) are only accessible via the bastion servers
- ensuring the bastion servers are only accessible via known locations

[govwifi-build]: https://github.com/alphagov/govwifi-build
