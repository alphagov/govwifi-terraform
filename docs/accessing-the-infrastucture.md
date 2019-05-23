# Accessing the Infrastructure

## VPN

All connections must be made via the GDS VPN. Please contact your local
service desk for access.

## Bastions

The bastion servers act as a gateway to their respective clusters + databases.
That is to say:

- To access any Staging database or server, you must access via the staging bastion.
- To access any Production database or server, you must access via the production bastion.

There are 2 ways to connect to a bastion server.

- Use the primary user account with the stored SSH key

### Using your own account

First, you must have have someone [set up your user account][user_account_setup].

\#TODO: add instructions, this isn't the process I used.

### Using the primary account

Extract SSH key for the bastion server from the encrypted store:

```sh
# Staging
PASSWORD_STORE_DIR=passwords pass show keys/govwifi-staging-bastion-key > ~/.ssh/govwifi/bastion-staging
# Producton
PASSWORD_STORE_DIR=passwords pass show keys/govwifi-bastion-key > ~/.ssh/govwifi/bastion-production
chmod 600 ~/.ssh/govwifi/*
```

Find out the Elastic IPs for the bastion servers. You can do this by going into the AWS console,
and find the instances with the Bastion name in.

Remember that there are 2 regions, so there may be more than 2 bastions.

It is recommended to set up an ssh config for ease of use. All further instructions will
assume you use similar naming.

**Note**: The IP addresses have been redacted. Please substitute in the correct IP addresses.

```
AddKeysToAgent = yes

Host govwifi-bastion-london-staging <redacted IP address>
    Hostname <redacted IP address>
    User ubuntu
    IdentityFile ~/.ssh/govwifi/bastion-staging
    ForwardAgent=Yes

Host govwifi-bastion-london-production <redacted IP address>
    Hostname <redacted IP address>
    User ubuntu
    IdentityFile ~/.ssh/govwifi/bastion-production
    ForwardAgent=Yes

Host govwifi-bastion-ireland-production <redacted IP address>
    Hostname <redacted IP address>
    User ubuntu
    IdentityFile ~/.ssh/govwifi/bastion-production
    ForwardAgent=Yes
```

You should now be able to connect to each of the hosts using ssh.

```sh
ssh govwifi-bastion-london-staging
```

## Databases

There are 4 databases, all currently located in London. 2 for staging, 2 for production.

To access each one, you will need to use their respective credentials and bastion server.

### Admin database

**AWS Naming convention**: Used for finding the database in the AWS Console

- Production: `wifi-admin-wifi-db`
- Staging: `wifi-admin-staging-db`

For anything related to the Admin panel, connect to the admin database:

**Endpoint**: View in the AWS Console

**Username**: View in the AWS Console, or the terraform config.

- Production: `grep -e "admin-db-user\W*=" terraform/wifi-london/main.tf`
- Staging: `grep -e "admin-db-user\W*=" terraform/staging-london/main.tf`

**Password**: Get the password from the encrypted terraform secrets:

- Production: `PASSWORD_STORE_DIR=passwords pass show terraform/wifi-london/secrets.tf | grep admin-db-password`
- Staging: `PASSWORD_STORE_DIR=passwords pass show terraform/staging-london/secrets.tf | grep admin-db-password`

Use your favourite GUI, or set up an SSH tunnel.

### Wifi database

**AWS Naming convention**: Used for finding the database in the AWS Console

- Production: `wifi-wifi-db`
- Staging: `wifi-staging-db`

This database provides for the authentication, logging, and user signup.

**Endpoint**: View in the AWS Console.

**Username**: View in the AWS Console, or the terraform config.

- Production: `PASSWORD_STORE_DIR=passwords pass show  terraform/wifi-london/secrets.tf | grep -e "^db-user"`
- Staging: `PASSWORD_STORE_DIR=passwords pass show  terraform/staging-london/secrets.tf | grep -e "^db-user"`

**Password**: Get the password from the encrypted terraform secrets:

- Production: `PASSWORD_STORE_DIR=passwords pass show terraform/wifi-london/secrets.tf | grep -e "^db-password"`
- Staging: `PASSWORD_STORE_DIR=passwords pass show terraform/staging-london/secrets.tf | grep -e "^db-password"`

Use your favourite GUI, or set up an SSH tunnel.

[user_account_setup]: joiner-leaver-checklist.md#Updating-allowed-SSH-public-keys
