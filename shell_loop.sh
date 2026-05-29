#!/bin/bash
# for loop , while loop , unitl loop.
SERVER=("PROD" "TEST" "DEV" "UAT")

for ser in "${SERVER[@]}"
do echo "Server $((++k)): $ser" 
done
