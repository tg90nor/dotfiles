{ config, lib, pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      extraConfig.pipewire = {
        "50-clock-quantum" = {
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
  };

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.qtimageformats
    qt6Packages.qt6ct
  ];
}
