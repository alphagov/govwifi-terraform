# Deploying frontend changes

Pushing images to ECR is now handled using Concourse via the `alphagov/govwifi-frontend` repo.

**Important**: Due to the daily reload that occurs, it is best to deploy the staging containers
before pushing the production images.

Review the image has been pushed, the ECS registry tags should be updated with
the SHA shown in the Concourse log.

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

Deploying cerificates + Keys is now handled using Concourse via the `alphagov/govwifi-build` repo.

Certificates are stored encrypted under `passwords/certs/`, and hosted in S3 buckets.

All S3 buckets should contain the CA certificates.

Staging buckets should hold the keys + certificates prefixed with `staging`.

Production buckets should hold the keys + certificates prefixed with `wifi`.
