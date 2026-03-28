# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig.pipewire = {
        "50-clock-quantum" = { # Give the file a name.
          "context.properties" = {
            "clock.force-quantum" = 2048;
          };
        };
      };
    };
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };
    };
    desktopManager.plasma6.enable = true;
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
    journald.extraConfig = ''
      SystemMaxUse=1G
      SystemKeepFree=100M
      MaxRetentionSec=7days
    '';
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="231d", ATTR{idProduct}=="0126", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="231d", ATTR{idProduct}=="0127", MODE="0666"
    '';
    unbound = {
      enable = true;
      settings = {
        remote-control = {
          control-enable = true;
        };
        server = {
          # Listen on the standard loopback address
          interface = "127.0.0.1";
          port = 53;
          # Other security/caching options...
          do-ip4 = true;
          do-ip6 = true;
          prefetch = true;
        };
        forward-zone = {
          name = "."; # Forward all traffic
          forward-addr = [
            "1.1.1.1@853#one.one.one.one"
            "1.0.0.1@853#one.one.one.one"
          ];
          forward-ssl-upstream = true;
        };
      };
    };
  };

  networking.nameservers = [ "127.0.0.1" ];

  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.podman = {
    enable = true;
  };

  virtualisation.spiceUSBRedirection.enable = true;

  users.users.glitterhoof = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "wireshark" ];
    shell = pkgs.zsh;
  };

  programs = {
    appgate-sdp.enable = true;
    appimage = {
      enable = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.icu ];
      };
    };
    kdeconnect = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-pipewire-audio-capture
	      obs-studio-plugins.obs-vkcapture
      ];
    };
    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 5000;
      newSession = true;
      keyMode = "vi";
      escapeTime = 20;
      clock24 = true;
      extraConfig = ''
        set-option -g default-shell $SHELL
        set-option -g allow-rename on
        set -g terminal-overrides ',xterm:Tc,xterm*:Tc'
        set -g prefix C-a
        unbind-key C-b
        bind-key C-a send-prefix
        set -g mouse on
        bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
      '';
    };
    wireshark = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    android-tools
    cargo
    dig
    evtest
    file
    gcc
    git
    jq
    kdePackages.qtimageformats
    keybase-gui
    libguestfs-with-appliance
    lsof
    pciutils
    psmisc
    qbittorrent
    qemu-utils
    qt6Packages.qt6ct
    quickemu
    ripgrep
    rust-analyzer
    rustc
    strawberry
    unstable.opencode
    unzip
    usbutils
    v4l-utils
    virtualgl
    wget
    whois
  ];

  environment.shells = with pkgs; [ zsh ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  networking.extraHosts =
    ''
      127.0.0.3 supervisor.ext-twitch.tv
      140.82.121.5 api.github.com
    '';

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];

  hardware.keyboard.qmk.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  system.autoUpgrade = {
    enable = true;
    allowReboot = false; # This is the key: it won't force a restart
    operation = "boot";  # It will prepare the next boot, not 'switch' now
    dates = "weekly";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}

