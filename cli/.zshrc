#
# .zshrc
#

# Don't run non-interactively
[[ $- != *i* ]] && return

# Colors and prompt
PS1="%B%{%F{green}%}[%n@%m%{%f%} %{%F{white}%}%~%{%f%}%{%F{green}%}]$%{%f%}%b "

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
compinit
_comp_options+=(globdots)

# VI mode
bindkey -v
export KEYTIMEOUT=1

# Edit line in $EDITOR
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load global shell configs
[ -f "$HOME/.config/shell/path" ] && source "$HOME/.config/shell/path"
[ -f "$HOME/.config/shell/aliases" ] && source "$HOME/.config/shell/aliases"
[ -f "$HOME/.config/shell/tools" ] && source "$HOME/.config/shell/tools"
