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

# ??
sudo apt install -y git

# Fim
exit
