# Dotfiles

clone: `git clone --bare https://github.com/Jackojc/dots $HOME/.dotfiles/.git`

checkout: `git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME checkout`

ignore untracked files `git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --local status.showUntrackedFiles no`

set default push remote `git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --set-upstream origin master`
