{ pkgs, lib, config, ... }:

{
  options = {
    emacs.enable = lib.mkEnableOption "enable emacs module";
  };

  config = lib.mkIf config.emacs.enable {
    services.emacs = {
      enable = true;
      package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        vterm 
      ]);
    };
  };
}
