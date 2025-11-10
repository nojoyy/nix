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
      enableFishIntegration = true;

      settings = {
        mgr = {
          show_symlink = true;
          ratio = [ 2 4 4];
        };
         opener = {
           edit = [
             {
               run = "emacsclient -nw \"$@\"";
               block=true;
               for = "unix";
             }
           ];
           open = [
             {
               run = "zathura \"$1\"";
               desc = "View PDF";
               for = "unix";
               mime = "application/pdf";
             }
             {
               run = "mpv \"$1\"";
               desc = "Play video";
               for = "unix";
               mime = "video/*";
             }
             {
               run = "imv \"$1\"";
               desc = "View image";
               for = "unix";
               mime = "image/*";
             }
           ];
         };
      };
      
      keymap = {
        mgr.prepend_keymap = [
          { run = "yank --cut"; on = ["d"]; }
          { run = "unyank"; on = ["D"]; }
          { run = "remove"; on = ["x"]; }
          { run = "remove --permanently"; on = ["X"]; }
          { run = "cd ~/Documents"; on = ["g" "u"]; desc = "Go to documents"; }
          { run = "cd ~/images"; on = ["g" "i"]; desc = "Go to images"; }
          { run = "cd ~/models"; on = ["g" "m"]; desc = "Go to models"; }
          { run = "cd ~/nix"; on = ["g" "n"]; desc = "Go to nix"; }
          { run = "cd ~/org"; on = ["g" "o"]; desc = "Go to org"; }
          { run = "cd ~/projects"; on = ["g" "p"]; desc = "Go to projects"; }
          { run = "cd ~/.config"; on = ["g" "c"]; desc = "Go to config"; }
          { run = "cd ~/Downloads"; on = ["g" "d"]; desc = "Go to downloads"; }
          { run = "cd ~/ledger"; on = ["g" "l"]; desc = "Go to ledger"; }
        ];
      };
    };
  };
}
