{...}: {
  flake.nixosModules.ow1topConfiguration = {
    pkgs,
    unstablePkgs,
    ...
  }: {
    virtualisation.docker = {
      enable = true;
    };
    networking = {
      hostName = "Ow1Top";
    };

    environment.systemPackages = [
      pkgs.spotify
    ];
  };
}
