{ config, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 137 138 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };
}


