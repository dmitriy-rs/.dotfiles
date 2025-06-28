# Optimized .zshrc with Zinit for maximum performance

# Early settings for better performance
setopt auto_cd
unsetopt beep

# Environment variables
export VISUAL=nvim
export EDITOR='nvim'
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# History configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Load aliases
[[ -f $ZDOTDIR/.aliases ]] && source $ZDOTDIR/.aliases

# Zinit installation
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load completions and colors
autoload -Uz compinit
autoload -U colors && colors
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ $zcompdump -nt /usr/share/zsh ]] && [[ ! $zcompdump.zwc -ot $zcompdump ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
  { [[ -f "$zcompdump" && ! -f "$zcompdump.zwc" ]] && zcompile "$zcompdump" } &!
fi

# Oh-My-Zsh compatibility - load required libs immediately for prompt
zinit snippet OMZ::lib/spectrum.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::lib/prompt_info_functions.zsh
zinit snippet OMZ::lib/async_prompt.zsh

# Load af-magic theme immediately for prompt
zinit snippet OMZ::themes/af-magic.zsh-theme

# Load OMZ git plugin for git aliases
zinit snippet OMZ::plugins/git/git.plugin.zsh

# Essential plugins with turbo mode
zinit ice wait"0c" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0c" lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait"0c" lucid
zinit light zsh-users/zsh-history-substring-search

# Completions
zinit ice wait"0c" lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# FZF - lazy load configuration
_fzf_init() {
  export FZF_BASE=/user/bin/fzf
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  
  # Load FZF if available
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# direnv - must be loaded immediately for directory env switching
eval "$(direnv hook zsh)"

# Lazy load functions
fzf() {
  unfunction fzf
  _fzf_init
  fzf "$@"
}

cargo() {
  unfunction cargo
  [[ -f ~/.cargo/env ]] && source $HOME/.cargo/env
  cargo "$@"
}

fnm() {
  unfunction fnm
  eval "$(command fnm env --use-on-cd)"
  fnm "$@"
}

z() {
  unfunction z
  eval "$(zoxide init zsh)"
  z "$@"
}

# Lazy load bun completions
if [[ -s "/Users/dmitriy/.bun/_bun" ]]; then
  bun() {
    unfunction bun
    source "/Users/dmitriy/.bun/_bun"
    bun "$@"
  }
fi

# Compile this file if needed
() {
  local zshrc="$ZDOTDIR/.zshrc"
  [[ -f "$zshrc" && ! -f "$zshrc.zwc" ]] && zcompile "$zshrc"
  [[ -f "$zshrc.zwc" && "$zshrc" -nt "$zshrc.zwc" ]] && zcompile "$zshrc"
}