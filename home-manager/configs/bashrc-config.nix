{ config, pkgs, ... }:

{
  # Ensure blesh is installed
  home.packages = with pkgs; [ blesh ];

  # Define .bashrc configuration
  home.file.".bashrc".text = ''
    # Custom PS1 prompt
    PS1='\[\e[96m\]\u\[\e[0m\] [\[\e[93m\]\W\[\e[0m\]] \[\e[92m\]λ\[\e[0m\] '

    # Source blesh
    [ -s "${pkgs.blesh}/share/blesh/ble.sh" ] && source "${pkgs.blesh}/share/blesh/ble.sh"
  '';
}

