{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.glitterhoof = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGhY7D80nkb4ZkkExrw7VvX6TZgh+SQvx9PDyLsa3PzoAAAAEXNzaDpyZXNpZGVudC1ldmls ssh:resident-evil"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = [ "root" "@wheel" ];
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=1G
    SystemKeepFree=100M
    MaxRetentionSec=7days
  '';

  environment.shells = with pkgs; [ zsh ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  system.stateVersion = "24.11";
}
