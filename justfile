# default recipe to display help information
default:
  @just --list

check ARGS="":
	NIXPKGS_ALLOW_UNFREE=1 REPO_PATH=$(pwd) nix flake check --impure --keep-going --show-trace {{ARGS}}

# Rebuild the system
rebuild: 
  # NOTE: Add --option eval-cache false if you end up caching a failure you can't get around
  scripts/rebuild.sh

# Rebuild the system and run a flake check
rebuild-full:
  scripts/rebuild.sh
  just check

# Rebuild the system and run a flake check
rebuild-trace:
  scripts/rebuild.sh trace
  just check

# Update the flake
update:
  nix flake update

# Git diff there entire repo expcept for flake.lock
diff:
  git diff ':!flake.lock'
