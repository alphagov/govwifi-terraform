# Notes on how to rebuild after key rotation.

Before deploying changes to Terraform, tag the current commit deployed to
production.  This is important so that we can review what changes were made when
as part of any problem solving at a later date.

Use a tag naming scheme similar to this: `current-production-2018-03-28`

Add a tag to every repository you are deploying changes to.

## Important

**This document is very out of date, and most does not apply any more.**

## Update your local Terraform

To pull in your changes from the public govwifi-terraform repository use the
following command.

```shell
make update-modules
```

If you have added/removed modules you will need to run the
[terraform-init](https://www.terraform.io/docs/commands/init.html) command, use
the following make commands to make this easier.

> It is safe to run this command multiple times.

```shell
make staging init-backend
make staging-london init-backend
make wifi init-backend
make wifi-london init-backend
```

## Deploy frontend changes

[See instructions in deploying-frontend.md](deploying-frontend.md)

## Update secrets in database

Connect to the bastion server for the correct region.  You can find the public
IP in the EC2 dashboard.

```shell
ssh ubuntu@<bastion server IP>
```

Connect to the RDS instance via MySQL client.

```shell
mysql -h db.london.ENVIRONMENT.service.gov.uk -uUSERNAME -p
```

You can grab the password from the appropriate secrets file.

```shell
PASSWORD_STORE_DIR=passwords pass "terraform/${ENVIRONMENT}-london/secrets.tf"
```

Update the RADIUS Shared Secret (radkey) using similar MySQL as below.

```mysql
BEGIN
select * from siteip where ip = "127.0.0.1";
select * from site where id = ?; -- USE ID FROM ABOVE
update site set radkey = ? where id = ?; -- USE ID FROM ABOVE
COMMIT
```

Update the health user password using similar MySQL as below.

```mysql
select * from userdetails where username = "health";
BEGIN;
update userdetails set password = ? where username = "HEALTH" LIMIT 1;
COMMIT;
```

Clear Memcache so that the old health user password is cleared from cache.
Restart the AWS ElasticCache instance for the correct environment in the
London region.

## Terraform Apply

Run Terraform apply to apply the infrastructure changes.

```shell
make staging terraform apply
```

Review these changes, noting that the frontends will be destroyed/recreated.

Type "yes" when you are happy with the changes shown.

You will need to re-run terraform apply to make the KeyPair changes and
Route53 changes.

```shell
make staging-london terraform apply
```

Again review, and type `yes` when you are happy with the changes.

## Reboot everything

### Restart ECS frontend containers

Once the API key changed from the above backend reboots, you can fix the broken
frontends by rebooting their ECS tasks.

Go to London region and stop the staging-frontend-cluster tasks
Go to Ireland region and stop the staging-frontend-cluster tasks

# Update the build server box

The build server box has a cron which creates a daily flat file backup of
GovWifi data by SSHing into the bastion and running `mysqldump`.

### Copying over key

You will need to SCP the new key used by the bastion into the following location
`/root/govwifi-new-bastion-key`

### Removing the known key

You'll also need to remove the old hostname from the known-hosts file.  Run the
following command:

```
ssh -i /root/govwifi-new-bastion-key ubuntu@<PRODUCTION_LONDON_BASTION_SERVER>
```

You will get a warning if there is a public key mismatch which needs addressing.
The warning will inform you of the change required.
