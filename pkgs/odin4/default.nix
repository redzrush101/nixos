{
  stdenv,
  autoPatchelfHook,
  libusb1,
  glibc,
  zlib,
  ...
}:

stdenv.mkDerivation {
  pname = "odin4";
  version = "4.0"; # Approximate version based on filename

  src = ../../odin;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libusb1
    zlib
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    install -Dm755 odin4 $out/bin/odin4
  '';

  meta = {
    description = "Samsung Odin4 Flash Tool";
    mainProgram = "odin4";
    platforms = [ "x86_64-linux" ];
  };
}
