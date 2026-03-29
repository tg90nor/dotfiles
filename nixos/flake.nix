{
  description = "NixOS configurations for glitternix, epoch-cube, and epoch-x1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, ... }:
    let
      lib = nixpkgs.lib;
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        glitternix = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { pkgs-unstable = pkgs-unstable; };
          modules = [
            ./hosts/glitternix/configuration.nix
            ./lib/nixos-modules/common.nix
            ./lib/nixos-modules/base-packages.nix
            ./lib/nixos-modules/desktop/kde.nix
          ];
        };

        epoch-cube = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { pkgs-unstable = pkgs-unstable; };
          modules = [
            ./hosts/epoch-cube/configuration.nix
            ./lib/nixos-modules/common.nix
            ./lib/nixos-modules/base-packages.nix
            ./lib/nixos-modules/services/ssh.nix
            ./lib/nixos-modules/services/k3s.nix
            ./lib/nixos-modules/services/home-assistant.nix
          ];
        };

        epoch-x1 = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { pkgs-unstable = pkgs-unstable; };
          modules = [
            ./hosts/epoch-x1/configuration.nix
            ./lib/nixos-modules/common.nix
            ./lib/nixos-modules/base-packages.nix
            ./lib/nixos-modules/desktop/hyprland.nix
          ];
        };
      };
    };
}
