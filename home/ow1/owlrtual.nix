{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/desktops # default is niri
    common/optional/browsers/zen.nix # default is niri
  ];
}
