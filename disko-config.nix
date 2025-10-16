{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdx";
        content = {
          type = "gpt";
          partitions = {
            # MBR (Master Boot Record) partition for GRUB.
            #boot = {
            #  start = "0M";
            #  size = "1M";
            #  type = "EF02";
            #};
            # ESP (EFI System Partition).
            ESP = {
              start = "1M";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # ZFS Partition
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      zpool = {
        type = "zpool";
        postCreateHook = "zfs snapshot zpool/root@blank";
        preMountHook = "zfs rollback -r zpool/root@blank";
        datasets = {
          "root/" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "false";
          };
          "nix/" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
          "persistence/" = {
            type = "zfs_fs";
            mountpoint = "/persistence";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}