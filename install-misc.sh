main() {
  sudo pacman -S calibre pinta redshift wavemon zeal picom
  sudo pacman -S deluge vlc tmux yarn notification-daemon
  sudo pacman -S nitrogen

  # lulz
  # sudo pacman -S cowsay fortune-mod
  # gem install artiik

  echo 'Installing yay packages'
  # yay -S franz-bin
  yay -S heroku-cli upwork postman-bin peek --noconfirm
  yay -S radarr charles prismatik green-recorder --noconfirm
}

main
