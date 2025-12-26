{ config, pkgs, ... }:

{
  # Enable udisks2 for mounting disks
  services.udisks2 = {
    enable = true;
    settings = {
    };
  };

  # Ensure udisks2 mount options are written to the correct file
  environment.etc."udisks2/mount_options.conf".text = ''
    [defaults]
    # For ntfs3 driver
    ntfs:ntfs3_defaults=uid=$UID,gid=$GID,noatime,noexec,prealloc,windows_names,nocase,iocharset=utf8
    ntfs:ntfs3_allow=uid=$UID,gid=$GID,noatime,noexec,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase,iocharset=utf8

    # For ntfs-3g driver (as fallback)
    ntfs:ntfs_defaults=uid=$UID,gid=$GID,noatime,noexec,prealloc,windows_names,nocase
    ntfs:ntfs_allow=uid=$UID,gid=$GID,noatime,noexec,force,umask,dmask,fmask,discard,prealloc,windows_names,nocase

    # Generic fallbacks
    ntfs_defaults=uid=$UID,gid=$GID,noatime,noexec,prealloc,windows_names,nocase
    ntfs3_defaults=uid=$UID,gid=$GID,noatime,noexec,prealloc,windows_names,nocase
  '';

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
