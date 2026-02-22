if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load
autoload -Uz promptinit && promptinit && prompt powerlevel10k 

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='vim'

export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.atuin/bin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

command -v npm >/dev/null && PATH="$(npm config get prefix 2>/dev/null)/bin:$PATH"

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh)"
command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"

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
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
