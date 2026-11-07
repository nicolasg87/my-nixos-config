{ ... }:
{
  flake.modules.nixos."virtualization/virt-manager" = { pkgs, ... }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
    programs.virt-manager.enable = true;
    services.spice-vdagentd.enable = true;
    environment.systemPackages = with pkgs; [
      dnsmasq
      virtiofsd
    ];
    networking.firewall.trustedInterfaces = [ "virbr0" ];

    # Discos de VM não ganham nada com CoW/checksums: o qcow2 já fragmenta e
    # reescreve em blocos, e o NODATACOW por mount option não funciona fora do
    # primeiro subvolume. chattr +C é por inode e só vale para arquivos criados
    # depois, então roda a cada boot (idempotente).
    #
    # tmpfiles tipo "h" = chattr; "-" ignora falha. systemd-tmpfiles-setup roda
    # After=local-fs.target, então o subvolume já está montado. É o mesmo
    # mecanismo que o systemd usa em /var/log/journal (journal-nocow.conf).
    systemd.tmpfiles.rules = [
      "h- /var/lib/libvirt/images - - - - +C"
    ];
  };
}
