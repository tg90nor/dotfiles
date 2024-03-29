#!/usr/bin/env zsh

dotdir="${DOTDIR:-$HOME/dot}"

_detect_os() {
  os="dunno"
  unamestr=$(uname | tr '[:upper:]' '[:lower:]')
  if [ "$unamestr" = "linux" ]; then
    if [ -f /etc/os-release ]; then
      distrostr=$(cat /etc/os-release | egrep '^ID=' | tr '=' ' '| tr -d '"' | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
    else
      distrostr=$(lsb_release -si | tr '[:upper:]' '[:lower:]') 
    fi
    if [[ "$distrostr" =~ /redhat/ ]]; then
      os="redhat"
    elif [[ "$distrostr" =~ /fedora/ ]]; then
      os="redhat"
    else
      os=$distrostr
    fi
  else
    os=$unamestr
  fi
}

_install_pkg_cmd() {
  case $os in
    darwin)
      # install homebrew if it is missing
      if ! type "brew" > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      install_pkg_cmd="brew install"
      ;;
    redhat|rhel|centos|fedora)
      install_pkg_cmd="sudo yum install"
      ;;
    debian|ubuntu)
      install_pkg_cmd="sudo apt-get install"
      ;;
    arch)
      install_pkg_cmd="echo sudo pacman -S"
      ;;
    *)
      echo "Unknown OS, cannot install $1"
      ;;
  esac
}

install_pkgs() {
  while (($#)); do
    if ! type "$1" > /dev/null; then
      pkgs="$pkgs $1"
    fi
    shift
  done
  if [ ! -z $pkgs ]; then
    eval "$install_pkg_cmd $pkgs"
  fi
}

install_dotfiles() {
  if [ ! -d $dotdir/dotfiles ]; then
    if [ -z $DOTFILES_CLONE_METHOD ]; then
      echo "Which method do you want to use for cloning the dotfiles git repo? (ssh|https)"
      read </dev/tty dotfiles_clone_method
      if [ "$dotfiles_clone_method" != "ssh" ] && [ "$dotfiles_clone_method" != "https" ]; then
        echo "Unrecognized option '$dotfiles_clone_method'. Aborting."
        exit 127
      fi
    else
      dotfiles_clone_method="$DOTFILES_CLONE_METHOD"
    fi

    echo "dotdir=$dotdir"
    echo "dotfiles_clone_method=$dotfiles_clone_method"

    mkdir -p $dotdir
    if [ "$dotfiles_clone_method" = "https" ]; then
      git clone https://github.com/tg90nor/dotfiles.git $dotdir/dotfiles
    elif [ "$dotfiles_clone_method" = "ssh" ]; then
      git clone git@github.com:tg90nor/dotfiles.git $dotdir/dotfiles
    fi
  fi
}

conf_file() {
  s=$1
  if [ $# -eq 2 ]; then
    d=$2
  else
    d=$HOME/.$s
  fi

  mkdir -p $d:h
  if [ -f "$d" ] && [ ! -L "$d" ]; then
    mv $d $d.bak
  fi
  ln -sf $dotdir/dotfiles/$s $d
}

# Make vim awesome
vim_conf() {
  conf_file vimrc
  conf_file ctags
  # Install vundle
  mkdir -p ~/.vim/bundle
  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi
  # Create directories to hold vim backup, swap, undo and view files
  mkdir -p ~/.vim/backup ~/.vim/swap ~/.vim/undo ~/.vim/view
}

# Make tmux awesome
tmux_conf() {
  # Copy .tmux.conf
  rm ~/.tmux.conf 2>/dev/null || true
  cp $dotdir/dotfiles/tmux.conf ~/.tmux.conf
  if [ -f ~/.tmux.conf.local ]; then
    cat ~/.tmux.conf.local >> ~/.tmux.conf
  fi
  conf_file gitmux
}

# Make zsh awesome
zsh_conf() {
  rm ~/.zlogin ~/.zlogout ~/.zpreztorc ~/.zprofile ~/.zshenv ~/.zshrc 2>/dev/null || true
  conf_file zsh/zshenv ~/.zshenv
  conf_file zsh/zshrc ~/.zshrc
  # Install zsh-snap
  if [ ! -d $dotdir/zsh-snap ]; then
    git clone https://github.com/marlonrichert/zsh-snap.git $dotdir/zsh-snap
  else
    cd $dotdir/zsh-snap
    git pull
  fi
}

_detect_os

if [ $# -ne 0 ]; then
  case $1 in
    "tmux")
      shift
      tmux_conf $@
      ;;
    "vim")
      shift
      vim_conf $@
      ;;
    "zsh")
      shift
      zsh_conf $@
      ;;
    *)
      $@
      ;;
  esac
  exit
fi

_install_pkg_cmd

install_pkgs curl tmux git vim

install_dotfiles
vim_conf
tmux_conf
zsh_conf
conf_file gh-config.yml ~/.config/gh/config.yml
