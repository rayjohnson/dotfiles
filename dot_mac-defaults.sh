
# Always show suffixes
defaults write NSGlobalDomain AppleShowAllExtensions -bool true


# Don't ask if I want to open something I downloaded from web
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Show path bar and status bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Devices for the sidebar
defaults write com.apple.sidebarlists systemitems -dict-add ShowServers -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks -int 1
defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -int 1


