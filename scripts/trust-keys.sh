#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

export PASSWORD_STORE_DIR=../.private/passwords
echo "Expecting passwords under $PASSWORD_STORE_DIR"

while IFS= read -r key && [[ -n "$key" ]]; do
  # fetch if not already there
  gpg --list-public-key "$key" > /dev/null || gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "$key"
  # set ultimate trust on the key (requires full length keys)
  echo "${key}:6" | gpg --import-ownertrust
done < "$PASSWORD_STORE_DIR/.gpg-id"
