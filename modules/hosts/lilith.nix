{ inputs, ... }:
{
  flake.nixosConfigurations.lilith = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ../../hardware/lilith-hardware-configuration.nix
      ../../hardware/lilith-disko-config.nix
      inputs.disko.nixosModules.disko
      inputs.nixos-hardware.nixosModules.lenovo-ideapad-s145-15api
      inputs.home-manager.nixosModules.home-manager

      # Fase 2 — aspectos de system/
      inputs.self.modules.nixos.base
      inputs.self.modules.nixos."system/secrets"
      inputs.self.modules.nixos."system/shell"
      inputs.self.modules.nixos."system/direnv"
      inputs.self.modules.nixos."system/bluetooth"
      inputs.self.modules.nixos."system/keyboard"
      inputs.self.modules.nixos."system/pipewire"
      inputs.self.modules.nixos."system/zram"
      inputs.self.modules.nixos."system/disk-health"
      inputs.self.modules.nixos."system/fonts"
      inputs.self.modules.nixos."system/nix-ld"
      inputs.self.modules.nixos."system/devenv"
      inputs.self.modules.nixos."system/nh"

      # Fase 3 — aspectos de apps/
      inputs.self.modules.nixos."apps/git"
      inputs.self.modules.nixos."apps/vim"
      inputs.self.modules.nixos."apps/general"
      inputs.self.modules.nixos."apps/emacs"
      inputs.self.modules.nixos."apps/ente-auth"
      inputs.self.modules.nixos."apps/browsers/vivaldi"

      # Fase 4 — aspectos de desktop/ (só os enable = true)
      inputs.self.modules.nixos."desktop/mango"
      #inputs.self.modules.nixos."desktop/umbriel"
      inputs.self.modules.nixos."desktop/noctalia"

      # Fase 5 — aspectos de services/, network/, virtualization/ (só os enable = true)
      inputs.self.modules.nixos."services/flatpak"
      inputs.self.modules.nixos."services/gaming"
      inputs.self.modules.nixos."services/navidrome"
      inputs.self.modules.nixos."services/jellyfin"
      inputs.self.modules.nixos."services/podman"
      inputs.self.modules.nixos."services/docker"
      inputs.self.modules.nixos."services/fhs"
      inputs.self.modules.nixos."network/firewall"
      inputs.self.modules.nixos."network/avahi"
      inputs.self.modules.nixos."virtualization/virt-manager"

      ({ config, pkgs, inputs, ... }:
        {
          nixpkgs.hostPlatform = "x86_64-linux";

          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.systemd-boot.configurationLimit = 10;
          boot.loader.efi.canTouchEfiVariables = true;

          # Sysrq
          boot.kernel.sysctl."kernel.sysrq" = 1;

          networking.hostName = "lilith";

          # Enable networking
          networking.networkmanager.enable = true;

          # Set your time zone.
          time.timeZone = "America/Maceio";

          # Select internationalisation properties.
          i18n.defaultLocale = "pt_BR.UTF-8";

          i18n.extraLocaleSettings = {
            LC_ADDRESS = "pt_BR.UTF-8";
            LC_IDENTIFICATION = "pt_BR.UTF-8";
            LC_MEASUREMENT = "pt_BR.UTF-8";
            LC_MONETARY = "pt_BR.UTF-8";
            LC_NAME = "pt_BR.UTF-8";
            LC_NUMERIC = "pt_BR.UTF-8";
            LC_PAPER = "pt_BR.UTF-8";
            LC_TELEPHONE = "pt_BR.UTF-8";
            LC_TIME = "pt_BR.UTF-8";
          };

          # Configure keymap in X11
          services.xserver = {
            xkb.layout = "br";
            xkb.variant = "abnt2";
          };

          # Configure console keymap
          console.keyMap = "br-abnt2";

          # Enable CUPS to print documents.
          services.printing.enable = true;

          # Define a user account.
          users.users.kim = {
            isNormalUser = true;
            description = "Kim";
            extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
            packages = with pkgs; [
              #  thunderbird
            ];
          };

          # xdg-portals
          xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
          };

          # Tuned
          services.tuned = {
            enable = true;
            ppdSupport = true;
          };

          # Allow unfree packages
          nixpkgs.config.allowUnfree = true;


          # Enable the default ports on firewall.
          services.syncthing.openDefaultPorts = true;

          # Coleta de lixo: responsabilidade do nh-clean (programs.nh.clean) —
          # gerações antigas + GC do store semanal (--keep-since 7d --keep 3).
          nix.settings.auto-optimise-store = true;

          # Habilita opções que ainda são experimentais (mais muito utilizadas) no NixOS
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Enable the OpenSSH daemon.
          services.openssh = {
            enable = true;
            allowSFTP = true;
          };

          system.stateVersion = "24.05";
        })

      # home-manager config (mantém o mesmo bloco do flake.nix antigo)
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.backupFileExtension = "hm-backup";
        home-manager.overwriteBackup = true;
        home-manager.users.kim = {
          home.username = "kim";
          home.homeDirectory = "/home/kim";
          home.stateVersion = "24.05";

          imports = [
            inputs.self.modules.homeManager.base
            # Fase 3 — aspectos home de apps/
            inputs.self.modules.homeManager."apps/git"
            inputs.self.modules.homeManager."apps/aria2"
            inputs.self.modules.homeManager."apps/mpv"
            inputs.self.modules.homeManager."apps/general"
            inputs.self.modules.homeManager."apps/browsers/firefox"
	    inputs.self.modules.homeManager."apps/browsers/vivaldi"
          ];
        };
      }
    ];
  };
}
