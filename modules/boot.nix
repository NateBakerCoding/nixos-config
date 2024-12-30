{ config, pkgs, ... }:

{
  # GRUB in UEFI mode
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;

  # In UEFI mode, do *not* specify /dev/nvme0n1
  boot.loader.grub.devices = [ "nodev" ];

  # (Optional) Usually for multiple OS detection
  boot.loader.grub.useOSProber = true;

  # The EFI mount point is set in the *EFI* config, not in GRUB:
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot"; 

  # Set Theme
  boot.plymouth = {
    enable = true;
    theme = "hud_3";
    themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "hud_3" ];
        })
    ];
  };

  # Enable 'Slient Boot'
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  # Hide the OS choice for bootloaders.
  # It's still possible to open the bootloader list by pressed
  # It will just not appear on screen unless a key is pressed
  boot.loader.timeout = 0; 
}
