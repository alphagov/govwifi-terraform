#!/bin/bash
set -euo pipefail

# This script pulls in the unencrypted values from the private `govwifi-build` repository.

# Command passed to the script from the Makefile (unencrypt-secrets or delete-secrets).
# It will be either "unencrypt" or "delete"
command="$1"

# If the filepath .private/non-encrypted/secrets-to-copy exists
if [[ -d .private/non-encrypted/secrets-to-copy ]]; then

  # Find all file paths of .gpg files in the .private/non-encrypted/secrets-to-copy directory
  files="$(find .private/non-encrypted/secrets-to-copy -type f)"

  # For each file in the list of files
  for FILE in $files; do
    # Remove the prepending file path (.private/non-encrypted/secrets-to-copy/) from the file name
    # Value will be e.g, govwifi/staging/variables.auto.tfvars.gpg
    target_file="${FILE#.private/non-encrypted/secrets-to-copy/}"
    if [ "$command" == "unencrypt" ]; then
      # Copy the variable.auto.tfvars file in the .private/non-encrypted/secrets-to-copy/* directories
      # to the govwifi/<staging | staging-london | wifi | wifi-london> directories.
      cp "${FILE}" "${target_file}"
    elif [ "$command" == "delete" ]; then
      # Delete the variable.auto.tfvars file in the .private/non-encrypted/secrets-to-copy/* directories
      rm "${target_file}"
    fi
  done

fi
