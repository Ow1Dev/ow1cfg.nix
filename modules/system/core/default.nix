{self, ...}: {
  flake.nixosModules.core = {pkgs, ...}: let
    modules = with self.nixosModules; [
      locale
      user
      bootloader
      nix
    ];
  in {
    imports =
      [
        /etc/nixos/hardware-configuration.nix
      ]
      ++ modules;

    environment.systemPackages = with pkgs; [
      wget
    ];

    system.stateVersion = "25.05";
  };
}
