#!/bin/bash
set -euo pipefail
file=$1
PASSWORD_STORE_DIR=passwords pass insert secrets-to-copy/"${file}" -m < "${file}"
