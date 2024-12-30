{ config, pkgs, ... }:

{
  boot.loader = {
    grub2 = {
      enable = true;
      version = 2;  # Explicitly specify GRUB2 version
      devices = [ "/dev/nvme0n1" ];  # Use your boot device
      efiSupport = true;             # Enable for UEFI systems
      efiInstallAsRemovable = false; # Set to true for some dual-boot scenarios
      extraConfig = ''
        # Add any GRUB2-specific configurations here
      '';
    };
    systemd-boot.enable = false;  # Disable other boot loaders if enabled
    grub.enable = false;          # Ensure the older GRUB is disabled
  };
}


