#!/bin/bash
set -euo pipefail

command="$1"
files=$(find .private/passwords/secrets-to-copy -type f -name '*.gpg')
for FILE in $files; do
  UNENCRYPTED_FILE_GPG=${FILE#.private/passwords/secrets-to-copy/}
  UNENCRYPTED_FILE=${UNENCRYPTED_FILE_GPG%.gpg}
  echo $UNENCRYPTED_FILE
  if [ "$command" == "unencrypt" ]; then
  PASSWORD_STORE_DIR=.private/passwords pass "secrets-to-copy/${UNENCRYPTED_FILE}" > $UNENCRYPTED_FILE
  elif [ "$command" == "delete" ]; then
    rm $UNENCRYPTED_FILE 
  fi
done

if [[ -d .private/non-encrypted/secrets-to-copy ]]; then
  files="$(find .private/non-encrypted/secrets-to-copy -type f)"
  for FILE in $files; do
    target_file="${FILE#.private/non-encrypted/secrets-to-copy/}"
    if [ "$command" == "unencrypt" ]; then
      cp "${FILE}" "${target_file}"
    elif [ "$command" == "delete" ]; then
      rm "${target_file}"
    fi
  done
fi
