{ pkgs, lib, config, ... }:

let module = config.modules.emacs;

org-sync = pkgs.writeScriptBin "org-sync" ''
#!/usr/bin/env bash

ORG_DIR="$HOME/org"
cd "$ORG_DIR"

git checkout main

git add .

git commit -m "Sync from $(hostname) at $(date '+%Y-%m-%d %H:%M:%S')" || true

git pull --rebase origin main

git push origin main
'';

in {
  options = {
    modules.emacs.enable = lib.mkEnableOption "enable emacs config";
    modules.emacs.org-sync.enable = lib.mkEnableOption "enable org-sync servic";
  };

  config = lib.mkIf module.enable {
    services.emacs = {
      enable = true;
      package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs: with epkgs; [
        vterm # vterm needs to pre compiled
        treesit-grammars.with-all-grammars # as well as treesit grammars
      ]);
    };
    
    # Source init files
    xdg.configFile."emacs/init.el".source = ./config/init.el;
    xdg.configFile."emacs/early-init.el".source = ./config/early-init.el;
    
    systemd.user.services.org-sync = lib.mkIf module.org-sync.enable {
      Unit = {
        Description = "Org sync";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${org-sync}/bin/org-sync";
      };
    };

    systemd.user.timers.org-sync = lib.mkIf module.org-sync.enable {
      Unit = {
        Description = "Org sync timer";
      };
      Timer = {
        OnCalendar = "*:0/15";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
