#!/bin/bash

set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TERRAFORM_DIR="${SCRIPT_DIR}/../terraform/${DEPLOY_ENV}"
export TF_CLI_ARGS_init="-backend=true -backend-config=${TERRAFORM_DIR}/backend.config"

cd "${TERRAFORM_DIR}"
terraform "$@"
