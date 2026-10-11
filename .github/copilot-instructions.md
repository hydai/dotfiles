# Copilot Instructions
- This repo provisions hydai's development environment by symlinking curated dotfiles via Dotbot; most edits adjust config in `install.conf.yaml` or the files it links.
- Top-level scripts: `install` ensures the `dotbot/` submodule is pulled before running Dotbot, while `setup.sh` is a one-step bootstrap that clones the repo, updates submodules, and runs `./install`.
- Dotfiles live in tool-specific folders (`oh-my-zsh/`, `tmux/`, `vim/`, `git/`, etc.); `tmux/` and `dotbot/` are submodules, so prefer changes in their source repos or commit the submodule update explicitly.

## Dotbot Configuration Patterns
- `install.conf.yaml` drives provisioning; link defaults enable `create` and `relink`, `clean` prunes stray links under `$HOME`, `link` maps homedir targets to repo files, and `shell` runs provisioning commands. Keep the Oh My Zsh installation step before links under `~/.oh-my-zsh`.
- When adding new links, prefer relative paths under the repo and set `force/relink` explicitly if idempotence requires it; keep `shell` commands safe to run multiple times because Dotbot invokes them each install.
- Shell steps already cover oh-my-zsh install, `vim +PlugInstall +qall`, and cloning `zsh-syntax-highlighting` / `zsh-autosuggestions`; match that style if you add more tooling installers.
- Update `install.conf.yaml` after adding new dotfiles so they are actually linked; forgetting this is the most common drift.

## Shell & Zsh Conventions
- `oh-my-zsh/zshrc` loads the custom `hydai` theme, sets cross-platform aliases, and sources OS-specific helpers via `uname`; mirror the Darwin/Linux case structure when adding platform toggles.
- Plugins listed in `plugins=(...)` must be available locally; cloning new ones usually belongs in the Dotbot `shell` section.
- The custom prompt lives in `oh-my-zsh/custom/themes/hydai.zsh-theme`; it depends on Powerline glyphs and extensive `vcs_info` hooks, so keep added segments lean and stick to existing helper patterns like `left_prompt_segment`.

## Vim Layout
- `vim/vimrc` uses `vim-plug`; declare plugins inside the existing `call plug#begin()/plug#end()` block and note commands like `:PlugInstall` or `:PlugUpdate` run via the install script.
- Formatting conventions rely on per-filetype autocmds (e.g., `Filetype yaml setlocal sw=2`); extend those blocks rather than adding new scattered autocmds.
- Helper functions such as `StripTrailingWhitespace()` and `InitializeDirectories()` are already consumed by autocmds—modify them in place if behavior needs changing instead of duplicating logic.

## Supporting Scripts & Submodules
- `scripts/modify_git_author_email.sh` is a template for history rewrites; adjust the constants before running and avoid checking in personal data.
- Submodule pointers live in `.gitmodules`; after updating `dotbot/` or `tmux/`, commit both the submodule SHA change and any generated lockfiles/config.
- The bundled `dotbot/` directory contains upstream Dotbot; if you modify its Python, follow `dotbot/DEVELOPMENT.md` and run `hatch test` from the submodule.

## Common Workflows
- Fresh setup: `./setup.sh` on a new machine (macOS/Linux) handles cloning and install; re-provisioning later only needs `./install`.
- After editing dotfiles, run `./install` to re-link and trigger post-install steps. For an isolated link-only check, set `HOME` to a temporary directory and invoke Dotbot directly with `--only link`; `-d` selects Dotbot's source directory, not the target home.
- For macOS-specific changes touching Homebrew paths, ensure the command works under the `case Darwin)` branch in `oh-my-zsh/zshrc`.

## Collaboration Notes
- Default to ASCII when editing configs unless a file already relies on Powerline symbols (e.g., the theme file) where glyphs are necessary.
- Document any new provisioning steps inline using brief comments so future contributors understand why a command is in the automation.
- If anything here is unclear or missing, let me know which section needs refinement so we can tighten the guidance.
