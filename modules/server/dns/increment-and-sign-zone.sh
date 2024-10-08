#!/usr/bin/env bash

set -e

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

if [ -f "/etc/named/$ZONE.zone.orig" ] && $(cmp -s "$ZONE_PATH" "/etc/named/$ZONE.zone.orig"); then
  echo "[dnssec] Zone $ZONE not changed"
  exit
fi

cd /etc/named
current_serial="0000000000"
if [ -f "/etc/named/$ZONE.zone" ]; then
  current_serial=$(named-checkzone "$ZONE" "/etc/named/$ZONE.zone" | egrep -ho '[0-9]{10}')
fi
new_serial=$(increment_serial $current_serial)

cp "$ZONE_PATH" "/etc/named/$ZONE.zone"
cp "/etc/named/$ZONE.zone"{,.orig}
sed -i "s/\$SERIAL/$new_serial/" "$ZONE.zone"
echo "[dnssec] Zone $ZONE with serial $new_serial"

for key in `ls K$ZONE*.key`
do
  echo "\$INCLUDE $key">> "$ZONE.zone"
done

echo "[dnssec] Signing zone"
dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o "$ZONE" -t "$ZONE.zone" >/dev/null

echo "[dnssec] Please set the following DS records at the registrar"
cat "dsset-$ZONE."
