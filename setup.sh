#!/usr/bin/env zsh

# Init
# Get script directory
dotdir=$(dirname ${0:A})
# Detect OS
os="dunno"
unamestr=$(uname)
if [[ "$unamestr" == "Linux" ]]; then
  distrostr=$(lsb_release -si)
  if [[ "$distrostr" =~ /RedHat/ ]]; then
    os="redhat"
  elif [[ "$distrostr" =~ /Fedora/ ]]; then
    os="redhat"
  else
    os=$distrostr
  fi
elif [[ "$unamestr" == "Darwin" ]]; then
  os=$unamestr
  if ! type "brew" > /dev/null; then
    # Install homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
else
  os=$unamestr
fi

# Make vim awesome
vim_conf() {
  # Copy .vimrc
  mv ~/.vimrc ~/.vimrc.lame || true
  cp $dotdir/.vimrc ~/.vimrc
  # Install distinguished color theme
  mkdir -p ~/.vim/colors
  curl https://raw.githubusercontent.com/Lokaltog/vim-distinguished/develop/colors/distinguished.vim > ~/.vim/colors/distinguished.vim
  # Install vundle
  mkdir -p ~/.vim/bundle
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
}

# Make tmux awesome
tmux_conf() {
  # Check if tmux is installed, and install if not
  if ! type "tmux" > /dev/null; then
    install_pkg tmux
  fi
  # Copy .tmux.conf
  mv ~/.tmux.conf ~/.tmux.conf.lame || true
  cp $dotdir/.tmux.conf ~/.tmux.conf
}

# Make zsh awesome
zsh_conf() {
  # Install oh-my-zsh
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  # Copy .zshrc
  mv ~/.zshrc ~/.zshrc.lame || true
  cp $dotdir/.zshrc ~/.zshrc
}

# Install rvm and ruby
rvm() {
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable
  rvm install 2.2
  rvm use 2.2 --default
}

install_pkg() {
  if [[ "$os" == "Darwin" ]]; then
    $(brew install $1)
  elif [[ "$os" == "redhat" ]]; then
    $(sudo yum install $1)
  elif [[ "$os" == "Ubuntu" ]]; then
    $(sudo apt-get install $1)
  else
    echo "Unknown OS, cannot install $1"
  fi
}

vim_conf
tmux_conf
zsh_conf
#rvm
