{ config, pkgs, pkgs-unstable, ... }:

{
  home.username = "glitterhoof";
  home.homeDirectory = "/home/glitterhoof";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "travis-1.9.1"
  ];
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    awscli2
    binutils
    brave
    btop
    pkgs-unstable.claude-code
    clipboard-jh
    cmake
    corepack
    discord
    distrobox
    dos2unix
    dotnet-sdk
    font-awesome
    gh
    ghostty
    git-secret
    gnumake
    go
    google-chrome
    gopls
    haruna
    imagemagick
    inkscape-with-extensions
    kdotool
    kind
    kubectl
    kubernetes-helm
    nerd-fonts.monaspace
    node2nix
    nodejs
    obs-cli
    openconnect
    pavucontrol
    pipenv
    prismlauncher
    python312Packages.ollama
    python312Packages.pip
    python312Packages.pygls
    python312Packages.python
    python312Packages.setuptools
    qmk
    ruby_3_3
    signal-desktop
    slack
    (symlinkJoin {
      name = "spotify";
      paths = [ spotify ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/spotify \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland"
      '';
    })
    sqlite
    sqlitebrowser
    terraform
    terraform-ls
    travis
    unrar-wrapper
    vault
    vlc
    wl-clipboard
    xdg-utils
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".local/bin/hyprland-keybinds" = { text = ''
      #!/usr/bin/env bash
      hyprctl -j binds | jq -r '.[] | 
        "\(.modmask),\(.key),\(.description // ""),\(.dispatcher),\(.arg // "")"' |
      sed -r \
        -e 's/^0,/,/' \
        -e 's/^1,/SHIFT+/' \
        -e 's/^4,/CTRL+/' \
        -e 's/^5,/SHIFT CTRL+/' \
        -e 's/^8,/ALT+/' \
        -e 's/^9,/SHIFT ALT+/' \
        -e 's/^12,/CTRL ALT+/' \
        -e 's/^64,/SUPER+/' \
        -e 's/^65,/SUPER SHIFT+/' \
        -e 's/^68,/SUPER CTRL+/' \
        -e 's/^69,/SUPER SHIFT CTRL+/' \
        -e 's/^72,/SUPER ALT+/' \
        -e 's/^73,/SUPER SHIFT ALT+/' \
        -e 's/^76,/SUPER CTRL ALT+/' \
        -e 's/^77,/SUPER SHIFT CTRL ALT+/' \
        -e 's/^,/,SUPER+/' \
        -e 's/,([^,]+),/ → \1 /' \
        -e 's/,$//' |
      sort |
      wofi --dmenu -p "Keybindings" --width 600 --height 400
    '';
    executable = true;
  };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/glitterhoof/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}/share/dotnet/";
  };

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 5000;
      newSession = true;
      keyMode = "vi";
      escapeTime = 20;
      clock24 = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.power-theme;
          extraConfig = "set -g @tmux_power_theme 'everforest'";
        }
      ];
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
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    waybar = {
      enable = true;
      settings = {
        main = {
          layer = "top";
          position = "top";
          height = 28;
          modules-left = [ "hyprland/workspaces" "hyprland/window" ];
          modules-center = [ "clock" ];
          modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%A %B %d}";
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 50;
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = {
            "100" = "󰁹";
            "75" = "󰁾";
            "50" = "󰁿";
            "25" = "󰁽";
            "0" = "󰁺";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            "100" = "󰝤";
            "50" = "󰝤";
            "0" = "󰝜";
          };
        };
      };
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font", sans-serif;
          font-size: 13px;
        }
        window#waybar {
          background: rgba(30, 30, 46, 0.9);
          color: #cdd6f4;
        }
        #workspaces button {
          padding: 0 5px;
          color: #cdd6f4;
        }
        #workspaces button.active {
          color: #89b4fa;
        }
        #window {
          color: #a6adc8;
        }
        #clock, #battery, #network, #pulseaudio {
          padding: 0 10px;
        }
        #battery.warning {
          color: #f9e2af;
        }
        #battery.critical {
          color: #f38ba8;
        }
        #tray {
          padding: 0 5px;
        }
      '';
    };
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
    $terminal = ghostty
    $menu = wofi --show drun
    $fileManager = dolphin
    $browser = brave

    monitor = DP-3, 5120x1440@69.97, 0x0, 1.066667

    xwayland {
      force_zero_scaling = true
    }

    exec-once = waybar

    env = DISPLAY,:0
    env = GDK_SCALE,1.1

    input {
      kb_layout = us
      kb_options = compose:ralt
      follow_mouse = 1
      numlock_by_default = true
    }

    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
      col.active_border = rgba(89b4faee) rgba(313244cc) 45deg
      col.inactive_border = rgba(45475aee)
      layout = dwind
    }

    decoration {
      rounding = 5
      blur {
        enabled = true
        size = 3
        passes = 1
      }
      shadow {
        enabled = true
        range = 20
        render_power = 3
      }
    }

    animations {
      enabled = true
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05
      animation = windows, 1, 5, myBezier
      animation = windowsOut, 1, 4, default, popin 80%
    }

    dwindle {
      pseudotile = true
      preserve_split = true
    }

    misc {
      force_default_wallpaper = 0
      disable_hyprland_logo = true
    }

    unbind = , mouse:272
    unbind = , mouse:273

    bind = SUPER, RETURN, exec, $terminal
    bind = SUPER, SPACE, exec, $menu
    bind = SUPER, B, exec, $browser
    bind = SUPER, E, exec, $fileManager
    bind = SUPER, F, fullscreen
    bind = SUPER, J, togglesplit
    bind = SUPER, K, exec, ~/.local/bin/hyprland-keybinds
    bind = SUPER, L, exec, hyprlock
    bind = SUPER, M, exec, hyprshutdown
    bind = SUPER, P, pseudo
    bind = SUPER, Q, killactive
    bind = SUPER, V, togglefloating

    bind = SUPER, TAB, cyclenext
    bind = SUPER SHIFT, TAB, cyclenext, prev

    bind = SUPER ALT, left, movefocus, l
    bind = SUPER ALT, right, movefocus, r
    bind = SUPER ALT, up, movefocus, u
    bind = SUPER ALT, down, movefocus, d

    bind = SUPER SHIFT, left, movewindow, l
    bind = SUPER SHIFT, right, movewindow, r
    bind = SUPER SHIFT, up, movewindow, u
    bind = SUPER SHIFT, down, movewindow, d

    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    bind = SUPER SHIFT, 1, movetoworkspace, 1
    bind = SUPER SHIFT, 2, movetoworkspace, 2
    bind = SUPER SHIFT, 3, movetoworkspace, 3
    bind = SUPER SHIFT, 4, movetoworkspace, 4
    bind = SUPER SHIFT, 5, movetoworkspace, 5
    bind = SUPER SHIFT, 6, movetoworkspace, 6
    bind = SUPER SHIFT, 7, movetoworkspace, 7
    bind = SUPER SHIFT, 8, movetoworkspace, 8
    bind = SUPER SHIFT, 9, movetoworkspace, 9
    bind = SUPER SHIFT, 0, movetoworkspace, 10

    bind = SUPER CTRL, left, workspace, -1
    bind = SUPER CTRL, right, workspace, +1

    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = SUPER, Print, exec, grim - | wl-copy

    bind = SUPER, bracketleft, exec, brightnessctl -s set 5%-
    bind = SUPER, bracketright, exec, brightnessctl -s set 5%+

    binde =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
    binde =, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
    bind = SUPER, equal, exec, playerctl next
    bind = SUPER, minus, exec, playerctl previous
    bind = SUPER, backslash, exec, playerctl play-pause
  '';
  home.file.".config/zsh/hm_config.zsh" = {
    enable = true; # Make sure this file is created/linked
    text = ''
      # This file is generated by Home Manager. Do not edit directly.

      # Set DOTNET_ROOT
      export DOTNET_ROOT="${pkgs.dotnet-sdk}/share/dotnet/"
      path+="$HOME/.dotnet/tools"
    '';
  };
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 10000; # Time in milliseconds
      background-color = "#282a36";
      text-color = "#f8f8f2";
      border-color = "#44475a";
      border-size = 2;
      border-radius = 5;
    };
    extraConfig = ''
      [urgency=high]
      border-color=#fab387
      default-timeout=0
    '';
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
