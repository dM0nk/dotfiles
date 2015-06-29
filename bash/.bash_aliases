#!/bin/bash



# Create alias for tmux
alias tmux="tmux -2"


#c++ compile with all warnings
alias gppw="g++ -Wall "
alias gpp="g++"


# copy a file with progress bar
alias copy_file="rsync -W --progress "

#copy a folder with progressbar
alias copy_folder="rsync -W -r --progress "


#remap cp and mv to be verbose
alias cp="cp -v"
alias mv="mv -v"

# unpack rar files.
alias unr="unrar e *.rar"

# Shortcuts to directorys
alias www="cd /storage/www"
alias code="cd /storage/code"
alias nconf="cd /etc/nginx/sites-enabled"

# storage serach using locate.
alias slocate="locate -d /straoge/.index/storage.db"




# vim: syntax=sh
