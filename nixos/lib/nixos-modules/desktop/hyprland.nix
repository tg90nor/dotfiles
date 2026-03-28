{ config, lib, pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
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
}
