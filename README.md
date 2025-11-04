# dotfiles

Personal dotfiles with multi-platform support for Linux, macOS, FreeBSD, and Windows (WSL).

## Supported Platforms

- **Linux** (Debian/Ubuntu, RHEL/CentOS/Fedora, Arch Linux)
- **macOS** (with Homebrew)
- **FreeBSD**
- **Windows** (via WSL - Windows Subsystem for Linux)

## Quick Start

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/hydai/dotfiles/master/setup.sh | bash
```

Or manually:

```bash
git clone https://github.com/hydai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
./install
```

## Platform-Specific Features

### Linux
- Automatic package manager detection (apt, yum, dnf, pacman)
- NVM (Node Version Manager) integration
- Debian/Ubuntu-specific aliases and configurations

### macOS
- Homebrew integration with automatic installation
- NVM via Homebrew
- macOS-specific aliases (Mission Control reset, Time Machine optimization)
- Java home detection via `/usr/libexec/java_home`

### FreeBSD
- pkg package manager aliases
- Ports system support
- FreeBSD-specific paths and configurations

### Windows (WSL)
- WSL detection and compatibility
- Linux package manager support within WSL

## File Structure

```txt
├── dotbot/                    # Dotbot installer framework (submodule)
├── git/
│   └── gitconfig             # Git configuration with GPG signing
├── iterm2/
│   └── color-setting.itermcolors  # macOS iTerm2 color scheme
├── oh-my-zsh/
│   ├── custom/
│   │   ├── os/               # Platform-specific configurations
│   │   │   ├── freebsd.zsh   # FreeBSD-specific settings
│   │   │   └── debian.zsh    # Debian/Ubuntu-specific settings
│   │   └── themes/
│   │       └── hydai.zsh-theme
│   └── zshrc                 # Main zsh configuration
├── screen/
│   └── screenrc              # GNU Screen configuration
├── scripts/
│   └── modify_git_author_email.sh
├── tmux/                     # Tmux configuration (submodule)
│   ├── tmux.conf
│   └── tmux.conf.local
├── vim/
│   └── vimrc                 # Vim configuration with plugins
├── install                   # Main installation script
├── install.conf.yaml         # Dotbot configuration
└── setup.sh                  # Platform detection and dependency installation
```

## Configured Applications

- **Git**: GPG signing, delta pager, LFS support
- **Zsh**: Oh-My-Zsh with custom theme and plugins
- **Vim**: Full IDE setup with plugins (NerdTree, fzf, ALE, vim-go, GitHub Copilot)
- **Tmux**: Custom configuration via submodule
- **Screen**: GNU Screen with custom keybindings

## Zsh Plugins

- git, gitignore
- zsh-syntax-highlighting
- zsh-autosuggestions
- docker, docker-compose
- asdf (version manager)

## Requirements

### All Platforms
- Git
- Zsh
- Curl

### Platform-Specific
- **Linux**: build-essential (or equivalent), cmake
- **macOS**: Homebrew (auto-installed if missing)
- **FreeBSD**: pkg package manager

## Customization

### Adding Platform-Specific Configuration

Create a new file in `oh-my-zsh/custom/os/` for your platform:

```bash
# oh-my-zsh/custom/os/myplatform.zsh
export MY_PLATFORM_VAR="value"
alias my-alias="my-command"
```

Platform detection happens in `oh-my-zsh/zshrc` and will automatically load the appropriate configuration.

## Fonts

For the best terminal experience with the custom theme, install Powerline fonts:
- [Powerline Fonts Repository](https://github.com/powerline/fonts)
