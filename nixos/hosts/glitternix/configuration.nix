{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services.hyprland = {
    enable = true;
    greetd = false;
  };

  networking.hostName = "glitternix";

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };

    mullvad-vpn = {
      enable = true;
    };

    ollama = {
      enable = true;
      host = "0.0.0.0";
    };

    keybase = {
      enable = true;
    };

    kbfs = {
      enable = true;
    };

    unbound = {
      enable = true;
      settings = {
        remote-control = {
          control-enable = true;
        };
        server = {
          interface = "127.0.0.1";
          port = 53;
          do-ip4 = true;
          do-ip6 = true;
          prefetch = true;
        };
        forward-zone = {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#one.one.one.one"
            "1.0.0.1@853#one.one.one.one"
          ];
          forward-ssl-upstream = true;
        };
      };
    };

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="231d", ATTR{idProduct}=="0126", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="231d", ATTR{idProduct}=="0127", MODE="0666"
    '';
  };

  networking.nameservers = [ "127.0.0.1" ];

  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.podman.enable = true;

  users.users.glitterhoof = {
    extraGroups = [ "wheel" "input" "wireshark" ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGhY7D80nkb4ZkkExrw7VvX6TZgh+SQvx9PDyLsa3PzoAAAAEXNzaDpyZXNpZGVudC1ldmls ssh:resident-evil"
    ];
  };

  programs = {
    appgate-sdp.enable = true;
    appimage = {
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.icu ];
      };
    };

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-pipewire-audio-capture
        obs-studio-plugins.obs-vkcapture
      ];
    };

    wireshark = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    android-tools
    cargo
    evtest
    gcc
    libguestfs-with-appliance
    qbittorrent
    qemu-utils
    quickemu
    ripgrep
    rust-analyzer
    rustc
    shadow
    strawberry
    pkgs-unstable.opencode
    usbutils
    v4l-utils
    virtualgl
  ];

  networking.extraHosts =
    ''
      127.0.0.3 supervisor.ext-twitch.tv
      140.82.121.5 api.github.com
    '';

  networking.firewall.allowedTCPPorts = [ 11434 ];

  hardware.keyboard.qmk.enable = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    operation = "boot";
    dates = "weekly";
  };
}
