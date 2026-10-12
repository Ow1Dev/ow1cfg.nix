{ ... }: {
  perSystem = {inputs', ...}: {
    packages.nvim = inputs'.nvim.packages.default;
  };
}
