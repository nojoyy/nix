{ config, pkgs, ... }:

{
  # Carbon - alternatively install cifs-utils package and mount manually
  fileSystems."/home/noah/carbon" = {
    device = "//192.168.0.106/basic";
    fsType = "cifs";
    options = [ "uid=noah" "gid=users" "credentials=/home/noah/.carbon_creds" "x-systemd.automount" "x-systemd.device-timeout=10" "noauto" ];
  };
}
