# dotfiles

## First-Time Installation Workflow

- Run `./setup.sh` from a temporary checkout to bootstrap a new machine.
- The bootstrap checks for Python 3.7 or newer before running Dotbot.
- On Debian-based Linux hosts the script installs the shell, Git, editor, and build dependencies with `apt-get`.
- On macOS, install Homebrew first; the bootstrap installs tmux and the Git helpers, while the installer adds Universal Ctags, clang-format, and uv when they are missing.
- The script clones the repository into `~/.dotfiles`, updates submodules, configures the push remote, and then executes `./install` from the new clone.
- `install` makes sure the Dotbot submodule is present, installs Oh My Zsh and the Vim command-line dependencies (Universal Ctags, clang-format, and Zuban), and applies the symlink/configuration rules defined in `install.conf.yaml`.
- Git commit signing uses the key configured in `git/gitconfig`; import its private key and install a `gpg` command before committing on a new machine.

Example invocation on a fresh machine:

```bash
git clone https://github.com/hydai/dotfiles.git
cd dotfiles
./setup.sh
```

Once the bootstrap completes, future re-provisioning only needs:

```bash
cd ~/.dotfiles
./install
```

## File Structure

```txt
├── git
│   └── gitconfig
├── iterm2
│   └── color-setting.itermcolors
├── oh-my-zsh
│   ├── custom
│   │   └── themes
│   │       └── hydai.zsh-theme
│   └── zshrc
├── screen
│   └── screenrc
├── scripts
│   └── install-vim-tools.sh
├── svn
│   └── svn_log_short
├── tmux
│   ├── tmux.conf
│   └── tmux.conf.local
└── vim
    ├── spell
    │   └── en.utf-8.add
    └── vimrc
```

## Powerline Fonts

- Please refer to this repo: [powerline fonts](https://github.com/powerline/fonts)
