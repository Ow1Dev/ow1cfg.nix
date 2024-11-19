# List available commands
default:
    @just --list

# Deploy system configuration
deploy SYSTEM IP:
    nixos-rebuild switch --flake .#{{SYSTEM}} --target-host {{IP}} --use-remote-sudo

# Update flake
update:
    nix flake update

# Check flake
check:
    nix flake check

# Show flake info
show:
    nix flake show

# Enter a development shell
dev-shell:
    nix develop 