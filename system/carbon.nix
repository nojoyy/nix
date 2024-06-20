{ config, pkgs, ... }:

{
  # Carbon
  fileSystems."/mnt/carbon" = {
    device = "//192.168.8.1/local";
    fsType = "cifs";
    options = [ "uid=1000" "gid=100" "credentials=/home/noah/.gli_creds" "x-systemd.automount" "x-systemd.device-timeout=10" "noauto" ];
  };
}
