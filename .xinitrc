setxkbmap -layout us,ara -variant ,digits -option grp:sclk_toggle caps:escape
feh --bg-scale ~/my-pictures/wallpapers/10.png &
dwmblocks &

xautolock \
  -time 30 \
  -locker "sleep.sh" \
  -killtime 60 \
  -killer "doas -n shutdown -h now" &

sxhkd &
dwm
