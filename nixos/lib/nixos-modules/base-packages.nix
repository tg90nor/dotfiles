{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bind
    coreutils
    file
    git
    jq
    lsof
    pciutils
    psmisc
    unzip
    wget
    whois
    zsh
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      historyLimit = 5000;
      newSession = true;
      keyMode = "vi";
      escapeTime = 20;
      clock24 = true;
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

    zsh.enable = true;
  };
}
