#!/bin/bash
set -e

# Set permissions for GPU access
if [ -e /dev/dri/renderD128 ]; then
    chmod 666 /dev/dri/renderD128
fi

# If no arguments provided, use the default Nextcloud command
if [ $# -eq 0 ]; then
    echo "No arguments provided, using default: apache2-foreground"
    exec /entrypoint.sh apache2-foreground
else
    exec /entrypoint.sh "$@"
fi