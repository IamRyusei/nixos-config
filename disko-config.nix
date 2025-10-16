{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdx";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        #mode = "mirror";
        # Workaround: cannot import 'zroot': I/O error in disko tests
        #options.cachefile = "none";
        #rootFsOptions = {
        #  compression = "zstd";
        #  "com.sun:auto-snapshot" = "false";
        #};
        #mountpoint = "/";
        # postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
          };
          home = {
            type = "zfs_fs";
	          options.mountpoint = "legacy";
            mountpoint = "/home";
          };
        };
      };
    };
  };
}