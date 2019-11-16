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
  ######### USER INSTALLATION ##########

  echo 'Installing pacman packages'
  pacman -Syyu sudo networkmanager git gvim xorg

  useradd -m luis
  passwd luis

  # TODO: login as luis user

  sudo pacman -S xorg-xbacklight zsh udisks2 alsa-utils
  sudo pacman -S dmenu pulseaudio pavucontrol
  sudo pacman -S pulseaudio-bluetooth blueman bluez-utils pulseaudio-alsa
  sudo pacman -S i3-gaps rsync
  sudo pacman -S bc

  echo 'Installing yaourt'
  git clone https://aur.archlinux.org/package-query.git
  cd package-query
  makepkg -si
  cd ..
  git clone https://aur.archlinux.org/yaourt.git
  cd yaourt
  makepkg -si
  cd ..

  echo 'Installing yaourt packages'
  yaourt -S --noconfirm rcm pamac-aur nvidia-beta

  # zsh
  echo 'Making Zsh default shell'
  chsh -s $(which zsh)

  # TODO: Setup system notifications and timesyncdaemon

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

  cd /etc/fonts/conf.d/
  sudo rm /etc/fonts/conf.d/10*
  sudo rm -rf 70-no-bitmaps.conf
  sudo ln -s ../conf.avail/70-yes-bitmaps.conf

  cd ~
  mkdir .local/share/fonts

  # ln -fs ~/Fonts/scientifica/regular/scientifica-11.bdf ~/.local/share/fonts/scientifica-11.bdf
  # ln -fs ~/Fonts/scientifica/bold/scientificaBold-11.bdf ~/.local/share/fonts/scientificaBold-11.bdf
}

main
