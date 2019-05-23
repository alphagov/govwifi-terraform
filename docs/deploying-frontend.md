# Deploying frontend changes

Pushing images to ECR is now handled using Jenkins via the `alphagov/govwifi-frontend` repo.

**Important**: Due to the daily reload that occurs, it is best to deploy the staging containers
before pushing the production images.

Review the image has been pushed, the ECS registry tags should be updated with
the SHA shown in the Jenkins log.

Open ECS AWS pages for `staging-frontend-cluster` in London and Ireland in new
tabs.  If you were deploying to production, the cluster is called
`wifi-frontend-cluster`.

Restart half at a time in each region remembering which you restarted.

Restart the other half once the first set have booted back up, healthchecks are
green and there are no alarms raised.

To check that the containers are booted and healthy you should navigate to the
Route53 AWS page and refresh the frontends for the environment you deployed to
until they are healthy.

## Deploying certificates + Keys

Certificates are stored encrypted under `passwords/certs/`, and hosted in S3 buckets.

All S3 buckets should contain the CA certificates.

Staging buckets should hold the keys + certificates prefixed with `staging`.

Production buckets should hold the keys + certificates prefixed with `wifi`.


These commands should automate the process:

```sh
# Staging
## Dublin
PASSWORD_STORE_DIR=passwords pass show certs/ca.pem | aws s3 cp - s3://govwifi-staging-dublin-frontend-cert/ca.pem
PASSWORD_STORE_DIR=passwords pass show certs/comodoCA.pem | aws s3 cp - s3://govwifi-staging-dublin-frontend-cert/comodoCA.pem
PASSWORD_STORE_DIR=passwords pass show certs/staging-server.key | aws s3 cp - s3://govwifi-staging-dublin-frontend-cert/server.key
PASSWORD_STORE_DIR=passwords pass show certs/staging-server.pem | aws s3 cp - s3://govwifi-staging-dublin-frontend-cert/server.pem

## London
PASSWORD_STORE_DIR=passwords pass show certs/ca.pem | aws s3 cp - s3://govwifi-staging-london-frontend-cert/ca.pem
PASSWORD_STORE_DIR=passwords pass show certs/comodoCA.pem | aws s3 cp - s3://govwifi-staging-london-frontend-cert/comodoCA.pem
PASSWORD_STORE_DIR=passwords pass show certs/staging-server.key | aws s3 cp - s3://govwifi-staging-london-frontend-cert/server.key
PASSWORD_STORE_DIR=passwords pass show certs/staging-server.pem | aws s3 cp - s3://govwifi-staging-london-frontend-cert/server.pem

# Production
## Dublin
PASSWORD_STORE_DIR=passwords pass show certs/ca.pem | aws s3 cp - s3://govwifi-production-dublin-frontend-cert/ca.pem
PASSWORD_STORE_DIR=passwords pass show certs/comodoCA.pem | aws s3 cp - s3://govwifi-production-dublin-frontend-cert/comodoCA.pem
PASSWORD_STORE_DIR=passwords pass show certs/wifi-server.key | aws s3 cp - s3://govwifi-production-dublin-frontend-cert/server.key
PASSWORD_STORE_DIR=passwords pass show certs/wifi-server.pem | aws s3 cp - s3://govwifi-production-dublin-frontend-cert/server.pem

## London
PASSWORD_STORE_DIR=passwords pass show certs/ca.pem | aws s3 cp - s3://govwifi-production-london-frontend-cert/ca.pem
PASSWORD_STORE_DIR=passwords pass show certs/comodoCA.pem | aws s3 cp - s3://govwifi-production-london-frontend-cert/comodoCA.pem
PASSWORD_STORE_DIR=passwords pass show certs/wifi-server.key | aws s3 cp - s3://govwifi-production-london-frontend-cert/server.key
PASSWORD_STORE_DIR=passwords pass show certs/wifi-server.pem | aws s3 cp - s3://govwifi-production-london-frontend-cert/server.pem
```