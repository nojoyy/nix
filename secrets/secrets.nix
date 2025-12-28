let
  # Server host keys (for decryption on deploy)
  carbon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq42LmQD2ZgJKpueWMwDFroylkt9ronJDmgCvchSalU";

  # User keys (for encryption/editing)
  noah = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRuZhMim1ysgzNXXNH98poyq55tYOOOynE+krGFxHbH";

  # Key groups
  allUsers = [ noah ];
  allServers = [ carbon ];
in {
  # Recipe Manager secrets
  "recipe-manager-invite-code.age".publicKeys = allUsers ++ [ carbon ];
}
