# Insert completion on first tab even if ambiguous
setopt menu_complete
# Highlight on tab
zstyle ':completion:*' menu select
# Ignore case
# https://stackoverflow.com/a/24237590
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# How to edit command line in full screen editor in ZSH?
# https://unix.stackexchange.com/a/34251
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
