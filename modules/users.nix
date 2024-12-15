{ config, pkgs, ... }:

{
  users.users.bakerdev = {
    isNormalUser = true;
    description = "Nate Baker";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}

