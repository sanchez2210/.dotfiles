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
  sudo pacman -S --noconfirm anki chromium calibre diff-so-fancy firefox git pamac pinta the_silver_searcher tmux vim wavemon yaourt zeal

  echo 'Installing yaourt packages'
  yaourt -S franz-bin
  yaourt -S green-recorder
  yaourt -S heroku-cli
  yaourt -S upwork
  yaourt -S postman-bin
  yaourt -S peek
  yaourt -S rcm

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

  # asdf
  echo 'Installing asdf'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0

  env zsh

  asdf plugin-add asdf-ruby
  asdf plugin-add asdf-nodejs

  asdf install ruby 2.4.4
  asdf install ruby 2.5.1

  # vundler
  echo 'Installing Vundle'
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall

  # oh-my-zsh
  echo 'Installing Oh-My-Zsh'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  # CONFIG

  # git
  git config --global user.name "Luis Felipe Sanchez"
  git config --global user.email sanchezhorna@outlook.com
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
}

main
