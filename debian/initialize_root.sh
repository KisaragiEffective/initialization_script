#!/bin/sh

# remove pre-installed and never used package
sudo apt -y remove libreoffice-* nano ibus-* anthy-* uim-* pluma
sudo apt -y autoremove

# upgrade firefox-esr
sudo apt -y upgrade
sudo apt -y install \
  vim \
  neofetch \
  fcitx-mozc \
  libnvidia-ml-dev \
  libssl-dev \
  nvidia-driver-libs:i386 \
  xclip \
  jq \
  nvidia-driver \
  pavucontrol \
  fcitx-mozc

# setup custom APT repository
# setup mono
sudo apt -y install apt-transport-https dirmngr gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/debian stable-buster main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

# setup adoptium (JDK)
sudo apt install -y wget apt-transport-https
sudo mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo tee /etc/apt/keyrings/adoptium.asc >/dev/null
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" \
  | tee /etc/apt/sources.list.d/adoptium.list

# setup vscode
sudo apt-get -y install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt -y install apt-transport-https

# end setup custom APT repository
sudo apt update
sudo apt -y install mono-devel temurin-17-jdk code

# setup ja_JP
sudo apt-get update
sudo apt-get install locales -y
# uncomment
sudo sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=ja_JP.UTF-8

# download Discord@latest (they bump its version eventually)
DISCORD_TEMP=$(mktemp)
curl -sSL 'https://discord.com/api/download?platform=linux&format=deb' > $DISCORD_TEMP
sudo apt install $DISCORD_TEMP
rm $DISCORD_TEMP
unset $DISCORD_TEMP

