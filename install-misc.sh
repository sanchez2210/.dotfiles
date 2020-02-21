main() {
  sudo pacman -Syu calibre pinta redshift wavemon zeal picom
  sudo pacman -Syu deluge vlc xscreensaver

  # lulz
  # sudo pacman -Syu cowsay fortune-mod
  # gem install artiik

  echo 'Installing yay packages'
  # yay -Syu franz-bin
  yay -Syu radarr prismatik green-recorder --noconfirm
}

main
