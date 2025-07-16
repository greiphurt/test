#!/bin/bash

set -e

# проверка, что установлен downgrade
if ! command -v downgrade &>/dev/null; then
  echo "❌ пакет downgrade не найден! Установи через: sudo pacman -S downgrade"
  exit 1
fi

echo "🧹 удаляем plasma 6, qt6 и прочее..."

sudo pacman -Rns plasma-desktop plasma-workspace plasma-wayland-session kwin kwin-effects-handbook kde-cli-tools kscreen systemsettings plasma-pa plasma-nm konsole dolphin sddm --noconfirm || true
sudo pacman -Rns $(pacman -Qdtq) --noconfirm || true

echo "📦 начинаем откат пакетов..."

# массив пакетов с версиями, которые нужно поставить (пример)
declare -A packages=(
  [qt5-base]="5.15.8-19"
  [qt5-declarative]="5.15.8-19"
  [qt5-quickcontrols2]="5.15.8-19"
  [kf5-frameworkintegration]="5.108.0-1"
  [kf5-kcoreaddons]="5.108.0-1"
  [kf5-kwindowsystem]="5.108.0-1"
  [kf5-kirigami2]="5.108.0-1"
  [plasma-desktop]="5.27.10-1"
  [plasma-workspace]="5.27.10-1"
  [kwin]="5.27.10-1"
  [konsole]="23.08.4-1"
  [dolphin]="23.08.4-1"
  [sddm]="0.20.1-2"
  # добавь сюда остальные зависимости по потребности
)

for pkg in "${!packages[@]}"; do
  ver="${packages[$pkg]}"
  echo "⬇️ ставим $pkg версии $ver"
  sudo downgrade -r "$ver" "$pkg" --noconfirm
done

echo "🚀 включаем sddm..."
sudo systemctl enable sddm

echo "✅ Plasma 5 и зависимости установлены! Перезагрузи систему."
