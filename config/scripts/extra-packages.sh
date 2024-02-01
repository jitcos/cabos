#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

wget https://copr.fedorainfracloud.org/coprs/kylegospo/prompt/repo/fedora-$(rpm -E %fedora)/kylegospo-prompt-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-prompt.repo
rpm-ostree override replace \
  --experimental \
  --from repo=copr:copr.fedorainfracloud.org:kylegospo:prompt \
      vte291 \
      vte-profile
rpm-ostree install prompt
rm -f /etc/yum.repos.d/_copr_kylegospo-prompt.repo

rpm-ostree uninstall gnome-extensions-app

wget https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -O /tmp/docker-compose && \
  install -c -m 0755 /tmp/docker-compose /usr/bin