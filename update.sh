#!/usr/bin/env bash
# Runs updates on all nodes
#
hosts=( "carter-zimmerman" "konishi" "polis" "pattern-juggler" )

nix flake update

# Save the current directory
DIR="$(pwd)"

# Change to the pkgs directory
cd pkgs

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
#
for host in ${hosts[@]}; do
    # Polis is our local host
    if [[ "${host}" != "polis" ]]; then
    	NIX_SSHOPTS="-t" nixos-rebuild --flake .#${host} switch --target-host ${host} --use-remote-sudo --use-substitutes;

	if [[ $(ssh "${host}" "diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules,systemd}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules,systemd})") ]]; then 
	    echo "Detected reboot is required. Rebooting target host ${host}"
	    ssh -t "${host}" "sudo reboot";
        else 
            echo "No reboot is required.";
	fi;
    else
        sudo nixos-rebuild --flake .#polis switch;
        if [[ $(diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules,systemd}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules,systemd})) ]]; then 
	    echo "Reboot is required. Rebooting system in 1 minute."
	    sudo shutdown -r 1m
        else 
	    echo "No reboot is required.";
	fi
    fi;
done;
