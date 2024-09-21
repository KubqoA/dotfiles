#!/usr/bin/env bash

set -e

ZONE="jakubarbet.me"

increment_serial() {
  local current_serial=$1
  local current_date=$(date +%Y%m%d)

  # Extract date and index from current serial
  local serial_date=${current_serial:0:8}
  local serial_index=${current_serial:8}

  # If the date has changed, reset index to 01
  if [ "$current_date" != "$serial_date" ]; then
    new_serial="${current_date}01"
  else
    # Increment the index, ensuring it's two digits
    new_index=$(printf "%02d" $((10#$serial_index + 1)))
    new_serial="$current_date$new_index"
  fi

  echo $new_serial
}

if [ ! -d /etc/named ]; then
  echo "[dnssec] /etc/named not found generating dnssec keys"
  mkdir -p /etc/named
  dnssec-keygen -a NSEC3RSASHA1 -b 2048 -K /etc/named -n ZONE "$ZONE" 2>/dev/null
  dnssec-keygen -f KSK -a NSEC3RSASHA1 -b 4096 -K /etc/named -n ZONE "$ZONE" 2>/dev/null
fi

if [ -f "/etc/named/$ZONE.conf.orig" ] && $(cmp -s ./jakubarbet.me.conf "/etc/named/$ZONE.conf.orig"); then
  echo "[dnssec] Zone not changed"
  exit
fi

cd /etc/named
current_serial="0000000000"
if [ -f "/etc/named/$ZONE.conf" ]; then
  current_serial=$(named-checkzone "$ZONE" "/etc/named/$ZONE.conf" | egrep -ho '[0-9]{10}')
fi
new_serial=$(increment_serial $current_serial)

cp ./jakubarbet.me.conf "/etc/named/$ZONE.conf"
cp "/etc/named/$ZONE.conf"{,.orig}
sed -i "s/\$SERIAL/$new_serial/" "$ZONE.conf"
echo "[dnssec] Zone $ZONE with serial $new_serial"

for key in `ls K$ZONE*.key`
do
  echo "\$INCLUDE $key">> "$ZONE.conf"
done

echo "[dnssec] Signing zone"
dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o "$ZONE" -t "$ZONE.conf" >/dev/null

echo "[dnssec] Please set the following DS records at the registrar"
cat "dsset-$ZONE."
