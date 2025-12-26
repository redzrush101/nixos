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
          defaults = "noatime,prealloc,windows_names,nocase";
          allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase";
        };
        ntfs3 = {
          defaults = "noatime,prealloc,windows_names,nocase";
          allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase";
        };
        # Keeping [defaults] as a fallback
        defaults = {
          ntfs_defaults = "noatime,prealloc,windows_names,nocase";
          ntfs_allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase";
          ntfs3_defaults = "noatime,prealloc,windows_names,nocase";
          ntfs3_allow = "uid=$UID,gid=$GID,noatime,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase";
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
