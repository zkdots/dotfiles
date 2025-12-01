
. "$HOME/.local/share/../bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/zk/.lmstudio/bin"
# End of LM Studio CLI section

# Make mise available in all sessions
eval "$(mise activate bash)"


# Added by Toolbox App
export PATH="$PATH:/home/zk/.local/share/JetBrains/Toolbox/scripts"

. "$HOME/.cargo/env"
export PATH="$HOME/.local/share/mise/shims:$PATH"
