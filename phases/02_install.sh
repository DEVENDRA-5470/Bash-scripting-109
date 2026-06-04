#!/bin/bash
# PHASE-2 INSTALLATION TOOLS

set -e

echo "===== INSTALLING REQUIRED TOOLS ========"
sudo apt update -y > /dev/null 2>&1
sudo apt install -y python3 python3-pip python3-venv unzip nginx > /dev/null 2>&1

echo "All Tool updated or installed"

