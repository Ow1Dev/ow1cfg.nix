{pkgs, ...}: {
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  environment.systemPackages = [pkgs.git];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
