{pkgs, ...}: {
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  environment.systemPackages = [pkgs.git pkgs.vim];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
