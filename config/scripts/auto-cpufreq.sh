#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

cd /tmp

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq

rpm-ostree install python-devel dmidecode gcc cairo-devel gobject-introspection-devel cairo-gobject-devel gtk3-devel

# Setup venv
venv_dir=/opt/auto-cpufreq/venv
mkdir -p "${venv_dir}"
python3 -m venv "${venv_dir}"

source "${venv_dir}/bin/activate"
python3 -m pip install --upgrade pip wheel

# Install pacakge
git config --global --add safe.directory $(pwd)
python -m pip install .
mkdir -p /usr/local/share/auto-cpufreq/
cp -r scripts/ /usr/local/share/auto-cpufreq/
cp -r images/ /usr/local/share/auto-cpufreq/
cp images/icon.png /usr/share/pixmaps/auto-cpufreq.png
cp scripts/org.auto-cpufreq.pkexec.policy /usr/share/polkit-1/actions
cp scripts/auto-cpufreq.service /etc/systemd/system

cp scripts/auto-cpufreq-venv-wrapper /usr/local/bin/auto-cpufreq
cp scripts/start_app /usr/local/bin/auto-cpufreq-gtk
chmod a+x /usr/local/bin/auto-cpufreq
chmod a+x /usr/local/bin/auto-cpufreq-gtk

desktop-file-install --dir=/usr/share/applications scripts/auto-cpufreq-gtk.desktop
update-desktop-database /usr/share/applications