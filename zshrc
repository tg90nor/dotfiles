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

# GO!
export GOPATH=$HOME/proj/go
export PATH="$PATH:$GOPATH/bin"

# Python
export PYTHONPATH=$HOME/proj/py

do_sudo() {
    integer glob=1
    while (($#))
    do
        case $1 in
        command|exec|-) shift; break;;
  nocorrect) shift; continue;;
  noglob) glob=0; shift; continue;;
  *) break;;
  esac
    done
    (($# == 0)) && 1=zsh
    if ((glob))
    then
        command sudo $~==*
    else
  command sudo $==*
    fi
}

alias _='noglob do_sudo '
alias rrails="ssh -L 3000:localhost:3000"

bindkey -s "^[OM" "^M"

if [[ -s "$HOME/.zshrc_custom" ]]; then
  source "$HOME/.zshrc_custom"
fi
