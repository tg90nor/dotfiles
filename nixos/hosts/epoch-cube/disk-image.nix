{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../lib/nixos-modules/common.nix
    ../../lib/nixos-modules/base-packages.nix
    ../../lib/nixos-modules/services/ssh.nix
  ];

  networking.hostName = "epoch-cube";
  networking.wireless = {
    enable = true;
    networks."beamish".psk = "ostepop1990!#";
  };
  networking.useDHCP = true;

  boot.loader.grub.enable = lib.mkForce false;

  hardware.enableRedistributableFirmware = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    operation = "boot";
    dates = "weekly";
  };
}
