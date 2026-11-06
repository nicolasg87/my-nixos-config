{ ... }:
{
  flake.modules.nixos."system/disk-health" = { ... }: {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    services.smartd = {
      enable = true;
      defaults.autodetect = true;
      notifications.wall.enable = true;
    };
  };
}
