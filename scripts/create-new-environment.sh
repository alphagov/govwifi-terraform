#!/bin/bash

# Usage
# Call this script with one argument (NEW_ENV_NAME) consisting of only lowercase alphabetic characters.
# Example: scripts/myscript.sh recovery

# Purpose
# This script will
#   create new directories in govwifi-terraform & govwifi-build for a user supplied environment name
#   copy staging files to the directories (correctly excluding .terraform directory structure)
#   modify the files to match the new environment name
#   modify the Makefile to add the new environment and preserve the previous version temporarily
#   generate a key pair and store in govwifi-build repo
#   

# Ensure the correct number of arguments are passed
if [ "$#" -ne 1 ]; then
    printf "Usage: $0 NEW_ENV_NAME\n\n"
    exit 1
fi

# Check if the input is alphabetic and no uppercase letters
if ! [[ $1 =~ ^[a-z]+$ ]]; then
    printf "Error: The argument must be a single word consisting of only lowercase characters\n\n"
    exit 1
fi

# Assign the provided parameter to NEW_ENV_NAME variable for further use
NEW_ENV_NAME=$1
printf "New environment name is: $NEW_ENV_NAME\n\n"

BUILD_REPO="../govwifi-build"
TERRAFORM_REPO="../govwifi-terraform"

# New environment in build, root
BUILD_PATH="$BUILD_REPO/non-encrypted/secrets-to-copy/govwifi"

# New environment in terraform, root
TERRAFORM_PATH="$TERRAFORM_REPO/govwifi"

# Source env directory in build repo
BUILD_SOURCE="$BUILD_PATH/staging"

# New env directory in build repo
BUILD_DESTINATION="$BUILD_PATH/$NEW_ENV_NAME"

# Source env directory in terraform repo
TERRAFORM_SOURCE="$TERRAFORM_PATH/staging"

# New env directory in terraform repo
TERRAFORM_DESTINATION="$TERRAFORM_PATH/$NEW_ENV_NAME"

# Create the build destination directory if it doesn't exist
if [ ! -d "$BUILD_DESTINATION" ]; then
    mkdir -p "$BUILD_DESTINATION"
fi

# Copy the secrets path to a new environment directory with the specified name
printf "Working in $BUILD_PATH\n\n"
cp -Rp $BUILD_SOURCE/* $BUILD_DESTINATION
printf "Done\n\n"

# Loop through the recovery files and replace 'govwifi' with the new environment nam
printf "Updating environment references in $BUILD_DESTINATION file\n\n"

for filename in "$BUILD_DESTINATION"/* ; do
    sed -i '' "s/[sS]taging/$NEW_ENV_NAME/g" $filename
done

# Create the terraform destination directory if it doesn't exist
if [ ! -d "$TERRAFORM_DESTINATION" ]; then
    mkdir -p "$TERRAFORM_DESTINATION"
fi

# Copy staging to a new environment directory with the specified name
printf "Working in $TERRAFORM_PATH\n\n"
cp -Rp $TERRAFORM_SOURCE/* $TERRAFORM_DESTINATION
rm -rf $TERRAFORM_DESTINATION.
printf "Done\n\n"

# Loop through the recovery files and replace 'govwifi' with the new environment nam
printf "Updating environment references in $TERRAFORM_DESTINATION file\n\n"

for filename in "$TERRAFORM_DESTINATION"/* ; do
    sed -i '' "s/[sS]taging/$NEW_ENV_NAME/g" $filename
done

# Inject new env into Makefile above "wifi:"

cat $TERRAFORM_REPO/Makefile | \
sed "s/^wifi:/${NEW_ENV_NAME}:\n	\$(eval export DEPLOY_ENV=${NEW_ENV_NAME})\n	\$(eval export REPO=${NEW_ENV_NAME})\nwifi:/g" > $TERRAFORM_REPO/Makefile.tmp
if [ $? -eq 0 ]; then
    printf "New Makefile has been updated with ${NEW_ENV_NAME} environment\n\n"
    mv $TERRAFORM_REPO/Makefile $TERRAFORM_REPO/Makefile.old
    mv $TERRAFORM_REPO/Makefile.tmp $TERRAFORM_REPO/Makefile
else
    printf "ERROR: Failed to modify Makefile with new environment\n\n"
fi

printf "finished\n\n"

# Create key pair
KEY_NAME="govwifi-${NEW_ENV_NAME}-bastion-$(date +%Y%m%d)"
KEY_PATH="${BUILD_REPO}/${KEY_NAME}"

printf "name: ${KEY_NAME}, full path: ${KEY_PATH}\n\n"
PASSPHRASE=""
ssh-keygen -t rsa -b 4096 -f $KEY_PATH -C "govwifi-developers@digital.cabinet-office.gov.uk"  -o -a 100 -P "$(echo -n "$PASSPHRASE\n" | sed 's/\\n/\n/')"
if [ $? -eq 0 ]; then
    printf "New key pair has been generated and saved in ${BUILD_REPO}\n\n"
else
    printf "Error: Failed to generate new key pair\n\n"
fi

# Encrypt keys and add to secrets                       TODO
# PASSWORD_STORE_DIR="${BUILD_REPO}/passwords"
# couldn't crack some local master password requirement programatically, moving on

# Modify dublin.tf and london.tf with key name
sed -i '' "s/$NEW_ENV_NAME-bastion-[0-9]*/$KEY_NAME/g" $TERRAFORM_DESTINATION/dublin.tf $TERRAFORM_DESTINATION/london.tf

if [ $? -eq 0 ]; then
    printf "london.tf and dublin.tf modified with new key name\n\n"
else
    printf "Error: Failed to modify files\n\n"
fi

# Read and insert public key into dublin.tf and dublin.tf
GOVWIFI_BASTION_KEY_PUB=`cat ${KEY_PATH}.pub`
sed -i '' "s|govwifi_bastion_key_pub.*|govwifi_bastion_key_pub  = \"$GOVWIFI_BASTION_KEY_PUB\"|" $TERRAFORM_DESTINATION/dublin.tf $TERRAFORM_DESTINATION/london.tf

if [ $? -eq 0 ]; then
    printf "New public key inserted\n\n"
else
    printf "Error: Failed to insert new public key\n\n"
fi

# Correct variables.tf key name
sed -i '' "s|$NEW_ENV_NAME-ec2-instances-[0-9]*|$KEY_NAME|" $TERRAFORM_DESTINATION/variables.tf
if [ $? -eq 0 ]; then
    printf "New key name updated in variables.tf\n\n"
else
    printf "Error: Failed to update key name in variables.tf\n\n"
fi
printf "finished\n\n"
