{ config, pkgs, ... }:

{
    hardware.opentabletdriver.enable=true;
    hardware.opentabletdriver.blacklistedKernelModules= [
        "hid-uclogic"
        "wacom"
    ];
}
