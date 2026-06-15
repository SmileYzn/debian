#!/bin/bash

# Limpar
clear

# Verificar se quem executou o script foi o usuário root
if [ "$(id -u)" -eq 0 ]; then
    echo -e "Não execute esse script como usuário root."
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "O pacote sudo não está instalado."
    exit 1
fi

# Usuário padrão (UID 1000)
USUARIO=$(id -nu 1000 2>/dev/null)

# Abrir pasta do usuário padrão da instalação Debian
if [ -z "$USUARIO" ]; then
    echo "Não foi possível localizar o usuário UID 1000."
    exit 1
fi

# Abre a pasta, ou sair se a pasta do usuário não existir
cd "/home/$USUARIO" || exit 1

# Adicionar contrib non-free-firmware
set -e

if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sudo sed -i \
        's/^Components:.*/Components: main contrib non-free non-free-firmware/' \
        /etc/apt/sources.list.d/debian.sources
else
    sudo sed -Ei \
        's#^(deb(-src)? .+ trixie(-security|-updates)? main).*$#\1 contrib non-free non-free-firmware#' \
        /etc/apt/sources.list
fi

# Atualizar Respositórios
sudo apt update

# Atualizar Sistema
sudo apt full-upgrade -y

# Pacotes Base
sudo apt install -y --no-upgrade 7zip alsa-firmware bash-completion curl fastfetch firmware-linux fwupd ffmpegthumbnailer git intel-microcode man-db power-profiles-daemon powertop unace unzip unrar wget xz-utils zip

# Pacotes XDG 
sudo apt install -y --no-upgrade xdg-user-dirs-gtk xdg-desktop-portal-gnome xdg-utils

# Bluetoth
sudo apt install -y --no-upgrade bluez

# Bluetoth
sudo systemctl enable bluetooth

# NTFS, CIFS, GVFS, EXFAT
sudo apt install -y --no-upgrade cifs-utils ntfs-3g exfatprogs exfat-fuse gvfs gvfs-backends gvfs-fuse

# Fontes adicionais
sudo apt install -y --no-upgrade fonts-adobe-sourcesans3 fonts-noto fonts-firacode fonts-open-sans fonts-roboto fonts-ubuntu

# GNOME Shell
sudo apt install -y --no-upgrade adwaita-icon-theme gnome-shell-extensions-common gnome-sushi gnome-tweaks

# GNOME Core Apps
sudo apt install -y --no-upgrade baobab dconf-editor file-roller gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-disk-utility gnome-font-viewer gnome-online-accounts gnome-system-monitor loupe seahorse showtime simple-scan

# NAUTILUS
sudo apt install -y --no-upgrade seahorse-nautilus

# Firefox
sudo apt install -y --no-upgrade firefox-esr firefox-esr-l10n-pt-br

# Adicionar grupo autologin
sudo sudo groupadd -r autologin

# Adicionar o usuário ao grupo
sudo sudo gpasswd autologin -a ${USUARIO}

# Abrir pasta do usuário
cd /home/$USUARIO

# Criar pastas padrão
xdg-user-dirs-update

# Criar pastas
mkdir Desktop Documentos Downloads Imagens Modelos Músicas Projetos Rede Vídeos

xdg-user-dirs-update --force --set DESKTOP /home/$USUARIO/Desktop
xdg-user-dirs-update --force --set DOCUMENTS /home/$USUARIO/Documentos
xdg-user-dirs-update --force --set DOWNLOAD /home/$USUARIO/Downloads
xdg-user-dirs-update --force --set PICTURES /home/$USUARIO/Imagens
xdg-user-dirs-update --force --set TEMPLATES /home/$USUARIO/Modelos
xdg-user-dirs-update --force --set MUSIC /home/$USUARIO/Músicas
xdg-user-dirs-update --force --set PROJECTS /home/$USUARIO/Projetos
xdg-user-dirs-update --force --set PUBLICSHARE /home/$USUARIO/Rede
xdg-user-dirs-update --force --set VIDEOS /home/$USUARIO/Vídeos

# Atualizar pastas padrão
xdg-user-dirs-update

# Remover pastas antigas
rm -rf Documents Music Pictures Public Projects Templates Videos

# Fim
exit 0
