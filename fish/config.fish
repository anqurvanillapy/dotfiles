#
# Useful aliases
#

alias ga='git add'
alias gb='git branch'
alias gba='git branch -a -vv'
alias gbd='git branch -D'
alias gck='git checkout'
alias gcl='git clone'
alias gcm='git commit -s -a -m'
alias gca='git commit -s --amend'
alias gcar='git commit -s --amend --reset-author'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gd='git diff'
alias gdn='git diff --name-status'
alias gf='git fetch --all --prune'
alias gl='git log --decorate --color'
alias glo='git log --oneline --decorate --color --graph -3'
alias gm='git merge'
alias gms='git merge --squash'
alias gpl='git pull --prune --ff-only'
alias gpr='git pull --rebase'
alias gps='git push'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias grm='git rm'
alias grs='git reset'
alias grsh='git reset --hard'
alias grvt='git checkout HEAD'
alias gs='git status -s'
alias gpla='find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull'

alias json='python3 -m json.tool'

alias !!='echo $history[1] | xargs -o'

#
# pyenv
#

if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
