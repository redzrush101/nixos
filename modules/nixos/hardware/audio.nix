{ config, pkgs, ... }:

{

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

  environment.systemPackages = with pkgs; [
    pavucontrol
    rnnoise-plugin
    deepfilternet
    alsa-plugins # For fallback
  ];
}
