#
# This file defines overlays/custom modifications to upstream packages
#

{ inputs, ... }:

let
  additions =
    final: prev:
    (prev.lib.packagesFromDirectoryRecursive {
      callPackage = prev.lib.callPackageWith final;
      directory = ../pkgs/common;
    });
  linuxModifications = final: prev: prev.lib.mkIf final.stdenv.isLinux { };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
    #    flameshot = prev.flameshot.overrideAttrs {
    #      cmakeFlags = [
    #        (prev.lib.cmakeBool "USE_WAYLAND_GRIM" true)
    #        (prev.lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
    #      ];
    #    };

    devpod = prev.devpod.overrideAttrs (old: {
        version = "0.6.12"; # Replace with the desired version
        src = prev.fetchFromGitHub {
          owner = "Ow1Dev";
          repo = "devpod";
          rev = "1e063c6cc97f70c76cbd03fc1fd11b4eea303a15";
          sha256 = "sha256-ux4tZ9qoH1rvcQoWFFb714+TQi5+KTi8hKH7F8eKx5I=";
        };

        ldflags = [
            "-X github.com/loft-sh/devpod/pkg/version.version=v0.6.12"
        ];
    });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      #      overlays = [
      #     ];
    };
  };

in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
