#!/bin/bash
set -euo pipefail

# This script pulls in the encrypted and unencrypted values from the private `govwifi-build` repository.

# Command passed to the script from the Makefile (unencrypt-secrets or delete-secrets).
# It will be either "unencrypt" or "delete"
command="$1"

# Find all file paths of .gpg files in the .private/passwords/secrets-to-copy directory
# Exclude any filename secrets*.gpg since the values have been migrated to Secrets Manager
files=$(find .private/passwords/secrets-to-copy -type f -name '*.gpg' ! -name '*secrets*.gpg')

# Iterate over the all the .gpg files in .private/passwords/secrets-to-copy
for FILE in $files; do

  # Remove the prepending file path (.private/passwords/secrets-to-copy/) from the file name
  # Value will be e.g, govwifi/staging/secrets.auto.tfvars.gpg
  UNENCRYPTED_FILE_GPG=${FILE#.private/passwords/secrets-to-copy/}

  # Remove the .gpg extension from the filename
  # Value will be e.g., govwifi/staging/secrets.auto.tfvars
  UNENCRYPTED_FILE=${UNENCRYPTED_FILE_GPG%.gpg}

  echo $UNENCRYPTED_FILE

  if [ "$command" == "unencrypt" ]; then
    # Copy the contents of UNENCRYPTED_FILE into a new file with the same name but within the root project directory
    PASSWORD_STORE_DIR=.private/passwords pass "secrets-to-copy/${UNENCRYPTED_FILE}" > $UNENCRYPTED_FILE
  elif [ "$command" == "delete" ]; then
    # Delete the UNENCRYPTED_FILE from the root project directory
    rm $UNENCRYPTED_FILE
  fi

done

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
