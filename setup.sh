#!/bin/zsh

###############################################################################
# Macbook Setup Script for Modern Web Development
# Author: brijr (https://brijr.dev)
# Last Updated: 2025
#
# This script sets up a new macOS machine for web development
# with a focus on TypeScript, React, and Next.js development.
# It includes modern tools and sensible defaults for a great
# developer experience.
###############################################################################

###############################################################################
# Error Handling & Logging Configuration
###############################################################################
set -euo pipefail  # -e: exit on error, -u: error on undefined var, -o pipefail: pipeline fails on the first failed command

# Logging function for better debugging and progress tracking
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling function that shows the line number where the error occurred
handle_error() {
    log "Error occurred in script at line: ${1}"
    exit 1
}

trap 'handle_error ${LINENO}' ERR

log "Starting setup script..."

###############################################################################
# Interactive Flags
###############################################################################
# Allows the user to choose between a minimal and a full installation
FULL_INSTALL=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --full)
            FULL_INSTALL=true
            shift
            ;;
        *)
            # Unknown option
            shift
            ;;
    esac
done

###############################################################################
# Architecture Check (Apple Silicon vs. Intel)
###############################################################################
IS_APPLE_SILICON=false
if [[ "$(uname -m)" == "arm64" ]]; then
    IS_APPLE_SILICON=true
    # Prepend Homebrew's Apple Silicon location to PATH
    export PATH="/opt/homebrew/bin:$PATH"
else
    # Prepend Homebrew's Intel location to PATH
    export PATH="/usr/local/bin:$PATH"
fi


###############################################################################
# Homebrew Installation & Update
###############################################################################
install_homebrew() {
    log "Checking for Homebrew..."
    if ! command -v brew &>/dev/null; then
        log "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log "Updating Homebrew..."
        brew update
    fi
}

###############################################################################
# Brew Packages
###############################################################################
brew_packages=(
    # Version Control
    git              # Version control system
    gh               # GitHub CLI for better GitHub integration

    # Node.js Development
    fnm              # Fast Node Manager
    pnpm             # Preferred package manager

    # Modern JavaScript/TypeScript Runtimes
    deno             # Secure runtime
    bun              # Fast all-in-one JS runtime

    # Terminal Improvements
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf

    # Editors and IDEs
    vim
    nvim

    # Development Tools
    python3
    rust
    docker          # CLI for Docker (optional if you’re using Docker Desktop)
    miniconda

    # Security
    gpg
    pinentry-mac
)

install_brew_packages() {
    log "Installing brew packages..."
    for package in "${brew_packages[@]}"; do
        log "Installing $package..."
        brew install "$package"
    done
}

###############################################################################
# Brew Cask Applications
###############################################################################
brew_cask_apps=(
    # Development Tools
    visual-studio-code
    cursor
    zed
    windsurf
    httpie
    docker-desktop       # Docker Desktop UI—see caution note below
    ngrok

    # Browsers
    arc
    firefox@developer-edition

    # Productivity
    raycast
    ghostty
    notion
    notion-calendar
    setapp
    rectangle
    maccy

    # Communication
    slack
    telegram
    discord
    zoom

    # Design Tools
    figma

    # Project Management
    linear-linear

    # Entertainment
    spotify
)

install_brew_cask_apps() {
    log "Installing cask applications..."

    for app in "${brew_cask_apps[@]}"; do
        # Verify the cask exists before installing
        if brew search --casks "$app" | grep -q "$app"; then
            log "Installing $app..."
            brew install --cask "$app"
        else
            log "Skipping $app, not found in Homebrew Cask."
        fi
    done
    
    # Caution note about Docker vs. Docker Desktop
    log "Note: You've installed both Docker CLI and Docker Desktop. If you plan on using Docker Desktop primarily, the standalone Docker CLI might be optional."
}

###############################################################################
# Optional: Single Source Configuration (Commented Example)
###############################################################################
# Instead of listing packages in the script, you could store them in a file:
#   brew_packages.txt
#   brew_cask_apps.txt
#   code_extensions.txt
# Then read them in:
#   while read -r pkg; do brew install "$pkg"; done < brew_packages.txt

