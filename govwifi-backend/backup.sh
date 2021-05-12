#!/bin/bash

function restore_mysql {
  gunzip < "${tempdir}/${filename}" | sudo -H mysql -h mysql-primary "${database}"
}

function get_secret() {
  aws secretsmanager get-secret-value --secret-id $1 --version-stage AWSCURRENT
}

function get_dump() {
  aws s3api get-object-acl --bucket govwifi-datasync --key $1.sql
}


# Admin Database
database_name='govwifi_admin_staging'

# Get creds from secrets
db_host=$(get_secret('govwifi/admin-db/credentials/hostname'))
db_username=$(get_secret "govwifi/admin-db/credentials/username" | jq '.SecretString.username')
db_password=$(get_secret "govwifi/admin-db/credentials/password" | jq '.SecretString.username')

# Get file from s3
get_dump $database_name

# untar database
# To be added after compression method is known

#Decrypt
#To be added after key is shared

# Remove problematic SQL lines
sed 's/^SET @@SESSION.SQL_LOG_BIN/-- SET @@SESSION.SQL_LOG_BIN/' $database_name
sed 's/^SET @@GLOBAL.GTID_PURGED=/*!80000/-- SET @@GLOBAL.GTID_PURGED=/*!80000/' $database_name

# Drop current database
mysql -h $db_host -u $db_username -p $db_password -e "drop database $database_name"

# Create new database
mysql -h $db_host -u $db_username -p $db_password -e "create database $database_name"

# Import data
mysql -h $db_host -u $db_username -p $db_password < $database_name.sql


# -------------#
# User Database
# -------------#

database_name='govwifi_staging_users'
db_host=$(get_secret('govwifi/users-db/credentials/hostname'))
db_username=$(get_secret "govwifi/users-db/credentials/username" | jq '.SecretString.username')
db_password=$(get_secret "govwifi/users-db/credentials/password" | jq '.SecretString.username')

# Remove problematic SQL lines
sed 's/^SET @@SESSION.SQL_LOG_BIN/-- SET @@SESSION.SQL_LOG_BIN/' $database_name
sed 's/^SET @@GLOBAL.GTID_PURGED=/*!80000/-- SET @@GLOBAL.GTID_PURGED=/*!80000/' $database_name

# Drop current database
mysql -h $db_host -u $db_username -p $db_password -e "drop database $database_name"

# Create new database
mysql -h $db_host -u $db_username -p $db_password -e "create database $database_name"

# Import data
mysql -h $db_host -u $db_username -p $db_password < $database_name.sql

# -------------#
# Session Database
# -------------#

database_name='govwifi_staging'
db_host=$(get_secret('govwifi/sessions-db/credentials/hostname'))
db_username=$(get_secret "govwifi/sessions-db/credentials/username" | jq '.SecretString.username')
db_password=$(get_secret "govwifi/sessions-db/credentials/password" | jq '.SecretString.username')

sed 's/^SET @@SESSION.SQL_LOG_BIN/-- SET @@SESSION.SQL_LOG_BIN/' $database_name
sed 's/^SET @@GLOBAL.GTID_PURGED=/*!80000/-- SET @@GLOBAL.GTID_PURGED=/*!80000/' $database_name

# Drop current database
mysql -h $db_host -u $db_username -p $db_password -e "drop database $database_name"

# Create new database
mysql -h $db_host -u $db_username -p $db_password -e "create database $database_name"

# Import data
mysql -h $db_host -u $db_username -p $db_password < $database_name.sql

# Delete old database file
rm $database_name.sql
