touch .hushlogin
echo -e " ╭╮╭╮\n ⎩⎭⎩⎭\n ('.')\n (()()\n *(_()() -- hello again"

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(git zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting pip pyenv python aws)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

# export MANPATH="/usr/local/man:$MANPATH"

export EDITOR='vim'

export PATH=$(npm config get prefix)/bin:$PATH

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# more versitle ls/eza version of the eza aliases
function e() {
  if [ -n "$1" ]; then
    eza --sort=modified -r --icons=always | head -"$1"
  else
    eza --sort=modified -r --icons=always
  fi
}

function ez() {
  if [ -n "$1" ]; then
    eza -l --sort=modified -r --icons=always | head -"$1"
  else
    eza -l --sort=modified -r --icons=always
  fi
}

# Simple mkdir-cd combo
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# create and open daily files
todaymd() {
  file="$(date +%Y-%m-%d).md"
  [ ! -f "$file" ] && touch "$file"
  ${EDITOR:-vim} "$file"
}

# My weather commands
function weather() {
  if [ "$1" = "-w" ]; then
    curl "wttr.in/Herzliya?format=3"
  elif [ "$1" = "-h" ]; then
    curl "wttr.in/Yeruham?format=3"
  elif [ -z "$1" ]; then
    curl "wttr.in/?format=3"
  else
    echo "Usage: weather [-w|-h]"
    echo "  -w: Get the weather for Herzliya"
    echo "  -h: Get the weather for Yeruham"
  fi
}

# Check for too large files 
code2heavy() {
  local path threshold exclude

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -path|--p)
        shift
        path="$1"
        ;;
      -threshold|--t)
        shift
        threshold="$1"
        ;;
      -exclude|--e)
        shift
        exclude="$1"
        ;;
      -help|--h)
        echo "Usage: code2heavy [-path|--p <path>] [-threshold|--t <threshold>] [-exclude|--e <exclude>]"
        return 0
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
    shift
  done

  if [[ -z "$path" ]]; then
    echo "Please provide a valid path using --path or -p option."
    return 1
  fi

  if [[ -z "$threshold" ]]; then
    echo "Please provide a valid threshold using --threshold or -t option."
    return 1
  fi


  if [[ -z "$exclude" ]]; then
    /usr/bin/find "$path" -type f -size +"$threshold"M
  else
    /usr/bin/find "$path" -type d -name "$exclude" -prune -o -type f -size +"$threshold"M
  fi
}


source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# For tkinter 
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# Make Vim the default Man pager
export MANPAGER="vim +MANPAGER -"

# enable zoxide
eval "$(zoxide init --cmd cd zsh)"

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


# echo "\e[92m"                    # Invoke a color
# figlet -f standard "Hello Meni"
# figlet -f standard "welcome back"  
# echo "\e[0m" # reset terminal color 

function record() {
    local default_file="record.log"
    
    # Check if a command is provided
    if [ -z "$1" ]; then
        echo "No command provided. Usage: run_and_log 'command' [filename]"
        return 1
    fi

    # Get the command to run
    local command="$1"
    
    # Get the file name if provided, otherwise use the default
    local filename="${2:-$default_file}"

    # Run the command and use tee to write to the file and output to terminal
    eval "$command" | tee "$filename"
}

# A function to use 'mods' to run shell commands
runmods() {
    generated_command=$(mods --role shell "$1")
    echo "Generated command: $generated_command"
    echo "Do you want to (r)un, (c)opy, or (q)uit?"
    read -r action
    
    case $action in
        r|R)
            # Run the command
            bash -c "$generated_command"
            ;;
        c|C)
            # Copy the command to the clipboard (using pbcopy for MacOS)
            echo "$generated_command" | pbcopy
            echo "Command copied to clipboard."
            ;;
        q|Q)
            echo "Canceled."
            ;;
        *)
            echo "Invalid option. Please enter r, c, or q."
            ;;
    esac
}

modshell() {
    command=$(mods --role shell "$@")
    echo "Generated Command:"
    echo "$command" | gum style --foreground 212 --padding "1 1" --italic

    choice=$(gum choose "Run" "Copy" "Cancel")

    case $choice in
        "Run")
            eval "$command"
            ;;
        "Copy")
            echo "$command" | pbcopy  # 'pbcopy' is for macOS
            echo "Command copied to clipboard."
            ;;
        "Cancel")
            echo "Operation canceled."
            ;;
    esac
}

[ -f ~/.zsh_keys ] && source ~/.zsh_keys

unset ZSH_AUTOSUGGEST_USE_ASYNC
eval "$(uv generate-shell-completion zsh)"

. "$HOME/.local/bin/env"
