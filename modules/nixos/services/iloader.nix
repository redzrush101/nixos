{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.iloader;
in {
  options.services.iloader = {
    enable = mkEnableOption "iloader, a user-friendly iOS sideloader";
    
    package = mkOption {
      type = types.package;
      default = pkgs.iloader;
      description = "The iloader package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    
    # iloader requires usbmuxd to communicate with iOS devices
    services.usbmuxd.enable = true;

    # Ensure necessary libraries are available (most are handled by autoPatchelf in the package)
    # but some might need system-wide presence or udev rules if needed.
    # usbmuxd handles the udev rules for iOS devices.
  };
}
