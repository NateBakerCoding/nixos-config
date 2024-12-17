{ config, lib, pkgs, ... }:

with lib; {
  options.services.nordvpn.enable = mkOption {
    type = types.bool;
    default = false;
    description = mdDoc ''
      Whether to enable the NordVPN daemon. Note that you'll have to set
      `networking.firewall.checkReversePath = false;` and allow UDP 1194
      and TCP 443 for it to work.
    '';
  };

  config = mkIf config.services.nordvpn.enable {
    environment.systemPackages = [ pkgs.nordvpn ];

    users.groups.nordvpn = {};
    systemd.packages = [ pkgs.nordvpn ];
    systemd.tmpfiles.packages = [ pkgs.nordvpn ];

    system.activationScripts.nordvpn = ''
      mkdir -m 700 -p /var/lib/nordvpn
      if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
        cp -r ${pkgs.nordvpn}/var/lib/nordvpn/* /var/lib/nordvpn
      fi
    '';
  };
}
