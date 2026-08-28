# shell-caps-negator.sh
# Automatically sourced by /etc/profile for Bash and Zsh users

# Ensure we are operating interactively in a supported shell
if [[ $- == *i* ]] && { [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; }; then
    if [ -f /usr/share/shell-caps-negator/negator.sh ]; then
        source /usr/share/shell-caps-negator/negator.sh
    fi
fi
