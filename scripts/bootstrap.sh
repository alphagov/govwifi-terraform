#!/bin/bash

# Usage
# Call this script with one argument (NEW_ENV_NAME) consisting of only lowercase alphabetic characters
# from the govwifi-terraform directory top level.
# Example: scripts/myscript.sh recovery

# Purpose
# This script will
#   check the env var PASSWORD_STORE_DIR is set and exit if false
#   create new directories in govwifi-terraform & govwifi-build for a user supplied environment name
#   copy staging files to the directories (correctly excluding .terraform directory structure)
#   modify the files to match the new environment name
#   modify the Makefile to add the new environment and preserve the previous version temporarily
#   generate a key pair and store in govwifi-build repo secrets
#   insert public key and key names into terraform files for the new environment
#   creates intitial DNS entry and outputs nameservers for production incorporation
#   creates access logs' buckets
#   creates state bucket


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

# Assign the provided parameter to NEW_ENV_NAME variable
NEW_ENV_NAME=$1
printf "New environment name is: $NEW_ENV_NAME\n\n"
while true; do
    read -p "Is this correct? (y/n): " yn
    case $yn in
        [Yy]* ) printf "Confirmed. Proceeding...\n\n"; break;;  # Continue the script if confirmed
        [Nn]* ) printf "Please set the correct environment name\n\n"; exit 1;;  # Exit if not confirmed
        * ) printf "Please answer y or n\n";;  # Repeat the prompt if input is invalid
    esac
done

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

# Check if PASSWORD_STORE_DIR is set
if [ -z "$PASSWORD_STORE_DIR" ]; then
    printf "The environment variable PASSWORD_STORE_DIR is not set\n\n"
    read -p "Please set PASSWORD_STORE_DIR and rerun the script. Press any key to exit"
    exit 1
else
    printf "PASSWORD_STORE_DIR is set to '$PASSWORD_STORE_DIR'. Continuing with the script...\n\n"
fi

# Set path to keys inside secrets
SSH_KEYS_SECRET_PATH="keys"

# Create key pair, $KEY_PATH includes path and key name
KEY_NAME="govwifi-${NEW_ENV_NAME}-bastion-$(date +%Y%m%d)"
KEY_PATH="${BUILD_REPO}/${KEY_NAME}"
KEY_PUB_NAME="${KEY_NAME}.pub"
PASSPHRASE=""

ssh-keygen -t rsa -b 4096 -f $KEY_PATH -C "govwifi-developers@digital.cabinet-office.gov.uk"  -o -a 100 -P "$(echo -n "$PASSPHRASE\n" | sed 's/\\n/\n/')"
if [ $? -eq 0 ]; then
    printf "New key pair has been generated and saved in ${BUILD_REPO}\n"
else
    printf "Error: Failed to generate new key pair\n\n"
fi

# Encrypt keys and add to secrets
printf "\n\n"
pass insert -m ${SSH_KEYS_SECRET_PATH}/${KEY_NAME} < ${KEY_PATH}

if [ $? -eq 0 ]; then
    printf "key ${KEY_PATH} added\n\n"
else
    printf "Error: Failed to add new key\n\n"
fi

pass insert -m ${SSH_KEYS_SECRET_PATH}/${KEY_PUB_NAME} < ${BUILD_REPO}/${KEY_PUB_NAME}

if [ $? -eq 0 ]; then
    printf "key ${KEY_PATH}.pub added\n\n"
    rm ${KEY_PATH} ${BUILD_REPO}/${KEY_PUB_NAME}
else
    printf "Error: Failed to add new pub key\n\n"
fi

pass find recovery

printf "\n\n"

# Check if new environment exists and prompt to overwrite
if [ -d "$TERRAFORM_DESTINATION" ]; then
    read -p "Directory $TERRAFORM_DESTINATION exists. Do you want to overwrite existing files? (y/n): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        printf "Overwriting files in $TERRAFORM_DESTINATION\n\n"
    else
        printf "New environment creation canceled\n\n"
        exit 1
    fi
else
    printf "Directory $TERRAFORM_DESTINATION does not exist. Creating\n\n"
fi

# Create the build destination directory if it doesn't exist
if [ ! -d "$BUILD_DESTINATION" ]; then
    mkdir -p "$BUILD_DESTINATION"
fi

# Copy the secrets path to a new environment directory with the specified name
printf "Working in $BUILD_PATH\n\n"
cp -Rp $BUILD_SOURCE/* $BUILD_DESTINATION
printf "Done\n\n"

# Loop through the environment files and replace 'govwifi' with the new environment nam
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

# DNS Setup
printf "Creating initial DNS entry, you'll need to copy the NameServers lines\n\n"
gds-cli aws govwifi-${NEW_ENV_NAME} -- aws route53 create-hosted-zone --name "${NEW_ENV_NAME}.wifi.service.gov.uk" --hosted-zone-config "Comment=\"\",PrivateZone=false" --caller-reference "govwifi-$(date)" | jq -r '.DelegationSet.NameServers[]'

# Let's create some required buckets

# S3 Access Logs buckets
gds-cli aws govwifi-${NEW_ENV_NAME} -- aws s3api create-bucket --bucket govwifi-${NEW_ENV_NAME}-london-accesslogs --region eu-west-2 --create-bucket-configuration LocationConstraint=eu-west-2
gds-cli aws govwifi-${NEW_ENV_NAME} -- aws s3api create-bucket --bucket govwifi-${NEW_ENV_NAME}-dublin-accesslogs --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1

# Remote State bucket
gds-cli aws govwifi-${NEW_ENV_NAME} -- aws s3api create-bucket --bucket govwifi-${NEW_ENV_NAME}-tfstate-eu-west-2 --region eu-west-2 --create-bucket-configuration LocationConstraint=eu-west-2

# Check buckets
gds-cli aws govwifi-${NEW_ENV_NAME} -- aws s3api list-buckets


printf "\n\nscript finished\n\n"
