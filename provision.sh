#!/bin/bash

function commandExists() {
  which "$1" > /dev/null
}

function directoryExists() {
  if [[ -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function fileExists() {
  if [[ -f "$1" ]]; then
    return 0
  else
    return 1
  fi
}

function xcode() {
  if ! commandExists xcode-select; then
    xcode-select --install
  fi
}

function installHomebrew() {
  if ! commandExists brew; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask
    brew tap caskroom/versions
    brew tap caskroom/fonts
  fi
}

function brewInstall() {
  brewAppsToInstall=(
  'coreutils'
  'gnu-sed'
  'wget --with-iri'
  'youtube-dl'
  'zsh'
  'trash'
  'fasd'
  'tmux'
  # used by tmux
  'reattach-to-user-namespace'
  'tree'
  'the_silver_searcher'
  'findutils'
  'imagemagick'
  'git'
  'hub'
  'go --cross-compile-common'
  'cmake'
  'ctags-exuberant'
  'node'
  'yarn'
  'ruby'
  'luajit'
  'vim --override-system-vi --with-luajit'
  'fzf'
  'curl --with-openssl'
  'python'
  'python3'
  )

  sudo chown -R $(whoami):admin /usr/local
  brew update
  brew upgrade --all

  for i in "${brewAppsToInstall[@]}"; do
    if brew list $i > /dev/null; then
      echo "$i already installed"
    else
      brew install $i
      if [[ "$i" = "fzf" ]]; then
        /usr/local/opt/fzf/install
      fi
    fi
  done

  brew cleanup
}

function brewCaskInstall() {
  caskAppsToInstall=(
  'google-chrome'
  'alfred2'
  'iterm2-beta'
  'nvalt'
  'the-unarchiver'
  )

  brew update

  for i in "${caskAppsToInstall[@]}"; do
    if brew cask list $i > /dev/null; then
      echo $i already installed
    else
      brew cask install $i
    fi
  done

  brew cleanup
  echo done installing homebrew cask apps...
}

function dotfiles() {
  if ! directoryExists ~/.dotfiles; then
    git clone https://github.com/esayemm/.files.git ~/.dotfiles

    filesToSymlink=(
    'vimrc'
    'zshrc'
    'vim'
    'gitconfig'
    'tmux.conf'
    'tmux'
    'agignore'
    )

    for i in "${filesToSymlink[@]}"; do
      if [[ ! -e ~/.$i ]]; then
        ln -s ~/.dotfiles/$i ~/.$i
      fi
    done
  fi
}

function setupBase16Shell() {
  if ! directoryExists ~/.config/base16-shell; then
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
  fi
}

function fonts() {
  # install my favorite font
  if [[ ! -e /Library/Fonts/ProggyCleanSZBP.tff ]]; then
    cd ~/Downloads
    wget http://www.proggyfonts.net/wp-content/download/ProggyCleanSZBP.ttf.zip
    unzip ProggyCleanSZBP.ttf.zip
    mv ProggyCleanSZBP.ttf /Library/Fonts/
  fi
}

function vimPlug() {
  if ! fileExists ~/.vim/autoload/plug.vim; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi
}

function tmuxSetup() {
  if ! directoryExists ~/.tmux/plugins/tpm; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

function checkDefaultShell() {
  if [[ "$SHELL" != "/usr/local/bin/zsh" ]]; then
    chsh -s /usr/local/bin/zsh
  fi
}

function setupNodeEnv() {
  packages=(
  'nodemon'
  'webpack'
  'n'
  )

  for i in "${packages[@]}"; do
    if !commandExists $i; then
      npm install -g $i
    fi
  done
}

installHomebrew
brewInstall
brewCaskInstall
dotfiles
setupBase16Shell
fonts
setupNodeEnv
vimPlug
checkDefaultShell
