{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Track the dev branch for latest opencode (1.14.x)
    opencode.url = "github:anomalyco/opencode/dev";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (
      let
        modules = inputs.import-tree ./modules;
        hosts = inputs.import-tree ./hosts;
      in {
        imports = modules.imports ++ hosts.imports;

        perSystem = { pkgs, system, ... }: {
          # Reconstruct pkgs with overlays so consumers get pkgs.opencode
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (inputs.opencode.overlays.default or (final: prev: {}))
            ];
          };

          formatter = pkgs.alejandra;
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              lua-language-server
              alejandra
              nixd
            ];
          };
        };
      }
    );
}
