{ pkgs, lib, config, ... }:

{
  systemd.user.services.krita = {
    Unit = {
      Description = "Krita as background";
    };
    Service = {
      ExecStart = "${pkgs.krita}/bin/krita";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
