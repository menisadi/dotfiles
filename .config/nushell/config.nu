# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.history.max_size = 100000
$env.config.history.file_format = "sqlite"

$env.EDITOR = 'nvim'
$env.PAGER = 'less'
$env.LESS = '-R -i'
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p --paging=always'"

# zoxide — regenerate with: zoxide init nushell | save -f ($nu.default-config-dir | path join "zoxide.nu")
const __zoxide = ($nu.default-config-dir | path join "zoxide.nu")
source $__zoxide

# ── aliases ───────────────────────────────────────────────────────────────────

alias lzg   = lazygit
alias lzd   = lazydocker
alias spp   = spotify_player
alias nwb   = newsboat
alias cless = csvlens --color-columns
alias vm    = vibemark
alias tw    = timew
alias twt   = timew start
alias twc   = timew continue
alias twp   = timew stop

alias ee  = eza --sort=created --icons=auto --group-directories-first
alias ell = eza -l --sort=created --icons=auto --group-directories-first --git --git-repos
alias es  = eza --sort=extension --icons=auto --group-directories-first
alias esa = eza -a --sort=extension --icons=auto --group-directories-first
alias eea = eza -a --sort=created --icons=auto --group-directories-first

# ── commands ──────────────────────────────────────────────────────────────────

def e [...args: string] {
    ^eza --sort=modified -r --icons=always --color=always ...$args
}

def el [...args: string] {
    ^eza -l --sort=modified -r --icons=always --color=always ...$args
}

def graph [] {
    ^git-graph --no-pager --color=always | less -RS
}

def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

def todaymd [] {
    let file = $"(date now | format date '%Y-%m-%d').md"
    if not ($file | path exists) { touch $file }
    ^$env.EDITOR $file
}

def cheat [topic: string] {
    http get $"https://cheat.sh/($topic)"
}

def --env yy [...args: string] {
    let tmp = (^mktemp -t "yazi-cwd.XXXXXX" | str trim)
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp | str trim)
    if ($cwd | is-not-empty) and $cwd != $env.PWD {
        cd $cwd
    }
    rm -f $tmp
}

def weather [flag?: string] {
    match $flag {
        "-w" => { http get "https://wttr.in/Herzliya?format=3" }
        "-h" => { http get "https://wttr.in/Yeruham?format=3" }
        null => { http get "https://wttr.in/?format=3" }
        _    => { print "Usage: weather [-w|-h]" }
    }
}
