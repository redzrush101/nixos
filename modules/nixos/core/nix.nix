{ pkgs, ... }:

{
  # Switch to Lix
  nix.package = pkgs.lixPackageSets.stable.lix;

  nix.settings = {
    # Enable flakes
    experimental-features = [ "nix-command" "flakes" ];

    # Auto-optimise store
    auto-optimise-store = true;
    
    # Binary caches
    substituters = [
      "https://cache.nixos.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPSQPHZdBs8CIs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # Automatic store optimization
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Run daily at 03:45

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Lix overlay for tools
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable) nix-direnv;
    })
  ];
}
