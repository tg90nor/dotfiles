{ config, lib, pkgs, ... }:

{
  networking.hostName = "epoch-x1";

  boot.loader.grub.enable = true;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    operation = "boot";
    dates = "weekly";
  };
}
