#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

cd /tmp

# Download oh-my-zsh into skel directory
git clone https://github.com/ohmyzsh/ohmyzsh.git /usr/etc/skel/.oh-my-zsh
mkdir -p /usr/etc/skel/.config/contexts/localhost
cp /usr/etc/skel/.oh-my-zsh/templates/zshrc.zsh-template /usr/etc/skel/.config/contexts/localhost/.zshrc