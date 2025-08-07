# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

plugins=(git zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting pyenv python fzf)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Skip OMZ's interactive compfix prompts and avoid extra overhead
ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit
for dump in "${ZSH_COMPDUMP:-$HOME/.zcompdump}"(N.mh+24); do compinit; done
compinit -C
zstyle ':omz:plugins' use-compinit false
source $ZSH/oh-my-zsh.sh

# source <(fzf --zsh)

# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='vim'

# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
command -v npm >/dev/null && PATH="$(npm config get prefix)/bin:$PATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Make Vim the default Man pager
export MANPAGER="vim +MANPAGER -"

# enable zoxide
eval "$(zoxide init --cmd cd zsh)"

eval "$(uv generate-shell-completion zsh)"

. "$HOME/.local/bin/env"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/meni/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/meni/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/meni/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/meni/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# yazi shell wrapper
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ---- WAV ➜ MP3 helper ----
wav2mp3 () {
  # convert one or many .wav files to VBR MP3 (≈ 192 kbps)
  for file in "$@"; do
    [ -f "$file" ] || { printf '✗ %s: not found\n' "$file"; continue; }
    ffmpeg -i "$file" \
           -codec:a libmp3lame \
           -q:a 2 \
           "${file%.*}.mp3"
  done
}

[ -f ~/.zsh_keys ] && source ~/.zsh_keys

# unset ZSH_AUTOSUGGEST_USE_ASYNC
