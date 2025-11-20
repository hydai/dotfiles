# dotfiles

## First-Time Installation Workflow

- Run `./setup.sh` from a temporary checkout to bootstrap a new machine.
- On Linux hosts the script installs required packages with `apt`; other platforms skip this step.
- The script clones the repository into `~/.dotfiles`, updates submodules, configures the push remote, and then executes `./install` from the new clone.
- `install` makes sure the Dotbot submodule is present and applies the symlink/configuration rules defined in `install.conf.yaml`.

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
├── iterm2
│   └── color-setting.itermcolors
├── oh-my-zsh
│   ├── custom
│   │   └── themes
│   │       └── hydai.zsh-theme
│   └── zshrc
├── screen
│   └── screenrc
└── vim
    └── vimrc
```

## Powerline Fonts

- Please refer to this repo: [powerline fonts](https://github.com/powerline/fonts)
