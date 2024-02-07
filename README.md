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
And we are done :)
