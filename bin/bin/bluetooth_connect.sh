#!/bin/sh

# Device MAC addresses and names
DEVICE1_MAC="98:47:44:D8:ED:8A"
DEVICE1_NAME="soundcore Life Q30"

DEVICE2_MAC="14:51:20:08:44:42"
DEVICE2_NAME="HUAWEI FreeBuds SE"

# Function to handle connection
connect_device() {
    MAC=$1
    NAME=$2
    
    # Check if already connected
    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        echo "✓ $NAME is already connected."
        return 0
    fi

    # Check if paired
    if bluetoothctl info "$MAC" | grep -q "Paired: yes"; then
        echo "⌛ Connecting to $NAME..."
        bluetoothctl connect "$MAC"
    else
        echo "🔍 Scanning for $NAME..."
        bluetoothctl scan on &
        SCAN_PID=$!
        
        # Wait for device discovery (adjust time as needed)
        sleep 10  
        
        # Stop scanning
        bluetoothctl scan off
        kill $SCAN_PID
        
        echo "⚡ Pairing with $NAME..."
        if echo -e "pair $MAC\n" | bluetoothctl | grep -q "Pairing successful"; then
            sleep 2
            bluetoothctl trust "$MAC"
            bluetoothctl connect "$MAC"
        else
            echo "❌ Failed to pair. Ensure $NAME is in pairing mode."
            return 1
        fi
    fi
}

# Select device (1 or 2)
SELECTED_DEVICE=1  # Change this value to switch devices

case $SELECTED_DEVICE in
    1)
        connect_device "$DEVICE1_MAC" "$DEVICE1_NAME"
        ;;
    2)
        connect_device "$DEVICE2_MAC" "$DEVICE2_NAME"
        ;;
    *)
        echo "Error: Select 1 or 2 to choose the device."
        exit 1
        ;;
esac
