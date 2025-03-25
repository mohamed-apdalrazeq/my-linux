#!/bin/bash

# MAC address of the Bluetooth device (replace this with your device's MAC address)
DEVICE_MAC="53:95:12:F3:08:2F"  # Replace with your device's MAC address

# Restart Bluetooth service
echo "Restarting Bluetooth service..."
doas sv restart bluetoothd

# Ensure Bluetooth is powered on
echo "Powering on Bluetooth..."
bluetoothctl power on

# Wait for a moment to ensure Bluetooth is powered on
sleep 2

# Make Bluetooth discoverable (optional)
echo "Making Bluetooth discoverable..."
bluetoothctl discoverable on

# Check if Bluetooth is powered on
STATUS=$(bluetoothctl show | grep "Powered: yes")
if [ -n "$STATUS" ]; then
    echo "Bluetooth is powered on."
else
    echo "Failed to power on Bluetooth."
    exit 1
fi

# Start scanning for devices (to discover the device if it's not already paired)
echo "Scanning for devices..."
bluetoothctl scan on
sleep 5  # Wait for devices to be discovered

# Stop scanning after some time
bluetoothctl scan off

# Try connecting to the device
echo "Attempting to connect to the device..."
bluetoothctl connect "$DEVICE_MAC"

# Check connection status
STATUS=$(bluetoothctl info "$DEVICE_MAC" | grep "Connected: yes")
if [ -n "$STATUS" ]; then
    echo "Successfully connected to the Bluetooth device!"
else
    echo "Failed to connect to the Bluetooth device. Ensure the device is in pairing mode and try again."
fi

