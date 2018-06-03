#!/usr/bin/env bash

sudo pacman -Syyu
sudo pacman -S anki chromium calibre diff-so-fancy firefox git green-recorder pamac pinta the_silver_searcher tmux vim wavemon yaourt zeal zsh

sudo yaourt -Syy
sudo yaourt --noconfirm -S franz-bin heroku-cli upwork postman-bin peek rcm

# asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0

zsh

asdf plugin-add asdf-ruby
asdf plugin-add asdf-nodejs

asdf install ruby 2.4.4
asdf install ruby 2.5.1

# vundler
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# CONFIG

# git
git config --global user.name "Luis Felipe Sanchez"
git config --global user.email sanchezhorna@outlook.com
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
