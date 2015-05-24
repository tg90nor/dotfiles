#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export VISUAL=vim
export EDITOR=vim
export LESS='-F -g -R -X -z-4'
export PATH="$PATH:$HOME/bin"

alias _="sudo "
alias rrails="ssh -L 3000:localhost:3000"
