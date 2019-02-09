main() {
  sudo pacman -S chromium calibre pamac pinta redshift wavemon zeal
  sudo pacman -S deluge thunar vlc

  echo 'Installing yaourt packages'
  # yaourt -S franz-bin
  yaourt -S green-recorder
  yaourt -S heroku-cli
  yaourt -S upwork
  yaourt -S postman-bin
  yaourt -S peek

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
