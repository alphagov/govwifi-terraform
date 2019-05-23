# Developer joiner, leaver checklist

This should be a complete list of tools/services that new technology team
joiners should be given access to, and leavers be removed from.

## Important

**This document is very out of date, and most does not apply any more.**

## Access to SaaS products

* AWS account
  - Main, [govwifi](https://govwifi.signin.aws.amazon.com/console)
* GitHub alphagov access to GovWifi repositories
* Trello [GovWifi](https://trello.com/govwifi) team
* [Notify](https://www.notifications.service.gov.uk/accounts)
  - GovWifi
  - GovWifi-Staging
* [Hund.io](https://status.wifi.service.gov.uk/dashboard/team/users)
* Google groups, current list of groups:
  - GovWifi Team
  - GovWifi-Critical-Alerts
  - GovWifi-DevOps
  - GovWifi-Feedback
  - govwifi-support
* [ZenDesk ticketing system](https://govuk.zendesk.com/agent/dashboard)
  - GOV.UK User support team manage user permissions

## Infrastructure

* VPNs
  - Live VPN: vpn.digital.cabinet-office.gov.uk/govwifi
  - DR VPN:  vpndr.digital.cabinet-office.gov.uk/govwifi
* GDS Build server, ah-govwf-d-01.dmz.gds
  - This server is managed by GDS IT networks team.  They create/remove user
  accounts using their Puppet scripts.
* [Jenkins account](https://jenkins.wifi.service.gov.uk/securityRealm/)

## Rotating secrets

When a developer leaves the GovWifi that had access to the encrypted secrets
we should consider them compromised and rotate them.

When a developer joins the GovWifi team we will need to re-encrypt the secrets
so they can use their own GPG key to read them.

### Re-encrypting secrets

For both leavers and joiners, we will need to re-encrypt the secrets.

#### Creating a key

The joiner will first need to create and publish a GPG key (if
they have not done so already).

Export your key in the 'armored' format using this command:

`gpg export -a`

And then visit [this site](http://pgp.mit.edu) and copy the output (including the `-----BEGIN PGP...` header and footer) to the 'Submit a Key' form.

Then will then need to give their GPG key id to someone on the team with access
to the secrets.  This is the long hex digits after the following command:

```
gpg -K --fingerprint
```

Your joiner will then need to share the final 8 HEX digits, e.g. 99C90033 of
their key with other teammates and they will need to run the following command
to import that key.  The following command can take a while to run, and can
timeout during execution.  It may need to be run multiple times before succeeding.

```shell
gpg --keyserver hkp://pgp.mit.edu --receive-keys <KEY_ID>
```

The teammates also need to trust the key once it has been imported, the
commands for which is as follows.  Note that you will enter a GPG shell after
the first command.

```shell
$> gpg --edit-key <KEY_ID>
gpg> trust
gpg> 5
```

#### Re-encrypting the secrets

A team member with access to the secrets will need to run:

```
PASSWORD_STORE_DIR=passwords pass init <keyids>
```

Where `<keyids>` is a space separated list of GPG key ids.  You can see the
current list in `passwords/.gpg-id`.  For a joiner you should be using the
existing ids and the one they provide, for a leaver you should be using the
existing ids minus their key.

And commit the changes. This will re encrypt the password store dir. They will
need to import and sign your key first

### Updating allowed SSH public keys

Each environment has a list of users defined inside of `terraform/*/userlist.tf`,
with a separate list for both staging and production environments.

Add or remove users accordingly.

### Rotating the secrets

For both production and staging, replace the <ENVIRONMENT> with "wifi" or
"staging" for the following steps.

#### Bastion KeyPairs

To generate new keypairs into a `new-keys` directory and encrypt them into the
passwords directory perform the following:

```shell
mkdir new-keys

ssh-keygen -f new-keys/govwifi-bastion-key -N ""
cat new-keys/govwifi-bastion-key | PASSWORD_STORE_DIR=passwords pass insert -m keys/govwifi-bastion-key

ssh-keygen -f new-keys/govwifi-staging-bastion-key -N ""
cat new-keys/govwifi-staging-bastion-key | PASSWORD_STORE_DIR=passwords pass insert -m keys/govwifi-staging-bastion-key
```

The public keys, which will be generated into `new-keys/govwifi-bastion-key.pub`
and `new-keys/govwifi-staging-bastion-key.pub` need to be copied into terraform
repository, file path `/govwifi-keys/bastion-keys.tf`.

The `new-keys` directory should not be committed, and needs to be deleted once
you have encrypted and copied over the details.

This will be sufficient for the ssh key rotation as all of our servers require getting in through the bastion.

#### Notify API Key

Generate API key for Notify, giving it a name in the format of "dd/mm/yyyy".
Then update the appropriate environment variables config file.

```shell
PASSWORD_STORE_DIR=passwords pass edit secrets-to-copy/govwifi-backend/etc/enrollment.<ENVIRONMENT>.cfg
```

Use the same secret and copy the value to `notify-api-key` value stored in
`passwords/terraform/<ENVIRONMENT>-london/secrets.tf`

```shell
PASSWORD_STORE_DIR=passwords pass edit terraform/<ENVIRONMENT>-london/secrets.tf
```

#### MySQL password

Update the `db-password` value stored in
`passwords/terraform/<ENVIRONMENT>-london/secrets.tf` with a value generated by
`openssl rand -base64 24`.

```shell
PASSWORD_STORE_DIR=passwords pass edit terraform/<ENVIRONMENT>-london/secrets.tf
```

#### HEALTH user password

This is the password used by the health user.

Update the `password` field stored in
`passwords/secrets-to-copy/govwifi-frontend/etc/peap-mschapv2.conf`.

This password needs to updated in the DB too.
This password is shared between staging and production, and is compiled into the
frontend container.

```shell
PASSWORD_STORE_DIR=passwords pass edit secrets-to-copy/govwifi-frontend/etc/peap-mschapv2.conf
```

#### Healthcheck site shared secret

There is a site in the database for localhosts requests.  This is used by
healthchecking requests.

Update the `hc-key` value stored in
`passwords/terraform/<ENVIRONMENT>/secrets.tf`
and `passwords/terraform/<ENVIRONMENT>-london/secrets.tf` with a value generated
 by `openssl rand -base64 24`.

```shell
PASSWORD_STORE_DIR=passwords pass edit terraform/<ENVIRONMENT>/secrets.tf
PASSWORD_STORE_DIR=passwords pass edit terraform/<ENVIRONMENT>-london/secrets.tf
```

#### Shared Secret

This is a secret used to authenticate communication between the backend and
frontend.

Update the `shared-key` value stored in
`terraform/<ENVIRONMENT>/secrets.tf`
and `terraform/<ENVIRONMENT>-london/secrets.tf` with a value stored in
`openssl rand -base64 24`.

#### AWS access key

Generate a new access key for the `govwifi-api-wifi` IAM user and save it into
the "Access-keyID" and "Access-key" fields of
`/govwifi-backend/etc/enrollment.default-values.cfg`.

```shell
PASSWORD_STORE_DIR=passwords pass edit secrets-to-copy/govwifi-backend/etc/enrollment.default-values.cfg
```

Now follow the [deployment](./rebuilding-after-performing-secret-rotation.md)
part of the guide.
