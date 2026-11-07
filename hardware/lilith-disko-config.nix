{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_50026B7785D222F5";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    # nodatacow não é definido por mount option: opções de mount
                    # do btrfs são filesystem-wide e só valem do primeiro
                    # subvolume montado (@). Onde importa, o NOCOW é aplicado
                    # por arquivo/diretório: swapfile via mkswapfile (NixOS) e
                    # @images via chattr +C (virtualization/virt-manager).
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "@containers" = {
                      mountpoint = "/var/lib/containers";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                    "@images" = {
                      mountpoint = "/var/lib/libvirt/images";
                      mountOptions = [
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
