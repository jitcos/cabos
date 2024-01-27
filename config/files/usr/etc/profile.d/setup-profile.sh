if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    # Add default settings when there are no settings
    if test ! -e "$HOME"/.config/Code/User/settings.json; then
        mkdir -p "$HOME"/.config/Code/User
        cp -f /etc/skel.d/.config/Code/User/settings.json "$HOME"/.config/Code/User/settings.json
    fi

    if [ ! -d "$HOME"/.vscode/extensions/themer-lucid ]; then
        mkdir -p "$HOME"/.vscode/extensions
        cp -r /etc/skel.d/.vscode/extensions/themer-lucid "$HOME"/.vscode/extensions
    fi
fi
