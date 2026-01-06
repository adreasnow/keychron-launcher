{
  fetchFromGitHub,
  lib,
  npm,
  stdenv,
}:
let
  pname = "keychron-launcher";
  appName = "Keychron Launcher";
  version = "2026.1.0";
  meta = {
    description = "Keychron Launcher electron app";
    maintainers = with lib.maintainers; [
      adreasnow
    ];
  };

  src = fetchFromGitHub {
    owner = "adreasnow";
    repo = "keychron-launcher";
    tag = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAA";
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      ;
    meta = meta // {
      platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };

    buildPhase = ''
      runHook preBuild
      ${pkg.npm}
      
      codesign --force --deep --sign - Keychron\ Launcher.app
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      cp -r "Keychron Launcher.app" "$out/Applications/"
      runHook postInstall
    '';
  };
in
darwin
