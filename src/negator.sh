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
            
            # Append the corrected command to Bash history
            history -s "$full_cmd"
            
            # Execute the corrected command
            "$lower_cmd" "${lower_args[@]}"
            return $?
        fi
        
        # Fallback to standard error behavior
        echo "$cmd: command not found" >&2
        return 127
    }

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
