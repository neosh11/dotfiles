# ensure that this script is loaded only once
if [[ -z $NEO_ZSH_COMMAND_TIMER_LOADED ]]; then
  NEO_ZSH_COMMAND_TIMER_LOADED=1
else
  return
fi

# Function to capture the start time before command execution
function preexec() {
  RPROMPT=""
  timer=$(($(gdate +%s%0N)/1000000))
}

# Function to calculate and display elapsed time after command execution
function precmd() {
  # if timer is not set then return
  if [ -z "$timer" ]; then
  RPROMPT=""
    return
  fi

  if [ -n "$timer" ]; then
    now=$(($(gdate +%s%0N)/1000000))
    elapsed=$(($now - $timer))

    # Set RPROMPT with elapsed time in cyan and reset color properly
    RPROMPT="%F{cyan}${elapsed}ms%f"
    unset timer
  fi
}

# Hook the functions into Zsh's lifecycle
autoload -Uz add-zsh-hook