#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

. "$HOME/.local/share/../bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/zk/.lmstudio/bin"
# End of LM Studio CLI section



# Added by Toolbox App
export PATH="$PATH:/home/zk/.local/share/JetBrains/Toolbox/scripts"

. "$HOME/.cargo/env"
