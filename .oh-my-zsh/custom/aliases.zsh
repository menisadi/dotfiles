alias casprod='/Users/meni/code/work/datastax-studio-6.8.32/bin/server.sh &'

alias lzg='lazygit'
alias lzd='lazydocker'
alias dclean="docker stop \$(docker ps -aq) && docker rm \$(docker ps -aq) && docker rmi \$(docker images -q)"

# Run protobuf3 instead of the newset version
alias protoc3='/opt/homebrew/Cellar/protobuf@3/3.20.3/bin/protoc "$@"'

alias cls='colorls --sd'
alias cla='colorls -A --sd'
alias ee='eza --sort=created --icons=auto --group-directories-first'
alias el='eza -Xl --sort=created --icons=auto --group-directories-first --git --git-repos'
alias es='eza --sort=extension --icons=auto --group-directories-first'
alias esa='eza -Xa --sort=extension --icons=auto --group-directories-first'
alias eea='eza -Xa --sort=created --icons=auto --group-directories-first'
alias e5='eza --sort=modified -r --icons=always --color=always | head -5'
alias el5='eza -l --sort=modified -r --icons=always --color=always | head -5'
alias e10='eza --sort=modified -r --icons=always --color=always | head -10'
alias el10='eza -l --sort=modified -r --icons=always --color=always | head -10'

alias avim='NVIM_APPNAME=astronvim nvim'
alias kvim='NVIM_APPNAME=kickstart nvim'
alias lvim='NVIM_APPNAME=lazyvim nvim'
alias nvide='neovide'
alias avide='NVIM_APPNAME=astronvim neovide'

alias nvims='NVIM_APPNAME=$(find ~/.config -maxdepth 2 -type f -name "init.lua" -exec dirname {} \; | xargs -I {} basename {} | gum choose) nvim'

alias sysinfo='neofetch'
alias systeminfo='neofetch'

alias gpng='gping 1.1.1.1 8.8.8.8 -c red,green --clear'

alias pgc="ping -i 1 google.com | awk -F'time=' '{ if (\$2 ~ /ms/) { split(\$2, a, \" ms\"); time=a[1]; if (time < 50) printf \"\033[32mGood \033[0m\"; else if (time < 100) printf \"\033[33mFair \033[0m\"; else if (time < 200) printf \"\033[38;5;208mBad \033[0m\"; else printf \"\033[31mFail \033[0m\"; } else printf \"\033[31mFail \033[0m\"; fflush(); }'"
# alias pgcolor='ping 8.8.8.8 | awk -F"time=" '\''/time=/ {split($2,a," "); if (a[1] < 70) print "\033[34mGood\033[0m"; else if (a[1] < 400) print "\033[32mFair\033[0m"; else if (a[1] < 2000) print "\033[33mBad\033[0m"; else print "\033[31mFail\033[0m";} !/time=/ {print "\033[31mFail\033[0m";}'\'
# alias pgplot='ping 8.8.8.8 | sed -u '\''/^.*time=/!d; s/^.*time=//g; s/ ms//g; /^\s*$/d'\'' | ttyplot -t "ping 8.8.8.8" -u ms'

alias pgtime="ping --apple-time -i 2 8.8.8.8"

alias spp='spotify_player'

# alias to love
alias love="/Applications/love.app/Contents/MacOS/love"

# script to rename and move downloaed csv files
alias movecsv="~/bin/move_csv.sh"

# concise git branching graph
alias gitfold="~/bin/graphfold.py"

alias list_errors="~/bin/list_erros.py"
alias missdoc="~/bin/list_missing_docstrings.py"
alias list_missing_docstrings="~/bin/list_missing_docstrings.py"
alias logic_map="~/bin/logic_map.py"
alias unused="~/bin/search_unused_files.py"

alias please="gum input --password | sudo -nS"
alias du10="gum spin --spinner dot --title 'Scanning...' -- fd -t f . --exec du -h {} | sort -rh | head -n 10"

alias sso-prod='aws sso login --profile prod && export AWS_PROFILE='\''prod'\'''


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
