#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'Installing extensions'

cd /tmp

git clone https://gitlab.com/arcmenu/ArcMenu.git
cd ArcMenu
make DESTDIR=/ install
cd ..

git clone https://github.com/theychx/WorkspaceSwitcherWrapAround.git
mkdir /usr/share/gnome-shell/extensions/WorkspaceSwitcherWrapAround
cp WorkspaceSwitcherWrapAround/src* /usr/share/gnome-shell/extensions/WorkspaceSwitcherWrapAround

git clone https://github.com/ethnarque/gnome-disable-workspace-animation.git
cp -r gnome-disable-workspace-animation/disable-workspace-animation@ethnarque /usr/share/gnome-shell/extensions

git clone https://github.com/cleardevice/gnome-disable-workspace-switcher.git
cp -r gnome-disable-workspace-switcher/disable-workspace-switcher-overlay@cleardevice /usr/share/gnome-shell/extensions
