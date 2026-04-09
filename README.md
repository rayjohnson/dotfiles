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

Then strip the quarantine flag from all installed apps to avoid "are you sure?" prompts when opening each one for the first time:
```bash
xattr -dr com.apple.quarantine /Applications
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

This will restore all dotfiles including your encrypted `~/.secrets.env`. It will also automatically run `mac-defaults.sh` to apply macOS system settings (key repeat, Finder preferences, etc.).

### 5. Manual system settings (cannot be automated)

- **Disable iCloud Passwords & Keychain**: System Settings → Apple ID → iCloud → turn off "Passwords & Keychain"
- **Disable AutoFill Passwords**: System Settings → Passwords → turn off "AutoFill Passwords"

These prevent macOS from showing password suggestions that overlap the 1Password extension.

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
