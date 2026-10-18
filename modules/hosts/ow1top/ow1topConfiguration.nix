{...}: {
  flake.nixosModules.ow1topConfiguration = {...}: {
    networking = {
      hostName = "Ow1Top";
    };
  };
}
