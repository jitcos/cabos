<p align="center">
  <img src="https://repository-images.githubusercontent.com/745253072/06f1c924-1a75-4feb-b024-90fb678ee515">
</p>

<p align="center">
  <img src="https://github.com/jitcos/cabos/actions/workflows/build.yml/badge.svg">
</p>

# About & Inspirations

My spin based on [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/), which is derived from the amazing [Universal Blue](https://universal-blue.org/images/main/) project. This image is created with [BlueBuild](https://blue-build.org/) tooling for making & maintaining container-based Linux desktop images.

cabos is inspired and borrows heavily from [Bluefin-DX](https://projectbluefin.io) and [gidro-os](https://github.com/fiftydinar/gidro-os).

The main idea is to have an up-to-date, stable, and pre-configured base OS, and to use customized containers with Distrobox to do development work within it. You can see an example of a base Ubuntu container to get started with [here](https://github.com/jitcos/jetskis).

ZSH is configured to use [oh-my-zsh](https://ohmyz.sh/) by default, but customizing the config has changed a little. If you use an Distrobox based on [Jetskis](https://github.com/jitcos/jetskis), you can share zsh between the two, but also have seperate options as well:

By default, your new `.zshrc` config for your machine will be located at `~/.config/contexts/localhost/.zshrc`. The default config for each Distrobox will be located in `~/.config/contexts/container-name/.zshrc`. To have shared config across both localhost and Distrobox containers, create a new config ending in `.zsh` here: `~/.config/contexts/config.d/`. Please note, it is not recommended to modify the base `~/.zshrc` file since it will source the appropriate files for whatever you're running at the time.

Running `SETUP_DEV_TOOLS=true distrobox enter jetskis` will setup nvm and pyenv in your container. You can modify the `~/.zshrc` file if you want to install other packages.

# Modifications

Removed packages (RPMs):
* Firefox
* htop
* nvtop (Except for Nvidia images)
* Gnome Software rpm-ostree package (not needed since we use rpm-ostree auto-updater)
* Gnome classic session
* Gnome Tour
* Gnome Initial Setup
* Gnome System Monitor
* Gnome system extensions
* Gnome Tweaks
* Gnome Terminal

Installed packages (RPMs):
* [System76 Scheduler](https://github.com/pop-os/system76-scheduler)
* [System76 Power Management](https://github.com/pop-os/system76-power)
* Android Tools (adb & fastboot)
* Zsh
* Mosh
* Micro
* [Gnome Boxes](https://apps.gnome.org/Boxes/)
* [VS Code](https://code.visualstudio.com/)
* p7zip & p7zip-plugins
* Podman
* Docker CE
* playerctl
* Samba
* Qemu

Installed akmods:
* [V4L2-loopback](https://github.com/umlaeute/v4l2loopback) (for allowing change of behavior for universal screensharing)
* [XOne](https://github.com/medusalix/xone) (Xbox One RF driver)
* [XPadNeo](https://github.com/atar-axis/xpadneo) (Xbox One Bluetooth driver)
* [WineSync](https://github.com/Cat-Lady/winesync-dkms/blob/main/README.md) (for possibly improving Windows apps performance)

Installed extensions:
* [Blur My Shell](https://github.com/aunetx/blur-my-shell)
* [Caffeine](https://github.com/eonpatapon/gnome-shell-extension-caffeine)
* [Hide Universal Access](https://extensions.gnome.org/extension/2398/hide-universal-access/)
* [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
* [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/)
* [AppIndicator Support](https://extensions.gnome.org/extension/615/appindicator-support/)
* [s76-scheduler](https://github.com/mjakeman/s76-scheduler-plugin)
* [Start Overlay in Application View](https://github.com/Hexcz/Start-Overlay-in-Application-View-for-Gnome-40-)
* [WorkspaceSwitcherWrapAround](https://github.com/theychx/WorkspaceSwitcherWrapAround)
* [disable-workspace-animation](https://github.com/ethnarque/gnome-disable-workspace-animation)
* [disable-workspace-switcher](https://github.com/cleardevice/gnome-disable-workspace-switcher)
* [Hibernate Status Button](https://extensions.gnome.org/extension/755/hibernate-status-button/)

Installed flatpaks:
* [Firefox](https://flathub.org/apps/org.mozilla.firefox) from Flathub instead of the system package
* [Mission Center](https://flathub.org/apps/io.missioncenter.MissionCenter) from Flathub instead of Gnome System Monitor
* [Konsole](https://flathub.org/apps/org.kde.konsole) Has font ligatures support
* [Calculator](https://apps.gnome.org/en/Calculator/)
* [Calendar](https://apps.gnome.org/en/Calendar/)
* [Camera](https://apps.gnome.org/en/Snapshot/)
* [Contacts](https://apps.gnome.org/en/Contacts/)
* [Clocks](https://apps.gnome.org/en/Clocks/)
* [Document Viewer](https://apps.gnome.org/en/Evince/)
* [Text Editor](https://apps.gnome.org/en/TextEditor/)
* [G4Music](https://flathub.org/apps/com.github.neithern.g4music)
* [Clapper](https://flathub.org/apps/com.github.rafostar.Clapper)
* [Image Viewer](https://apps.gnome.org/en/Loupe/)
* [Sticky Notes](https://flathub.org/apps/com.vixalien.sticky)
* [Flatseal](https://flathub.org/apps/com.github.tchx84.Flatseal)
* [Warehouse](https://flathub.org/apps/io.github.flattool.Warehouse)
* [PinApp](https://flathub.org/apps/io.github.fabrialberio.pinapp)
* [Extension Manager](https://flathub.org/apps/com.mattjakeman.ExtensionManager)
* [Blue Recorder](https://flathub.org/apps/sa.sy.bluerecorder)
* [Gear Lever](https://flathub.org/apps/it.mijorus.gearlever)

Optional flatpaks at first login:
* [Characters](https://flathub.org/apps/org.gnome.Characters)
* [Disk Usage Analyzer](https://flathub.org/apps/org.gnome.baobab)
* [Font Viewer](https://flathub.org/apps/org.gnome.font-viewer)
* [Logs](https://flathub.org/apps/org.gnome.Logs)
* [Maps](https://flathub.org/apps/org.gnome.Maps)
* [Photos (Organizer)](https://flathub.org/apps/org.gnome.Photos)
* [Sushi (Nautilus Previewer)](https://flathub.org/apps/org.gnome.NautilusPreviewer)
* [Weather](https://flathub.org/apps/org.gnome.Weather)
* [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter)
* [Font Downloader](https://flathub.org/apps/org.gustavoperedo.FontDownloader)
* [Brave Browser](https://flathub.org/apps/com.brave.Browser)
* [GNOME Web](https://flathub.org/apps/org.gnome.Epiphany)
* [Google Chrome](https://flathub.org/apps/com.google.Chrome)
* [Microsoft Edge](https://flathub.org/apps/com.microsoft.Edge)
* [Opera](https://flathub.org/apps/com.opera.Opera)
* [GNOME Builder](https://flathub.org/apps/org.gnome.Builder)
* [PyCharm (Community)](https://flathub.org/apps/com.jetbrains.PyCharm-Community)
* [PyCharm (Professional)](https://flathub.org/apps/com.jetbrains.PyCharm-Professional)
* [IntelliJ IDEA (Community)](https://flathub.org/apps/com.jetbrains.IntelliJ-IDEA-Community)
* [IntelliJ IDEA (Ultimate)](https://flathub.org/apps/com.jetbrains.IntelliJ-IDEA-Ultimate)
* [Webstorm](https://flathub.org/apps/com.jetbrains.WebStorm)
* [PhpStorm](https://flathub.org/apps/com.jetbrains.PhpStorm)
* [Rider](https://flathub.org/apps/com.jetbrains.Rider)
* [CLion](https://flathub.org/apps/com.jetbrains.CLion)
* [GoLand](https://flathub.org/apps/com.jetbrains.GoLand)
* [Android Studio](https://flathub.org/apps/com.google.AndroidStudio)
* [Sublime Text 3](https://flathub.org/apps/com.sublimetext.three)
* [Bruno](https://flathub.org/apps/com.usebruno.Bruno)
* [Insomnia](https://flathub.org/apps/rest.insomnia.Insomnia)
* [Postman](https://flathub.org/apps/com.getpostman.Postman)
* [Podman Desktop](https://flathub.org/apps/io.podman_desktop.PodmanDesktop)
* [Meld](https://flathub.org/apps/org.gnome.meld)
* [Spotify](https://flathub.org/apps/com.spotify.Client)
* [Pithos (Pandora)](https://flathub.org/apps/io.github.Pithos)
* [VLC](https://flathub.org/apps/org.videolan.VLC)
* [Kdenlive](https://flathub.org/apps/org.kde.kdenlive)
* [Shotcut](https://flathub.org/apps/org.shotcut.Shotcut)
* [Flowblade](https://flathub.org/apps/io.github.jliljebl.Flowblade)
* [OpenShot](https://flathub.org/apps/org.openshot.OpenShot)
* [Audacity](https://flathub.org/apps/org.audacityteam.Audacity)
* [GIMP](https://flathub.org/apps/org.gimp.GIMP)
* [Krita](https://flathub.org/apps/org.kde.krita)
* [Inkscape](https://flathub.org/apps/org.inkscape.Inkscape)
* [Figma](https://flathub.org/apps/io.github.Figma_Linux.figma_linux)
* [PrusaSlicer](https://flathub.org/apps/com.prusa3d.PrusaSlicer)
* [Cura](https://flathub.org/apps/com.ultimaker.cura)
* [FreeCAD](https://flathub.org/apps/org.freecadweb.FreeCAD)
* [OpenSCAD](https://flathub.org/apps/org.openscad.OpenSCAD)
* [Discord](https://flathub.org/apps/com.discordapp.Discord)
* [Telegram](https://flathub.org/apps/org.telegram.desktop)
* [WhatsApp](https://flathub.org/apps/io.github.mimbrero.WhatsAppDesktop)
* [Signal](https://flathub.org/apps/org.signal.Signal)
* [Slack](https://flathub.org/apps/com.slack.Slack)
* [Microsoft Teams](https://flathub.org/apps/com.github.IsmaelMartinez.teams_for_linux)
* [Bottles](https://flathub.org/apps/com.usebottles.bottles)
* [Lutris](https://flathub.org/apps/net.lutris.Lutris)
* [Heroic Launcher](https://flathub.org/apps/com.heroicgameslauncher.hgl)
* [Steam](https://flathub.org/apps/com.valvesoftware.Steam)
* [Gamescope](https://flathub.org/apps/org.freedesktop.Platform.VulkanLayer.gamescope)
* [MangoHUD](https://flathub.org/apps/org.freedesktop.Platform.VulkanLayer.MangoHud//22.08)
* [SteamTinkerLaunch](https://flathub.org/apps/com.valvesoftware.Steam.Utility.steamtinkerlaunch)
* [Proton Updater](https://flathub.org/apps/net.davidotek.pupgui2)
* [OnlyOffice](https://flathub.org/apps/org.onlyoffice.desktopeditors)
* [LibreOffice](https://flathub.org/apps/org.libreoffice.LibreOffice)
* [Obsidian](https://flathub.org/apps/md.obsidian.Obsidian)
* [Standard Notes](https://flathub.org/apps/org.standardnotes.standardnotes)
* [Thunderbird](https://flathub.org/apps/org.mozilla.Thunderbird)
* [OBS Studio](https://flathub.org/apps/com.obsproject.Studio)
* [Boatswain](https://flathub.org/apps/com.feaneron.Boatswain)

Settings applied by default:
* 4 static workspaces (dynamical workspaces disabled)
* Disabled workspaces only on primary monitor
* Disabled "hot corners"
* Disable middle-click paste
* Enable normal "Minimize, Maximize, and Close" buttons on application windows
* Use Alt+Left & Alt-Right to navigate workspaces
* Use Alt+, for Previous Track
* Use Alt+. for Next Track
* Use Alt+/ for Play/Pause
* Enabled two-finger scrolling
* Disabled "natural" scrolling direction
* Enabled tap-to-click
* Not using UI scaling - but set 1.5x font scaling
* Default to "dark" theme
* Enabled Night Light
* Enabled GSConnect
* [Increased inotify limits](https://www.suse.com/support/kb/doc/?id=000020048) (for preventing errors like "too many open files" when installing/using some huge applications & games)

# Installation

## ISO (Recommended)

ISOs are online-based & are constantly upgraded. There is no need to worry about the version & the date of the ISO.

ISO is available for download [here.](https://github.com/jitcos/cabos/releases/tag/auto-iso)

Just download & proceed with installation.

After you get into the OS, type this command into Terminal & reboot:

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jitcos/cabos:latest
```

## Rebase from Silverblue

To rebase an existing Silverblue/Kinoite installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/jitcos/cabos:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jitcos/cabos:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

This repository builds date tags as well, so if you want to rebase to a particular day's build:

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/jitcos/cabos:20230403
```

# Modifications

Optional config:
* `ujust configure-grub`: Hide GRUB text output on boot (if you want to make boot process faster [press Shift on boot if you need to see boot menu])
* `ujust enable-hibernation`: Setup new swapfile and change configurations to allow your computer to hibernate or suspend-to-hibernate

# Recommended Extensions
* [Grand Theft Focus](https://extensions.gnome.org/extension/5410/grand-theft-focus/) - Just be sure to configure Telegram/WhatsApp properly
* [System76 Power](https://github.com/LFd3v/gnome-shell-extension-system76-power) Manually install this for support with the System76 Power service
