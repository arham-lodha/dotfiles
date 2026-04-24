export ZDOTDIR="$HOME/.config/zsh"

. "$HOME/.local/share/cargo/env"

# XDG runtime env vars — added by xdg_migrate.sh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Zsh history
export HISTFILE="$XDG_DATA_HOME/zsh/history"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# Node
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_prefix="$XDG_DATA_HOME/npm"

# Julia
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia"

# Dart / Flutter / Pub
export PUB_CACHE="$XDG_DATA_HOME/pub-cache"
export DART_CONFIG_DIR="$XDG_CONFIG_HOME/dart"

# Lean / Elan
export ELAN_HOME="$XDG_DATA_HOME/elan"

# Python tools
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export MPLCONFIGDIR="$XDG_CONFIG_HOME/matplotlib"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
