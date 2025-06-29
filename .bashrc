# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
set -o vi
alias ls='ls --color=auto'

##PS1='\[\033[01;31m\]\W >\[\033[00m\] '
PS1='\[\033[38;5;85m\]\W\[\033[01;31m\] >\[\033[00m\] '

alias ll='ls -l'
alias i='doas xbps-install -S'
alias u='i; doas xbps-install -u xbps; doas xbps-install -u'
alias q='doas xbps-query -Rs'
alias r='doas xbps-remove -R'
alias s='source ~/.bashrc'
alias m='doas dhclient -v wlp2s0'

##yt-dlp
alias y='yt-dlp -F'
alias f='yt-dlp -f best'
alias c='yt-dlp -f bestvideo+bestaudio --merge-output-format mp4'
alias C='yt-dlp --cookies-from-browser firefox'
alias 1080='yt-dlp -f "bv[height=1080]+ba" -o "%(playlist_index)s - %(title).100s.%(ext)s"'
alias 1080r='yt-dlp --playlist-reverse -f "bv[height=1080]+ba" -o "%(playlist_title)s/%(playlist_index)03d - %(title).100s.%(ext)s"'
alias 720='yt-dlp -f "bv[height=720]+ba" -o "%(playlist_title)s/%(playlist_index)03d - %(title).100s.%(ext)s"'
alias 720r='yt-dlp --playlist-reverse -f "bv[height=720]+ba" -o "%(playlist_title)s/%(playlist_index)03d - %(title).100s.%(ext)s"'

alias unb='doas rfkill unblock bluetooth'
alias res='doas sv restart bluetoothd'
alias n='nnn'
alias h='htop'
alias t='btm'
alias l='lsblk'
alias b="bluetoothctl"

##dotnet
alias M='dotnet add package Microsoft.CodeAnalysis.CSharp'
alias dr='dotnet ef migrations remove'
alias da='dotnet ef migrations add'
alias du='dotnet ef database update'
alias d='dotnet run'
alias dg='dotnet new gitignore'

##vim
alias vi='vim-huge'
##set -o vi

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Alias's to show disk space and space used in a folder
alias folders='/usr/bin/du -h --max-depth=1'
alias treed='tree -CAFd'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# This alias uses ffmpeg to record the computer screen at a resolution of 1366x768 and saves it as an mp4 video file.
# The frame rate is set to 25 frames per second, and it uses x11grab to capture the screen on Linux systems.
alias f='ffmpeg -video_size 1366x768 -framerate 25 -f x11grab -i :0.0 output.mov'

# اختصار للدالة التي تبحث عن عناوين الـ IP
alias myip="whatsmyip"

# دالة للبحث عن عناوين الـ IP الداخلية والخارجية
function whatsmyip() {
    # Detect internal IP address for either WiFi or Ethernet
    if command -v ip &>/dev/null; then
        internal_ip=$(ip addr show wlp2s0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
        if [ -z "$internal_ip" ]; then
            internal_ip=$(ip addr show enp1s0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
        fi
    else
        internal_ip=$(ifconfig wlp2s0 2>/dev/null | grep "inet " | awk '{print $2}')
        if [ -z "$internal_ip" ]; then
            internal_ip=$(ifconfig enp1s0 2>/dev/null | grep "inet " | awk '{print $2}')
        fi
    fi

    # Print the internal IP address
    if [ -n "$internal_ip" ]; then
        echo "Internal IP: $internal_ip"
    else
        echo "Internal IP: Not found"
    fi

    # Print the external IP address
    external_ip=$(curl -s ifconfig.me)
    echo "External IP: $external_ip"
}
