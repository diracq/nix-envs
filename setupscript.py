import subprocess

from git import Repo
from pathlib import Path

# Ask user if they are running WSL or baremetal
while True:
    prompt = "Are you running WSL or baremetal? (wsl/baremetal): "
    env_type = input(prompt).lower()
    if env_type in ["wsl", "baremetal"]:
        break
    print("Please enter either 'wsl' or 'baremetal'")


# Get path to place this repository
nixos_path = Path("/etc/nixos")

# Clone the repository into /etc/nixos
print("Cloning configuration into /etc/nixos...")
Repo.clone_from("https://github.com/diracq/nix-envs", nixos_path / "nix-envs")

# Add import line after first "imports = [" line
print("Modifying configuration.nix to import nix-envs configuration...")
with open(nixos_path / "configuration.nix", "r+") as file:
    content = file.readlines()
    file.seek(0)
    for line in content:
        file.write(line)
        if "imports = [" in line:
            file.write("    # import dirac configuration\n")
            file.write(f"    ./nix-envs/{env_type}.nix\n")
    file.truncate()

# Rebuild NixOS with new configuration
print("Rebuilding NixOS with new configuration...")
subprocess.run(["sudo", "nixos-rebuild", "switch"], check=True)

exit_message = """
Done! You can now start using your new NixOS environment.

Recommended to next run gh auth login to login to github.
"""
print(exit_message)
