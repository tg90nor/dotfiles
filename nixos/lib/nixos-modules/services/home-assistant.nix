{ config, lib, pkgs, ... }:

{
  users.users.homeassistant = {
    isNormalUser = true;
    group = "homeassistant";
    extraGroups = [ "dialout" ];
    home = "/var/lib/homeassistant";
  };

  users.groups.homeassistant = {};

  systemd.services.homeassistant = {
    description = "Home Assistant";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      TZ = "Europe/Oslo";
    };
    serviceConfig = {
      Type = "forking";
      User = "homeassistant";
      Group = "homeassistant";
      ExecStartPre = "${pkgs.podman}/bin/podman rm -f homeassistant || true";
      ExecStart = "${pkgs.podman}/bin/podman run --detach --network host --device /dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_5c3942dab64bef11ac6cc2a079f42d1b-if00-port0:/dev/ttyUSB0 -v /var/lib/homeassistant/config:/config --hostname homeassistant --name homeassistant ghcr.io/home-assistant/home-assistant:stable";
      ExecStop = "${pkgs.podman}/bin/podman stop homeassistant";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
