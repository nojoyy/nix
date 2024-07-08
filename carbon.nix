{ config, pkgs, ... }:

{
  # Carbon - alternatively install cifs-utils package and mount manually
  fileSystems."/mnt/carbon" = {
    device = "//192.168.0.106/vault";
    fsType = "cifs";
    options = [ "uid=1000" "gid=100" "credentials=/home/noah/.carbon_creds" "x-systemd.automount" "x-systemd.device-timeout=10" "noauto" ];
  };
}
