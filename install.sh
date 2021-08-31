#!/bin/bash
export DEBIAN_FRONTEND="noninteractive"
shopt -s dotglob

echo " ========================================="
echo " =  Workspace preparing...               ="
echo " =  Installing apps, utils and many more ="
echo " ========================================="

DOTFILES=$(pwd)
echo "  dotfiles located at: $DOTFILES"
echo "  home     located at: $HOME"

echo " -> Copying local and config... "
mkdir -p $HOME/.local
cp -R $DOTFILES/local/* $HOME/.local
cp -R $DOTFILES/config/* $HOME/.config


echo " -> Updating & Upgrading... "
sudo apt-get update --yes
sudo apt-get upgrade --yes

echo " -> Installing packages... "
sudo apt-get install --yes zsh neofetch htop curl wget zip unzip sed mc micro python3 python3-pip httpie git gpg tmux nano vim || {
    echo " ERROR: Failed to install packages: $?"
    exit 1
}

echo " -> Installing oh-my-zsh..."
(sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch) || {
    echo " Warning: Oh-My-Zsh Installation failed "
}

echo " -> Installing nvm..."
(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash) || {
    echo " Warning: nvm Installation failed "
}
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


echo " -> Installing sdkman..."
(curl -s "https://get.sdkman.io" | bash) || {
    echo " Warning: nvm Installation failed "
}
source "$HOME/.sdkman/bin/sdkman-init.sh"


echo " -> autorun.sh "
source $HOME/.local/autorun.sh


echo " -> Installing node 14..."
nvm install 14 --default --latest-npm || {
    echo " Warning: node 14 Installation failed "
}

echo "->  Installing java 11"
sdk install java 11.0.12-librca || {
    echo " Warning: java 11.0.12-librca Installation failed "
}

echo " -> Trying to install yarn... "
nvm exec 14 npm i -g yarn

echo " -> Set shell to zsh"
sudo chsh --shell $(which zsh) $USER

echo " -> Copying files"
cp -R $DOTFILES/files/* $HOME

echo " Prepare done"
