{ config, pkgs, ... }:

{
  # Enable udisks2 for mounting disks
  services.udisks2 = {
    enable = true;
    settings = {
      "udisks2.conf" = {
        defaults = {
          ntfs_driver = "ntfs3";
        };
      };
      "mount_options.conf" = {
        # Using specific sections instead of just [defaults] for better compatibility
        ntfs = {
          defaults = "noatime,force";
          allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard";
        };
        ntfs3 = {
          defaults = "noatime,force";
          allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard";
        };
        # Keeping [defaults] as a fallback
        defaults = {
          ntfs_defaults = "noatime,force";
          ntfs_allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard";
          ntfs3_defaults = "noatime,force";
          ntfs3_allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard";
        };
      };
    };
  };

  # Enable GVfs for MTP (Android) and other userspace filesystems
  services.gvfs.enable = true;

  # Enable usbmuxd for iOS devices
  services.usbmuxd.enable = true;

  # Enable periodic fstrim for SSD life and performance
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Filesystem support
  # ntfs3 is the native kernel driver, ntfs (usually ntfs-3g) is the fuse one
  boot.supportedFilesystems = [
    "ntfs"
    "ntfs3"
  ];

  # System packages for iOS/Android mounting and NTFS utilities
  environment.systemPackages = with pkgs; [
    ifuse # for mounting iOS devices
    libimobiledevice # for iOS communication
    ntfs3g # provides ntfsfix and other utilities
  ];
}
