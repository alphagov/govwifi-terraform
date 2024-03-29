# DEPRECATED

We're retaining this documentation for reference.

It provides insight into the decisions taken by the original contributors to the Terraform.

Our code has drifted so these instructions are no longer applicable

## Terraform

Welcome to the Terraform playbook.

This is a step by step guide to using Terraform to create the architecture
needed for Govwifi.

Copy the directories called wifi and wifi-london to new environment name
(performance in this case)

### Important

**This document is very out of date, and most does not apply any more.**

### AWS
Ensure you have AWS CLI tools installed

```bash
$ aws --version
aws-cli/1.8.1 Python/2.7.10 Darwin/15.6.0

$ terraform --version
Terraform v0.9.6
```

### Create Elastic IPs
*London, Dublin*

3 for the frontends, and 1 for the bastion (convenience)

- Edit `./terraform/<environment-names>/firewall-variables.tf`
- Add the Elastic IPs created above to the variable `frontend-radius-IPs`

### SSH Keys

Generate keys, one for the bastions and one for the frontend and backend EC2
instances.  Use the following command for each.

```bash
ssh-keygen -t rsa -b 4096 -C "GovWifi-DevOps@digital.cabinet-office.gov.uk"
```

Don't overwrite the keys by giving them unique names eg ~/.ssh/govwifi-bastion
and ~/.ssh/govwifi-ec2-instances

#### Upload public key to AWS with AWS CLI

##### London
```bash
aws ec2 import-key-pair --key-name govwifi-bastion --public-key-material "$(cat ~/.ssh/govwifi-bastion.pub)" --region eu-west-2
aws ec2 import-key-pair --key-name govwifi-ec2-instances --public-key-material "$(cat ~/.ssh/govwifi-ec2-instances.pub)" --region eu-west-2
```

##### Dublin

```bash
aws ec2 import-key-pair --key-name govwifi-bastion --public-key-material "$(cat ~/.ssh/govwifi-bastion.pub)" --region eu-west-1
aws ec2 import-key-pair --key-name govwifi-ec2-instances --public-key-material "$(cat ~/.ssh/govwifi-ec2-instances.pub)" --region eu-west-1
```

#### Update Terraform config with new keys

For both London AND Dublin:

- variables.tf

  ```
  variable "ssh-key-name" {
    type    = "string"
    default = "govwifi-ec2-instances"
  }
  ```

- main.tf

  module "backend"
  ```
  bastion-ssh-key-name       = "govwifi-bastion-key"
  ```

  module "frontend"
  Update to unique value
  ```
  vpc-cidr-block
  zone-subnets
  ```

### Secrets

#### Add private keys

This could give an error but it's ok if you can see the gpg file exists in
passwords/keys

```bash
PASSWORD_STORE_DIR=passwords pass insert keys/govwifi-bastion -m < ~/.ssh/govwifi-bastion
PASSWORD_STORE_DIR=passwords pass insert keys/govwifi-ec2-instances -m < ~/.ssh/govwifi-ec2-instances
```

### Docker registries

Upload Docker frontend and backend images to AWS repo and define image path in secrets.tf

*Do this ONLY for Dublin*

```bash
aws ecr create-repository --repository-name "govwifi/backend" --region eu-west-1
aws ecr create-repository --repository-name "govwifi/frontend" --region eu-west-1
```

### Route53
#### Create a Hosted Zone

*Dublin only*

```bash
aws route53 create-hosted-zone --name "performance.wifi.service.gov.uk" --hosted-zone-config "Comment=\"\",PrivateZone=false" --caller-reference "$(date)"
```

*Make sure you control the name servers for the domain you've added*

### Terraform Secrets

*Create secrets.tf file for both London and Dublin*

We need to create a new Terraform secrets file which will be pgp encrypted.

This file contains the secrets for Terraform.

```bash
touch terraform/performance-london/secrets.tf
```

The keys and values that are required are:

```
db-password       = "xxx"
hc-key            = "xxx"
shared-key        = "xxx"
aws-account-id    = "xxx"
docker-image-path = "xxx"
route53-zone-id   = "xxx"
elb-ssl-cert-arn  = "xxx"
```
*Note: elb-ssl-cert-arn cannot be set until we have the infrastrucure up*

##### db-password

Password for mysql database, this is not used in Dublin.
Generate a random password

##### hc-key

Healthcheck Radius Key

##### shared-key

Radius Server Preshared Key

##### aws-account-id

AWS Account Id

```bash
aws sts get-caller-identity
```

##### docker-image-path
Url for images

<AWS Account Id>.dkr.ecr.<Region>.amazonaws.com/<Prefix of repository name in ECS>

We have two repos
govwifi/frontend
and
govwifi/backend

##### route53-zone-id

```bash
aws route53 list-hosted-zones-by-name
```

Copy Zone Id from Output (excluding /hostedzone/)

##### elb-ssl-cert-arn

This can only be populated once we have an elb with a cert generated by AWS. Leave this out of the file for now.

#### Once this is done, you can encrypt and add the secrets files

```bash
PASSWORD_STORE_DIR=passwords pass insert terraform/performance-london/secrets.tf -m < terraform/performance-london/secrets.tf

PASSWORD_STORE_DIR=passwords pass insert terraform/performance/secrets.tf -m < terraform/performance/secrets.tf
```

