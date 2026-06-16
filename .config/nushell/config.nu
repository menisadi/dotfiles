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

# ── prompt ───────────────────────────────────────────────────────────────────

$env.PROMPT_COMMAND = {|| $"(ansi green_bold)($env.PWD | str replace $env.HOME '~')(ansi reset) " }
$env.PROMPT_INDICATOR = {|| $"(ansi green)❯(ansi reset) " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| $"(ansi green)❯(ansi reset) " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi yellow)❯(ansi reset) " }
$env.PROMPT_COMMAND_RIGHT = {|| "" }
