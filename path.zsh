# brew (x86)

brew_init_86 ()
{
  if [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# brew arm64
#
# if arm64 brew is installed, its shellenv needs to be evaluated second since
# it will prepend the path, and the arm64 brew bin should be preferred.
brew_init()
{
  if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

if [[ $(uname -m) == "x86_64" ]]; then
  brew_init
  brew_init_86
else
  brew_init_86
  brew_init
fi

# go
export PATH="$HOME/go/bin:$PATH"

# lvim
export PATH="$PATH:$HOME/.local/bin/"

# rust
export PATH="$PATH:$HOME/.cargo/bin"

# scripts
export PATH="$custom/scripts:$custom/scripts/private:$PATH"
