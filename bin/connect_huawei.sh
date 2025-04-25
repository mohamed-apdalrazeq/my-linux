#!/bin/sh

MAC=""
NAME=""

# Reset previous operations
bluetoothctl scan off >/dev/null 2>&1
bluetoothctl disconnect "$MAC" >/dev/null 2>&1

# Connection handler
if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    echo "$NAME is already connected."
    exit 0
fi

if bluetoothctl info "$MAC" | grep -q "Paired: yes"; then
    echo "Connecting to $NAME..."
    bluetoothctl connect "$MAC" || {
        sleep 3
        bluetoothctl connect "$MAC"
    }
else
    echo "Starting pairing process..."
    bluetoothctl scan on &
    SCAN_PID=$!
    sleep 10
    bluetoothctl scan off
    kill $SCAN_PID 2>/dev/null
    
    echo "Pairing with $NAME..."
    if echo -e "pair $MAC\n" | bluetoothctl | grep -q "Pairing successful"; then
        bluetoothctl trust "$MAC"
        sleep 2
        bluetoothctl connect "$MAC"
    else
        echo "Pairing failed. Ensure $NAME is in pairing mode."
        exit 1
    fi
fi
