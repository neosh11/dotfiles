# check if brew is installed
if ! command -v brew &> /dev/null
then
    echo "brew is not installed. Please install brew."
    exit
fi

# ------------------------- Tmux -------------------------
echo "Setting up tmux..."

# check if tmux is installed
if ! command -v tmux &> /dev/null
then
    echo "tmux is not installed. Installing tmux..."
    brew install tmux
fi

# check if tpm is installed
if [ ! -d ~/.tmux/plugins/tpm ]
then
    echo "tpm is not installed. Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# check if tmux.conf exists if it does create a backup, then create a symlink using our tmux.conf
if [ -f ~/.tmux.conf ]
then
    echo "tmux.conf already exists. Creating a backup..."
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s $(pwd)/.tmux.conf ~/.tmux.conf


# check if reattach-to-user-namespace is installed
brew install reattach-to-user-namespace
brew install --cask font-monaspace-nerd-font font-noto-sans-symbols-2
brew install bash bc coreutils gawk gh glab gsed jq nowplaying-cli
# For Ubuntu
# apt-get install bash bc coreutils gawk git jq playerctl 

# ------------------------- Kitty -------------------------
echo "Setting up kitty..."

read -p "Do you have kitty installed? (yes/no): " choice
case "$choice" in 
    yes|YES|Yes ) 
        # install nerd-fonts if Hack Nerd Font is not installed
        if [ ! -f /Library/Fonts/Hack-Regular.ttf ]
        then
            echo "Hack Nerd Font is not installed. Installing Hack Nerd Font..."
            brew install --cask font-hack-nerd-font
        fi

        echo "kitty is installed. Setting up kitty..."
        # check if kitty.conf exists if it does create a backup, then create a symlink using our kitty.conf
        if [ -f ~/.config/kitty/kitty.conf ]
        then
            echo "kitty.conf already exists. Creating a backup..."
            mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
        fi
        ln -s $(pwd)/kitty/kitty.conf ~/.config/kitty/kitty.conf


        if [ -d ~/.config/kitty/theme.conf ]
        then
            echo "theme.conf already exists. Creating a backup..."
            mv ~/.config/kitty/theme.conf ~/.config/kitty/theme.conf.bak
        fi
        ln -s $(pwd)/kitty/theme.conf ~/.config/kitty/theme.conf

        if [ -d ~/.config/kitty/tokyo.jpg ]
        then
            echo "tokyo.webp already exists."
            rm ~/.config/kitty/tokyo.jpg
        fi
        ln -s $(pwd)/kitty/tokyo.jpg ~/.config/kitty/tokyo.jpg

        ;;
    no|NO|No ) 
        echo "Skipping kitty setup..."
        ;;
    * ) 
        echo "Invalid input. Skipping kitty setup..."
        ;;
esac


# ------------------------- Zsh -------------------------
echo "Setting up zsh..."

# check if zsh is installed
if command -v zsh &> /dev/null
then
    if ! grep -q "source ~/.zshhooks/neosh-timer.zsh" ~/.zshrc
    then
        # make a symlink to our neosh-timer.zsh in the home directory in the folder ~/.zshhooks
        if [ ! -d ~/.zshhooks ]
        then
            mkdir ~/.zshhooks
        fi
        ln -s $(pwd)/zsh/neo-timer.zsh ~/.zshhooks/neo-timer.zsh

        # add the source command to our zshrc
        echo "source ~/.zshhooks/neo-timer.zsh" >> ~/.zshrc
    fi
fi

