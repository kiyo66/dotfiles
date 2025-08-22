# Dotfiles : neovim + fish environment setup

This repository provides a script to automatically set up a development environment with **Neovim** and the **Fish shell**.
The script installs the required binaries, links configuration files, and ensures that both tools are ready to use.

---

## What the Script Does

1. **Installs Fish**
   - Automatically detects and installs Fish using one of the supported package managers:
     - `apt-get`, `dnf`, `yum`, `pacman`
   - Skips installation if `fish` is already available.

2. **Installs Neovim**
   - Downloads the specified version of Neovim from [GitHub Releases](https://github.com/neovim/neovim/releases).
   - Extracts it under:
     ```
     ~/.config/nvim-<version>
     ```
   - Ensures the Neovim binary is executable:
     ```
     ~/.config/nvim-<version>/nvim-linux-x86_64/bin/nvim
     ```

3. **Creates Symlinks for Configurations**
   - Links `nvim/` in this repo to `~/.config/nvim`
   - Links `fish/` in this repo to `~/.config/fish`

4. **Loads Fish Configuration**
   - If `~/.config/fish/config.fish` exists, it is sourced automatically.

---

## Usage

```bash
git clone <this-repo-url>
cd <this-repo>
chmod +x init.sh
./init.sh

