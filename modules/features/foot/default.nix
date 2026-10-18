{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.foot = moduleWithSystem (
    {
      self',
      pkgs,
    }: {
      environment.systemPackages = with self'.packages; [
        foot
      ];

      fonts.packages = [
        pkgs.nerd-fonts.fira-mono
      ];
    }
  );
  perSystem = {pkgs, ...}: let
    color = hex: builtins.replaceStrings ["#"] [""] hex;
  in {
    packages.foot = inputs.wrappers.wrappers.foot.wrap {
      inherit pkgs;

      settings.main = {
        font = "FiraMono Nerd Font Mono:size=11";
      };

      settings.colors-dark = {
        cursor = "${color "#2e3440"} ${color "#eceff4"}";
        foreground = color "#eceff4";
        background = color "#2e3440";

        regular0 = color "#3b4252";
        regular1 = color "#bf616a";
        regular2 = color "#a3be8c";
        regular3 = color "#ebcb8b";
        regular4 = color "#81a1c1";
        regular5 = color "#b48ead";
        regular6 = color "#88c0d0";
        regular7 = color "#e5e9f0";

        bright0 = color "#4c566a";
        bright1 = color "#bf616a";
        bright2 = color "#a3be8c";
        bright3 = color "#ebcb8b";
        bright4 = color "#81a1c1";
        bright5 = color "#b48ead";
        bright6 = color "#8fbcbb";
        bright7 = color "#eceff4";

        "16" = color "#d08770";
        "17" = color "#5e81ac";

        selection-foreground = color "#eceff4";
        selection-background = color "#434c5e";

        search-box-no-match = "${color "#2e3440"} ${color "#bf616a"}";
        search-box-match = "${color "#eceff4"} ${color "#3b4252"}";

        jump-labels = "${color "#2e3440"} ${color "#ebcb8b"}";
        urls = color "#88c0d0";
      };
    };
  };
}
