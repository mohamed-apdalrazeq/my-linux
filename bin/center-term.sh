#!/bin/bash

WINDOW_NAME="centered-term"
GEOMETRY="80x25+0+0"

# Search for the window using its name and class (to avoid conflicts with other names)
window_id=$(wmctrl -lx | grep -i "$WINDOW_NAME" | awk '{print $1}')

if [ -z "$window_id" ]; then
    # If the window does not exist, create it with the specified name and class
    st -c "$WINDOW_NAME" -T "$WINDOW_NAME" -g "$GEOMETRY" &
else
    # If the window exists, toggle its visibility (minimized ↔ visible)
    current_desktop=$(xdotool get_desktop)
    
    # 1. Move the window to the current desktop
    wmctrl -i -r "$window_id" -t "$current_desktop"
    
    # 2. Toggle the window state (hidden ↔ visible)
    if xprop -id "$window_id" | grep -q 'window state: Iconic'; then
        # If minimized, show it
        xdotool windowmap "$window_id"
        wmctrl -i -a "$window_id"
    else
        # If visible, minimize it
        xdotool windowunmap "$window_id"
    fi
fi

