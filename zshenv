# My scripts
export PATH="$PATH:$HOME/bin"

# Go
export GOPATH=$HOME/proj/go
export PATH="$PATH:$GOPATH/bin"
function gocd() {
  cd $GOPATH/src/$1
}

# Python
export PYTHONPATH=$HOME/proj/py

# Ruby
alias rrails="ssh -L 3000:localhost:3000"

# Kubernetes
function kco() {
  if [ -z $1 ]; then
    kubectl config current-context
  else
    kubectl config use-context $1
  fi
}
alias kc=kubectl

