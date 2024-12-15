{ config, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = [
    pkgs.baobab
    pkgs.cheese
    pkgs.epiphany
    pkgs.simple-scan
    pkgs.geary
    pkgs.seahorse
  ];
}

