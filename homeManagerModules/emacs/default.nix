{ pkgs, lib, config, ... }:

let module = config.modules.emacs;

in {
  options = {
    modules.emacs.enable = lib.mkEnableOption "enable emacs config";
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
  };
}
