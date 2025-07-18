# File: /etc/nixos/configuration.nix
# Description:

{ config, lib, pkgs, ... }: 
{
  imports = [ 
    ./hardware-configuration.nix
    ./disko-config.nix
    ./users.nix
  ];

  # System
  system.stateVersion = "24.11"; # DO NOT MODIFY! - Version of NixOS initial installation.

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  # Timezone
  time.timeZone = "Europe/Rome";
  time.hardwareClockInLocalTime = false;
  
  # Networking
  networking.hostName = "nixos-server";

  # Logind
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Console
  console = {
    enable = true;
    earlySetup = false;
    useXkbConfig = false;
    keyMap = "it";
    font = "Lat2-Terminus16";
    colors = [];
    packages = [];  
  };

  # Packages
  environment.systemPackages = with pkgs; [
    gh # GitHub CLI tool 
    git # Distributed version control system
    nano # Small, user-friendly console text editor
  ];

  # OpenSSH
  services.openssh.enable = true;
  services.openssh = {
 #   port = 22;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

}

