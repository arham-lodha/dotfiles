# dotfiles

Managed with a bare git repo. The `dot` alias is your `git` command for this repo.

## Setup on a new machine

```zsh
git clone --bare git@github.com:arham-lodha/dotfiles.git $HOME/dotfiles
alias dot='git --git-dir=$HOME/dotfiles --work-tree=$HOME'
dot config status.showUntrackedFiles no
dot checkout
dot submodule update --init --recursive  # pulls nvim config
```

> If checkout fails due to conflicts, back up and remove the conflicting files, then re-run.

## Daily usage

```zsh
# See what's changed
dot status
dot diff

# Stage and commit a change
dot add ~/.config/zsh/.zshrc
dot commit -m "update zshrc"

# Push / pull
dot push
dot pull

# Track a new dotfile
dot add ~/.config/some/new/config
dot commit -m "track new config"

# Stop tracking a file (keeps the file locally)
dot rm --cached ~/.config/some/config
```

## What's tracked

| File | Purpose |
|------|---------|
| `~/.zshenv` | XDG vars, sets `ZDOTDIR` |
| `~/.config/zsh/.zshrc` | Main shell config |
| `~/.config/zsh/.zprofile` | Login shell config |
| `~/.config/zsh/p10k.zsh` | Powerlevel10k prompt |
| `~/.config/nvim` | Neovim config (submodule → arham-lodha/kickstart.nvim) |
| `~/.config/git/config` | Global git config |
| `~/.config/mise/config.toml` | mise version manager |
| `~/.config/zed/settings.json` | Zed editor |
| `~/.config/karabiner/karabiner.json` | Keyboard remapping |
| `~/.yarnrc` | Yarn config |
