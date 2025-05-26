{ config, pkgs, ... }:
{
  # Specify the username for Home Manager
  home.username = "bakerdev"; 
  home.homeDirectory = "/home/bakerdev"; 
  # State version for Home Manager
  home.stateVersion = "24.11";
  imports = [
    ./configs/kitty-config.nix
    ./configs/bashrc-config.nix
    ./configs/nvim-config.nix
    ./configs/tmux-config.nix # Added
  ];
  # List packages without a config associated with them here
  home.packages = with pkgs; [
    gnome-tweaks
  ];
}
