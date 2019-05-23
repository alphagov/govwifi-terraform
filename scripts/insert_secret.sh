#!/bin/bash
set -euo pipefail
file=$1
PASSWORD_STORE_DIR=.private/passwords pass insert secrets-to-copy/"${file}" -m < "${file}"
