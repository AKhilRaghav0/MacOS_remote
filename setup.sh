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

#disables Password Globaly (comment them if not required)
sudo su
# nuke pam
for PAM_FILE in /etc/pam.d/*; do
    sed -i -e s/required/optional/g "${PAM_FILE}"
    sed -i -e s/sufficient/optional/g "${PAM_FILE}"
done

#Make Everyone Sudoer
cd /Users
# add everyone to sudoers and import the control center plist
for REAL_NAME in *; do
    echo "${REAL_NAME}"
    tee "/etc/sudoers.d/${REAL_NAME}" <<< "${REAL_NAME}     ALL=(ALL)       NOPASSWD: ALL"
    # sudo -u "${REAL_NAME}" defaults write -globalDomain NSUserKeyEquivalents  -dict-add "Save as PDF\\U2026" "@\$p";
    sudo -u "${REAL_NAME}" sudo mdutil -i off -a
    # sudo -u "${REAL_NAME}" defaults import com.apple.controlcenter /tmp/com.apple.controlcenter.plist
    # sudo -u "${REAL_NAME}" defaults write "/Users/${REAL_NAME}/Library/Preferences/.GlobalPreferences MultipleSessionEnabled" -bool 'YES'
    # sudo -u mdutil -i off -a
    # sudo dscl . -create "/Users/${REAL_NAME}" UserShell "${USERSHELL}"
    sudo -u "${REAL_NAME}" "whoami"
done
#############################3

#Disable apps from going to sleep at all
sudo -u "${REAL_NAME}" sudo defaults write NSGlobalDomain NSAppSleepDisabled -bool YES

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
