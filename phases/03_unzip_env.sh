#!/bin/bash

set -e

echo "This is unzip and env file"

echo "Unzipping Project folder ......"
rm -rf /home/ubuntu/lms-app
unzip /home/ubuntu/lms-app.zip
cd /home/ubuntu/lms-app

echo "Virtual Environment Creating ...."

python3 -m venv myenv
source myenv/bin/activate

echo "Installing Dependencies...."
pip install -r requirements.txt
pip install gunicorn -q 

echo "Migration for DB...."
export FLASK_APP=app.py
flask db upgrade

