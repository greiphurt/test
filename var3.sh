#!/bin/bash

set -e

echo "🧨 удаляем plasma 6, qt6 и сиротки..."
sudo pacman -Rns $(pacman -Qq | grep -E '^plasma|^kde|^qt6|^kf6|^kwin|^konsole|^dolphin') --noconfirm || true
sudo pacman -Rns $(pacman -Qdtq) --noconfirm || true

echo "🔑 подключаем chaotic-aur..."
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/chaotic-keyring.git
cd chaotic-keyring && makepkg -si --noconfirm
cd ..
git clone https://aur.archlinux.org/chaotic-mirrorlist.git
cd chaotic-mirrorlist && makepkg -si --noconfirm

echo "📦 добавляем репозиторий chaotic-aur в pacman.conf..."
sudo bash -c 'echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf'
sudo pacman -Sy

echo "🖥️ ставим Plasma 5.27.10..."
sudo pacman -S plasma5-desktop dolphin5 konsole5 sddm5 plasma5-pa plasma5-nm systemsettings5 kscreen5 kde-cli-tools5 --noconfirm

echo "🚀 включаем sddm..."
sudo systemctl enable sddm

echo "✅ Установка завершена! Перезагрузи систему 🎉"
