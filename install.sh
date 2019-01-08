: ${VERBOSE:=0}
: ${CP:=/bin/cp}
: ${LN:=/bin/ln}
: ${MKDIR:=/bin/mkdir}
: ${RM:=/bin/rm}
: ${DIRNAME:=/usr/bin/dirname}
: ${XARGS:=/usr/bin/xargs}
verbose() {
  if [ "$VERBOSE" -gt 0 ]; then
    echo "$@"
  fi
}
handle_file_cp() {
  if [ -e "$2" ]; then
    printf "%s " "overwrite $2? [yN]"
    read overwrite
    case "$overwrite" in
      y)
        $RM -rf "$2"
        ;;
      *)
        echo "skipping $2"
        return
        ;;
    esac
  fi
  verbose "'$1' -> '$2'"
  $DIRNAME "$2" | $XARGS $MKDIR -p
  $CP -R "$1" "$2"
}
handle_file_ln() {
  if [ -e "$2" ]; then
    printf "%s " "overwrite $2? [yN]"
    read overwrite
    case "$overwrite" in
      y)
        $RM -rf "$2"
        ;;
      *)
        echo "skipping $2"
        return
        ;;
    esac
  fi
  verbose "'$1' -> '$2'"
  $DIRNAME "$2" | $XARGS $MKDIR -p
  $LN -sf "$1" "$2"
}

main() {

  echo 'Installing pacman packages'
  sudo pacman -Syyu
  sudo pacman -S chromium calibre diff-so-fancy firefox flameshot fzf git
  sudo pacman -S imagemagick pamac pinta postgresql redshift rsync
  sudo pacman -S the_silver_searcher tmux ttf-ubuntu-font-family gvim
  sudo pacman -S wavemon xorg-xbacklight yarn zeal zsh
  # sudo pacman -S yaourt
  # sudo pacman -S dmenu
  # sudo pacman -S i3

  echo 'Installing yaourt packages'
  # yaourt -S franz-bin
  yaourt -S green-recorder
  yaourt -S heroku-cli
  # yaourt -S upwork
  yaourt -S postman-bin
  yaourt -S peek
  yaourt -S rcm

  # zsh
  echo 'Making Zsh default shell'
  chsh -s $(which zsh)

  # oh-my-zsh
  echo 'Installing Oh-My-Zsh'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  #.dotfiles
  echo 'Installing dotfiles'
  git clone https://github.com/sanchez2210/.dotfiles ~/.dotfiles

  handle_file_ln "/home/luis/.dotfiles/default-gems" "/home/luis/.default-gems"
  handle_file_ln "/home/luis/.dotfiles/install.sh" "/home/luis/.install.sh"
  handle_file_ln "/home/luis/.dotfiles/install-test.sh" "/home/luis/.install-test.sh"
  handle_file_ln "/home/luis/.dotfiles/tmux.conf" "/home/luis/.tmux.conf"
  handle_file_ln "/home/luis/.dotfiles/tool-versions" "/home/luis/.tool-versions"
  handle_file_ln "/home/luis/.dotfiles/vimrc" "/home/luis/.vimrc"
  handle_file_ln "/home/luis/.dotfiles/vimrc.bundles" "/home/luis/.vimrc.bundles"
  handle_file_ln "/home/luis/.dotfiles/zshenv" "/home/luis/.zshenv"
  handle_file_ln "/home/luis/.dotfiles/zshrc" "/home/luis/.zshrc"

  # vundler
  echo 'Installing Vundle'
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  # Vim plugins
  vim +PluginInstall +qall

  # asdf
  echo 'Installing asdf'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0

  # Ruby
  echo 'installing ruby versions'
  zsh -c "asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git"
  zsh -c "asdf install ruby 2.4.4"
  zsh -c "asdf install ruby 2.5.1"

  # Node
  echo 'installing nodejs versions'
  zsh -c "asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git"
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  zsh -c "asdf install nodejs 8.11.2"

  # CONFIG

  # Postgresql
  echo 'Postgresql configuration'
  sudo -u postgres initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
  systemctl start postgresql.service
  systemctl enable postgresql.service
  sudo -u postgres createuser --interactive

  # git
  echo 'Git configuration'
  git config --global user.name "Luis Felipe Sanchez"
  git config --global user.email sanchezhorna@outlook.com
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  git config --global credential.helper 'cache --timeout=28800'

  # Listen
  echo 'Increasing the amount of inotify watchers'
  echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
}

main
