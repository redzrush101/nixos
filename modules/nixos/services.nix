{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ===== NETWORKING =====
  # Networking via systemd-networkd + IWD
  networking.networkmanager.enable = false;

  networking.wireless.iwd = {
    enable = true;
    settings.Network.EnableNetworkConfiguration = true;
  };

  systemd.network.enable = true;
  networking.useNetworkd = true;

  systemd.network.networks = {
    "10-wired" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };
    "20-wireless" = {
      matchConfig.Name = "wl*";
      networkConfig.DHCP = "yes";
      networkConfig.IgnoreCarrierLoss = "3s";
    };
  };

  services.resolved.enable = true;

  # ===== VIRTUALISATION =====
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = [ pkgs.fuse-overlayfs ];
    };
    containers = {
      enable = true;
      registries.search = [ "docker.io" ];
      policy = {
        default = [ { type = "insecureAcceptAnything"; } ];
      };
      containersConf.settings = {
        containers = {
          cgroup_manager = "systemd";
        };
        engine = {
          cgroup_manager = "systemd";
        };
      };
      storage.settings = {
        storage = {
          driver = "overlay";
          runroot = "/run/user/1000/containers";
          graphroot = "/home/yassin/.local/share/containers/storage";
        };
      };
    };
  };

  # Fix for rootless podman: "/" is not a shared mount
  systemd.services.podman-shared-mount = {
    description = "Make / shared for Podman";
    before = [ "podman.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/mount --make-rshared /";
      RemainAfterExit = true;
    };
  };

  # Distrobox
  environment.systemPackages = [ pkgs.distrobox ];

  # Expose Nix Profile to Distrobox
  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro"
  '';

  # Enable cgroup delegation for rootless containers
  systemd.services."user@1000" = {
    overrideStrategy = "asDropin";
    serviceConfig.Delegate = "memory pids cpu cpuset";
  };
}
