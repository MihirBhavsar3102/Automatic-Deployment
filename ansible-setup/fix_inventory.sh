#!/bin/bash

INVENTORY_FILE="/mnt/c/Mihir Bhavsar/Automatic Deployment/ansible-setup/inventory"

echo "Fixing inventory file: $INVENTORY_FILE"

# 1. Convert encoding (UTF-16 to UTF-8)
iconv -f utf-16 -t utf-8 "$INVENTORY_FILE" -o "$INVENTORY_FILE.tmp" && mv "$INVENTORY_FILE.tmp" "$INVENTORY_FILE"

# 2. Convert Windows line endings to Unix
dos2unix "$INVENTORY_FILE"

# 3. Set correct permissions
chmod 644 "$INVENTORY_FILE"

echo "Inventory file fixed and ready to use!"
