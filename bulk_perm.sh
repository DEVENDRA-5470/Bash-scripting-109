#!/bin/bash
for file in $(find . -name "*.sh")
do
chmod 400 $file
echo "Permission Applied 😎: $file "
done
