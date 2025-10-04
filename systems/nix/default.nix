{ pkgs, ... }:{
  imports = [
    ./nh.nix
    ./nixpkgs.nix
  ];
  
  environment.systemPackages = [pkgs.git];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };
}
