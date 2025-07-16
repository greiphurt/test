#!/bin/bash
set -e

echo "📦 добавляем репозиторий с Plasma 5.27.10..."
echo "
[plasma5]
SigLevel = Optional TrustAll
Server = https://kde.legacy.packages.repo/arch/\$arch
" | sudo tee -a /etc/pacman.conf

echo "🔄 обновляем списки пакетов..."
sudo pacman -Sy

echo "📥 устанавливаем Plasma 5.27.10..."
sudo pacman -S --noconfirm plasma-desktop dolphin konsole kwin systemsettings sddm xorg-server

echo "🛑 блокируем обновление Plasma 5..."
sudo sed -i '/^IgnorePkg/ d' /etc/pacman.conf
echo "IgnorePkg = plasma-desktop dolphin konsole kwin systemsettings" | sudo tee -a /etc/pacman.conf

echo "🚀 включаем sddm..."
sudo systemctl enable sddm

echo "✅ Установка завершена! Перезагрузи систему и наслаждайся Plasma 5 🎉"
