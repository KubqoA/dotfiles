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

if [ -f "/etc/named/$ZONE_NAME.zone.orig" ] && $(cmp -s "$ZONE_FILE" "/etc/named/$ZONE_NAME.zone.orig"); then
  echo "[dnssec] Zone $ZONE_NAME not changed"
else
  cd /etc/named
  current_serial="0000000000"
  if [ -f "/etc/named/$ZONE_NAME.zone" ]; then
    current_serial=$(named-checkzone "$ZONE_NAME" "/etc/named/$ZONE_NAME.zone" | egrep -ho '[0-9]{10}')
  fi
  new_serial=$(increment_serial $current_serial)
  
  cp "$ZONE_FILE" "/etc/named/$ZONE_NAME.zone"
  cp "/etc/named/$ZONE_NAME.zone"{,.orig}
  sed -i "s/\$SERIAL/$new_serial/" "$ZONE_NAME.zone"
  echo "[dnssec] Zone $ZONE_NAME with serial $new_serial"
  
  for key in `ls K$ZONE_NAME*.key`
  do
    echo "\$INCLUDE $key">> "$ZONE_NAME.zone"
  done
  
  echo "[dnssec] Signing zone"
  dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o "$ZONE_NAME" -t "$ZONE_NAME.zone" >/dev/null
  
  echo "[dnssec] Please set the following DS records at the registrar"
  cat "dsset-$ZONE_NAME."
fi

