{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Version of NixOS channel (DO NOT MODIFY!)
  system.stateVersion = "24.11";
  
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # System time zone.
  time.timeZone = "Europe/Rome";

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Services
  services.openssh.enable = true;


  services.logind.lidSwitchExternalPower = "ignore"; # Prevent sleep when lid is closing

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
#  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
 # networking.wireless.networks."Vodafone-GottaGoFaster" = {
 #   #
#
#  }
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  #  useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
#  services = {
 #   displayManager.sddm.enable = true;
 #   xserver = {
 #     enable = true;
 #     desktopManager.lxqt.enable = true;
 #   };
 # };



  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;


  # Users definition
  users.users = {
    leonard0 = {
      isNormalUser = true;
      description = "Leonardo Spaccini";
      extraGroups = [ "wheel"]; ####, "docker" ];
      password = "spacc1";
    };
  };

  # Docker
  # (see: https://nixos.wiki/wiki/Docker )
#  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
##  virtualisation.docker.daemon.settings = {
#  data-root = "/some-place/to-store-the-docker-data";
#  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    neofetch
  ];

  # Git configuration
  # (see: https://nixos.wiki/wiki/Git )
#  programs.git = {
#    enable = true;
##    userName = "Leonardo Spaccini";
#    userEmail = "leonardo.spaccini.gtr@gmail.com";
#    config = {

#      init = {
#        defaultBranch = "master";
#      };
#    };
#  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}