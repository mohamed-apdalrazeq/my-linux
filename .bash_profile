# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# Load custom keyboard layout
doas loadkeys .config/loadkeys/loadkeysrc
doas rfkill unblock bluetooth

# Set environment variables
export BROWSER="DRI_PRIME=1 firefox"
export TERMINAL="st"
export TERM="st"
export PATH=$HOME/.local/bin/:$PATH
export PATH=$PATH:/opt/resolve/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export DRI_PRIME=1
export PATH=$PATH:/home/mohamed/project/VSCode/VSCode-linux-x64/bin/
export PATH=$HOME/.local:$PATH

export PATH=$DOTNET_ROOT:$PATH


# Start X session if not already running
[[ ! $DISPLAY && $(tty) = "/dev/tty1" ]] && startx
