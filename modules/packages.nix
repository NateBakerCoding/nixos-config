{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    google-chrome
    firefox
    kitty
    gnome-tweaks
    lenovo-legion
    autorandr
    ferium
    prismlauncher
    unzip
    git
    gcc
    blesh
    tree
    ripgrep
    ollama-cuda
    tidal-hifi
    xclip
    scanmem
    lutris
    unrar
    steam
    openvpn
    krita                       # Drawing software
    opentabletdriver             # Support for drawing tablet
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}

