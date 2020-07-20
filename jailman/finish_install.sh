#!/usr/local/bin/bash
# This file contains the install script for transmission

#init jail
initplugin "$1"

# Initialise defaults

# Check if dataset Downloads dataset exist, create if they do not.
createmount "$1" "${global_dataset_downloads}" /mnt/downloads

# Check if dataset Complete Downloads dataset exist, create if they do not.
createmount "$1" "${global_dataset_downloads}"/complete /mnt/downloads/complete

# Check if dataset InComplete Downloads dataset exist, create if they do not.
createmount "$1" "${global_dataset_downloads}"/incomplete /mnt/downloads/incomplete

iocage exec "$1" chown -R transmission:transmission /config

# Start service once to create the files needed
iocage exec "$1" service transmission start
sleep 2 # It can take a few seconds.
iocage exec "$1" service transmission stop

# Without the whitelist disabled, the user will not be able to access it. They can reenable and manually whitelist their IP's.
SETTINGS="/config/settings.json"

echo "Disabling RPC whitelist, you may want to reenable it with the specific IP's you will access transmission with by editing $SETTINGS"
sed -i '' -e 's/\([[:space:]]*"rpc-whitelist-enabled":[[:space:]]*\)true,/\1false,/' $SETTINGS

iocage exec "$1" service transmission restart
exitplugin "$1"
