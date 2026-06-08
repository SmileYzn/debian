#!/bin/bash

# Limpar
clear

# Usuário padrão (UID 1000)
USUARIO=$(id -nu 1000)

# Verificar acesso root
if [[ $EUID -eq 0 ]]; then
    echo -e "Esse script NÃO deve ser executado como ${USER}"
    exit
fi

# Abrir pasta do usuário
cd /home/$USUARIO

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
sudo apt upgrade -y

# Pacotes Base
sudo apt install -y --no-upgrade 7zip alsa-firmware bash-completion fastfetch fwupd ffmpegthumbnailer git man-db power-profiles-daemon powertop unace unzip unrar xz-utils zip

# Pacotes XDG 
sudo apt install -y --no-upgrade xdg-user-dirs-gtk xdg-desktop-portal-gnome xdg-utils

# Bluetoth, CUPS
sudo apt install -y --no-upgrade bluez cups

# Bluetoth, CUPS
sudo systemctl enable bluetooth cups touchegg

# NTFS, CIFS, GVFS, EXFAT
sudo apt install -y --no-upgrade cifs-utils ntfs-3g exfatprogs exfat-fuse gvfs gvfs-backends gvfs-fuse

# Fontes adicionais
sudo apt install -y --no-upgrade fonts-adobe-sourcesans3 fonts-noto fonts-firacode fonts-open-sans fonts-roboto fonts-ubuntu

# Atualizar cache
sudo fc-cache -f -v

# GNOME Shell
sudo apt install -y --no-upgrade adwaita-icon-theme gnome-shell-extensions-common gnome-sushi gnome-tweaks

# NAUTILUS
sudo apt install -y --no-upgrade seahorse-nautilus

# Firefox
sudo apt install -y --no-upgrade firefox-esr firefox-esr-l10n-pt-br

# Fim
exit
