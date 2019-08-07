#!/bin/bash
installation(){
    local name=`echo $1 | cut -d'-' -f2`
    echo "Installing $name"
    ($1)
    echo "$name installation succeeded"
}

# Installation of basic tools
git clone https://github.com/haomingw/dotfiles $HOME/Documents/Projets

confirm() {
    read -p "Anything else to install in these tools? (y/N) " choice
    case $choice in
        [yY][eE][sS]|[yY] ) ;;
        * ) exit 0;;
    esac
}

install-tools(){
    while :
    do
        bash $HOME/Documents/Projets/dotfiles/install.sh -n
        confirm
    done
}
installation install-tools

# Install Homebrew Xcode dependency
install-xcode(){
    xcode-select --install
}
installation install-xcode

# Install Homebrew
install-homebrew(){
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}
installation install-homebrew 

# Install pyenv to manage different versions of Python
install-pyenv(){
    brew update
    brew install pyenv
    echo -e 'if command -v pyenv >/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
    source ~/.zshrc
}
installation install-pyenv

# Install Python 3.6.0 and switching to this version
install-python(){
    pyenv install 3.6.0
    pyenv local 3.6.0
}
installation install-python

# Install virtualenv
install-virtualenv(){
    pip install virtualenv
}
installation install-virtualenv

# Configure ssh key
echo "Configuration of ssh key"
read -p "What is your github email address? " email
ssh-keygen -t rsa -b 4096 -C $email -f $HOME/.ssh/id_rsa -P ""

echo "Add your ssh key to Github, following the instructions of this webpage: https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account"
echo "Your key is already copied in your clipboard, you can skip the first step"
python -m webbrowser https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account
pbcopy < ~/.ssh/id_rsa.pub
read "When you are done, press enter to continue"

echo "Now we configure your local connection to Github"
read -p "Please enter your Github username" username
git config --global user.name $username
git config --global user.email $email

# Configure server connections
echo "Starting configuration for connexion to servers"
read -p "Do you want to configure a server connexion? (y/N)" server_connexion
case $server_connexion in 
    [yY][eE][sS]|[yY]) 
        read -p "Please provide template path" template_path
        sed -e "s/%USER%/$USER/g" $template_path > $HOME/.ssh/config
        echo "Server connexion configuration is complete" ;;
    *) echo "Server configuration aborted"
    exit 0 ;;
esac

test(){
    echo "Starting configuration for connexion to servers"
    read -p "Do you want to configure a server connexion? (y/N)" server_connexion
    case $server_connexion in 
        [yY][eE][sS]|[yY]) 
            read -p "Please provide template path " template_path
            sed -e "s/%USER%/$USER/g" $template_path > $HOME/.ssh/config \
            && echo "Server connexion configuration is complete" \
            || echo "Server connexion configuration failed";;
        *) echo "Server configuration aborted" ;;
    esac
}
