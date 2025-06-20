{ pkgs, lib, config, ... }:

let module = config.modules.emacs;

in {
  options = {
    modules.emacs.enable = lib.mkEnableOption "enable emacs module";
  };

  config = lib.mkIf module.enable {
    services.emacs = {
      enable = true;
      package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs: with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
      ]);
    };
  };
}
