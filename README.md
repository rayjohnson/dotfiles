# dotfiles

This is Ray Johnson's dotfiles repo. Follow the below instructions for setting up a new machine.

## Set up new Mac

First install brew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Download and install Brewfile
```
curl -O https://raw.githubusercontent.com/rayjohnson/dotfiles/main/Brewfile
brew bundle --file Brewfile
```

One of the things installed is chezmoi - now let's init chezmoi
```
chezmoi init https://github.com/rayjohnson/dotfiles.git
```

## If you install new things with Brew - update brewfile
```
brew bundle dump --force --file Brewfile
chezmoi re-add Brewfile
```
