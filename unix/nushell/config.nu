use std/util "path add"

$env.XDG_CONFIG_HOME = $env.HOME | path join ".config"
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.VIMCONFIG = $env.XDG_CONFIG_HOME | path join "nvim"
$env.VIMDATA = $env.HOME | path join ".local/share/nvim"

path add "~/.local/scripts"
path add ($env.XDG_CONFIG_HOME | path join "bin")
path add "/opt/homebrew/bin"
path add ($env.HOME | path join ".cargo/bin")

# bun
$env.BUN_INSTALL = $env.HOME | path join ".bun"
path add ($env.BUN_INSTALL | path join "bin")

source aliases.nu

let posh_dir = (brew --prefix oh-my-posh | str trim)
let posh_theme = $'($posh_dir)/themes/'
# For more [Themes demo](https://ohmyposh.dev/docs/themes)
$env.PROMPT_COMMAND = { || oh-my-posh prompt print primary --config $'($posh_theme)/robbyrussell.omp.json' }

# Zoxide
zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

# Direnv
$env.config.hooks.env_change.PWD = (
     $env.config.hooks.env_change.PWD | append (source nu-hooks/direnv/config.nu)
)

# Fnm
if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  let node_path = match $nu.os-info.name {
    "windows" => $"($env.FNM_MULTISHELL_PATH)",
    _ => $"($env.FNM_MULTISHELL_PATH)/bin",
  }
  path add $node_path
}


# Zellij
# if 'ZELLIJ' not-in ($env | columns) and 'SSH_CONNECTION' not-in ($env | columns)  {
#     zs
# }
