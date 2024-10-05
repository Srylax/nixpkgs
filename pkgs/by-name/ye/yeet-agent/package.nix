{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "yeet-agent";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Srylax";
    repo = "yeet";
    rev = "bad6d06eb8ac456ea3cb0de17c3ed3fa9efb1f6d";
    hash = "sha256-Vp70MPOk1yueeWdOBauzLT0bjhMWAxwdQFq2oXTo03g=";
  };

  buildAndTestSubdir = "yeet-agent";

  cargoHash = "sha256-OIKd6HgdAkhzj5vM20fXLFWvCQttBTbV7vIQ0a3mBIw=";

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
    );

  meta = {
    description = "A pull-based nix-flake deployment tool.";
    homepage = "https://github.com/Srylax/yeet";
    platforms = lib.platforms.all;
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ Srylax ];
  };
}
