{ config, pkgs, ... }:

{
  # Ensure blesh is installed
  home.packages = with pkgs; [ blesh ];

  # Define .bashrc configuration
  home.file.".bashrc".text = ''
    # Custom PS1 prompt
    PS1='\[\e[96m\]\u\[\e[0m\] [\[\e[93m\]\W\[\e[0m\]] \[\e[92m\]λ\[\e[0m\] '

    function update_nixconfig(){
        # Navigate to the NixOS configuration directory
        cd ~/nixos-config || exit

        # Stage all changes
        git add .

        # Commit changes with the current date in the message
        current_date=$(date "+%b %d %Y")
        git commit -m "$current_date"

        # Rebuild NixOS with the specified flake
        sudo nixos-rebuild switch --flake ~/nixos-config#bakerdev

    }

    # Source blesh
    [ -s "${pkgs.blesh}/share/blesh/ble.sh" ] && source "${pkgs.blesh}/share/blesh/ble.sh"
  '';

}

