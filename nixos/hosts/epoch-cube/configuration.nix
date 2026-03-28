{ config, lib, pkgs, ... }:

{
  networking.hostName = "epoch-cube";
  networking.wireless = {
    enable = true;
    networks."beamish".psk = "ostepop1990!#";
  };
  networking.useDHCP = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "btrfs";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    operation = "boot";
    dates = "weekly";
  };
}
