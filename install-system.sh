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
  pacstrap /mnt base base-devel linux linux-firmware fakeroot gvim grub efibootmgr intel-ucode amd-ucode networkmanager sudo git

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
