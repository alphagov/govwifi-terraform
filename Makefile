help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
check-env:
	$(if ${DEPLOY_ENV},,$(error Must pass DEPLOY_ENV=<name>))
staging-london:
	$(eval export DEPLOY_ENV=staging-london)
	$(eval export REPO=staging)
	$(eval export AWS_REGION=eu-west-2)
staging:
	$(eval export DEPLOY_ENV=staging)
	$(eval export REPO=staging)
	$(eval export AWS_REGION=eu-west-1)
performance-london:
	$(eval export DEPLOY_ENV=performance-london)
	$(eval export REPO=latest)
	$(eval export AWS_REGION=eu-west-2)
performance:
	$(eval export DEPLOY_ENV=performance)
	$(eval export REPO=latest)
	$(eval export AWS_REGION=eu-west-1)
wifi-london:
	$(eval export DEPLOY_ENV=wifi-london)
	$(eval export REPO=latest)
	$(eval export AWS_REGION=eu-west-2)
wifi:
	$(eval export DEPLOY_ENV=wifi)
	$(eval export REPO=latest)
	$(eval export AWS_REGION=eu-west-1)

plan_task: check-env
	scripts/run-terraform.sh plan ${terraform_flags}
plan: check-env unencrypt-secrets plan_task delete-secrets ## Run terraform plan after decrypting secrets. Must run in form make <env> plan
apply_task: check-env
	scripts/run-terraform.sh apply ${terraform_flags}
apply: check-env unencrypt-secrets apply_task delete-secrets ## Run terraform apply after decrypting secrets. Must run in form make <env> apply
.PHONY: terraform
terraform_task: check-env
# if running a targeted terraform plan/apply, remove `delete-secrets` command from the list
terraform: check-env unencrypt-secrets delete-secrets
	scripts/run-terraform.sh ${terraform_cmd}
destroy_task: check-env
	scripts/run-terraform.sh destroy
destroy: check-env unencrypt-secrets destroy_task delete-secrets ## Run terraform destroy after decrypting secrets. Must run in form make <env> apply
run-terraform-init: check-env
	scripts/run-terraform.sh init
init-backend: check-env unencrypt-secrets run-terraform-init delete-secrets ## Initalize the terraform backend. Use this when first working on the project to download the required state file. Must run in form make <env> init-backend
rencrypt-passwords: .private ## Rencrypt passwords after adding a new gpg id to the password store
	PASSWORD_STORE_DIR=$$(pwd)/.private/passwords pass init $$(cat .private/passwords/.gpg-id)
unencrypt-secrets: .private
	scripts/unencrypt-secrets.sh unencrypt
delete-secrets: .private
	scripts/unencrypt-secrets.sh delete

lint: lint-terraform
format: format-terraform

lint-terraform:
	terraform fmt -check=true -diff=true

format-terraform:
	terraform fmt

.private:
	git clone git@github.com:alphagov/govwifi-build.git .private

update-secrets: .private
	cd .private && git pull
