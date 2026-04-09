# dotfiles

This is Ray Johnson's dotfiles repo. Follow the below instructions for setting up a new machine.

## Set up new Mac

### 1. Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Install all packages via Brewfile
This installs chezmoi, 1Password, age, and everything else.
```bash
curl -O https://raw.githubusercontent.com/rayjohnson/dotfiles/main/Brewfile
brew bundle --file Brewfile
```

### 3. Sign into 1Password and retrieve the age decryption key
```bash
op signin
op document get "age-private-key" --output ~/.age/key.txt
chmod 600 ~/.age/key.txt
```

### 4. Initialize chezmoi and apply dotfiles
```bash
chezmoi init --apply https://github.com/rayjohnson/dotfiles.git
```

This will restore all dotfiles including your encrypted `~/.secrets.env`.

---

## Updating your dotfiles

### If you install new things with Brew
```bash
brew bundle dump --force --file $(chezmoi source-path)/Brewfile
```

### To update any tracked dotfile
```bash
chezmoi add ~/.zshrc   # or any other tracked file
```

`chezmoi add` automatically commits and pushes to git.

## Updating secrets

Edit `~/.secrets.env` and re-add it with the `--encrypt` flag to preserve encryption:
```bash
vim ~/.secrets.env
chezmoi add --encrypt ~/.secrets.env
```
