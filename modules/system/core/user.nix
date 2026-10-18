{self, ...}: {
  flake.nixosModules.user = {pkgs, ...}: let
    modules = with self.nixosModules; [
      zsh
    ];
  in {
    imports = modules;
    users.users.ow1 = {
      isNormalUser = true;
      initialPassword = "pass";
      shell = pkgs.zsh;
      description = "ow1";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };
}
