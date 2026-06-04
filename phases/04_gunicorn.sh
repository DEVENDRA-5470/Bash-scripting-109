#!/bin/bash
echo "This is gunicorn file code"

set -e

cd /home/ubuntu/lms-app
source myenv/bin/activate

pkill gunicorn 2> /dev/null || true
sleep 2

CPU_CORS=$(nproc)
WORKERS=$((2 * CPU_CORS + 1))

nohup gunicorn -w $WORKERS -b 127.0.0.1:5000 app:app &
sleep 3

echo "Gunicorn Started Success ✅"
