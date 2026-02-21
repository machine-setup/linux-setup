#!/bin/bash

cd "$(dirname "$0")"

cp .tmux.conf ~/.tmux.conf
cp .vimrc ~/.vimrc
cp .config.fish ~/.config.fish

# Install cli tools when using Ubuntu
# if command -v apt &>/dev/null; then
#   sudo apt update
#   sudo apt install -y zsh tmux ripgrep

#   curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz
#   sudo rm -rf /opt/nvim
#   sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
#   echo 'export PATH=/opt/nvim-linux-x86_64/bin:$PATH' >> ~/.zshrc
# fi
