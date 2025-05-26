{ config, pkgs, ... }:

{
  users.users.bakerdev = {
    isNormalUser = true;
    description = "Nate Baker";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ]; # Modified
    shell = pkgs.bash; # Added
  };
}

