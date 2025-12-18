# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# --- User Exports, Aliases, and Functions ---

# Aliases
alias dbeaver21='dbeaver -vm /usr/lib/jvm/java-21-openjdk/bin/java'
alias nz='NVIM_APPNAME=nvim-zk nvim'
alias nt='NVIM_APPNAME=nvim-test nvim'
alias nb='NVIM_APPNAME=nvim-brian nvim'
alias nt2='NVIM_APPNAME=nvim-test-2 nvim'

# startup the ssh agent
eval $(keychain --eval --quiet id_ed25519)

# Environment Loading
. "$HOME/.local/share/../bin/env"

# LM Studio CLI
export PATH="$PATH:/home/zk/.lmstudio/bin"

# ROCm / AMD GPU Environment
export PATH="/opt/rocm/bin:$PATH"
export LD_LIBRARY_PATH="/opt/rocm/lib:$LD_LIBRARY_PATH"
export ROCM_HOME="/opt/rocm"

# Kiro Terminal Integration
if [[ "$TERM_PROGRAM" == "kiro" ]]; then
    . "$(kiro --locate-shell-integration-path bash)"
fi

# --- PATH Management (Cleaned & Deduplicated) ---

# Composer Tools (Global)
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Rust / Cargo
. "$HOME/.cargo/env"

# Local User Binaries
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --- Mise Version Manager (PHP, Node, Java, etc.) ---
# This replaces the manual shim exports and handles shell integration correctly
eval "$(mise activate bash)"

# --- Starship Prompt ---
eval "$(starship init bash)"
alias win='~/scripts/start-win.sh'
