{ pkgs }:

pkgs.spotify.overrideAttrs (oldAttrs: {
  postInstall = (oldAttrs.postInstall or "") + ''
    # Wrap spotify with Wayland flags
    wrapProgram $out/bin/spotify \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
  '';
})
