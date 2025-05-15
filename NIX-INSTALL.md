# Installing with Nix

Claude Squad can be built and installed using [Nix](https://nixos.org/), a powerful package manager and build system.

## Using Nix Flakes (Recommended)

If you have Nix with flakes enabled, you can run Claude Squad directly without installing it:

```bash
# Run directly without installing
nix run github:smtg-ai/claude-squad

# Or, install it using nix profile
nix profile install github:smtg-ai/claude-squad
```

## Building from Source with Nix

You can also build Claude Squad from source using the provided flake:

```bash
# Clone the repository
git clone https://github.com/smtg-ai/claude-squad.git
cd claude-squad

# Build using nix build
nix build

# The built binary will be available at ./result/bin/claude-squad
./result/bin/claude-squad
```

## Development Environment

A development environment with all dependencies is also provided:

```bash
# Start a development shell
nix develop

# Now you can build and run claude-squad within this shell
go build
./claude-squad
```

## NixOS Module

If you're using NixOS, you can add Claude Squad to your system configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-squad.url = "github:smtg-ai/claude-squad";
  };

  outputs = { self, nixpkgs, claude-squad, ... }:
    {
      nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            environment.systemPackages = [
              claude-squad.packages.x86_64-linux.default
            ];
          })
        ];
      };
    };
}
```

## Home Manager

If you use Home Manager, you can add Claude Squad to your home configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    claude-squad.url = "github:smtg-ai/claude-squad";
  };

  outputs = { self, nixpkgs, home-manager, claude-squad, ... }:
    {
      homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            home.packages = [
              claude-squad.packages.x86_64-linux.default
            ];
          }
        ];
      };
    };
}
```