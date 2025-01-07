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
