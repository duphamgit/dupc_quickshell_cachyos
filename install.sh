#!/bin/bash

# Dừng script nếu có lỗi xảy ra
set -e

echo "🚀 --- Bắt đầu quá trình cài đặt Dotfiles cho CachyOS ---"

# 1. Cập nhật hệ thống
echo "🔄 Đang cập nhật hệ thống..."
sudo pacman -Syu --noconfirm

# 2. Kiểm tra và cài đặt các gói phần mềm từ pkglist.txt
if [ -f "pkglist.txt" ]; then
    echo "📦 Đang cài đặt các phần mềm từ danh sách pkglist.txt..."
    # Ưu tiên dùng paru để cài cả gói repo chính và AUR
    if command -v paru &> /dev/null; then
        paru -S --needed --noconfirm - < pkglist.txt
    else
        sudo pacman -S --needed --noconfirm - < pkglist.txt
    fi
else
    echo "⚠️ Không tìm thấy pkglist.txt! Sẽ cài các gói cơ bản..."
    sudo pacman -S --needed --noconfirm chromium fcitx5-unikey fcitx5-im fcitx5-configtool fcitx5-bamboo ttf-dejavu ttf-liberation noto-fonts
fi

# 3. Cấu hình biến môi trường cho tiếng Việt (Fcitx5)
echo "🇻🇳 Đang thiết lập cấu hình gõ tiếng Việt..."
ENV_FILE="/etc/environment"
IF_CONFIG_EXISTS=$(grep "GTK_IM_MODULE=fcitx" $ENV_FILE || true)

if [ -z "$IF_CONFIG_EXISTS" ]; then
    sudo sh -c "echo 'GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx' >> $ENV_FILE"
    echo "✅ Đã cập nhật /etc/environment"
else
    echo "ℹ️ Cấu hình tiếng Việt đã tồn tại, bỏ qua."
fi

# 4. Tạo Symlink cho Quickshell
echo "🔗 Liên kết file cấu hình Quickshell..."
mkdir -p ~/.config/quickshell

# Lấy đường dẫn tuyệt đối của thư mục hiện tại
DOTFILES_DIR=$(pwd)
ln -sf "$DOTFILES_DIR/shell.qml" ~/.config/quickshell/
