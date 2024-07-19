{ ... }:

{
  imports = [
    ./grub.nix
    ./locale.nix
    ./pipewire.nix
    ./polkit.nix
    ./sddm.nix
    ./ssh.nix
    ./terminal.nix
  ];
}
