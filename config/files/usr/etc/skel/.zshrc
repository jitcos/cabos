

if [ -n "$CONTAINER_ID" ]; then
  # Inside of a distrobox container
  export XDG_CONFIG_HOME="$HOME/.config/contexts/$CONTAINER_ID"
  export ZDOTDIR="$HOME/.config/contexts/$CONTAINER_ID"
  export NVM_DIR="$HOME/.config/contexts/$CONTAINER_ID/.nvm"
  export PYENV_ROOT="$HOME/.config/contexts/$CONTAINER_ID/.pyenv"

  SETUP_DONE="$XDG_CONFIG_HOME/setup-done"

  if ! [ -f "$SETUP_DONE" ]; then
    # Run setup
    echo 'Running initial setup...'

    # Install oh-my-zsh
    ZSH="$ZDOTDIR/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Spaceship theme
    ZSH_CUSTOM="$ZDOTDIR/oh-my-zsh/custom"
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

    # nvm
    nvm_setup='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'

    echo "$nvm_setup" >> "$ZDOTDIR/.zshrc"

    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    "$NVM_DIR/nvm.sh"
    nvm install 8 ; nvm install 12
    nvm install 14 ; npm install -g npm@7
    nvm install 18 ; npm install -g npm@9 ; nvm alias default 18

    # pyenv
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"

    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> "$ZDOTDIR/.zshrc"
    echo 'eval "$(pyenv init -)"' >> "$ZDOTDIR/.zshrc"

    PATH="$PYENV_ROOT/bin:$PATH" pyenv init -
    PATH="$PYENV_ROOT/bin:$PATH" pyenv install 3.10.13; pyenv install 2.7.18
    PATH="$PYENV_ROOT/bin:$PATH" pyenv virtualenv 2.7.18 local2
    PATH="$PYENV_ROOT/bin:$PATH" pyenv global 3.10.13 local2

    echo 1 > "$SETUP_DONE"
  fi

  source "$ZDOTDIR/.zshrc"
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
