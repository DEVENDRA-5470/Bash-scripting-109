#!/bin/bash
SERVER=("DEV" "PROD" "TEST" "UAT")
for server in "${SERVER[@]}"
do makedir -p "$server"
echo "Folder $server Created..✅"
done
