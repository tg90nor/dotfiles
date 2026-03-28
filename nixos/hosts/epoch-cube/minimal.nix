{ config, lib, pkgs, ... }:

{
  imports = [
    ../../lib/nixos-modules/common.nix
    ../../lib/nixos-modules/services/ssh.nix
  ];

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

  system.stateVersion = "24.11";
}
