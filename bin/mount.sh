#!/bin/bash

MOUNT_DIR="/mnt"

# Ensure main mount directory exists
[ ! -d "$MOUNT_DIR" ] && doas mkdir -p "$MOUNT_DIR"

mount_device() {
    DEVICE="$1"
    MOUNT_POINT="$MOUNT_DIR/$DEVICE"
    USER_ID=$(id -u)
    GROUP_ID=$(id -g)
    
    # Check if device actually exists
    if [ ! -b "/dev/$DEVICE" ]; then
        echo "Error: Device does not exist!" | dmenu -i -p "Error:"
        exit 1
    fi

    FSTYPE=$(lsblk -no FSTYPE "/dev/$DEVICE")

    # Create mount directory
    doas mkdir -p "$MOUNT_POINT"

    case "$FSTYPE" in
        "ntfs")
            doas mount -t ntfs-3g -o "uid=$USER_ID,gid=$GROUP_ID,umask=077" "/dev/$DEVICE" "$MOUNT_POINT"
            ;;
        "vfat"|"exfat")
            doas mount -o "uid=$USER_ID,gid=$GROUP_ID,fmask=177,dmask=077" "/dev/$DEVICE" "$MOUNT_POINT"
            ;;
        *)
            doas mount -o "uid=$USER_ID,gid=$GROUP_ID" "/dev/$DEVICE" "$MOUNT_POINT"
            ;;
    esac

    echo "Mounted /dev/$DEVICE at $MOUNT_POINT"
}

unmount_device() {
    DEVICE="$1"
    MOUNT_POINT="$MOUNT_DIR/$DEVICE"

    if doas umount -l "$MOUNT_POINT"; then
        echo "Unmounted /dev/$DEVICE"
        doas rmdir "$MOUNT_POINT"
    else
        echo "Failed to unmount /dev/$DEVICE!" | dmenu -i -p "Error:"
        exit 1
    fi
}

# Generate partition list
DEVICE=$(lsblk -ln -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE | awk '
    /part/ && !/SWAP/ {
        if ($4 == "") status = "[Unmounted]"; else status = "[Mounted]"
        printf "%s (%s) %s\n", $1, $2, status
    }' | dmenu -i -l 10 -p "Select partition:")

[ -z "$DEVICE" ] && exit 1

# Extract device name
DEVICE_NAME=$(echo "$DEVICE" | awk '{print $1}')

# Validate device existence
if [ ! -b "/dev/$DEVICE_NAME" ]; then
    echo "Error: Selected partition does not exist!" | dmenu -i -p "Error:"
    exit 1
fi

# Check mount status
MOUNTED=$(lsblk -no MOUNTPOINT "/dev/$DEVICE_NAME")

if [ -n "$MOUNTED" ]; then
    RESPONSE=$(echo -e "Unmount\nCancel" | dmenu -i -p "/dev/$DEVICE_NAME is mounted. Action:")
    [ "$RESPONSE" = "Unmount" ] && unmount_device "$DEVICE_NAME"
else
    RESPONSE=$(echo -e "Mount\nCancel" | dmenu -i -p "/dev/$DEVICE_NAME is unmounted. Action:")
    [ "$RESPONSE" = "Mount" ] && mount_device "$DEVICE_NAME"
fi

exit 0
