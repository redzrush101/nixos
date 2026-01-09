{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # ===== GRAPHICS =====
  hardware.graphics = {
    enable = true;
  };

  # DBus
  services.dbus.enable = true;

  # Thumbnailer service
  services.tumbler.enable = true;

  # Polkit
  security.polkit.enable = true;

  # Link libexec for polkit agents
  environment.pathsToLink = [ "/libexec" ];

  # Scroll Window Manager
  environment.systemPackages = [
    inputs.scroll-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.kitty # Terminal for initial usage
    pkgs.polkit_gnome
    pkgs.wmenu # Required by xdg-desktop-portal-wlr for output chooser
    # Filesystem utilities
    pkgs.ifuse # for mounting iOS devices
    pkgs.libimobiledevice # for iOS communication
    pkgs.ntfs3g # provides ntfsfix and other utilities
    # Audio utilities
    pkgs.pavucontrol
    pkgs.rnnoise-plugin
    pkgs.deepfilternet
    pkgs.alsa-plugins # For fallback
  ];

  environment.sessionVariables = {
    # Tell QT, GDK and others to use the Wayland backend by default
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # XDG desktop variables to set scroll as the desktop
    XDG_CURRENT_DESKTOP = "scroll";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "scroll";

    # Configure Electron to use Wayland instead of X11
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f '%o' -or";
        };
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
      scroll = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
      };
      sway = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ===== AUDIO =====
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Audio quality
    extraConfig.pipewire."10-quality" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          96000
        ];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 2048;
      };
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -11;
            "rt.prio" = 88;
          };
        }
      ];
    };

    # Resampling settings
    extraConfig.client."10-resample" = {
      "stream.properties" = {
        "resample.quality" = 14;
      };
    };

    # Mic processing
    extraConfig.pipewire."20-input-processing" = {
      "context.modules" = [
        {
          name = "libpipewire-module-echo-cancel";
          args = {
            "capture.props" = {
              "node.name" = "processed-mic-capture";
              "node.description" = "Processed Microphone (Capture Context)";
            };
            "source.props" = {
              "node.name" = "processed-mic";
              "node.description" = "Processed Microphone (WebRTC)";
            };
            "sink.props" = {
              "node.name" = "processed-mic-sink";
              "node.description" = "Echo-Cancellation Helper Sink";
            };
            "library.name" = "aec/libspa-aec-webrtc";
            "aec.args" = {
              "webrtc.gain_control" = true;
              "webrtc.noise_suppression" = true;
              "webrtc.voice_detection" = true;
              "webrtc.extended_filter" = false;
            };
          };
        }
      ];
    };

    # Device rules
    wireplumber.extraConfig."51-hifi-settings" = {
      "monitor.alsa.rules" = [
        # Headphones
        {
          matches = [ { "node.name" = "~alsa_output.pci-0000_09_00.4.*"; } ];
          actions = {
            update-props = {
              "audio.format" = "S32LE";
              "audio.rate" = 48000;
              "api.alsa.period-size" = 1024;
              "api.alsa.headroom" = 1024;
              "session.suspend-timeout-seconds" = 0; # Fix popping
            };
          };
        }
        # Microphone
        {
          matches = [ { "node.name" = "~alsa_input.pci-0000_09_00.4.*"; } ];
          actions = {
            update-props = {
              "audio.format" = "S32LE";
              "audio.rate" = 48000;
              "api.alsa.period-size" = 1024;
              "api.alsa.disable-batch" = true;
            };
          };
        }
      ];
    };
  };

  programs.noisetorch.enable = true;

  # Startup volume
  systemd.user.services.set-mic-volume = {
    description = "Set microphone volume to 50% on startup";
    wantedBy = [ "graphical-session.target" ];
    after = [
      "pipewire.service"
      "wireplumber.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.5";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # ===== DRIVERS =====
  # RTL88x2BU WiFi driver
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
  boot.blacklistedKernelModules = [ "rtw88_8822bu" ];
  boot.extraModprobeConfig = ''
    options 88x2bu rtw_switch_usb_mode=1 rtw_power_mgnt=0 rtw_ips_mode=0 \
      rtw_enusbss=0 rtw_beamforming_enable=0 rtw_vht_enable=2 rtw_stbc_enable=0
  '';

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ===== FILESYSTEMS =====
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
}
