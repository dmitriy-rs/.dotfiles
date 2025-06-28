. "$HOME/.cargo/env"

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export EDITOR=nvim
export VISUAL=nvim
export VIMCONFIG="$XDG_CONFIG_HOME/nvim"
export VIMDATA="$HOME/.local/share/nvim"

# Consolidate all PATH modifications here
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="/Users/dmitriy/Library/pnpm"

# Build PATH efficiently in one go
path=(
    "$HOME/.local/scripts"
    "$XDG_CONFIG_HOME/bin"
    "/opt/homebrew/bin"
    "$HOME/go/bin"
    "$BUN_INSTALL/bin"
    "$PNPM_HOME"
    $path
)
# Remove duplicates while preserving order
typeset -U path
export PATH
