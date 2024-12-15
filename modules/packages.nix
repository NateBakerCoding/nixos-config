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
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}

