{ config, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;  # Specify GRUB2 explicitly
    devices = [ "/dev/nvme0n1" ];  # Use your boot device
    efiSupport = true;             # Enable for UEFI systems
    efiInstallAsRemovable = false; # Set to true for some dual-boot scenarios
    extraConfig = ''
      # Add any GRUB2-specific configurations here
    '';
  };

  # Ensure other bootloaders are disabled
  boot.loader.systemd-boot.enable = false;
};



