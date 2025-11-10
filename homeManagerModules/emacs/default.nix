{ pkgs, lib, config, inputs, ... }:

let module = config.modules.emacs;

org-sync = pkgs.writeScriptBin "org-sync" ''
#!/run/current-system/sw/bin/bash
ORG_DIR="$HOME/org"
cd "$ORG_DIR"

git checkout main
git pull origin main --rebase 

git add .

git commit -m "Auto-sync from $(hostname) at $(date '+%Y-%m-%d %H:%M:%S')"

git push origin main

echo "Sync completed"
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

    systemd.user.services.org-sync = lib.mkIf module.org-sync.enable {
      Unit = {
        Description = "Org sync";
      };
      Service = {
        Type = "oneshot";
        Environment = [
          "GCM_CREDENTIAL_STORE=cache"
          "HOME=${config.home.homeDirectory}"
        ];
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
