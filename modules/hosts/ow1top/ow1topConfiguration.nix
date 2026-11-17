{...}: {
  flake.nixosModules.ow1topConfiguration = {pkgs, ...}: {
    virtualisation.docker = {
      enable = true;
    };
    networking = {
      hostName = "Ow1Top";
    };

    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
