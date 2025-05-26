{ config, pkgs, lib, ... }:

{
  boot.kernelParams = [ "amd_pstate=active" ];
  hardware.enableRedistributableFirmware = true;
  services.power-profiles-daemon.enable = false;

  hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.blacklistedKernelModules= [
        "hid-uclogic"
        "wacom"
    ];
}
