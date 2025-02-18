from git import Repo
from pathlib import Path

# Ask user if they are running WSL or baremetal
while True:
    env_type = input("Are you running WSL or baremetal? (wsl/baremetal): ").lower()
    if env_type in ["wsl", "baremetal"]:
        break
    print("Please enter either 'wsl' or 'baremetal'")


# Get path to place this repository
nixos_path = Path("/etc/nixos")

# Clone the repository into /etc/nixos
print("Cloning configuration into /etc/nixos")
Repo.clone_from("https://github.com/diracq/nix-envs", nixos_path / "nix-envs")

# Add import line after first "imports = [" line
with open(nixos_path / "configuration.nix", "r+") as file:
    content = file.readlines()
    file.seek(0)
    for line in content:
        file.write(line)
        if "imports = [" in line:
            file.write(f"    ./nix-envs/{env_type}.nix\n")
    file.truncate()
