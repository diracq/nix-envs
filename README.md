# nix-envs
This repository contains various scripts and configurations for setting up a unified Dirac NixOS environment.

There is support for both baremetal installations of NixOS installation in WSL2.

## Installation
### WSL2 Preconfigured Tarball

Navigate to [the engineering folder on the Dirac Google Drive](https://drive.google.com/drive/folders/0AGQuWK0xz_dmUk9PVA).

Download the `dirac-nixos.wsl` file to your local machine. Navigate to the file in file explorer. Then, right click in the folder and select "Open in Terminal".

```ps2
wsl --install
wsl --list --verbose
```
Ensure this shows WSL version 2. Run the following command to install the tarball:

```ps2
wsl --install --from-file .\dirac-nixos.wsl --name DiracNixOS
```

---

To launch the environment, run:

```ps2
wsl -d DiracNixOS
```

To set this as the default WSL distribution, run:

```ps2
wsl --setdefault DiracNixOS
```

### Baremetal NixOS Installation

If attempting this, contact @drew-dirac for assistance. More complicated, but it will be worth it!

---

First, install NixOS using the [graphical installation ISO](https://nixos.org/download.html).
https://channels.nixos.org/nixos-24.11/latest-nixos-gnome-x86_64-linux.iso

After downloading the ISO, burn it to a USB drive using a tool like [Etcher](https://etcher.balena.io/) and install NixOS.

⚠️ **Warning**
- Back up all important data before proceeding with installation
- If dual booting with Windows, ensure you have:
  - Disabled Fast Startup in Windows
  - Disabled Secure Boot in BIOS
  - Created unallocated disk space for NixOS
  - Expanded the EFI boot partition: see [this wiki page](https://nixos.wiki/wiki/Dual_Booting_NixOS_and_Windows)
  - *Generally, dual booting is not recommended. Lots of ways to break the Windows installation.*
- The installation will format the target drive/partition, permanently erasing its contents
- If you're unsure about any steps, consult the [NixOS Manual](https://nixos.org/manual/nixos/stable/) or seek assistance (@drew-dirac)

Once you have booted into the live environment, follow the graphical installer prompts to install NixOS.

---

After installation is complete, run the following:

```bash
nix --extra-experimental-features "nix-command flakes" run github:diracq/nix-envs
```

This will clone the nix-envs repository to /etc/nixos/nix-envs and modify /etc/nixos/configuration.nix to import the nix-envs modules.

## Initial Setup and Configuration

First, update your system configuration and apply it:

```bash
sudo git -C /etc/nixos/nix-envs pull
sudo nixos-rebuild switch --upgrade
```

Then, run the following to configure github and our monorepo. Be sure to select **SSH** as the authentication method.

```bash
mkdir dirac && cd dirac
gh auth login
gh repo clone diracq/buildos-web -- --recurse-submodules && cd buildos-web
# you may need to explicitly allow the direnv hook
cd buildos-web && direnv allow
```

You should see a message that states `nix environment initialized`.

You are now done setting up your NixOS environment! Continue to follow the instructions in the [buildos-web README](https://github.com/diracq/buildos-web/blob/main/README.md) to get the repo configured.

### Updating Packages

To update NixOS and rebuild based on your `/env/nixos/configuration.nix` file, run the following:

```bash
sudo nixos-rebuild switch --upgrade
```
You can omit `--upgrade` if you just want to evaluate the system configuration and not update packages.

### Further Customization

Your `~/.zshrc` is in the normal place and can be tweaked as you like it.

To install or modify packages, edit the `/etc/nixos/configuration.nix` file. [Guide for the reccomended method](https://matthewrhone.dev/nixos-package-guide#installing-a-package-via-configurationnix-system-wide)

> ⚠️ **Warning:** Avoid all use of the `nix-env` command. It is not declarative. It is much nicer to just add packages to the `environment.systemPackages` list.

To build the configuration, run `sudo nixos-rebuild switch`.

## Manual WSL2 Tarball Generation

Below are the steps to build and set up a WSL2 tarball manually (in case the preconfigured tarball is not available/functional).

### Build the base NixOS WSL Tarball
On a machine with Nix installed (and flakes/nix-command enabled), run the following command to build the tarball:

```bash
sudo nix run github:diracq/nix-envs#nixosConfigurations.wsl.config.system.build.tarballBuilder
```
> We build from this repository's flake, as we set the nixpkgs channel to a newer stable version than nix-wsl's default.

This will output a nixos.wsl file in the current directory.

### Install the Tarball

```bash
wsl --install --from-file nixos.wsl --name DiracNixOS
```

### Run setup script

```bash
nix --extra-experimental-features "nix-command flakes" run github:diracq/nix-envs
```

This will clone the nix-envs repository to /etc/nixos/nix-envs and modify /etc/nixos/configuration.nix to import the nix-envs modules.

### Export the Finished Tarball

```ps2
wsl --export DiracNixOS .\dirac-nixos.wsl
```


