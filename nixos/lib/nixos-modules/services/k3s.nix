{ config, lib, pkgs, ... }:

{
  services.k3s = {
    enable = true;
    package = pkgs.k3s;
    # Token can be set here or left empty for single-node setup
    # tokenFile = "/var/lib/rancher/k3s/server/agent-token";
  };
}
