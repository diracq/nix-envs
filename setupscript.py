import subprocess
from termcolor import cprint

from git import Repo
from pathlib import Path


def setup_nixenvs(env_type):
    """
    Clone the nix-envs repo.
    Configure nix for the given environment type.
    """
    nixos_path = Path("/etc/nixos")
    nixenvs_path = nixos_path / "nix-envs"

    # exit if nix-envs directory already exists
    if nixenvs_path.exists():
        cprint(
            "Warning: nix-envs directory already exists, skipping clone.",
            "yellow"
        )
        return

    print("Cloning configuration into /etc/nixos...")
    Repo.clone_from("https://github.com/diracq/nix-envs", nixenvs_path)

    # add import line after first "imports = [" line
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


def setup_github():
    """
    Check if user is logged in to GitHub.
    If not, log in.
    """
    print("Checking GitHub login status...")

    result = subprocess.run(["gh", "auth", "status"], capture_output=True, text=True)
    if result.returncode == 0 and "Logged in to github.com account" in result.stdout:
        cprint("You are already logged in to GitHub.", "green")
        return

    print("Logging in to GitHub with gh...")
    cprint(
        "Please select the option to generate a new SSH key (unless you already have one).",
        "yellow",
    )
    subprocess.run(["gh", "auth", "login", "--git-protocol", "ssh"], check=True)


if __name__ == "__main__":
    # ask user if they are running WSL or baremetal
    while True:
        prompt = "Are you running WSL or baremetal? (wsl/baremetal): "
        env_type = input(prompt).lower()
        if env_type in ["wsl", "baremetal"]:
            break
        else:
            print("Please enter either 'wsl' or 'baremetal'")

    setup_nixenvs(env_type)

    # Rebuild NixOS with new configuration
    print("Rebuilding NixOS with new configuration...")
    subprocess.run(["sudo", "nixos-rebuild", "switch"], check=True)

    # check if user is logged in to GitHub
    try:
        setup_github()
    except FileNotFoundError:
        cprint("GitHub CLI (gh) not found. Please ensure it's installed.", "red")
        exit(1)

    exit_message = """
    Done! You can now start using your new NixOS environment.

    Check the README for next configuration steps.
    """
    cprint(exit_message, "green")
