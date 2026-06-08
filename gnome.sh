#!/bin/bash

# Limpar
clear

# Verificar se quem executou o script foi o usuário root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "Esse script DEVE ser executado com o usuário root"
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
apt full-upgrade -y

# Pacotes Base
apt install -y --no-upgrade 7zip alsa-firmware bash-completion curl fastfetch firmware-linux fwupd ffmpegthumbnailer git intel-microcode man-db power-profiles-daemon powertop unace unzip unrar wget xz-utils zip

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

# GNOME Core Apps
apt install -y --no-upgrade e baobab dconf-editor decibels file-roller gnome-backgrounds gnome-calculator gnome-calendar gnome-characters gnome-disk-utility gnome-font-viewer gnome-online-accounts gnome-system-monitor loupe seahorse showtime simple-scan

# NAUTILUS
apt install -y --no-upgrade seahorse-nautilus

# Firefox
apt install -y --no-upgrade firefox-esr firefox-esr-l10n-pt-br

# Fim
exit 0
