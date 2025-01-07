#!/bin/zsh

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
brew update

# Install packages
packages=(
    git
    node
    python3
    vim
    zsh-syntax-highlighting
    zsh-autosuggestions
    gh
    pnpm
    nvim
    docker
    miniconda
)

for package in "${packages[@]}"; do
    brew install "$package"
done

# Install apps
apps=(
    raycast
    ghostty
    notion
    setapp
    zoom
    zed
    cursor
    windsurf
    linear-linear
    spotify
    figma
    slack
    discord
    maccy
    rectangle
    notion-calendar
)

for app in "${apps[@]}"; do
    brew install --cask "$app"
done

# Non-brew installs
# granola.ai
# craft.do
# things (app store)

# Add zsh plugins to .zshrc
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