###############################################################################
# Oh My Zsh Installation & Configuration
###############################################################################
install_oh_my_zsh() {
    # Install Oh My Zsh for better shell experience
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Optionally manage plugins with Oh My Zsh plugin system instead of Homebrew:
    #   plugins=(
    #       git
    #       node
    #       npm
    #       macos
    #       zsh-syntax-highlighting
    #       zsh-autosuggestions
    #   )

    # Install Typewritten prompt
    log "Installing Typewritten prompt..."
    npm install -g typewritten

    # Configure shell
    log "Configuring shell..."
    cat << 'EOF' >> ~/.zshrc

###########################################
# Shell Configuration
###########################################
# Load syntax highlighting and autosuggestions from brew
if [ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Set ZSH theme to Typewritten
ZSH_THEME="typewritten"

# Oh My Zsh Configuration
plugins=(
    git
    node
    npm
    macos
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Aliases for Development Workflow
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias p="pnpm"
alias pb="pnpm build"
alias c="clear"
alias l="ls -la"
alias ..="cd .."

# Environment Configuration
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

EOF
}

###############################################################################
# Global NPM Packages
###############################################################################
install_global_npm_packages() {
    log "Installing global npm packages..."
    pnpm add -g vercel typescript @antfu/ni prettier eslint
}

###############################################################################
# Git Configuration
###############################################################################
configure_git() {
    log "Configuring Git..."

    # User settings
    git config --global user.name "Bridger Tower"
    git config --global user.email "bridgertower@gmail.com"

    # Core settings
    git config --global init.defaultBranch main
    git config --global core.editor "code --wait"
    git config --global pull.rebase true
    git config --global core.excludesfile "$HOME/.gitignore_global"
    git config --global http.postBuffer 157286400

    # Custom aliases
    git config --global alias.send '!f() { git add . && git commit -m "${1:-wip}" && git push; }; f'

    # Create global gitignore file
    cat << EOF > ~/.gitignore_global
.DS_Store
.vscode/
.idea/
*.log
node_modules/
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
EOF

    # SourceTree configuration (optional)
    git config --global difftool.sourcetree.cmd 'opendiff "$LOCAL" "$REMOTE"'
    git config --global mergetool.sourcetree.cmd '/Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"'
    git config --global mergetool.sourcetree.trustExitCode true
}

###############################################################################
# SSH & GPG Configuration
###############################################################################
configure_ssh_gpg() {
    # Set up SSH key for GitHub
    log "Setting up SSH key..."
    ssh-keygen -t ed25519 -C "$(git config --get user.email)" -f "$HOME/.ssh/id_ed25519" -N ""

    # Configure GPG for signed commits
    log "Configuring GPG..."
    echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent
}

###############################################################################
# macOS System Preferences
###############################################################################
configure_macos_settings() {
    log "Configuring macOS settings..."

    # Dock preferences
    log "Configuring Dock..."
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 36
    defaults write com.apple.dock magnification -bool true

    # Screenshot settings
    log "Configuring Screenshots..."
    mkdir -p ~/Screenshots
    defaults write com.apple.screencapture location ~/Screenshots

    # Security settings
    log "Configuring Security..."
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Trackpad settings
    log "Configuring Trackpad..."
    defaults write -g com.apple.trackpad.scaling -float 2.5

    # Keyboard settings
    log "Configuring Keyboard..."
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Finder settings
    log "Configuring Finder..."
    defaults write com.apple.finder AppleShowAllFiles YES
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Restart affected apps
    log "Restarting affected applications..."
    killall Dock
    killall Finder
    killall SystemUIServer
}

###############################################################################
# VS Code Extensions
###############################################################################
code_extensions=(
    "alexcvzz.vscode-sqlite"
    "amazonwebservices.codewhisperer-for-command-line-companion"
    "bradlc.vscode-tailwindcss"
    "codeium.windsurfpyright"
    "esbenp.prettier-vscode"
    "formulahendry.auto-close-tag"
    "github.vscode-github-actions"
    "ms-azuretools.vscode-docker"
    "ms-python.debugpy"
    "ms-python.python"
    "raillyhugo.one-hunter"
    "redwan-hossain.auto-rename-tag-clone"
)

install_vscode_extensions() {
    log "Installing VS Code extensions..."

    # Make sure 'code' CLI is available or remind user to add it
    if ! command -v code &>/dev/null; then
        log "WARNING: 'code' command not found. Please enable 'code' CLI from VS Code."
        log "Skipping automatic extension installs..."
        return
    fi

    for extension in "${code_extensions[@]}"; do
        log "Installing VS Code extension: $extension..."
        code --install-extension "$extension"
    done
}

###############################################################################
# Main Execution
###############################################################################
main() {
    install_homebrew
    install_brew_packages
    install_oh_my_zsh

    # Only install cask applications if --full is used (example usage)
    if $FULL_INSTALL; then
        install_brew_cask_apps
        configure_ssh_gpg
    else
        log "Skipping full cask app installation (use --full to enable)."
    fi

    install_global_npm_packages
    configure_git
    configure_macos_settings
    install_vscode_extensions

    log "Setup completed successfully!"
    cat <<EOF

===================== NEXT STEPS =====================
1. Open a new terminal session or run 'source ~/.zshrc'
   to apply your new shell configuration.
2. If not done yet, manually install any apps not on 
   Homebrew (e.g. Craft, granola.ai, Things).
3. Consider configuring VS Code to sync settings 
   (Settings Sync) or manually log in to your account.
4. Enjoy your new development environment!
======================================================
EOF
}

main
