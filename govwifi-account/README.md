# govwifi-account

## Purpose

Module contains IAM related resources: groups, policies, roles, users, and user-policies,

These resources were imported from AWS in order to ensure all of our IAM related AWS resources also existed in some format in Terraform.

## Note

This module only gets run with "wifi-london" as the location to stop multiple locations trying to control the account, not region, settings.
