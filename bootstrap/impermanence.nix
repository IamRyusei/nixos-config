# https://nixos.wiki/wiki/Impermanence
{ config, pkgs, ... }:
#let
#  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
#in 
{
  #imports = [ "${impermanence}/nixos.nix" ];

  environment.persistence."/persistence" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/home"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/etc/NetworkManager/system-connections"
      #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      #{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
}