{ ... }:
{
  flake.modules.nixos."system/disk-health" = { ... }: {
    # Scrub mensal: valida checksums e detecta corrupção silenciosa.
    # Subvolumes aninhados do mesmo device são deduplicados pelo módulo,
    # então "/" cobre @, @home, @nix, @swap, @containers e @images.
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    # smartd: monitora o SSD via SMART e avisa em todos os TTYs.
    # autodetect já é o default; explícito para deixar a intenção clara.
    services.smartd = {
      enable = true;
      autodetect = true;
      notifications.wall.enable = true;
    };
  };
}
