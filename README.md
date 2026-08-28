# Shell Caps Negator 🔄

Ever accidentally hit Caps Lock and typed `GIT COMMIT -M "FIX"`? 
Instead of deleting the whole line or manually changing case, simply hit the `Up` arrow, add a tilde (`~`) to the front, and hit enter. 

`~GIT COMMIT -M "FIX"` instantly executes as `git commit -m "fix"`. 

The utility uses native shell parameter expansion (zero subshells, zero latency) to rewrite your command, fix your shell history, and execute it seamlessly.

## Features
- **Zero Dependencies:** Pure shell parameter expansion (no `awk`, `sed`, or `tr` required).
- **History Correction:** The corrected lowercase command safely replaces your uppercase mistake in the shell `history`.
- **Cross-Shell:** Native support for both Bash and Zsh.
- **Safe:** Does not interfere with standard home directory `~` expansions (e.g., `~/Downloads`).

## Installation (Debian / Ubuntu)

You can install this utility directly via `apt` using the secure, signed GitHub Pages repository.

```bash
# 1. Download the repository's public GPG key
curl -fsSL https://mohit0404.github.io/shell-caps-negator/public.key | sudo gpg --dearmor -o /usr/share/keyrings/shell-caps-negator-archive-keyring.gpg

# 2. Add the custom repository to your APT sources
echo "deb [signed-by=/usr/share/keyrings/shell-caps-negator-archive-keyring.gpg] https://mohit0404.github.io/shell-caps-negator/ ./" | sudo tee /etc/apt/sources.list.d/shell-caps-negator.list > /dev/null

# 3. Update the package cache and install
sudo apt update
sudo apt install shell-caps-negator
