# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ----------------------- Styles -------------------------------

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5' # makes it light grey, non bold

# ------------------------ Alias -------------------------------

alias gaf='cd ~/freelancer-dev/fl-gaf'
alias webapp='cd ~/freelancer-dev/fl-gaf/webapp'
#alias sshzclare='ssh -i ~/.ssh/id_rsa dev@zclare.syd1.fln-dev.net'
#alias sshzclare='ssh devbox'
alias fltools='bash ~/fl-tools.sh'
alias gil='git log --date=relative --pretty="format:%Cred%h %Cblue%ar %Cgreen%an%n %s" "$@"'
alias greset='git reset --hard origin/master && git clean -fd && git pull origin' #reset to clean original master
alias logs='fli service log -f fl-gaf'  # opens logs on the devbox
alias vpn='bash ~/vpn.sh'
alias vpn-stop='bash ~/vpn-stop.sh'
alias enable-legacy-styles='ssh devbox "jq '\''.s3_cdn_url = \"https://www.f-dev-cdn.com\"'\'' /mnt/gaf/config/local/local.json > /mnt/gaf/config/local/temp.json && mv /mnt/gaf/config/local/temp.json /mnt/gaf/config/local/local.json"'
# ---------------------- Functions -----------------------------
apatch () {
    for diff; do
        arc patch --nobranch --skip-dependencies "$diff";
    done
}

function arcdiff() {
    # Template URL
    TEMPLATE_URL="https://phabricator.tools.flnltd.com/file/data/v44rvugg6obxtrleil3e/PHID-FILE-rrkrnh7bjyih4bb67keu/Loadshift_diff_template"

    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is not installed. Please install curl to use this script."
        return 1
    fi

    # Prompt for Name
    echo -n "Diff Name: "
    read diff_name

    # Prompt for ticket ID
    echo -n "Enter ticket ID: "
    read ticket_id
    
    # Create temporary files
    temp_file=$(mktemp)
    
    # Fetch template from URL and handle errors
    if ! curl -s "$TEMPLATE_URL" > "$temp_file.template"; then
        echo "Error: Failed to fetch template from URL"
        rm "$temp_file.template"
        return 1
    fi

    # Replace the variables in the template
    sed -e "1s/.*/${diff_name}/" \
        -e "s/Ref .*/Ref ${ticket_id}/" \
        "$temp_file.template" > "$temp_file"

    # Clean up template file
    rm "$temp_file.template"

    # Create the diff using arc
    arc diff --create --message-file "$temp_file" "$@"

    # Clean up temporary file
    rm "$temp_file"
}


# ----------- Setup and paths for different programs ----------- 

# For pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# FLI
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="~/.local/bin:$PATH"
pyenv activate fli

# Arcanist
export PATH="$PATH:$HOME/tools/arcanist/bin"
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# bun completions
[ -s "/home/zclare/.bun/_bun" ] && source "/home/zclare/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
USE_BUN=true

# node
nvm use "$(cat ~/freelancer-dev/fl-gaf/webapp/.nvmrc)"