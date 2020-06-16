main() {
  sudo pacman -Syu ttf-ubuntu-font-family i3lock the_silver_searcher zsh-syntax-highlighting diff-so-fancy flameshot fzf sqlite sqlitebrowser tidy
  sudo pacman -Syu imagemagick tmux yarn postgresql chromium morc_menu bmenu autojump redis unzip xdotool xorg-fonts-misc xautolock

  echo 'Installing yay packages'
  # yay -Syu franz-bin
  yay -Syu green-recorder charles i3-scrot i3lock-fancy-git heroku-cli upwork postman-bin peek nerd-fonts-complete --noconfirm
  yay -Syu xidlehook --noconfirm

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
  zsh -c "asdf install nodejs 10.15.0"

  # CONFIG

  # Postgresql
  echo 'Postgresql configuration'
  sudo runuser postgres -c "initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
  systemctl start postgresql.service
  systemctl enable postgresql.service
  sudo runuser postgres -c "createuser --interactive"

  # git
  echo 'Git configuration'
  git config --global user.name "Luis Felipe Sanchez"
  git config --global user.email sanchezhorna@outlook.com
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  git config --global credential.helper 'cache --timeout=28800'

  # Listen
  echo 'Increasing the amount of inotify watchers'
  echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

  # Install powerlevelNk theme
}

main
