{ config, lib, pkgs, ... }:

{
  networking.hostName = "epoch-cube";
  networking.wireless = {
    enable = true;
    networks."beamish".psk = "ostepop1990!#";
  };
  networking.useDHCP = true;

  boot.loader.grub.enable = false;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "btrfs";
  };

  virtualisation.podman.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 6443 8123 ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    operation = "boot";
    dates = "weekly";
  };
}
