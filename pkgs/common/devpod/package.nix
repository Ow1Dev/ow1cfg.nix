{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "devpod";
  version = "1e063c6"; # Use a short commit hash for clarity in the package name
  commit = "1e063c6cc97f70c76cbd03fc1fd11b4eea303a15";
  meta = with lib; {
    description = "Codespaces but open-source, client-only and unopinionated: Works with any IDE and lets you use any cloud, kubernetes or just localhost docker";
    mainProgram = "devpod";
    homepage = "https://devpod.sh";
    license = licenses.mpl20;
    maintainers = with maintainers; [ maxbrunet ];
  };
in
buildGoModule {
  inherit pname meta version;

  src = fetchFromGitHub {
    owner = "Ow1Dev";
    repo = pname;
    rev = commit;
    sha256 = "sha256-8LbqrOKC1als3Xm6ZuU2AySwT0UWjLN2xh+/CvioYew=";
  };

  vendorHash = null;
  env.CGO_ENABLED = 0;
        
  ldflags = [
      "-X github.com/Ow1Dev/devpod/pkg/version.version=${commit}"
  ];

  excludedPackages = [ "./e2e" ];

  postInstall = ''
      $out/bin/devpod completion bash >devpod.bash
      $out/bin/devpod completion fish >devpod.fish
      $out/bin/devpod completion zsh >devpod.zsh
      installShellCompletion devpod.{bash,fish,zsh}
  '';
}
