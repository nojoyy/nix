{
  disko.devices = {
    disk = {
      ssd1 = {
        type = "disk";
        device = "/dev/disk/by-id/96E9742D-D865-41D0-9366-7BC1D156C4B8";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      # ssd2 = {
      #   type = "disk";
      #   device = "";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       boot = {
      
      #       };
      #       primary = {
      #         size = "100%";
      #         content = {
      #           type = "lvm_pv";
      #           vg = "mainpool";
      #         };
      #       };
      #     };
      #   };
      # };
    #   hdd1 = {
    #     type = "disk";
    #     device = "/dev/disk/by-id/C68B1A96-8E88-45C8-8BC4-49FDD1F6C2D2";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         root = {
    #           size = "100%";
    #           content = {
    #             type = "filesystem";
    #             format = "ext4";
    #             mountpoint = "/mnt/tier-two";
    #           };
    #         };
    #       };
    #     };
    #   };
    #   hdd2 = {
    #     type = "disk";
    #     device = "/dev/disk/by-id/E2D4C2E4-296A-4EFF-AC20-3EAF873AB695";
    #     content = {
    #       type = "gpt";
    #       partitions = {
    #         root = {
    #           size = "100%";
    #           content = {
    #             type = "filesystem";
    #             format = "ext4";
    #             mountpoint = "/mnt/tier-one";
    #           };
    #         };
    #       };
    #     };
    #   };
    };
  };
}
