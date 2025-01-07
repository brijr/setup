#!/bin/zsh

###########################################
# Macbook Setup Script for Modern Web Development
# Author: brijr (https://brijr.dev)
# Last Updated: 2025
#
# This script sets up a new macOS machine for web development
# with a focus on TypeScript, React, and Next.js development.
# It includes modern tools and sensible defaults for a great
# developer experience.
###########################################

###########################################
# Error Handling & Logging Configuration
###########################################
# Exit on error (-e) and undefined variables (-u)
# This helps catch problems early rather than causing
# issues later in the script
set -e  # Exit on error
set -u  # Exit on undefined variable

# Logging function for better debugging and progress tracking
# Format: [YYYY-MM-DD HH:MM:SS] Message
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling function that shows the line number
# where the error occurred
handle_error() {
    log "Error occurred in script at line: ${1}"
    exit 1
}

# Trap any errors and handle them with our error function
trap 'handle_error ${LINENO}' ERR

log "Starting setup script..."

###########################################
# Homebrew Installation & Update
###########################################
# Check if Homebrew is installed, install if missing
if ! command -v brew &> /dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew to latest version
log "Updating Homebrew..."
brew update

###########################################
# Core Development Tools Installation
###########################################
# Install essential development packages
# Each tool is carefully chosen for modern web development
log "Installing brew packages..."
packages=(
    # Version Control
    git              # Version control system
    gh               # GitHub CLI for better GitHub integration

    # Node.js Development
    fnm              # Fast Node Manager (better than nvm)
    pnpm             # Preferred package manager (faster than npm)
    
    # Modern JavaScript/TypeScript Runtimes
    deno             # Secure runtime with TypeScript support
    bun              # Fast all-in-one JavaScript runtime
    
    # Terminal Improvements
    zsh-syntax-highlighting    # Better command highlighting
    zsh-autosuggestions        # Fish-like autosuggestions
    fzf                        # Fuzzy finder for terminal
    
    # Editors and IDEs
    vim             # Terminal text editor
    nvim            # Modern, async vim-based editor
    
    # Development Tools
    python3         # Python programming language
    rust            # Systems programming language
    docker          # Containerization platform
    miniconda       # Minimal conda installation
    
    # Security
    gpg             # GNU Privacy Guard for signing commits
    pinentry-mac    # Secure password entry for GPG
)

for package in "${packages[@]}"; do
    log "Installing $package..."
    brew install "$package"
done

###########################################
# Application Installation
###########################################
# Install GUI applications via Homebrew Cask
log "Installing applications..."
apps=(
    # Development Tools
    visual-studio-code   # Primary code editor
    cursor               # AI-powered code editor
    zed                  # Fast, collaborative editor
    windsurf             # AI-powered IDE
    httpie               # CLI for HTTP requests
    docker-desktop       # Docker management
    ngrok                # Local tunnel for testing
    
    # Browsers
    arc                          # AI-powered browser optimized for developers
    firefox@developer-edition    # Firefox with developer tools
    
    # Productivity
    raycast            # Spotlight replacement with extensions
    ghostty            # Modern terminal emulator
    notion             # Notes and documentation
    notion-calendar    # Calendar integration
    setapp             # Curated app store
    rectangle          # Window management
    maccy              # Clipboard manager
    
    # Communication
    slack              # Team communication
    telegram           # Instant messaging
    discord            # Developer communities
    zoom               # Video conferencing
    
    # Design Tools
    figma              # UI/UX design tool
    
    # Project Management
    linear-linear      # Modern project management
    
    # Entertainment
    spotify            # Music streaming
)

for app in "${apps[@]}"; do
    log "Installing $app..."
    brew install --cask "$app"
done

###########################################
# Manual Installation Reminders
###########################################
# Some apps need to be installed manually
# granola.ai - AI notes platform
# craft.do - Native documentation tool
# things - Task management (App Store)
# cyberduck - SFTP client (paid for it on the App Store)

###########################################
# Shell Configuration (Oh My Zsh & Typewritten)
###########################################
# Install Oh My Zsh for better shell experience
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Typewritten prompt
log "Installing Typewritten prompt..."
npm install -g typewritten

# Configure shell with plugins and settings
log "Configuring shell..."
cat << 'EOF' >> ~/.zshrc
###########################################
# Shell Configuration
###########################################
# Load syntax highlighting and autosuggestions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
EOF

###########################################
# Aliases for Development Workflow
###########################################
# Git shortcuts
alias gs="git status"
alias gc="git commit"
alias gp="git push"

# Package manager shortcuts
alias p="pnpm"
alias pb="pnpm build"

# Navigation shortcuts
alias c="clear"
alias l="ls -la"
alias ..="cd .."

###########################################
# Environment Configuration
###########################################
# PNPM configuration
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Rust toolchain
export PATH="$HOME/.cargo/bin:$PATH"

###########################################
# Global NPM Packages
###########################################
# Install essential global packages for web development
log "Installing global npm packages..."
pnpm add -g vercel typescript @antfu/ni prettier eslint

###########################################
# Git Configuration
###########################################
# Configure Git with modern defaults
log "Configuring Git..."
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global pull.rebase true

###########################################
# SSH & GPG Configuration
###########################################
# Set up SSH key for GitHub
log "Setting up SSH key..."
ssh-keygen -t ed25519 -C "$(git config --get user.email)"

# Configure GPG for signed commits
log "Configuring GPG..."
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent

###########################################
# macOS System Preferences
###########################################
# Configure macOS for development
log "Configuring macOS settings..."
# Finder settings
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Keyboard settings
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###########################################
# VS Code Extensions
###########################################
# Install essential VS Code extensions for web development
log "Installing VS Code extensions..."
code_extensions=(
    "bradlc.vscode-tailwindcss"      # Tailwind CSS IntelliSense
    "dsznajder.es7-react-js-snippets" # React/Redux snippets
    "dbaeumer.vscode-eslint"         # ESLint integration
    "esbenp.prettier-vscode"         # Prettier formatting
    "github.copilot"                 # AI code completion
    "github.copilot-chat"            # AI chat interface
)

for extension in "${code_extensions[@]}"; do
    log "Installing VS Code extension: $extension..."
    code --install-extension "$extension"
done

log "Setup completed successfully!"
