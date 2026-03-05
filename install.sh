#!/usr/bin/env bash
set -e

echo "Installing dependencies..."

sudo pacman -S --needed --noconfirm hyprland hyprpaper waybar kitty rofi-wayland xdg-desktop-portal-hyprland polkit-kde-agent networkmanager ly fastfetch ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts noto-fonts-emoji pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils pamixer brightnessctl grim slurp wl-clipboard xdg-user-dirs xdg-utils neovim git unzip fish

echo "Enabling services..."
sudo systemctl enable NetworkManager
sudo systemctl enable ly@tty1.service

echo "Installing Paru (AUR helper)..."
if ! command -v paru >/dev/null 2>&1; then
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si --noconfirm
cd -
rm -rf /tmp/paru
fi

echo "Installing the browser"
paru -S librewolf-bin

echo "Setting Fish as default shell..."
chsh -s /usr/bin/fish

echo "Creating config directories..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar

echo "Installing wallpaper..."
sudo mkdir -p /usr/share/backgrounds
sudo cp assets/astolfo.png /usr/share/backgrounds/astolfo.png

echo "Hyprpaper config..."
cat > ~/.config/hypr/hyprpaper.conf <<EOF
wallpaper {
  monitor =
  path = /usr/share/backgrounds/astolfo.png
  fit_mode = cover
}
EOF

echo "Hyprland config..."
cat > ~/.config/hypr/hyprland.conf <<EOF
monitor=,preferred,auto,1

exec-once = hyprpaper
exec-once = waybar
exec-once = polkit-kde-authentication-agent-1

bind = SUPER, RETURN, exec, kitty
bind = SUPER, Q, killactive
bind = SUPER, E, exec, rofi -show drun
bind = SUPER, F, exec, librewolf
bind = SUPER, M, exit
EOF

echo "Installing Waybar config..."
cp waybar/config.jsonc ~/.config/waybar/config
cp waybar/style.css ~/.config/waybar/style.css

echo "Creating pacman monster alias..."
alias -s monster="sudo pacman"


echo "Astolfo Hyprland setup complete!"
echo "Reboot and login with Ly."
