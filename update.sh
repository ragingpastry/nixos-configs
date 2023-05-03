#!/usr/bin/env bash
# Runs updates on all nodes
#
# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Define functions
error() {
  echo -e "${RED}Error: $1${NC}" >&2
  exit 1
}

warn() {
  echo -e "${YELLOW}Warning: $1${NC}" >&2
}

success() {
  echo -e "${GREEN}$1${NC}" >&2
}

parse_hosts() {
    local hosts
    if [ $# -eq 1 ]; then
        IFS=',' read -ra hosts <<< "$1";
    elif [ $# -lt 1 ]; then
        hosts=( "carter-zimmerman" "konishi" "polis" "pattern-juggler" );
    else
        return 1;
    fi;
    echo "${hosts[@]}"
}

reboot_required() {
    diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules,systemd}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules,systemd}) \
      || return 0 \
      && return 1
}

update_flake() {
    nix flake update

    # Save the current directory
    DIR="$(pwd)"

    # Change to the pkgs directory
    cd pkgs || { error "Failed to cd to the 'pkgs' directory!"; exit 1; }

    # Find all default.nix files with "fetchFromGitHub"
    for f in $(find . -name "default.nix" -type f -exec grep -H "fetchFromGitHub" {} \; | cut -d: -f1); do
      # Get the directory containing the default.nix file and remove the ./ prefix
      folder=$(dirname "$f" | sed 's|^\./||')
    
      # Run nix-update with the directory name
      echo "Running nix-update for $folder"
      nix-update "$folder" || { echo "Error running nix-update in $folder" >&2; exit 1; }
    done

    # Change back to the original directory, even if there was an error
    trap 'cd "$DIR"' ERR
}

# Parse input
while getopts ':n:h' opt; do
  case "$opt" in
    n)
      arg="$OPTARG"
      echo "Setting nodes with '${OPTARG}'"
      declare -a hosts
      read -ra hosts <<< "$(parse_hosts "${arg}")"
      if [ ${#hosts[@]} -eq 0 ]; then
        echo "Error parsing arguments"
        exit 1
      fi
      echo "Running against ${hosts[*]}"
      ;;
    h)
      success "Usage: $(basename $0) [-n node1,node2,node3]"
      exit 0
      ;;
    :)
      error "option requires an argument.\nUsage: $(basename $0) [-n node1,node2,node3]"
      exit 1
      ;;
    ?)
      error "Invalid command option.\nUsage: $(basename $0) [-n node1,node2,node3]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

update_flake

for host in "${hosts[@]}"; do
    # Polis is our local host. We don't want to reboot that right away.
    if [[ "${host}" == "polis" ]]; then
        sudo nixos-rebuild --flake .#polis switch;
        reboot_required && \
        {
            warn "Reboot required for host ${host}. Not automatically rebooting.";
        } || \
        {
            success "No reboot required for host ${host}."
        };
    # Conjoiner is our media server. We want to schedule a reboot for this
    elif [[ "${host}" == "conjoiner" ]]; then
    	NIX_SSHOPTS="-t" nixos-rebuild --flake .#"${host}" switch --target-host "${host}" --use-remote-sudo --use-substitutes;
        ssh -t ${host} "$(typeset -f reboot_required); reboot_required" && \
          { 
            warn "Reboot required for host ${host}. Not automatically rebooting.";
          } || \
          {
            success "No reboot required for host ${host}."
          };
        ssh ${host} "$(typeset -f reboot_required); reboot_required"
    # All others can reboot whenever
    else
    	NIX_SSHOPTS="-t" nixos-rebuild --flake .#"${host}" switch --target-host "${host}" --use-remote-sudo --use-substitutes;
        ssh -t ${host} "$(typeset -f reboot_required); reboot_required" && \
          { 
            warn "Reboot required. Rebooting host ${host}";
            ssh -t ${host} "sudo shutdown -r +1 'System will reboot in 1 minute';";
          } || \
          {
            success "No reboot required for host ${host}."
          };
    fi;
done;
