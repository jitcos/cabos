

if [ -n "$CONTAINER_ID" ]; then
  # Inside of a distrobox container
  export XDG_CONFIG_HOME="$HOME/.config/contexts/$CONTAINER_ID"
  export NVM_DIR="$HOME/.config/contexts/$CONTAINER_ID/.nvm"
  export PYENV_ROOT="$HOME/.config/contexts/$CONTAINER_ID/.pyenv"

  SETUP_DONE="$XDG_CONFIG_HOME/setup-done"

  if ! [ -f "$SETUP_DONE" ]; then
    /usr/bin/distrobox-user

    echo 1 > "$SETUP_DONE"
  fi

  source "$XDG_CONFIG_HOME/.zshrc"
  unset SETUP_DONE
else
  # localhost
  source "$HOME/.config/contexts/localhost/.zshrc"
fi

# Load seperated config files
for conf in "$HOME/.config/contexts/config.d/"*.zsh; do
  source "${conf}"
done
unset conf
