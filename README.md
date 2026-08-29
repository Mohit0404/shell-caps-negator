# ⌨️ Shell Caps Negator

[![Release](https://img.shields.io/github/v/release/Mohit0404/shell-caps-negator?style=flat-square)](https://github.com/Mohit0404/shell-caps-negator/releases)
[![Debian Package](https://img.shields.io/badge/Debian-APT_Repository-A81D33?style=flat-square&logo=debian)](#installation)
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh-4EAA25?style=flat-square&logo=gnu-bash)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)

**Shell Caps Negator** is a lightweight, zero-dependency CLI productivity tool for Bash and Zsh that automatically intercepts and corrects accidental ALL-CAPS terminal commands. 

Ever typed an entire command in ALL CAPS before realizing Caps Lock was on? Instead of deleting the whole line and starting over, just slap a ~ at the front (e.g., ~LS -LA). Shell Caps Negator instantly catches the prefix, converts the command to lowercase, executes it, and cleanly rewrites your shell history.

## ✨ Features

* **Instant Typo Correction:** Converts commands like `~GIT COMMIT -M "MSG"` directly to `git commit -m "msg"`.
* **Smart History Rewriting:** Keeps your terminal history pristine. It intercepts the raw `~CAPS` error, pops it off the history buffer, and injects the corrected lowercase command natively. Pressing the `UP` arrow shows the correct command.
* **Native Zsh & Bash Support:** Hooks directly into `command_not_found_handle` (Bash) and `command_not_found_handler` (Zsh).
* **Zero Overhead:** Extremely lightweight. It only triggers on failures prefixed with `~`, meaning it adds absolutely zero latency to your standard terminal usage.

## 🚀 Installation

### Debian / Ubuntu (APT Repository)

We maintain a signed APT repository for seamless updates. Run the following commands to add the repo and install the package:

```bash
# 1. Download the repository's public GPG key
curl -fsSL [https://mohit0404.github.io/shell-caps-negator/public.key](https://mohit0404.github.io/shell-caps-negator/public.key) | sudo gpg --dearmor -o /usr/share/keyrings/shell-caps-negator-archive-keyring.gpg

# 2. Add the custom repository to your APT sources
echo "deb [signed-by=/usr/share/keyrings/shell-caps-negator-archive-keyring.gpg] [https://mohit0404.github.io/shell-caps-negator/](https://mohit0404.github.io/shell-caps-negator/) ./" | sudo tee /etc/apt/sources.list.d/shell-caps-negator.list > /dev/null

# 3. Update the package cache and install
sudo apt update
sudo apt install shell-caps-negator

```

*Note: After installation, open a new terminal window or run `exec bash -l` (or `exec zsh -l`) to load the new profile.*

### macOS / Homebrew

*(Coming Soon - Roadmap)*

## 💻 Usage

Just use your terminal normally. When you make a Caps Lock mistake, prepend it with `~` (if it isn't already), and watch it resolve:

```bash
$ ~NVIDIA-SMI
# Instantly executes: nvidia-smi

$ ~SUDO SYSTEMCTL RESTART NGINX
# Instantly executes: sudo systemctl restart nginx

```

## 🛠️ Under the Hood

Rewriting the shell history buffer for corrected commands is notoriously difficult in Bash because `command_not_found_handle` executes within an isolated subshell.

Shell Caps Negator solves this cleanly by bridging the subshell and parent shell. It captures the corrected command to a PID-specific temporary file (`/tmp/.caps_negator_history_fix_$$`) and securely injects a cleanup function into the user's `PROMPT_COMMAND`. The moment the subshell exits, the parent shell reads the corrected string, rewrites the active `history` buffer, and instantly deletes the temporary file before drawing the next prompt. Zsh handles this natively without subshell isolation.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check [issues page](https://www.google.com/search?q=https://github.com/Mohit0404/shell-caps-negator/issues) if you want to contribute.

## 📝 License

This project is [MIT](https://opensource.org/licenses/MIT) licensed.

