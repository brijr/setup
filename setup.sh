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

# Colors for better logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function for better debugging and progress tracking
# Format: [YYYY-MM-DD HH:MM:SS] Message
log() {
    local level=$1
    local message=$2
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    case $level in
        "INFO")
            echo -e "${BLUE}[${timestamp}] INFO: ${message}${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[${timestamp}] SUCCESS: ${message}${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[${timestamp}] WARNING: ${message}${NC}"
            ;;
        "ERROR")
            echo -e "${RED}[${timestamp}] ERROR: ${message}${NC}"
            ;;
        *)
            echo -e "[${timestamp}] ${message}"
            ;;
    esac
}

# Error handling function that shows the line number
# where the error occurred
handle_error() {
    log "ERROR" "An error occurred in script at line: ${1}"
    exit 1
}

# Trap any errors and handle them with our error function
trap 'handle_error ${LINENO}' ERR

# Function to check if required files exist
check_required_files() {
    local script_dir=$(dirname "$0")
    local required_files=("packages.txt" "apps.txt" "vscode-extensions.txt")
    local missing_files=()

    for file in "${required_files[@]}"; do
        if [[ ! -f "${script_dir}/${file}" ]]; then
            missing_files+=("${file}")
        fi
    done

    if [[ ${#missing_files[@]} -gt 0 ]]; then
        log "ERROR" "Missing required files: ${missing_files[*]}"
        exit 1
    fi
}

# Function to verify command exists
verify_command() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        log "ERROR" "Required command not found: $cmd"
        return 1
    fi
    return 0
}

# Function to verify installation
verify_installation() {
    local name=$1
    local type=$2
    local identifier=$3

    case $type in
        "brew")
            if brew list | grep -q "^${identifier}$"; then
                log "SUCCESS" "$name installed successfully"
                return 0
            fi
            ;;
        "cask")
            if brew list --cask | grep -q "^${identifier}$"; then
                log "SUCCESS" "$name installed successfully"
                return 0
            fi
            ;;
        "vscode")
            if code --list-extensions | grep -q "^${identifier}$"; then
                log "SUCCESS" "$name installed successfully"
                return 0
            fi
            ;;
    esac

    log "ERROR" "Failed to verify installation of $name"
    return 1
}

# Function to create installation summary
create_summary() {
    local summary_file="${HOME}/setup_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Installation Summary ($(date))"
        echo "=============================="
        echo
        echo "Brew Packages:"
        brew list
        echo
        echo "Cask Applications:"
        brew list --cask
        echo
        echo "VS Code Extensions:"
        code --list-extensions
        echo
        echo "Environment Information:"
        echo "- macOS Version: $(sw_vers -productVersion)"
        echo "- Shell: $SHELL"
        echo "- Node Version: $(node -v 2>/dev/null || echo 'Not installed')"
        echo "- Python Version: $(python3 -V 2>/dev/null || echo 'Not installed')"
        echo "- Git Version: $(git --version 2>/dev/null || echo 'Not installed')"
    } > "$summary_file"

    log "INFO" "Installation summary saved to: $summary_file"
}

# Function to backup existing configurations
backup_configs() {
    local backup_dir="${HOME}/.config_backup_$(date +%Y%m%d_%H%M%S)"
    log "INFO" "Creating backup of existing configurations in $backup_dir"
    
    mkdir -p "$backup_dir"
    
    # Backup existing config files
    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_dir/"
    [[ -f "$HOME/.gitconfig" ]] && cp "$HOME/.gitconfig" "$backup_dir/"
    [[ -f "$HOME/.vimrc" ]] && cp "$HOME/.vimrc" "$backup_dir/"
    
    # Backup VS Code settings
    local vscode_settings="$HOME/Library/Application Support/Code/User/settings.json"
    [[ -f "$vscode_settings" ]] && cp "$vscode_settings" "$backup_dir/"
    
    log "SUCCESS" "Configurations backed up to: $backup_dir"
}

# Start setup
log "INFO" "Starting setup script..."

# Check for required files
check_required_files

# Verify essential commands
verify_command "curl" || exit 1
verify_command "git" || exit 1

# Backup existing configurations
backup_configs

###########################################
# Interactive Flags
###########################################
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

###########################################
# Architecture Check (Apple Silicon vs. Intel)
###########################################
IS_APPLE_SILICON=false
if [[ "$(uname -m)" == "arm64" ]]; then
    IS_APPLE_SILICON=true
    # Prepend Homebrew's Apple Silicon location to PATH
    export PATH="/opt/homebrew/bin:$PATH"
else
    # Prepend Homebrew's Intel location to PATH
    export PATH="/usr/local/bin:$PATH"
fi

###########################################
# Homebrew Installation & Update
###########################################
install_homebrew() {
    log "INFO" "Checking for Homebrew..."
    if ! command -v brew &>/dev/null; then
        log "INFO" "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log "INFO" "Updating Homebrew..."
        brew update
    fi
}

