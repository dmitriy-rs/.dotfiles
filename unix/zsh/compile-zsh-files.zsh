#!/usr/bin/env zsh
# Compile zsh configuration files for faster loading

# Function to compile a file if needed
compile_if_needed() {
  local file="$1"
  if [[ -f "$file" && ! -f "$file.zwc" ]] || [[ "$file" -nt "$file.zwc" ]]; then
    echo "Compiling $file..."
    zcompile "$file"
  fi
}

# Compile main configuration files
compile_if_needed "$HOME/.config/zsh/.zshrc"
compile_if_needed "$HOME/.config/zsh/.zshenv"
[[ -f "$HOME/.config/zsh/.aliases" ]] && compile_if_needed "$HOME/.config/zsh/.aliases"

# Compile oh-my-zsh files
compile_if_needed "$HOME/.oh-my-zsh/oh-my-zsh.sh"

# Compile plugin files
plugins=(
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
)

for plugin in $plugins; do
  [[ -f "$plugin" ]] && compile_if_needed "$plugin"
done

echo "Compilation complete!"