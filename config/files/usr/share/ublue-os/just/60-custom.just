# Include some of your custom scripts here!

# Configure GRUB screen with various options
configure-grub ACTION="prompt":
  #!/usr/bin/env bash
  bold=$(tput bold)
  normal=$(tput sgr0)
  OPTION={{ ACTION }}
  if [ "$OPTION" == "prompt" ]; then
  echo "${bold}Configuring GRUB${normal}"
  echo 'GRUB hiding option can be useful for making boot-times faster.'
  echo 'Hide or Unhide GRUB? Press ESC to exit.'
  OPTION=$(ugum choose "Unhide (Default)" Hide)
  elif [ "$OPTION" == "help" ]; then
    echo "Usage: ujust configure-grub <option>"
    echo "  <option>: Specify the quick option - 'hide' or 'unhide'"
    echo "  Use 'hide' to hide GRUB boot screen."
    echo "  Use 'unhide' to revert to defaults."
    exit 0
  fi
  if [ "${OPTION,,}" == "hide" ]; then
    sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
    output=$(echo 'GRUB_TIMEOUT_STYLE=hidden' | sudo tee -a /etc/default/grub 2>&1) || echo "$output" && false
    output=$(echo 'GRUB_HIDDEN_TIMEOUT=1' | sudo tee -a /etc/default/grub 2>&1) || echo "$output" && false
    if [ -d /sys/firmware/efi ]; then
      output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
          echo 'Hide UEFI GRUB logs during boot setting applied.'
    else
      output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
          echo 'Hide BIOS GRUB logs during boot setting applied.'
    fi
  elif [ "$OPTION" == "Unhide (Default)" ] || [ "${OPTION,,}" == "unhide" ]; then
    sudo sed -i '/GRUB_HIDDEN_TIMEOUT=1/d' /etc/default/grub
    sudo sed -i '/GRUB_TIMEOUT_STYLE=hidden/d' /etc/default/grub
    sudo sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/g' /etc/default/grub
    if [ -d /sys/firmware/efi ]; then
      output=$(sudo grub2-mkconfig -o /etc/grub2-efi.cfg 2>&1) || echo "$output" && false
          echo 'Reverted setting "UEFI GRUB logs during boot" to defaults.'
    else
      output=$(sudo grub2-mkconfig -o /etc/grub2.cfg 2>&1) || echo "$output" && false
          echo 'Reverted setting "BIOS GRUB logs during boot" to defaults.'
    fi
  fi

enable-hibernation:
  #!/usr/bin/env bash

  HIBERNATION_SETUP_VER=2
  HIBERNATION_SETUP_VER_FILE="/etc/ublue/hibernation"

  sudo mkdir -p "$(dirname "$HIBERNATION_SETUP_VER_FILE")" || exit 1

  HIBERNATION_SETUP_VER_RAN=$(cat "$HIBERNATION_SETUP_VER_FILE")

  if [[ -f $HIBERNATION_SETUP_VER_FILE && "$HIBERNATION_SETUP_VER" = "$HIBERNATION_SETUP_VER_RAN" ]]; then
    echo "Hibernation is already setup. Exiting..."
    exit 0
  fi

  # Get the total memory (RAM + Swap) in kilobytes from the 'free' command
  total_memory_kb=$(free -k | awk '/^Mem:/ {mem=$2} /^Swap:/ {swap=$2} END {print mem + swap}')

  # Convert kilobytes to gigabytes and round up
  total_memory_gb=$(printf "%.0f" $(echo "scale=2; $total_memory_kb / 1024 / 1024" | bc))

  echo 'Creating Swapfile'
  sudo btrfs subvolume create /var/swap
  sudo btrfs filesystem mkswapfile --size ${total_memory_gb}g --uuid clear /var/swap/swapfile

  uuid_variable=$(sudo findmnt -no UUID -T /var/swap/swapfile)
  swap_offset=$(sudo btrfs inspect-internal map-swapfile -r /var/swap/swapfile)

  echo 'Adding resume to kernel arguments'
  sudo rpm-ostree kargs --append="resume=UUID=$uuid_variable resume_offset=$swap_offset"

  echo 'Adding swap to /etc/fstab'
  echo '/var/swap/swapfile    none    swap    defaults,pri=0 0 0' | sudo tee -a /etc/fstab
  sudo swapon /var/swap/swapfile

  sudo semanage fcontext -a -t swapfile_t '/var/swap(/.*)?'
  sudo restorecon -RF /var/swap

  cd /tmp

  echo 'Adding policies to allow hibernation'

  POLICY_MODULE_CONTENT="
  module hibernation_modules 1.0;

  require {
    class file { open };
    class dir { search };
    type systemd_localed_t, container_file_t, systemd_logind_t, swapfile_t, systemd_sleep_t;
  }

  # Allow systemd_localed_t to open files labeled as container_file_t
  allow systemd_localed_t container_file_t:file open;

  # Allow systemd_logind_t to search directories labeled as swapfile_t
  allow systemd_logind_t swapfile_t:dir search;

  # Allow systemd_sleep_t to search directories labeled as swapfile_t
  allow systemd_sleep_t swapfile_t:dir search;
  "

  # Echo to a file
  echo "$POLICY_MODULE_CONTENT" > hibernation_modules.te

  checkmodule -M -m -o hibernation_modules.mod hibernation_modules.te
  semodule_package -o hibernation_modules.pp -m hibernation_modules.mod
  sudo semodule -i hibernation_modules.pp

  echo 'AllowHibernation=yes' | sudo tee -a /etc/systemd/sleep.conf
  echo 'AllowSuspendThenHibernate=yes' | sudo tee -a /etc/systemd/sleep.conf
  echo 'HibernateDelaySec=90min' | sudo tee -a /etc/systemd/sleep.conf
  echo 'HibernateMode=shutdown' | sudo tee -a /etc/systemd/sleep.conf
  echo 'SuspendEstimationSec=60min' | sudo tee -a /etc/systemd/sleep.conf

  echo 'HandleLidSwitch=suspend-then-hibernate' | sudo tee -a /etc/systemd/logind.conf
  echo 'HandleLidSwitchExternalPower=suspend-then-hibernate' | sudo tee -a /etc/systemd/logind.conf

  dconf write /org/gnome/shell/extensions/hibernate-status-button/show-hibernate true
  dconf write /org/gnome/shell/extensions/hibernate-status-button/show-hybrid-sleep false
  dconf write /org/gnome/shell/extensions/hibernate-status-button/show-suspend-then-hibernate true

  echo "$HIBERNATION_SETUP_VER" | sudo tee "$HIBERNATION_SETUP_VER_FILE"
  echo 'All done! Please reboot to enable the changes.'