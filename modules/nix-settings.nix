{ config, pkgs, ... }:

{
  system.stateVersion = "24.11";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true; # Added
  };

  nix.gc = { # Added
    automatic = true;
    options = "--delete-older-than 7d";
  };
}

