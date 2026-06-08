#!/bin/bash

# Limpar
clear

# Usuário padrão (UID 1000)
USUARIO=$(id -nu 1000)

# Abrir pasta do usuário padrão da instalação debian
cd /home/$USUARIO

# Verificar se quem executou o script foi o usuário root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "Esse script DEVE ser executado com o usuário root"
    exit 1
fi

# Adicionar contrib non-free-firmware
set -e

if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    sed -i \
        's/^Components:.*/Components: main contrib non-free non-free-firmware/' \
        /etc/apt/sources.list.d/debian.sources
else
    sed -Ei \
        's#^(deb(-src)? .+ trixie(-security|-updates)? main).*$#\1 contrib non-free non-free-firmware#' \
        /etc/apt/sources.list
fi

# Atualizar Respositórios
apt update

# Atualizar Sistema
apt upgrade -y

# Pacotes Base
apt install -y --no-upgrade 7zip alsa-firmware bash-completion curl fastfetch firmware-linux fwupd ffmpegthumbnailer git man-db power-profiles-daemon powertop unace unzip unrar wget xz-utils zip

# Pacotes XDG 
apt install -y --no-upgrade xdg-user-dirs-gtk xdg-desktop-portal-gnome xdg-utils

# Bluetoth, CUPS
apt install -y --no-upgrade bluez cups

# Bluetoth, CUPS
systemctl enable bluetooth cups

# NTFS, CIFS, GVFS, EXFAT
apt install -y --no-upgrade cifs-utils ntfs-3g exfatprogs exfat-fuse gvfs gvfs-backends gvfs-fuse

# Fontes adicionais
apt install -y --no-upgrade fonts-adobe-sourcesans3 fonts-noto fonts-firacode fonts-open-sans fonts-roboto fonts-ubuntu

# Atualizar cache
fc-cache -f -v

# GNOME Shell
apt install -y --no-upgrade adwaita-icon-theme gnome-shell-extensions-common gnome-sushi gnome-tweaks

# NAUTILUS
apt install -y --no-upgrade seahorse-nautilus

# Firefox
apt install -y --no-upgrade firefox-esr firefox-esr-l10n-pt-br

# Fim
exit 0
