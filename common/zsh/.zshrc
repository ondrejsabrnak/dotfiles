# 1Password SSH Agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# ZSH Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Aliases
## Git
alias gc="git fetch --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs -r git branch -D"
alias gph="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate --all"
alias gs="git status"
alias gw="git switch "
alias gtfo="git reset --hard; git clean -xfd"
## Kubernetes
alias k=kubectl
alias kx=kubectx
alias kn=kubens
## Terraform
alias tf=terraform
alias tfi="terraform init"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfp="terraform plan"
alias tfs="terraform show"
alias tfo="terraform output"

# fzf
source <(fzf --zsh)

# kube-ps1
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
## Default state: off
export KPS1_ACTIVE=0
export ORIGINAL_PS1="$PS1"
## Make sure the shell expands $(...) in PS1
setopt PROMPT_SUBST
kps1() {
  if [[ "$KPS1_ACTIVE" == "1" ]]; then
    ### Turn it off
    export PS1="$ORIGINAL_PS1"
    export KPS1_ACTIVE=0
  else
    ### Turn it on
    export KUBE_PS1_SYMBOL_ENABLE=false
    export PS1='$(kube_ps1) '"$ORIGINAL_PS1"
    export KPS1_ACTIVE=1
  fi
}