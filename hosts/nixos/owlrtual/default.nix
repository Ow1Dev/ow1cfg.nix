# This is an example nixos hosts module.
# They will automatically be imported below.

#############################################################
#
#  Hostname1 - Example Desktop
#
###############################################################

{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/greetd.nix" 
      "hosts/common/optional/services/openssh.nix" 
      "hosts/common/optional/audio.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #
  hostSpec = {
    hostName = "owlrtual";
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  virtualisation.virtualbox.guest.enable = true;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  hardware.graphics = {
    enable = true;
  };
  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
