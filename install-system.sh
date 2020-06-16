main(){
  echo 'Setting keyboard'
  loadkeys us

  # Connect to the internet
  # ip link

  # iwd + dchpcd if wireless

  # ping 8.8.8.8

  echo 'Update the System Clock'
  timedatectl set-ntp true
  timedatectl set-timezone America/Lima

  echo 'Create Partition Table'
  parted /dev/sda mklabel gpt

  echo 'Create EFI Partition'
  parted /dev/sda mkpart primary fat32 1MiB 551MiB
  parted /dev/sda set 1 esp on
  mkfs.fat -F32 /dev/sda1

  echo 'Create Swap Partition'
  parted /dev/sda mkpart primary linux-swap 551MiB 6.5GiB

  echo 'Initialize swap'
  mkswap /dev/sda2
  swapon /dev/sda2

  echo 'Create Ext4 Partition'
  parted /dev/sda mkpart primary ext4 6.5GiB 100%
  mkfs.ext4 /dev/sda3

  echo 'Mount Ext4 partition'
  mount /dev/sda3 /mnt

  echo 'Mount EFI partition'
  mkdir /mnt/efi
  mount /dev/sda1 /mnt/efi

  echo 'Install base system + some'
  pacstrap /mnt base base-devel linux linux-firmware fakeroot gvim grub efibootmgr intel-ucode amd-ucode networkmanager network-manager-applet alacritty sudo git libnotify notification-daemon xf86-video-amdgpu

  ########## CONFIGURING SYSTEM #############
  genfstab -U /mnt >> /mnt/etc/fstab

  echo 'Set Time'
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
  arch-chroot /mnt hwclock --systohc

  echo 'Generate locale'
  sed -i "s/#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/" /mnt/etc/locale.gen
  arch-chroot /mnt locale-gen

  # Create the locale.conf(5) file, and set the LANG variable accordingly:
  echo 'Set LANG'
  echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

  # If you set the keyboard layout, make the changes persistent in vconsole.conf(5):
  echo 'Persist Keyboard'
  echo "KEYMAP=us" >> /mnt/etc/vconsole.conf

  echo 'Set hostname'
  echo "luis-lap" > /mnt/etc/hostname

  echo "127.0.0.1	localhost" >> /mnt/etc/hosts
  echo "::1		localhost" >> /mnt/etc/hosts
  echo "127.0.1.1	luis-lap.localdomain	luis-lap" >> /mnt/etc/hosts

  echo "[D-BUS Service]" > "/mnt/usr/share/dbus-1/services/org.freedesktop.Notifications.service"
  echo "Name=org.freedesktop.Notifications" >> "/mnt/usr/share/dbus-1/services/org.freedesktop.Notifications.service"
  echo "Exec=/usr/lib/notification-daemon-1.0/notification-daemon" >> "/mnt/usr/share/dbus-1/services/org.freedesktop.Notifications.service"

  # sudo find /sys/ -type f -iname '*brightness*'
  # Then link it
  # sudo ln -s /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight /sys/class/backlight

  # /etc/X11/xorg.conf.d/20-amdgpu.conf
  #
  # Section "Device"
  #      Identifier "AMD"
  #      Driver "amdgpu"
  #      Option "Backlight" "amdgpu_bl0"
  # EndSection

  # /etc/X11/xorg.conf.d/20-intel.conf
  #
  # Section "Device"
  #     Identifier  "Intel Graphics"
  #     Driver      "intel"
  #     Option      "Backlight"  "intel_backlight"
  # EndSection

  # /etc/udev/rules.d/90-backlight.rules

  # ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
  # ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
  # ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chgrp video /sys/class/leds/%k/brightness"
  # ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"

  # usermod -a -G video <user>

  arch-chroot /mnt passwd
  arch-chroot /mnt systemctl enable NetworkManager.service

  ######### USER INSTALLATION ##########

  arch-chroot /mnt useradd -m luis
  arch-chroot /mnt passwd luis

  echo 'Install GRUB'
  arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
  arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
}

main
