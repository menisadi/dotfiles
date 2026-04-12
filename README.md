# Dotfiles Repository README

## Introduction
This repository contains my dotfiles, managed using GNU Stow and backed up with Git.

## Prerequisites
Before restoring the dotfiles on a new machine, make sure you have Git and GNU Stow installed.

### Installing Git
You can install Git using the following command:
```bash
# For macOS with Homebrew
brew install git
```
For other platforms, please refer to the official [Git documentation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

### Installing Stow
You can install Stow using the following command:
```bash
# For macOS with Homebrew
brew install stow
```
For other platforms, please refer to the official [GNU Stow documentation](https://www.gnu.org/software/stow/).


## Restoration Process
To restore the dotfiles on a new machine, follow these steps:
1. Make sure you are on the home directory:
```bash
cd ~
```
2. Clone this repository:
```bash
git clone git@github.com:menisadi/dotfiles.git 
```
3. Navigate to the cloned repository:
```bash
cd dotfiles
```
4. Use Stow to symlink the desired dotfiles to their respective locations: 
```bash
stow .
```

5. Install vim-plug (Vim plugin manager):
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
Then open Vim and run `:PlugInstall`.

6. Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then open Tmux and press `prefix + I` to install plugins.

## Dependencies

Most of these can be installed via Homebrew.

### Core (configs won't work well without these)
```bash
brew install antidote fzf eza bat ripgrep zoxide atuin
```
- **Antidote** — Zsh plugin manager (loads p10k, syntax highlighting, autosuggestions, vi-mode)
- **FZF** — Fuzzy finder, used in shell keybindings and aliases
- **Eza** — Modern `ls` replacement, used heavily in aliases
- **Bat** — `cat` replacement with syntax highlighting
- **Ripgrep** — Fast grep, used in aliases and FZF integration
- **Zoxide** — Smart `cd`, initialized in .zshrc
- **Atuin** — Shell history manager, initialized in .zshrc

### Editors
```bash
brew install neovim
```

### Terminal & Multiplexer
```bash
brew install kitty tmux
```
Alternatives configured: Alacritty, Ghostty

### Recommended CLI Tools
```bash
brew install lazygit lazydocker yazi gum glow neofetch jq gping
```
- **Lazygit / Lazydocker** — TUI for Git and Docker
- **Yazi** — Terminal file manager
- **Gum** — Terminal UI toolkit, used in custom functions
- **Glow** — Markdown renderer
- **Neofetch** — System info
- **JQ** — JSON processor
- **Gping** — Ping with a graph

### Optional
```bash
brew install newsboat w3m trafilatura timewarrior bottom csvlens spotify_player
```

### Fonts
Install a [Nerd Font](https://www.nerdfonts.com/) (the terminal configs use JetBrains Mono Nerd Font):
```bash
brew install --cask font-jetbrains-mono-nerd-font
```
