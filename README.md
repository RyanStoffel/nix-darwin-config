# Nix Darwin Configuration

My personal macOS system configuration using Nix Darwin and Home Manager.

## What This Manages

### System Level
- **Homebrew**: Casks and formulae
- **System Preferences**: Dock, Finder, and macOS settings
- **Fonts**: Development and system fonts
- **Services**: Background services and daemons

### User Environment
- **Shell**: Zsh configuration and aliases
- **Development Tools**: Git, editors, CLI tools
- **Applications**: GUI applications via Homebrew casks
- **Dotfiles**: Home directory configuration files

## Installation

This configuration is managed as part of my [dotfiles](https://github.com/RyanStoffel/dotfiles):

```bash
# Clone dotfiles
git clone git@github.com:RyanStoffel/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install GNU Stow
brew install stow

# Stow nix-darwin config
stow nix-darwin-config

# Apply configuration
darwin-rebuild switch --flake ~/nix-darwin-config
```

## Structure
```bash
~/nix-darwin-config/
├── flake.nix          # Flake configuration and inputs
├── flake.lock         # Locked dependency versions
└── home.nix           # Home Manager configuration
```

## Key Features

### Development Environment
- **Languages**: Node.js, Python, Java
- **Editors**: Vim, Neovim, Cursor, Zed, Vscode
- **Version Control**: Git
- **Terminal**: Modern shell setup with useful aliases

### Package Management
- **Nix Packages**: System packages and development tools
- **Homebrew Integration**: GUI applications and system utilities
- **Automatic Updates**: Managed dependency versions

## Included Packages

### Development Tools
- vim
- neovim
- git
- gh
- zed-editor
- jdk21
- python313
- python313Packages.pip
- nodejs_22
- wget
- curl
- htop
- code-cursor
- eslint
- zsh-powerlevel10k
- kitty
- vscode

### Applications (via Homebrew)
- sf
- microsoft-office
- raycast

## Customization

### Adding Packages
Edit `flake.nix` to add new packages:

```nix
environment.systemPackages = with pkgs; [
  # Add new packages here
  your-package-name
];
```

## System Settings
Modify system preferences in the darwin configuration section of **flake.nix**.

## Shell Configuration
Zsh settings are managed through Home Manager in **home.nix**:
```nix
programs.zsh = {
  enable = true;
  shellAliases = {
    # Your aliases here
  };
};
```

## Usage

### Applying Changes
```bash
# After editing configuration files
sudo darwin-rebuild switch --flake ~/nix-darwin-config
```

## Updating Dependencies
```bash
# Update flake inputs
nix flake update ~/nix-darwin-config

# Apply updates
sudo darwin-rebuild switch --flake ~/nix-darwin-config
```

## Rollback
```bash
# List generations
sudo darwin-rebuild --list-generations

# Rollback to previous generation
sudo darwin-rebuild rollback
```

## Security Notes
- This configuration is kept in a private repository
- Sensitive information should use **sops-nix** or similar
- SSH keys and personal tokens are not managed by Nix

## Requirements
- macOS (tested on recent versions)
- Nix package manager
- Xcode Command Line Tools

Declarative macOS configuration with Nix Darwin
