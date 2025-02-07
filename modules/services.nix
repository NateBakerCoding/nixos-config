{ configs, pkgs, ...}:


{
    services.logind.lidSwitch = "ignore";
    
    services.ollama = {
        enable = true;
        acceleration = "cuda";
    };

    services.udev.packages = [
        pkgs.opentabletdriver
    ];

    services.udev.extraRules = ''
KERNEL=="hidraw*", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0947", TAG+="uaccess", TAG+="udev-acl"
SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0947", TAG+="uaccess", TAG+="udev-acl"
SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="0947", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
}


