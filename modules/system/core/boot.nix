{...}: {
  flake.nixosModules.bootloader = {pkgs, ...}: {
    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
        };
        systemd-boot.enable = true;
      };
      kernelPackages = pkgs.linuxPackages_latest;
    };
  };
}
