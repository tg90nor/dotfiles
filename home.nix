{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "glitterhoof";
  home.homeDirectory = "/home/glitterhoof";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };


  home.packages = with pkgs; [
    (unstable.google-cloud-sdk.withExtraComponents [unstable.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    alacritty
    brave
    clipboard-jh
    discord
    font-awesome
    gh
    go
    google-chrome
    gopls
    haruna
    kubectl
    nerdfonts
    obs-cli
    pavucontrol
    ripgrep
    signal-desktop
    slack
    spotify
    terraform
    terraform-ls
    waybar
    wofi
    xdg-desktop-portal-hyprland
    xdg-utils
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/glitterhoof/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 5000;
      newSession = true;
      keyMode = "vi";
      escapeTime = 20;
      clock24 = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.power-theme;
          extraConfig = "set -g @tmux_power_theme 'everforest'";
        }
      ];
      extraConfig = ''
        set-option -g default-shell $SHELL
        set-option -g allow-rename on
        set -g terminal-overrides ',xterm:Tc,xterm*:Tc'
        set -g prefix C-a
        unbind-key C-b
        bind-key C-a send-prefix
        set -g mouse on
        bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
      '';
    };
  };
}
