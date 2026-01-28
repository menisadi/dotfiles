# Greeting (dim + minimal)
[[ -o interactive ]] && {
  local sym=">"
  local msg="May your labels be clean and your merges painless."
  print -P "%F{240}${sym} ${msg}%f"
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

ZVM_INIT_MODE=sourcing

plugins=(git python zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting)
ZSH_AUTOSUGGEST_USE_ASYNC=1

source "$ZSH/oh-my-zsh.sh"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='vim'

export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.atuin/bin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

command -v npm >/dev/null && PATH="$(npm config get prefix 2>/dev/null)/bin:$PATH"

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh)"

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"

if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
else
  export MANPAGER='less -R'
fi

export BAT_THEME="Catppuccin Mocha"

# source <(fzf --zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh_keys ] && source ~/.zsh_keys

# unset ZSH_AUTOSUGGEST_USE_ASYNC
