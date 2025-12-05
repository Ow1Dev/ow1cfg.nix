{
  imports = [
    ./hardware-configuration.nix
    ./../../systems
  ];

  programs.firefox.enable = true;
  programs.localsend.enable = true;

  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  networking.hostName = "nestop"; # Define your hostname.
}
