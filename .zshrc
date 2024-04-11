# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting vscode 
python aws)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias cls='colorls --sd'
alias cla='colorls -A --sd'
alias ee='eza --sort=created --icons=auto --group-directories-first'
alias el='eza -Xl --sort=created --icons=auto --group-directories-first --git --git-repos'
alias es='eza --sort=extension --icons=auto --group-directories-first'
alias esa='eza -Xa --sort=extension --icons=auto --group-directories-first'
alias eea='eza -Xa --sort=created --icons=auto --group-directories-first'
alias e5='eza --sort=modified -r --icons=always | head -5'
alias e10='eza --sort=modified -r --icons=always | head -10'

alias avim='NVIM_APPNAME=astronvim nvim'
alias kvim='NVIM_APPNAME=kickstart nvim'
alias nvide='neovide'
alias avide='NVIM_APPNAME=astronvim neovide'

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# list files containing a given expression
function fnep() {
  find . -type f -exec grep -l $1 {} + | xargs eza -l --sort=created --icons=auto
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

# alias to love
alias love="/Applications/love.app/Contents/MacOS/love"

# script to rename and move downloaed csv files
alias movecsv="~/bin/move_csv.sh"

# enable zoside
eval "$(zoxide init --cmd cd zsh)"

# echo "\e[92m"                    # Invoke a color
# figlet -f standard "Hello Meni"
# figlet -f standard "welcome back"  
# echo "\e[0m" # reset terminal color 
