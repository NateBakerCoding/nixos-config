{
  description = "NixOS Configuration for Bakerdev";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # Use stable nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    overlay = import ./overlays/custom.nix;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlay ];
    };
  in
  {
    nixosConfigurations = {
      bakerdev = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware.nix
          ./modules/users.nix
          ./modules/networking.nix
          ./modules/audio.nix
          ./modules/nvidia.nix
          ./modules/desktop.nix
          ./modules/services.nix
          ./modules/packages.nix
          ./modules/gnome.nix
          ./modules/nix-settings.nix
          ./modules/wine.nix
          ./modules/nordvpn.nix

          # Integrate Home Manager
          home-manager.nixosModules.home-manager
          # Ensure home-manager command is globally available
          {
            environment.systemPackages = with pkgs; [ home-manager ];
          }
        ];
      };
    };
    
    homeConfigurations = {
      bakerdev = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
