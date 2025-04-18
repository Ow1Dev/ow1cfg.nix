# Shell for bootstrapping flake-enabled nix and other tooling
{
  pkgs ? # If pkgs is not defined, instantiate nixpkgs from locked commit
    let
      lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { overlays = [ ]; },
  ...
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    BOOTSTRAP_USER = "ow1";
    BOOTSTRAP_SSH_PORT = "22";

    nativeBuildInputs = builtins.attrValues {
      inherit (pkgs)
        nix
        home-manager
        nh
        git
        just
        pre-commit
        deadnix
        yq-go # jq for yaml, used for build scripts
        bats # bash testing
        ;
    };
  };
}
