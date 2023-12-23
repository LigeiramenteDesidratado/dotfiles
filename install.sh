#!/bin/sh

set -xe

CURRENT_DIR=$(pwd)

ln -sf "$CURRENT_DIR/.aliases" "$HOME/"
ln -sf "$CURRENT_DIR/.xinitrc" "$HOME/"
ln -sf "$CURRENT_DIR/.bashrc" "$HOME/"
ln -sf "$CURRENT_DIR/.vimrc" "$HOME/"
ln -sf "$CURRENT_DIR/.taskrc" "$HOME/"
ln -sf "$CURRENT_DIR/.tmux.conf" "$HOME/"

ln -sf "$CURRENT_DIR/.config/ncmpcpp" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/sxiv" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/vifm" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/zathura" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/nvim" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/mpv" "$HOME/.config/"
ln -sf "$CURRENT_DIR/.config/mpd" "$HOME/.config/"

ln -sf "$CURRENT_DIR/.config/emoji" "$HOME/.config/"
