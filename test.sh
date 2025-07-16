#!/bin/bash
set -e

echo "Удаляем plasma 6 и qt6..."
sudo pacman -Rdd --noconfirm plasma-desktop plasma-workspace plasma-wayland-session kwin kde-cli-tools kscreen systemsettings plasma-pa plasma-nm konsole dolphin \
$(pacman -Qq | grep -E '^qt6|^kf6|libplasma6' || true)

echo "Очищаем сироты..."
sudo pacman -Rns --noconfirm $(pacman -Qdtq || true)

echo "Скачиваем пакеты plasma 5.27.10..."

PKGS=(
  "plasma-desktop-5.27.10-1-x86_64.pkg.tar.zst"
  "plasma-workspace-5.27.10-1-x86_64.pkg.tar.zst"
  "kwin-5.27.10-1-x86_64.pkg.tar.zst"
  "kde-cli-tools-5.27.10-1-x86_64.pkg.tar.zst"
  "kscreen-5.27.10-1-x86_64.pkg.tar.zst"
  "systemsettings-5.27.10-1-x86_64.pkg.tar.zst"
  "plasma-pa-5.27.10-1-x86_64.pkg.tar.zst"
  "plasma-nm-5.27.10-1-x86_64.pkg.tar.zst"
  "konsole-23.08.4-1-x86_64.pkg.tar.zst"
  "dolphin-23.08.4-1-x86_64.pkg.tar.zst"
)

mkdir -p ~/plasma5 && cd ~/plasma5

BASE_URL="https://archive.archlinux.org/packages"

for pkg in "${PKGS[@]}"; do
  letter=${pkg:0:1}
  echo "Скачиваем $pkg"
  wget "$BASE_URL/$letter/${pkg%%-*}/$pkg" --show-progress
done

echo "Устанавливаем plasma 5..."
sudo pacman -U --noconfirm *.pkg.tar.zst

echo "Блокируем обновления plasma 5..."
sudo sed -i '/^IgnorePkg/d' /etc/pacman.conf
echo "IgnorePkg = plasma-desktop plasma-workspace kwin kde-cli-tools kscreen systemsettings plasma-pa plasma-nm konsole dolphin" | sudo tee -a /etc/pacman.conf

echo "Устанавливаем sddm и xorg..."
sudo pacman -S --noconfirm sddm xorg-server xdg-desktop-portal-kde

echo "Включаем sddm..."
sudo systemctl enable sddm

echo "Готово! Перезагрузи систему и заходи в Plasma 5."
