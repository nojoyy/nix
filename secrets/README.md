# Secrets Management with agenix

## Update an existing secret

```bash
cd ~/nix/secrets
echo -n "NEW_VALUE" | nix-shell -p age --run 'age \
  -r "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq42LmQD2ZgJKpueWMwDFroylkt9ronJDmgCvchSalU" \
  -r "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRuZhMim1ysgzNXXNH98poyq55tYOOOynE+krGFxHbH" \
  -o SECRET_NAME.age'
```

## Add a new secret

1. Add entry to `secrets.nix`:
```nix
"new-secret.age".publicKeys = allUsers ++ [ carbon ];
```

2. Encrypt the value:
```bash
echo -n "SECRET_VALUE" | nix-shell -p age --run 'age -r "CARBON_KEY" -r "NOAH_KEY" -o new-secret.age'
```

3. Reference in NixOS module:
```nix
age.secrets.new-secret.file = ../../secrets/new-secret.age;
environment.SECRET_FILE = config.age.secrets.new-secret.path;
```

## Deploy

```bash
sudo nixos-rebuild switch --flake ~/nix#Carbon
```

## Keys

- **Carbon:** `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq42LmQD2ZgJKpueWMwDFroylkt9ronJDmgCvchSalU`
- **Noah:** `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRuZhMim1ysgzNXXNH98poyq55tYOOOynE+krGFxHbH`