### Terraform backend configuration

```bash
touch terraform/performance/backend.config
touch terraform/performance-london/backend.config
```
Contents:
```
# Secret terraform backend config values in variable = "value" format
# Eg.
# access_key = "AWSACCESSKEY"
#encrypt    = true
#kms_key_id = "ID of KMS key once it's created"
```
*Note: the KMS key can only be set after it is created by terraform. This means that the s3 bucket setup has to
wait until the first apply has finished.*

#### Move these files into the encrypted secrets as well.

```bash
./scripts/insert_secret.sh terraform/performance/backend.config
./scripts/insert_secret.sh terraform/performance-london/backend.config
```

### main.tf

Update vpc-cidr-block  = "10.64.0.0/16"
Set it to something unique (the 64 part), check other main.tf files to make sure it's not used

update zone-subnets, set to same (64)

*note*
 bastion-identity is not used

performance ->  bastion-set-cronjobs, ensure this is set to 0!
Otherwise the environment will start sending timed jobs, eg. data to Performance Platform (external reporting tool)
and survey requests to newly registered users.

generate a db user in main.tf
```
db-user = "RandomGeneratedUsername"
```

### SNS
critical-notifications-arn
capacity-notifications-arn

#### Create topics

Remember to grab the ARN values from each command, to put into terraform for both London and Dublin
```
  critical-notifications-arn = "xxx"
  capacity-notifications-arn = "xxx"
```

##### London
```
aws sns create-topic --name govwifi-performance-critical
aws sns create-topic --name govwifi-performance-capacity
```

##### Dublin
```
aws sns create-topic --name govwifi-performance-critical --region eu-west-1
aws sns create-topic --name govwifi-performance-capacity --region eu-west-1
```

### Solve ELB certificate catch-22

Comment out the following lines in terraform/modules/govwifi-backend/loadbalancer.tf

```
#    ssl_certificate_id = "${var.elb-ssl-cert-arn}"
```

Provide default values in both variables.tf as follows:

```
variable "elb-ssl-cert-arn" {
  type        = "string"
  description = "ARN of the ACM SSL certificate to be attached to the ELB"
  default     = "unused for now"
}
```

### Solve bug with cache name length
In the file `govwifi-backend/cache.tf`, the cluster id is dynamically generated.
cluster_id             = "cache-${var.Env-Name}-wifi"

The problem is that there is a 20 character limit for this value.
Consider removing everything but the environment name.

TODO: these manual steps can easily be done with Terraform

*legacy-bastion-user is unused, to be removed*

### Run init for terraform

```
make performance-london init-backend
```

### Deprecated Bastion Server AMI

In the file `terraform/performance/main.tf`

Update this line:

#### terraform/performance-london/main.tf
`bastion-ami = "ami-b11d17d7"` to: `bastion-ami = "ami-1ffb9066"`

Update this line:

#### terraform/performance/main.tf
`bastion-ami = "ami-0d120569"` to: `bastion-ami = "ami-8d9e7bea"`

When running this again, you will receive the following error message:

*OptInRequired: In order to use this AWS Marketplace product you need to accept terms and subscribe.*

There will be a link, follow the link and accept the terms and conditions to proceed.

Run
```
make performance apply
```

### Activate the Ruleset

*Ensure the Ruleset exists*
```
aws ses list-receipt-rule-sets --region=eu-west-1
```

Activate the Ruleset
```
aws ses set-active-receipt-rule-set --rule-set-name performance-ses-ruleset --region=eu-west-1
```

To see whether the ruleset is active
```
aws ses describe-active-receipt-rule-set --region=eu-west-1
```

### Create a new SSL Certificates for the ELBs in both London and Dublin
```
aws acm request-certificate --domain-name elb.london.performance.wifi.service.gov.uk
```

*Note the ARN value in the output*

```
aws acm request-certificate --domain-name elb.dublin.performance.wifi.service.gov.uk --region eu-west-1
```

*Note the ARN value in the output*

Add these ARNs to secrets for Dublin:
```
PASSWORD_STORE_DIR=passwords pass edit "terraform/performance/secrets.tf"
```

Add the following line:

```
elb-ssl-cert-arn  = "xxx"
```

Do the same for London.

*There is more email validation on this certificate step*

### Upload images to Elastic Container Registry (ECR)
The AWS Account Id is hardcoded and needs to be updated to the new account:
Edit both `govwifi-frontend/push.sh` and `govwifi-backend/push.sh`, change the account id.
 ```bash
make rebuild-frontend
make rebuild-backend
`aws ecr get-login --region eu-west-1 --no-include-email`
make performance push-frontend
```

TODO:
  Change db user (it's prod right now).

### Bastion

terraform/modules/govwifi-backend/management.tf

### Route53 healthcheck is manual

* TODO: Put this infra into Terraform

### Some of the CloudWatch alarms are manual

* TODO: Work out which alarms are manual and move them into Terraform

### Buy new certificate for environment

This is the secret used by FreeRADIUS to identify itself.

/govwifi-frontend/etc/raddb/certs/<env>.wifi

Production certificates are purchased and organised through the GDS Service
Desk.

Otherwise self-signed certificates can be used for internal testing.
