{
  description = "ow1 flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = let
        inherit (self) outputs;
      in {
        nixosConfigurations = {
          ow1vm = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs outputs;};
            modules = [./hosts/ow1vm];
          };
        };

        homeConfigurations = {
          "ow1@ow1vm" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            extraSpecialArgs = {inherit inputs outputs;};
            modules = [./home/ow1/ow1vm.nix];
          };
        };

        overlays = import ./overlays {inherit inputs;};
      };
      systems = [
        "x86_64-linux"
      ];
      perSystem = {pkgs, ...}: let
        inherit (pkgs) alejandra just nixos-rebuild mkShell;
      in {
        devShells = {
          default = mkShell {
            nativeBuildInputs = [just alejandra nixos-rebuild];
          };
        };

        formatter = alejandra;
      };
    };
}
