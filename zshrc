# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

## Variables

export VISUAL=vim
export EDITOR=vim
export LESS='-F -g -R -X -z-4'

# dotfile scripts in path
export PATH="$PATH:$HOME/bin"

# go
export GOPATH=$HOME/proj/go
export PATH="$PATH:$GOPATH/bin"

# python
export PYTHONPATH=$HOME/proj/py

## Completion

source <(kubectl completion zsh)

## Aliases and functions

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

# go
function gocd() {
  cd $GOPATH/src/$1
}
compdef '_files -W "$GOPATH/src"' gocd

# ruby
alias rrails="ssh -L 3000:localhost:3000"

# kubernetes
function kco() {
  if [ -z $1 ]; then
    kubectl config current-context
  else
    kubectl config use-context $1
  fi
}
complete -F __kubectl_config_get_contexts kco
alias kc=kubectl
alias kfw=kubeforward

## Other stuff

# Fixes something i dont even remember what
bindkey -s "^[OM" "^M"

# Source custom settings
if [[ -s "$HOME/.zshrc_custom" ]]; then
  source "$HOME/.zshrc_custom"
fi
