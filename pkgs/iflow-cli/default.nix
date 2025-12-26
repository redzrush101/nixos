{ lib
, stdenv
, fetchurl
, makeWrapper
, bun
, ripgrep
}:

stdenv.mkDerivation rec {
  pname = "iflow-cli";
  version = "0.4.11";

  src = fetchurl {
    url = "https://registry.npmjs.org/@iflow-ai/iflow-cli/-/iflow-cli-${version}.tgz";
    hash = "sha512-seDmhUNHigNrQtfqblfDQYhB+dEFldAef17gTYH8DD9V5eDcdDw8aF8bU3QluPLgPS2SXCzZ8U0EoynD3SdeDA==";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = let
    platformMap = {
      "x86_64-linux" = "x64-linux";
      "aarch64-linux" = "arm64-linux";
      "x86_64-darwin" = "x64-darwin";
      "aarch64-darwin" = "arm64-darwin";
    };
    targetDir = platformMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  in ''
    runHook preInstall

    mkdir -p $out/libexec/iflow-cli
    cp -r . $out/libexec/iflow-cli

    rm -rf $out/libexec/iflow-cli/vendors/ripgrep
    mkdir -p $out/libexec/iflow-cli/vendors/ripgrep/${targetDir}
    ln -s ${ripgrep}/bin/rg $out/libexec/iflow-cli/vendors/ripgrep/${targetDir}/rg

    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bun $out/bin/iflow \
      --add-flags "run $out/libexec/iflow-cli/bundle/iflow.js" \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "iFlow CLI";
    homepage = "https://github.com/iflow-ai/iflow-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "iflow";
    platforms = platforms.all;
  };
}
