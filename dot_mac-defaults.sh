#!/bin/bash
# macOS system defaults for developer setup.
# Run this script after a fresh install, then log out and back in for all changes to take effect.

# Show file extensions in Finder - prevents confusion between e.g. "script" (directory)
# and "script.sh" (file), and makes it obvious when files have unexpected types.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable quarantine dialog for downloaded apps - removes the "Are you sure you want to
# open this?" prompt for every downloaded file. Convenient but be aware you lose one
# layer of warning against accidentally running malicious downloads.
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show status bar (file count, disk space) and path bar (full folder path) at the
# bottom of Finder windows - useful for knowing where you are and how much space is free.
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Show the full POSIX path (e.g. /Users/ray/src/project) in the Finder title bar
# instead of just the folder name - useful when you have many folders with the same name.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show connected servers, removable media, and hard disks in the Finder sidebar.
# Note: these com.apple.sidebarlists keys may not work on macOS Ventura and later.
defaults write com.apple.sidebarlists systemitems -dict-add ShowServers -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -int 1

# Restart Finder to apply changes
killall Finder
