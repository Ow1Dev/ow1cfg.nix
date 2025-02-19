{ inputs
, lib
, ...
}:
let
in {
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    inputs.nixos-wsl.nixosModules.default
    #
    # ========== Disk Layout ==========
    #
    #inputs.disko.nixosModules.disko

    #
    # ========== Misc Inputs ==========
    #

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Non-Primary Users to Create ==========
      #

      #
      # ========== Optional Configs ==========
      #
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "ow1forge";
  };

  wsl.enable = true;
  wsl.defaultUser = "ow1";
  wsl.docker-desktop.enable = true;

  virtualisation.docker = {
     enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs.nix-ld.enable = true;

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
