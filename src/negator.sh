# src/negator.sh
# Core logic to negate accidental ALL CAPS shell commands prefixed with '~'.

if [ -n "$BASH_VERSION" ]; then
    command_not_found_handle() {
        local cmd="$1"
        # Check if the command starts with ~ followed by an uppercase letter
        if [[ "$cmd" == \~[A-Z]* ]]; then
            # Strip the leading tilde
            local stripped="${cmd#\~}"
            
            # Convert command to lowercase using Bash built-in parameter expansion
            local lower_cmd="${stripped,,}"
            
            # Shift the command name out of the arguments array
            shift
            
            # Convert all arguments to lowercase
            local lower_args=()
            for arg in "$@"; do
                lower_args+=("${arg,,}")
            done
            
            # Reconstruct the full lowercase string for history
            local full_cmd="$lower_cmd ${lower_args[*]}"
            full_cmd="${full_cmd% }" # Trim trailing space if there are no arguments

            # Bridge the subshell gap via a PID-specific file
            echo "$full_cmd" > "/tmp/.caps_negator_history_fix_$$"

            # Execute the corrected command
            "$lower_cmd" "${lower_args[@]}"
            return $?
        fi
        
        # Fallback to standard error behavior
        echo "$cmd: command not found" >&2
        return 127
    }

    # The Bash History Hook (Runs in the parent shell)
    _caps_negator_history_update() {
        local hist_file="/tmp/.caps_negator_history_fix_$$"

        # Fast, process-free check
        if [[ -f "$hist_file" ]]; then
            local corrected
            read -r corrected < "$hist_file"

            # Delete the raw ~CAPS entry and append the clean command
            history -d -1 2>/dev/null
            history -s "$corrected"

            # Clean up the session's specific file
            rm -f "$hist_file"
        fi
    }

    # Safely attach the hook to PROMPT_COMMAND
    if [[ "${PROMPT_COMMAND:-}" == *_caps_negator_history_update* ]]; then
        : # Do nothing if already attached
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        if declare -p PROMPT_COMMAND 2>/dev/null | grep -q 'declare -a'; then
            PROMPT_COMMAND+=(_caps_negator_history_update)
        else
            PROMPT_COMMAND="_caps_negator_history_update; ${PROMPT_COMMAND:-}"
        fi
    fi

elif [ -n "$ZSH_VERSION" ]; then
    command_not_found_handler() {
        local cmd="$1"
        if [[ "$cmd" == \~[A-Z]* ]]; then
            local stripped="${cmd#\~}"
            
            # Convert command to lowercase using Zsh built-in modifier
            local lower_cmd="${stripped:l}"
            
            shift
            
            local lower_args=()
            for arg in "$@"; do
                lower_args+=("${arg:l}")
            done
            
            local full_cmd="$lower_cmd ${lower_args[*]}"
            full_cmd="${full_cmd% }"
            
            # Append the corrected command to Zsh history
            print -s "$full_cmd"
            
            "$lower_cmd" "${lower_args[@]}"
            return $?
        fi
        
        echo "$cmd: command not found" >&2
        return 127
    }
fi
