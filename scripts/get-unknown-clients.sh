#!/bin/bash

START_DATE=${START_DATE:-"1d ago"}
TARGET_PORT=${TARGET_PORT:-"1812"}
LOG_GROUP="wifi-frontend-docker-log-group"
REGEX="\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}"

# check if we have the awslogs utility setup
check_awslogs_exists() {
    command -v awslogs >/dev/null 2>&1 || {
        echo "\`awslogs\` command is missing." >&2
        echo "Please install \`awslogs\` from https://github.com/jorgebastida/awslogs"
        exit 1
    }
}

check_region() {
    if [[ ! ${AWS_REGION} ]]; then
        echo "AWS_REGION is not set."
        exit 1
    fi
}

run_command() {
    COMMAND="awslogs get ${LOG_GROUP} --start=\"${START_DATE}\""
    if [[ ${END_DATE} ]]; then
        COMMAND="${COMMAND} --end=${END_DATE}"
    fi
    COMMAND="${COMMAND} --filter-pattern=\"unknown client\" --no-color | grep \"port ${TARGET_PORT}\" | grep -o \"${REGEX}\" | sort | uniq -c | sort -nr"

    echo "Region       : ${AWS_REGION}"
    echo "Start date   : ${START_DATE}"
    echo "Target port  : ${TARGET_PORT}"
    echo "Rejected IPs : "
    eval $COMMAND
}

check_awslogs_exists
check_region
run_command
