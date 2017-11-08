# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export VISUAL=vim
export EDITOR=vim
export LESS='-F -g -R -X -z-4'

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

bindkey -s "^[OM" "^M"

# dotfile scripts in path
export PATH="$PATH:$HOME/bin"

# go
export GOPATH=$HOME/proj/go
export PATH="$PATH:$GOPATH/bin"

# python
export PYTHONPATH=$HOME/proj/py

# Completion
compctl -/ -W $GOPATH/src gocd
source <(kubectl completion zsh)
complete -F __kubectl_config_get_contexts kco

# Source custom settings
if [[ -s "$HOME/.zshrc_custom" ]]; then
  source "$HOME/.zshrc_custom"
fi
