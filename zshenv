## Aliases and functions

# go
function gocd() {
  cd $GOPATH/src/$1
}

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
alias kc=kubectl
alias kfw=kubeforward

# Source custom settings
if [[ -s "$HOME/.zshenv_custom" ]]; then
  source "$HOME/.zshenv_custom"
fi
