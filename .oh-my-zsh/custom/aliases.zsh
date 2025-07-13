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

alias please="gum input --password | sudo -nS"
alias du10="gum spin --spinner dot --title 'Scanning...' -- fd -t f . --exec du -h {} | sort -rh | head -n 10"

alias sso-prod='aws sso login --profile prod && export AWS_PROFILE='\''prod'\'''
