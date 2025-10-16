# NixOS Installation Guide

This guide contains all the steps for a reproducible NixOS installation.

In particular, this guide refers to NixOS 24.11 (Vicuna).

## Preparation

1. Download the minimal ISO image of the latest NixOS distro from the [official link](https://nixos.org/download/#download-nixos)
or an older version from [here](https://releases.nixos.org/?prefix=nixos) 
https://github.com/nix-community/nixos-images

instead.

2. Create a bootable USB drive that will be used for installation
Installation with minimal installer.

3. Boot into the nixos minimal installer.

## Installation

1. (Optional) Switch keyboard layout to your preferred one (in my case it's Italian)

> $ sudo loadkeys it

2. Open a shell as root and navigate to the `/root` directory

> $ sudo -s \
> $ cd /

1. (Optional) WIFI
> $ ifconfig # to check the NIC \
> $ wpa_passphrase "\$YOUR_SSID" "\$YOUR_PASSWORD" > /tmp/wpa_supplicant.conf \
> $ wpa_supplicant -B -i interface_name -c /tmp/wpa_supplicant.conf

## NOT WORKING Config ssh tunnell for easier install (optional)

> $ ssh -V \
> $ nix-env -iA nixpkgs.openssh \
> $ sudo nano /etc/ssh/sshd_config \


PasswordAuthentication yes
PermitRootLogin yes

// default: PubkeyAuthentication no
// default: ListenAddress 0.0.0.0
// ERROR: READ ONLY FILESISTEM

> $ systemctl restart sshd

Login as root with no password

## Install Disko

Source - https://nixos.asia/en/nixos-install-disko

Identify wether the system is UEFI or BIOS (legacy) by checking if `/sys/firmware/efi` exists means system uses UEFI.

Identify the disk where to install the system by using `fdisk -l` and `lsblk`.

1. Retrieve the disk configuration to a temporary location, calling it "disko-config.nix" (we will use it later):

// TODO SOSTITUIRE CON IL DISKO.NIX DI QUESTO PROGETTO  
> $ curl https://raw.githubusercontent.com/iamryusei/nixos-config/refs/heads/master/disko-config.nix -o /tmp/disko-config.nix

NANO and change /dev/sdx to target disk

> $ nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disko-config.nix

check if everything is ok with `df -h` `zfs list` `zpool list` `zfs list -t snapshot`should see zroot/root mounted on /mnt, and other ...

// For BIOS/MBR:
// create a /dev/sda/sd1 partition as 1GB 
// swap 16 GB
// then the rest main partition

Generate initial NixOS configuration 
With the disk partitioned, we are ready to follow the usual NixOS installation process. The first step is to generate the initial NixOS configuration under /mnt.

Before I even mount it, I create a snapshot while it is totally blank:

> $  zfs snapshot zroot/root@blank

> $ nixos-generate-config --no-filesystems --root /mnt \
> $ mv /tmp/disko-config.nix /mnt/etc/nixos \
> $ curl https://raw.githubusercontent.com/IamRyusei/nixos-config/refs/heads/master/flake.nix -o /mnt/etc/nixos/flake.nix \
> $ curl https://raw.githubusercontent.com/IamRyusei/nixos-config/refs/heads/master/configuration.nix -o /mnt/etc/nixos/configuration.nix \
> $ cd /mnt/etc/nixos

1. Move the disko-config.nix to the flake directory:

mv /tmp/disko-config.nix /mnt/etc/nixos

5. Let’s check that our final configuration is correct by using nix repl. In particular, we test the fileSystems set by disko:

# First, create a flake.lock
cd /mnt/etc/nixos
sudo nix --experimental-features "nix-command flakes" flake lock

// # Start repl
// nix --experimental-features "nix-command flakes" repl

sudo nixos-install --root /mnt --flake '/mnt/etc/nixos#nixos'
# NOTE: You will be prompted to set the root password at this point.
sudo reboot



set networking.hostId to value of -> head -c 8 /etc/machine-id

boot.loader.grub.device = "nodev";
# boot.loader.efi.efiSysMountPoint = "/boot/efi";





## config
```
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

  services.logind.lidSwitchExternalPower = "ignore"; # Prevent sleep when lid is closing

  services.openssh.enable = true;

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
```