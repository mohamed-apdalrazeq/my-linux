# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# Load custom keyboard layout
doas loadkeys .config/loadkeys/loadkeysrc
doas rfkill unblock bluetooth

# Set environment variables
export BROWSER="firefox"
export TERMINAL="st"
export TERM="st"
export PATH=$HOME/.local/bin/:$PATH
export PATH=$PATH:/opt/resolve/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PATH=$HOME/.dotnet:$HOME/.dotnet/tools:$PATH
export PATH=$PATH:/home/mohamed/project/VSCode/VSCode-linux-x64/bin/
export PATH=$HOME/.local:$PATH
export PATH=$DOTNET_ROOT:$PATH
export NNN_OPENER="$HOME/.config/nnn/mynnn_opener.sh"
export PATH="$PATH:$HOME/.netcoredbg/netcoredbg"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$HOME/.dotnet:$PATH

#GO
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Start X session if not already running
[[ ! $DISPLAY && $(tty) = "/dev/tty1" ]] && startx
