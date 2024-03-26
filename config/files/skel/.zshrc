if [ -n "$CONTAINER_ID" ]; then
  # Inside of a distrobox container
  export XDG_CONFIG_HOME="$HOME/.config/contexts/$CONTAINER_ID"
  export NVM_DIR="$HOME/.config/contexts/$CONTAINER_ID/.nvm"
  export PYENV_ROOT="$HOME/.config/contexts/$CONTAINER_ID/.pyenv"

  SETUP_DONE="$XDG_CONFIG_HOME/setup-done"

  if ! [ -f "$SETUP_DONE" ]; then
    if [ -n "$SETUP_DEV_TOOLS" ]; then
      echo 'Running initial setup...'

      # Install oh-my-zsh
      git clone https://github.com/ohmyzsh/ohmyzsh.git "$XDG_CONFIG_HOME/oh-my-zsh"
      cp $XDG_CONFIG_HOME/oh-my-zsh/templates/zshrc.zsh-template "$XDG_CONFIG_HOME/.zshrc"
      sed -i 's/export ZSH=\$HOME\/.oh-my-zsh/export ZSH=\$XDG_CONFIG_HOME\/oh-my-zsh/' "$XDG_CONFIG_HOME/.zshrc"

      # Spaceship theme
      ZSH_CUSTOM="$XDG_CONFIG_HOME/oh-my-zsh/custom"
      git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
      ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
      sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/' "$XDG_CONFIG_HOME/.zshrc"

      # nvm
      nvm_setup='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

      echo "$nvm_setup" >> "$XDG_CONFIG_HOME/.zshrc"

      git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
      bash -c 'cd "$NVM_DIR" && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`'
      \. "$NVM_DIR/nvm.sh"

      nvm install 8 ; nvm install 12
      nvm install 14 ; npm install -g npm@7
      nvm install 18 ; nvm alias default 18

      # pyenv
      git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
      git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"

      echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "$XDG_CONFIG_HOME/.zshrc"
      echo 'eval "$(pyenv init -)"' >> "$XDG_CONFIG_HOME/.zshrc"

      "$PYENV_ROOT/bin/pyenv" install 3.10.13; "$PYENV_ROOT/bin/pyenv" install 2.7.18
      "$PYENV_ROOT/bin/pyenv" virtualenv 2.7.18 local2
      "$PYENV_ROOT/bin/pyenv" global 3.10.13 local2

      echo 1 > "$SETUP_DONE"
    fi
  fi
  unset SETUP_DONE

  if [ -f "$XDG_CONFIG_HOME/.zshrc" ]; then
    source "$XDG_CONFIG_HOME/.zshrc"
  fi

  if [ -d "$XDG_CONFIG_HOME/config.d/" ]; then
    files=("$XDG_CONFIG_HOME/config.d/"*.zsh)
    if [ ${#files[@]} -gt 0 ]; then
      for conf in "${files[@]}"; do
        source "$conf"
      done
      unset conf
    fi
    unset files
  fi
else
  # localhost
  if [ -f "$HOME/.config/contexts/localhost/.zshrc" ]; then
    source "$HOME/.config/contexts/localhost/.zshrc"
  fi

  if [ -d "$HOME/.config/contexts/localhost/config.d/" ]; then
    files=("$HOME/.config/contexts/localhost/config.d/"*.zsh)
    if [ ${#files[@]} -gt 0 ]; then
      for conf in "${files[@]}"; do
        source "$conf"
      done
      unset conf
    fi
    unset files
  fi
fi

# Load seperated config files
if [ -d "$HOME/.config/contexts/config.d/" ]; then
  files=("$HOME/.config/contexts/config.d/"*.zsh)
  if [ ${#files[@]} -gt 0 ]; then
    for conf in "${files[@]}"; do
      source "$conf"
    done
    unset conf
  fi
  unset files
fi
