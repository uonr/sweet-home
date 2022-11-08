# Insert completion on first tab even if ambiguous
setopt menu_complete
# Highlight on tab
zstyle ':completion:*' menu select
# Ignore case
# https://stackoverflow.com/a/24237590
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
