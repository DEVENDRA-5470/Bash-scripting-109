#!/bin/bash
set -e

PEM_KEY=$1
ZIP_FILE=$2
SERVER_IP=$3
SCRIPTS_DIR=$4

echo " "
echo "====== Phase-1 Checking files ======"
[ ! -f "$PEM_KEY" ] && echo "Pem file not found ❌" && exit 1
[ ! -f "$ZIP_FILE" ] && echo "Zip file not found ❌" && exit 1
echo "✅ Local files found"

echo " "
echo "========= REMOTE FILE CHECK ========="
REMOTE_FILE=$(basename "$ZIP_FILE")
echo "REMOTE-FILE : $REMOTE_FILE"

REMOTE_ZIP=$(ssh -i "$PEM_KEY" -o StrictHostKeyChecking=no "ubuntu@$SERVER_IP" \
    "[ -f /home/ubuntu/$REMOTE_FILE ] && echo 'exists' || echo 'missing'")
echo "REMOTE-ZIP : $REMOTE_ZIP"

if [ "$REMOTE_ZIP" == "exists" ]; then
    echo "File already exists skipping upload...! ⚠️"
else
    echo " "
    echo "======== Uploading zip project ========="
    scp -i "$PEM_KEY" -o StrictHostKeyChecking=no "$ZIP_FILE" "ubuntu@$SERVER_IP:/home/ubuntu/"
    echo "Project uploaded to server ✅"
fi

echo " Creating folder on server : deploy ✅"

ssh -i "$PEM_KEY" -o StrictHostKeyChecking=no "ubuntu@$SERVER_IP" "mkdir -p /home/ubuntu/deploy"
echo "Deploy folder ready ✅"

echo "Uploading phase scripts to server in deploy folder ✅"

for script in 02_install.sh 03_unzip_env.sh 04_gunicorn.sh 05_nginx.sh ; do
  scp -i "$PEM_KEY" -o StrictHostKeyChecking=no "$SCRIPTS_DIR/phases/$script" "ubuntu@$SERVER_IP:/home/ubuntu/deploy/"
done

echo "$script Uploaded ✅"


