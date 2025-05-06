{
  fetchFromGitHub,
  buildGoModule,
  stdenvNoCC,
  pnpm,
  nodejs,
  lib,
}: let
  version = "0.24.3";
  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "2a92baf52c8f2e27c5fa4ad98a8b095b50b43601";
    hash = "sha256-7lTRCTOXOPmv4DMA+mGqGr9FoRZRZ8Kgb+S57QmfqNw=";
  };

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "memos-web";
    inherit version src;
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      hash = "sha256-ooiH13yzMTCSqzmZVvVy2jWoIfJecMlE6JkwcG5EV5k=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm -C web exec vite build --mode release --outDir=$out --emptyOutDir
      runHook postBuild
    '';
    pnpmRoot = "web";
    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];
  });
in
  buildGoModule {
    pname = "memos";
    inherit version src;

    vendorHash = "sha256-SWpnsTdti3hD1alvItpXllTJHGxeKP8q7WD2nBzFG7o=";

    # Inject frontend assets into go build
    prePatch = ''
      rm -rf server/router/frontend/dist
      cp -r ${frontend} server/router/frontend/dist
    '';

    meta = with lib; {
      homepage = "https://usememos.com";
      description = "Lightweight, self-hosted memo hub";
      maintainers = with maintainers; [
        indexyz
        Srylax
      ];
      license = licenses.mit;
      mainProgram = "memos";
    };
  }
