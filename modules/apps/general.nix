{ pkgs, ... }:
{
  flake.modules.nixos."apps/general" = { pkgs, ... }: {
    my-nixos.packages = {
      # Archive
      inherit (pkgs) rar unrar unzip wget zip;

      # Security
      inherit (pkgs) age sops ssh-to-age;

      # Video
      inherit (pkgs) yt-dlp;

      # System
      inherit (pkgs) btop efibootmgr fastfetch rclone rsync;
    };
  };

  flake.modules.homeManager."apps/general" = { pkgs, ... }: {
    my-nixos.homePackages = {
      inherit (pkgs) picard feishin opus-tools lrcget imagemagick yt-dlp
        android-tools qbittorrent libreoffice-qt6-fresh keepassxc komikku;
    };
  };
}
