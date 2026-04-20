{ config, lib, pkgs, ... }:

let
  cfg = config.services.hyprland;
in

{
  options.services.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment";
    greetd = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable greetd with tuigreet (disable if using SDDM)";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
      };

      greetd = lib.mkIf cfg.greetd {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
            user = "greeter";
          };
        };
      };
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      xdg-utils
      dunst
      mako
      wayland
      wofi
      brightnessctl
      playerctl
    ];
  };
}
