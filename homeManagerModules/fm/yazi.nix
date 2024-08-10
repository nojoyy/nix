{ pkgs, lib, config, ... }:

let
  module = config.modules.yazi;

in {
  options = {
    modules.yazi.enable = lib.mkEnableOption "enable yazi config";
  };

  config = lib.mkIf module.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        manager = {
          show_symlink = true;
          ratio = [ 2 4 4];
        };
         opener = {
           edit = [
             { run = "emacsclient -nw \"$@\""; block=true; for = "unix"; }
           ];
         };
      };
      
      keymap = {
        manager.prepend_keymap = [
          { run = "yank --cut"; on = ["d"]; }
          { run = "unyank"; on = ["D"]; }
          { run = "remove"; on = ["x"]; }
          { run = "remove --permanently"; on = ["X"]; }
        ];
      };
    };
  };
}
