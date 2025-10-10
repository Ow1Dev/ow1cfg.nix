{
  imports = [
    ./core/boot.nix
    ./core/default.nix

    ./services/gdm.nix

    ./programs

    ./network
    ./nix

    ./hardware/bluetooth.nix
    ./hardware/nvidia.nix
  ];
}
