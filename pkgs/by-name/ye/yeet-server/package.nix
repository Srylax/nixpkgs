{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "yeet-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Srylax";
    repo = "yeet";
    rev = "269aa0b02a174be11088e2f0c15463b855ba9c0f";
    hash = "sha256-7k5lGMMOlIcjecpmuvCMOhLifT9hLNZRbXQDD7a4MGo=";
  };

  buildAndTestSubdir = "yeet-server";

  cargoHash = "sha256-ic9LTLYrpIou/ixDAdPhq1XljwAg9c2pcGkIWgU/5Zo=";

  meta = {
    description = "A pull-based nix-flake deployment tool.";
    homepage = "https://github.com/Srylax/yeet";
    platforms = lib.platforms.all;
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ Srylax ];
  };
}
