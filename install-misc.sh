main() {
  sudo pacman -Syu calibre pinta redshift wavemon zeal picom
  sudo pacman -Syu deluge vlc tmux yarn notification-daemon
  sudo pacman -Syu nitrogen

  # lulz
  # sudo pacman -Syu cowsay fortune-mod
  # gem install artiik

  echo 'Installing yay packages'
  # yay -Syu franz-bin
  yay -Syu heroku-cli upwork postman-bin peek --noconfirm
  yay -Syu radarr charles prismatik green-recorder --noconfirm
}

main
