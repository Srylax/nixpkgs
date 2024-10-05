{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage rec {
  pname = "yeet-agent";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Srylax";
    repo = "yeet";
    rev = "2c31a37f24e45aa687b1e5fb828f22449f70cfdc";
    hash = "sha256-4wTVXIUDhPpjnfutB3QQGWZtvnfagovSsV321/VAiXM=";
  };

  buildAndTestSubdir = "yeet-agent";

  cargoHash = "sha256-N8d8NBsoqemXZoFsdg6AtZRUMSOOv0yqDpGB2bOcTzI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        SystemConfiguration
        CoreServices
        Cocoa
      ]
    ) ++ lib.optionals stdenv.isLinux [
      dbus
    ];

  meta = {
    description = "A pull-based nix-flake deployment tool.";
    homepage = "https://github.com/Srylax/yeet";
    platforms = lib.platforms.all;
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ Srylax ];
  };
}
