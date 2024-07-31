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
             { exec = "emacsclient -nw \"$@\""; block=true; for = "unix"; }
           ];
         };
      };
      
      keymap = {
        manager.prepend_keymap = [
          { exec = "yank --cut"; on = ["d"]; }
          { exec = "unyank"; on = ["D"]; }
          { exec = "remove"; on = ["x"]; }
          { exec = "remove --permanently"; on = ["X"]; }
        ];
      };
    };
  };
}
