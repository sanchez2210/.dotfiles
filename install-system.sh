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
  mount -a

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

  mkdir /mnt
  mkdir /mnt/efi

  echo 'Mount partitions'
  mount /dev/sda3 /mnt
  mount /dev/sda1 /mnt/efi

  echo 'Install base system'
  pacstrap /mnt base

  ########## CONFIGURING SYSTEM #############
  genfstab -U /mnt >> /mnt/etc/fstab

  arch-chroot /mnt

  # Time
  ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
  hwclock --systohc

  # Locatization
  echo "en_US.UTF-8 UTF-8  " >> /etc/locale.gen
  locale-gen

  # Create the locale.conf(5) file, and set the LANG variable accordingly:
  echo "LANG=en_US.UTF-8" >> /etc/locale.conf

  # If you set the keyboard layout, make the changes persistent in vconsole.conf(5):
  echo "KEYMAP=us" >> /etc/vconsole.conf

  echo "luis-pc" > /etc/hostname
  echo "127.0.0.1	localhost" >> /etc/hosts
  echo "::1		localhost" >> /etc/hosts
  echo "127.0.1.1	luis-pc.localdomain	luis-pc" >> /etc/hosts

  passwd

  pacman -S grub efibootmgr

  grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
  grub-mkconfig -o /boot/grub/grub.cfg
}

main
