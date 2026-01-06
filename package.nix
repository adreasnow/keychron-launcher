{
  fetchFromGitHub,
  lib,
  pkgs,
  stdenv,
}:
let
  pname = "keychron-launcher";
  appName = "Keychron Launcher";
  version = "2026.1.1";
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
    hash = "sha256-c3uBZeBb0Zo+QQhxVcMPFMe2hIkiA3lnOyaR1T0qZM8=";
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

    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.cacert
      pkgs.nodejs
    ];

    buildPhase = ''
      set -x

      export HOME=$TMPDIR
      export npm_config_cache=$TMPDIR/.npm
      export NODE_EXTRA_CA_CERTS=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt

      npx nativefier \
      --name "${appName}" \
      --electron-version 39.2.7 \
      --browserwindow-options '{"webPreferences":{"experimentalFeatures":true}}' \
      --icon icon.icns \
      --fast-quit \
      --honest \
      --enable-features=WebHID \
      --disable-dev-tools \
      "https://launcher.keychron.com"

      rm -rf "${appName}-darwin-arm64/${appName}.app/Contents/Resources/app"
      mv app "${appName}-darwin-arm64/${appName}.app/Contents/Resources/app"
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      cp -r "${appName}-darwin-arm64/${appName}.app" "$out/Applications/"
      runHook postInstall
    '';
  };
in
darwin
