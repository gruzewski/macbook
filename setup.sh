#!/usr/bin/env bash

read -p "ℹ️  Grant Terminal Full Disk Access in System Preferences > Security & Privacy > Privacy..."

if [[ $(uname -m) == 'arm64' ]]; then
  softwareupdate --install-rosetta --agree-to-license
  PREFIX=/opt/homebrew
else
  PREFIX=/usr/local
fi
PATH=$PREFIX/bin:$PATH
BIN_PATH=$PREFIX/bin
OPT_PATH=$PREFIX/opt

# SSH key
if [[ ! -f "~/.ssh/id_rsa.pub" ]]; then
  ssh-keygen -t rsa
  echo "ℹ️  Please add this public key to GitHub: https://github.com/account/ssh"
  cat ~/.ssh/id_rsa.pub
  echo
fi

# Xcode
xcode-select --install

# Homebrew
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Log in to the App Store
open -a "App Store"
read -p "ℹ️  Log in to the App Store and press any key..."

# Install Casks that require a password
brew install --cask docker zoom

# Install Brews, Casks and MAS apps
brew install mas
brew bundle

# Setup version manager
source $OPT_PATH/asdf/libexec/asdf.sh

# Install Python
asdf plugin-add python
PYTHON3_VERSION=$(asdf list-all python | grep -v '[a-z]' | grep '^3' | tail -1)
asdf install python $PYTHON3_VERSION
asdf global python $PYTHON3_VERSION

# Install Poetry
asdf plugin-add poetry
POETRY_VERSION=$(asdf list-all poetry | tail -1)
asdf install poetry $POETRY_VERSION

# Install Kubectl
asdf plugin-add kubectl
KUBECTL_VERSION=$(asdf list-all kubectl | tail -1)
asdf install kubectl $KUBECTL_VERSION

# Install Terraform
asdf plugin-add terraform
TERRAFORM_VERSION=$(asdf list-all terraform | grep -v '[a-z]' | tail -1)
asdf install terraform $TERRAFORM_VERSION

# Install Rust
asdf plugin-add rust
RUST_VERSION=$(asdf list-all rust | grep -v '[a-z]' | tail -1)
asdf install rust $RUST_VERSION

# Install packages
pip3 install pylint

# Rust
sudo mkdir /opt/cargo && sudo chown jacek:admin /opt/cargo
RUSTFLAGS="-C link-arg=/opt/homebrew/opt/libyaml/lib/libyaml.a" cargo install pyoxidizer --root /opt/cargo/ --force

# zsh shell
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
omz update
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp .zshrc ~/.zshrc
source ~/.zshrc

# Show ~/Library folder
setfile -a v ~/Library
chflags nohidden ~/Library

# Customise Dock
dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/1Password.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Signal.app"
dockutil --no-restart --add "/Applications/DevUtils.app"
dockutil --no-restart --add "/Applications/Obsidian.app"

killall Dock

# Defaults
./defaults.sh

# Add Go2Shell to Finder
./defaults/finder.sh

# Other defaults
./defaults/other.sh

# Set default file handlers
duti handlers.duti

# Create locate database
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# Set default DNS
networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001

# Starting CopyClip
open -a "CopyClip"
read -p "ℹ️  Start CopyCut on startup and press any key..."

# Starting CleanShot
open -a "CleanShot X"
read -p "ℹ️  Activate CleanShot and press any key..."

# Starting Docker
open -a "Docker"
read -p "ℹ️  Configure and log in to Docker and press any key..."

echo -e "\033[1mFinal Steps\033[0m"

cat << EOF
macOS
- Log in to iCloud
- Set resolution to 'More Space' in System Preferences > Displays
- Change appearance to dark
Chrome
- Sign in
Visual Studio Code
- Turn on Settings Sync
Accounts
- Sign in to 1Password
- Sign in to Slack
- Sign in to Spotify
EOF
