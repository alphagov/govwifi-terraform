#!/bin/bash

# Get the current date in seconds since epoch
current_date=$(date +%s)

# List all IAM users
users=$(aws iam list-users --query "Users[].UserName" --output text)

# Days to wait before deactivating key
deactivate_after_days=45

# Loop through users
for user in $users; do
    
    # Get access keys for the user
    access_keys=$(aws iam list-access-keys --user-name "$user" --query "AccessKeyMetadata[?Status=='Active'].{AccessKeyId:AccessKeyId,CreateDate:CreateDate}" --output json)

    # Loop through access keys
    for key in $(echo "$access_keys" | jq -c '.[]'); do
        access_key_id=$(echo "$key" | jq -r '.AccessKeyId')
        create_date=$(echo "$key" | jq -r '.CreateDate')

        # Get information about the last time the key was used
        last_used_info=$(aws iam get-access-key-last-used --access-key-id "$access_key_id")

        # # Extract the LastUsedDate field
        last_used_date=$(echo "$last_used_info" | jq -r '.AccessKeyLastUsed.LastUsedDate')

        # Calculate the difference in days
        if [ "$last_used_date" != "null" ]; then
            last_used_seconds=$(date --date="$last_used_date" +%s)
            days_inactive=$(( (current_date - last_used_seconds) / 86400 ))
            
            if (( "$days_inactive" > $deactivate_after_days )); then
                echo "Making Access Key inactive: User: $user, Access Key: $access_key_id. It has not been used for $days_inactive days"
                aws iam update-access-key --user-name "$user" --access-key-id "$access_key_id" --status Inactive 
            fi
        else
            # If the key has never been used calculate how long ago the key was created
            create_date_seconds=$(date --date="$create_date" +%s)
            days_inactive=$(( (current_date - create_date_seconds) / 86400 ))
            
            if (( "$days_inactive" > $deactivate_after_days )); then
                echo "Deactivating keys that have never been used"
                echo "Making Access Key inactive: User: $user, Access Key: $access_key_id. It was created $days_inactive days ago and not used"
                aws iam update-access-key --user-name "$user" --access-key-id "$access_key_id" --status Inactive 
            fi
        fi
    done
done