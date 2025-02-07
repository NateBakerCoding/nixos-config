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
    jq
    usbutils
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packaging (atm only for opentabletdriver)
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-wrapped-6.0.36"
    "dotnet-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];



}