###########################################
# Core Development Tools Installation
###########################################
# Install essential development packages
# Each tool is carefully chosen for modern web development
install_brew_packages() {
    log "INFO" "Installing brew packages..."
    local failed_packages=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ $line =~ ^#.*$ ]] || [[ -z "$line" ]] && continue
        
        # Extract package name (everything before the first #)
        package=$(echo "$line" | sed 's/[[:space:]]*#.*$//' | xargs)
        
        if [[ -n "$package" ]]; then
            log "INFO" "Installing $package..."
            if brew install "$package" 2>/dev/null; then
                verify_installation "$package" "brew" "$package" || failed_packages+=("$package")
            else
                log "ERROR" "Failed to install $package"
                failed_packages+=("$package")
            fi
        fi
    done < "$(dirname "$0")/packages.txt"

    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log "WARNING" "Failed to install the following packages: ${failed_packages[*]}"
        return 1
    fi

    log "SUCCESS" "All brew packages installed successfully"
}

install_brew_cask_apps() {
    log "INFO" "Installing applications..."
    local failed_apps=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ $line =~ ^#.*$ ]] || [[ -z "$line" ]] && continue
        
        # Extract app name (everything before the first #)
        app=$(echo "$line" | sed 's/[[:space:]]*#.*$//' | xargs)
        
        if [[ -n "$app" ]]; then
            log "INFO" "Installing $app..."
            if brew install --cask "$app" 2>/dev/null; then
                verify_installation "$app" "cask" "$app" || failed_apps+=("$app")
            else
                log "ERROR" "Failed to install $app"
                failed_apps+=("$app")
            fi
        fi
    done < "$(dirname "$0")/apps.txt"

    if [[ ${#failed_apps[@]} -gt 0 ]]; then
        log "WARNING" "Failed to install the following apps: ${failed_apps[*]}"
        return 1
    }

    log "SUCCESS" "All applications installed successfully"
}

install_vscode_extensions() {
    log "INFO" "Installing VS Code extensions..."
    local failed_extensions=()

    # Verify VS Code CLI is available
    if ! verify_command "code"; then
        log "ERROR" "'code' command not found. Please install VS Code and enable the CLI."
        return 1
    }

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ $line =~ ^#.*$ ]] || [[ -z "$line" ]] && continue
        
        # Extract extension ID (everything before the first #)
        extension=$(echo "$line" | sed 's/[[:space:]]*#.*$//' | xargs)
        
        if [[ -n "$extension" ]]; then
            log "INFO" "Installing VS Code extension: $extension..."
            if code --install-extension "$extension" 2>/dev/null; then
                verify_installation "$extension" "vscode" "$extension" || failed_extensions+=("$extension")
            else
                log "ERROR" "Failed to install extension: $extension"
                failed_extensions+=("$extension")
            fi
        fi
    done < "$(dirname "$0")/vscode-extensions.txt"

    if [[ ${#failed_extensions[@]} -gt 0 ]]; then
        log "WARNING" "Failed to install the following extensions: ${failed_extensions[*]}"
        return 1
    }

    log "SUCCESS" "All VS Code extensions installed successfully"
}

# Function to create installation summary
create_summary() {
    local summary_file="${HOME}/setup_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Installation Summary ($(date))"
        echo "=============================="
        echo
        echo "Brew Packages:"
        brew list
        echo
        echo "Cask Applications:"
        brew list --cask
        echo
        echo "VS Code Extensions:"
        code --list-extensions
        echo
        echo "Environment Information:"
        echo "- macOS Version: $(sw_vers -productVersion)"
        echo "- Shell: $SHELL"
        echo "- Node Version: $(node -v 2>/dev/null || echo 'Not installed')"
        echo "- Python Version: $(python3 -V 2>/dev/null || echo 'Not installed')"
        echo "- Git Version: $(git --version 2>/dev/null || echo 'Not installed')"
    } > "$summary_file"

    log "INFO" "Installation summary saved to: $summary_file"
}

# Main execution
main() {
    local start_time=$(date +%s)
    local script_dir=$(dirname "$0")
    
    # Create log directory
    mkdir -p "${HOME}/setup_logs"
    local log_file="${HOME}/setup_logs/setup_$(date +%Y%m%d_%H%M%S).log"
    
    # Redirect all output to log file while maintaining console output
    exec 1> >(tee -a "$log_file")
    exec 2> >(tee -a "$log_file" >&2)
    
    log "INFO" "Setup started. Log file: $log_file"
    
    # Run installations
    install_brew_packages || log "WARNING" "Some brew packages failed to install"
    install_brew_cask_apps || log "WARNING" "Some applications failed to install"
    install_vscode_extensions || log "WARNING" "Some VS Code extensions failed to install"
    
    # Create installation summary
    create_summary
    
    # Calculate execution time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log "SUCCESS" "Setup completed in ${duration} seconds"
    
    # Final instructions
    log "INFO" "Please check the installation summary and log file for any issues"
    log "INFO" "You may need to restart your computer for all changes to take effect"
}

# Run main function
main
