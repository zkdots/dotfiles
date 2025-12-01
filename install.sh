#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Dotfiles Tool Installer..."

# Function to check and install a package
install_package() {
    PACKAGE=$1
    if pacman -Qi "$PACKAGE" &> /dev/null || yay -Qi "$PACKAGE" &> /dev/null; then
        echo "✅ $PACKAGE is already installed."
    else
        echo "📦 Installing $PACKAGE..."
        yay -S --noconfirm "$PACKAGE"
    fi
}

# 1. Ensure yay is installed
if ! command -v yay &> /dev/null; then
    echo "⚠️  yay is not installed. Installing yay-bin..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay-bin
else
    echo "✅ yay is already installed."
fi

# 2. List of tools to install
TOOLS=(
    "stow"
    "git"
    "neovim"
    "tmux"
    "alacritty"
    "starship"
    "hyprland"
    "ghostty"
)

# 3. Install tools
echo "🔄 Checking and installing tools..."
for tool in "${TOOLS[@]}"; do
    install_package "$tool"
done

# 4. Install Tmux Plugin Manager (TPM) if missing
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "🧩 Installing Tmux Plugin Manager..."
    mkdir -p "$TPM_DIR"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "✅ Tmux Plugin Manager is already installed."
fi

# 5. Set Ghostty as Default Terminal
echo "🖥️  Configuring Ghostty as default terminal..."

# Set TERMINAL env var in bashrc if not present
if ! grep -q "export TERMINAL=ghostty" "$HOME/.bashrc"; then
    echo "export TERMINAL=ghostty" >> "$HOME/.bashrc"
    echo "   - Added 'export TERMINAL=ghostty' to .bashrc"
fi

# Attempt to set via gsettings (for GNOME/GTK apps)
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty' 2>/dev/null || true
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg '' 2>/dev/null || true
    echo "   - Updated GNOME/GTK default terminal settings"
fi

# Attempt to set via xdg-mime (for file associations)
if command -v xdg-mime &> /dev/null; then
    xdg-mime default ghostty.desktop x-scheme-handler/terminal
    echo "   - Updated xdg-mime defaults"
fi

echo "🎉 All tools are installed and configured!"
