#!/bin/sh

DATABASES_FILE="./databases2.nix"
PASSWORD_FILE="./password2.nix"
WIRELESS_FILE="./wireless2.nix"

echo "[ ]" >$DATABASES_FILE

echo "\"$(nix-shell -p mkpasswd --run "mkpasswd --rounds 500000 -m sha-512 --salt $(head -c 40 /dev/random | base64 | sed -e 's/+/./g' |  cut -b 10-25)")\"" >$PASSWORD_FILE

echo "{ }" >$WIRELESS_FILE
