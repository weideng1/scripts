#!/bin/bash

function show_help {
  echo "Automatically assign WiFi network based on location"
  echo "Usage: $0"
}

OPTIND=1

# quiet mode not used right now
QUIET_MODE=0

while getopts "h?q" opt; do
  case "$opt" in
  h|\?)
    show_help
    exit 0
    ;;
  q) QUIET_MODE=1
    ;;
  esac
done

export location=`/usr/local/bin/whereami predict`
case $location in
studyroom)
  ssid="weihome"
  ;;
dinningroom)
  ssid="weihome"
  ;;
mainbedroom)
  ssid="weihome_EXT"
  ;;
livingroom)
  ssid="weihome_GARDEN"
  ;;
*)
  ssid="weihome"
  ;;
esac
echo "Connecting to $ssid ..."

AIRPORT="en0"
WIFI_NETWORK_NAME="$ssid"
WIFI_PASSWORD="xxxxxxxx"

CURRENT_WIFI_NETWORK_NAME=`/usr/sbin/networksetup -getairportnetwork $AIRPORT | awk '{print $NF}'` 
if [ "$CURRENT_WIFI_NETWORK_NAME" == "$WIFI_NETWORK_NAME" ];
then
    echo "Already connected to $ssid!";
    exit 0
fi
 
if /usr/sbin/networksetup -setairportnetwork $AIRPORT $WIFI_NETWORK_NAME $WIFI_PASSWORD | grep -i -a "Failed" ;
then
    echo "Failed to connect, just restarting...";
    /usr/sbin/networksetup -setairportpower $AIRPORT off
    /usr/sbin/networksetup -setairportpower $AIRPORT on
    sleep 1
fi
 
/usr/sbin/networksetup -getairportnetwork $AIRPORT

