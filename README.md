# Modern macOS Development Setup

![Developer Setup](https://github.com/user-attachments/assets/f4272ead-dd53-4529-8e2a-ae420b5275ae)

A comprehensive setup script for modern web development on macOS, focusing on TypeScript, React 19, Next.js 15, and related technologies.

## Features

- 🚀 One-command setup for your entire development environment
- 🛠️ Essential development tools and CLI utilities
- 📦 Modern package management with pnpm
- 🔧 Optimized VS Code configuration
- ⚡️ Performance-focused macOS settings
- 🔒 Secure Git and SSH configuration
- 📝 Detailed logging and error handling
- 🔄 Automatic backup of existing configurations

## What's Included

### Core Development Tools

- Git with enhanced configuration
- Node.js (via fnm) with pnpm
- Python 3 and Rust
- Docker and development containers
- Modern CLI tools (gh, fzf, etc.)

### Applications

- VS Code with curated extensions
- Modern terminal setup (zsh + typewritten)
- Development-focused browsers
- Essential productivity tools
- Design and collaboration apps

### Configurations

- Optimized macOS system preferences
- Git configuration with useful aliases
- SSH and GPG setup for secure development
- VS Code settings and extensions
- Shell configuration with useful aliases

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/brijr/setup.git
   cd setup
   ```

2. Make the script executable:

   ```bash
   chmod +x setup.sh
   ```

3. Run the setup:
   ```bash
   ./setup.sh        # Basic installation
   ./setup.sh --full # Full installation with all apps
   ```

## Customization

The script is designed to be easily customizable. Edit these files to modify the installation:

- `packages.txt`: Homebrew packages
- `apps.txt`: macOS applications
- `vscode-extensions.txt`: VS Code extensions

## How to Customize This Template

Want to make this setup script your own? Here's how to customize every aspect of it:

### 1. Fork and Clone

First, fork this repository and clone it:

```bash
git clone https://github.com/YOUR_USERNAME/setup.git
cd setup
```

### 2. Customize Package Lists

#### Development Tools (`packages.txt`)

Edit `packages.txt` to modify which Homebrew packages to install:

```txt
# Version Control
git              # Keep this for Git support
gh               # GitHub CLI (remove if not needed)

# Add your preferred packages
golang           # Go language support
rust             # Systems programming
bun              # JavaScript runtime

# Remove any packages you don't need
# Add comments to document why you need each package
```

#### Applications (`apps.txt`)

Modify `apps.txt` to change which macOS applications to install:

```txt
# Development
visual-studio-code   # Main editor
iterm2              # Terminal emulator

# Add your preferred apps
obsidian            # Note taking
brave-browser       # Privacy browser

# Group apps by category and add comments
```

#### VS Code Extensions (`vscode-extensions.txt`)

Customize `vscode-extensions.txt` for your preferred VS Code setup:

```txt
# Theme
github.github-vscode-theme    # Your preferred theme

# Language Support
dbaeumer.vscode-eslint       # JavaScript/TypeScript linting
rust-lang.rust-analyzer      # If you use Rust

# Add extensions that match your development needs
```

### 3. Customize Shell Configuration

Edit the shell configuration section in `setup.sh` to set your preferred:

- Shell theme
- Aliases
- Environment variables
- Shell plugins

```bash
# Example customization in setup.sh
cat << 'EOF' >> ~/.zshrc
# Your custom prompt theme
ZSH_THEME="your-theme"

# Your aliases
alias gc="git commit"
alias d="docker"

# Your environment variables
export PATH="$HOME/your-path:$PATH"
EOF
```

### 4. Customize Git Configuration

Modify the Git configuration section to match your details:

```bash
# In setup.sh
configure_git() {
    # Your details
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"

    # Your preferred editor
    git config --global core.editor "vim"

    # Your aliases
    git config --global alias.publish '!git push -u origin $(git branch --show-current)'
}
```

### 5. Customize macOS Preferences

Edit the macOS settings section to match your preferences:

```bash
# In setup.sh
configure_macos_settings() {
    # Your dock preferences
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 40

    # Your finder preferences
    defaults write com.apple.finder ShowPathbar -bool true

    # Add any other macOS settings you prefer
}
```

### 6. Add Custom Functions

Add your own functions for additional setup steps:

```bash
# In setup.sh
setup_development_folders() {
    # Create your project structure
    mkdir -p ~/Projects/{personal,work,opensource}

    # Clone your commonly used repositories
    git clone https://github.com/your/repo ~/Projects/personal/
}

configure_databases() {
    # Setup your database configurations
    brew install postgresql
    brew services start postgresql
}
```

### 7. Modify the Installation Flow

Customize the main installation flow in `setup.sh`:

```bash
main() {
    # Remove steps you don't need
    # Add your custom steps
    install_homebrew
    install_brew_packages
    setup_development_folders    # Your custom function
    configure_databases         # Your custom function

    # Conditional installations
    if $FULL_INSTALL; then
        # Your full installation steps
    fi
}
```

### 8. Add Your Own Features

Some ideas for additional customization:

- Add language-specific setup (Python virtualenvs, Node.js configurations)
- Include your dotfiles
- Add cloud provider CLI tools (AWS, GCP, Azure)
- Configure multiple Git accounts for work/personal
- Add backup/restore functionality
- Include your custom scripts and tools

### 9. Documentation

Remember to update this README with:

- Your name and contact information
- Any specific instructions for your setup
- Additional requirements or prerequisites
- Troubleshooting specific to your configuration

### 10. Testing

Before committing your changes:

1. Test on a fresh macOS installation if possible
2. Verify all installations work as expected
3. Check that backups are working
4. Ensure error handling works properly
5. Test both basic and full installation modes

## Features

### Automatic Backup

Before making any changes, the script automatically backs up your existing configurations to `~/.config_backup_[timestamp]`.

### Installation Verification

Every installation is verified to ensure it completed successfully. Failed installations are logged and reported.

### Detailed Logging

- All operations are logged to `~/setup_logs/setup_[timestamp].log`
- Color-coded output for better visibility
- Comprehensive error messages with line numbers

### Installation Summary

After completion, the script generates a detailed summary at `~/setup_summary_[timestamp].txt` containing:

- Installed packages and applications
- VS Code extensions
- Environment information
- System versions

## Troubleshooting

### Common Issues

1. Permission errors:

   ```bash
   sudo ./setup.sh
   ```

2. Homebrew installation fails:

   - Ensure you have internet connection
   - Check [Homebrew's requirements](https://docs.brew.sh/Installation)

3. VS Code extensions not installing:
   - Ensure VS Code is installed and the 'code' command is available
   - Run `code --version` to verify

### Logs and Diagnostics

- Check the log file in `~/setup_logs/` for detailed error information
- Review the installation summary in `~/setup_summary_[timestamp].txt`
- For VS Code issues, check `~/.vscode/extensions/`

## Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details

## Author

[brijr](https://brijr.dev) - Bridger Tower

---

**Note**: This script is regularly maintained and updated with the latest development tools and best practices. Check back for updates!
