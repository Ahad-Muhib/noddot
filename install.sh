#!/bin/bash

echo "Installing packages..."
sudo pacman -S --needed - < pkglist.txt

echo "Copying configs..."
cp -r hypr ~/.config/
cp -r systemd/user ~/.config/systemd/

echo "Enabling services..."
systemctl --user daemon-reload
systemctl --user enable auto-rotate.service

echo "Setup complete!"
