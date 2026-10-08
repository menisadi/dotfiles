if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Preventing vi-mode from overriding fzf's keybindings
# (zvm runs these with a local `commands` shadowing zsh's $commands, so use whence)
zvm_after_init_commands+=('fzf_bin="$(whence -p fzf)" && _zsh_cache_eval "fzf-init" "fzf --zsh" "$fzf_bin" && bindkey -r "^r" && bindkey "^f" fzf-history-widget')
zvm_after_init_commands+=('[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/navi-widget.zsh" ] && source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/navi-widget.zsh"')

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load
autoload -Uz promptinit && promptinit && prompt powerlevel10k 

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='nvim'
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
export HISTORY_IGNORE="export *(*KEY*|*SECRET*|*TOKEN*|*PASSWORD*)=*"

export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.atuin/bin:$PATH"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

_zsh_cache_eval() {
  local key="$1"
  local generator="$2"
  local bin_path="$3"
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache_file="$cache_dir/${key}.zsh"

  mkdir -p "$cache_dir"
  if [[ ! -s "$cache_file" ]] || [[ -n "$bin_path" && -x "$bin_path" && "$bin_path" -nt "$cache_file" ]]; then
    eval "$generator" >| "$cache_file" 2>/dev/null
  fi

  [[ -s "$cache_file" ]] && source "$cache_file"
}

if npm_bin="${commands[npm]}"; [[ -n "$npm_bin" ]]; then
  npm_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  npm_prefix_cache="$npm_cache_dir/npm-prefix"
  mkdir -p "$npm_cache_dir"

  if [[ ! -s "$npm_prefix_cache" ]] || [[ "$npm_bin" -nt "$npm_prefix_cache" ]]; then
    npm config get prefix 2>/dev/null >| "$npm_prefix_cache"
  fi

  if [[ -s "$npm_prefix_cache" ]]; then
    npm_prefix="$(<"$npm_prefix_cache")"
    [[ -n "$npm_prefix" ]] && export PATH="$npm_prefix/bin:$PATH"
  fi
fi

if zoxide_bin="${commands[zoxide]}"; [[ -n "$zoxide_bin" ]]; then
  _zsh_cache_eval "zoxide-init" "zoxide init --cmd cd zsh" "$zoxide_bin"
fi
if uv_bin="${commands[uv]}"; [[ -n "$uv_bin" ]]; then
  _zsh_cache_eval "uv-completion" "uv generate-shell-completion zsh" "$uv_bin"
fi
if atuin_bin="${commands[atuin]}"; [[ -n "$atuin_bin" ]]; then
  _zsh_cache_eval "atuin-init" "atuin init zsh" "$atuin_bin"
fi
if rbenv_bin="${commands[rbenv]}"; [[ -n "$rbenv_bin" ]]; then
  _zsh_cache_eval "rbenv-init-norehash" "rbenv init - --no-rehash zsh" "$rbenv_bin"
fi
if navi_bin="${commands[navi]}"; [[ -n "$navi_bin" ]]; then
  _zsh_cache_eval "navi-widget" "navi widget zsh" "$navi_bin"
fi

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"

export PAGER='less'
export LESS='-R -i'

if command -v bat >/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p --paging=always'"
else
  export MANPAGER="$PAGER"
fi

# export BAT_THEME="Catppuccin Mocha"

[ -f ~/.zsh_keys ] && source ~/.zsh_keys
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
