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

# python
export PYTHONPATH=$HOME/proj/py

## Completion

source <(kubectl completion zsh)
complete -F __kubectl_config_get_contexts kco
complete -F _kubectl kc

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

# ruby
alias rrails="ssh -L 3000:localhost:3000"

## Other stuff

# Fixes something i dont even remember what
bindkey -s "^[OM" "^M"

# Source custom settings
if [[ -s "$HOME/.zshrc_custom" ]]; then
  source "$HOME/.zshrc_custom"
fi
