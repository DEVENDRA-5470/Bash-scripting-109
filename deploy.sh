#!/bin/bash
set -e

PEM_KEY=$HOME/aws-deployments/my-new-lms.pem
ZIP_FILE=$HOME/aws-deployments/lms-app.zip
SCRIPTS_DIR="$(dirname "$0")"

read -p "Enter Your EC2 Public IP : " SERVER_IP
[ -z "$SERVER_IP" ] && echo "IP REQUIRED ❌" && exit 1

for phase in phases/01_upload.sh phases/02_install.sh phases/03_unzip_env.sh phases/04_gunicorn.sh phases/05_nginx.sh ; do
[ ! -f "$SCRIPTS_DIR/$phase" ] && echo "Scripts Not found ❌ : $SCRIPTS_DIR/$phase" && exit 1

done

 echo "ALL FILES ARE OKAY ✅"

echo "Calling upload.sh script for uploading all phases to server ..."

bash phases/01_upload.sh "$PEM_KEY" "$ZIP_FILE" "$SERVER_IP" "$SCRIPTS_DIR"

echo "Phase-1 Completed ✅"

echo "Running all phases on server for Auto Deployment"
ssh -q -T -i "$PEM_KEY" -o StrictHostKeyChecking=no "ubuntu@$SERVER_IP" << REMOTE
export SERVER_IP="$SERVER_IP"

set-e 

bash /home/ubuntu/deploy/02_install.sh
echo "Phase-2 Completed ✅"

bash /home/ubuntu/deploy/03_unzip_env.sh
echo "Phase-3 Completed ✅"

bash /home/ubuntu/deploy/04_gunicorn.sh
echo "Phase-4 Completed ✅"

bash /home/ubuntu/deploy/05_nginx.sh
echo "Phase-5 Completed ✅"

echo "Deployment Done ✅"

echo "App live at Open in browser: http://$SERVER_IP"

REMOTE 

