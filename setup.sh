#setup.sh VNC_USER_PASSWORD VNC_PASSWORD NGROK_AUTH_TOKEN

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/akhil
sudo dscl . -create /Users/akhil UserShell /bin/bash
sudo dscl . -create /Users/akhil RealName "Akhil"
sudo dscl . -create /Users/akhil UniqueID 1001
sudo dscl . -create /Users/akhil PrimaryGroupID 80
sudo dscl . -create /Users/akhil NFSHomeDirectory /Users/vncuser
sudo dscl . -passwd /Users/akhil $1
sudo dscl . -passwd /Users/akhil $1
sudo createhomedir -c -u akhil > /dev/null

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

#VNC password - http://hints.macworld.com/article.php?story=20071103011608872
echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate


#Enable Performance mode
sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"

#Reduce Motion and Transparency 
defaults write com.apple.Accessibility DifferentiateWithoutColor -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
defaults write com.apple.universalaccess reduceMotion -int 1
defaults write com.apple.universalaccess reduceTransparency -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

#Enable Multi-Session
sudo /usr/bin/defaults write .GlobalPreferences MultipleSessionsEnabled -bool TRUE

defaults write "Apple Global Domain" MultipleSessionsEnabled -bool true

#Disable Screen-Lock
defaults write com.apple.loginwindow DisableScreenLock -bool true

defaults write com.apple.loginwindow AllowList -string '*'


#install ngrok
brew install --cask ngrok
#install chrome
brew install --cask google-chrome
#install Chrome-remote-desktop
brew install --cask chrome-remote-desktop-host
#install microsoft-remote-desktop(optional)
#brew install --cask microsoft-remote-desktop
#team-viewer (test)
brew install --cask teamviewer
#Anydesk
brew install --cask anydesk

##Enable AnyDesk automatically

defaults write com.apple.universalaccessAuthWarning "/Applications/AnyDesk.app" -bool true
defaults write com.apple.universalaccessAuthWarning "/Applications/AnyDesk.app/Contents/MacOS/AnyDesk" -bool true
defaults write com.apple.universalaccessAuthWarning "3::/Applications" -bool true
defaults write com.apple.universalaccessAuthWarning "3::/Applications/AnyDesk.app" -bool true
defaults write com.apple.universalaccessAuthWarning "com.philandro.anydesk" -bool true






#configure ngrok and start it
ngrok authtoken $3
ngrok tcp 5900 --region=in &
