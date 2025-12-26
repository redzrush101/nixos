{ pkgs, ... }:

{
  # Switch to Lix (drop-in replacement for Nix)
  nix.package = pkgs.lixPackageSets.stable.lix;

  # Overlay to ensure other tools use Lix instead of CppNix
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nix-direnv
        ;
    })
  ];
}
