#
# .bashrc
#

# Don't run non-interactively
[[ $- != *i* ]] && return

# Prompt
PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '

# Display if in guix env
if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="\u@\h \w [dev]\$ "
fi

# Load global shell configs
[ -f "$HOME/.config/shell/path" ] && source "$HOME/.config/shell/path"
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"
[ -f "$HOME/.config/shell/tools" ] && source "$HOME/.config/shell/tools"
