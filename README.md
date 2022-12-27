# MacOS_remote
MacOS Remote Desktop for Xcode &amp; for testing purpose.


[<img src="https://i.ytimg.com/vi/MZYly2gmmHs/maxresdefault.jpg" width="50%">](https://www.youtube.com/watch?v=MZYly2gmmHs)

## OSX Optimizations

Below you will find extremely good optimizers, particularly for virtual machines.
Some of the commands are dangerous from a remote access perspective, but they will greatly optimize your VM/MacOS_Remote.


## Disable spotlight indexing on macOS to heavily speed up Virtual Instances.

```bash
# massively increase virtualized macOS by disabling spotlight.
sudo mdutil -i off -a

# since you can't use spotlight to find apps, you can renable with
# sudo mdutil -i on -a

```

### Skip the GUI login screen (at your own risk!)
```bash
defaults write com.apple.loginwindow autoLoginUser -bool true
```
### Enable performance mode

Turn on performance mode to dedicate additional system resources for server applications.

Details: https://support.apple.com/en-us/HT202528

```
# check if enabled (should contain `serverperfmode=1`)
nvram boot-args

# turn on
sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"

# turn off
sudo nvram boot-args="$(nvram boot-args 2>/dev/null | sed -e $'s/boot-args\t//;s/serverperfmode=1//')"
```
### Disable heavy login screen wallpaper

```bash
sudo defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture ""
```

### Reduce Motion & Transparency

```bash
defaults write com.apple.Accessibility DifferentiateWithoutColor -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
defaults write com.apple.universalaccess reduceMotion -int 1
defaults write com.apple.universalaccess reduceTransparency -int 1
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1
```



## System Info

    OS: macOS Monterey (version 12)
    RAM: 14GB DRAM
    Disk: 77GB available of 408GB
    Processer: 3.3GHz
    Screen: 20.5-inch (1176 * 885)
    Internet Speed: 1Gbps or higher
    Preinstall: Python 2, NodeJS 14, PHP 8, R, Xcode, Visual Studio, Chrome, Firefox, Microsoft Edge...

## How to use

    Click Fork in the right corner of the screen to save it to your Github.
    Visit https://dashboard.ngrok.com to get NGROK_AUTH_TOKEN
    In Github go to ⚙ Settings> Secrets> New repository secret
    In Name: enter NGROK_AUTH_TOKEN
    In Value: visit https://dashboard.ngrok.com/auth/your-authtoken Copy and Paste Your Authtoken into
    Press Add secret
    Go to Action> macOS> Run workflow
    Reload the page and press build > build
    Connect with VNC Viewer
        Install VNC Viewer
        Go to: https://dashboard.ngrok.com/endpoints/status copy host(eg: 0.tcp.in.ngrok.io:13472)
        Username: akhil
        Password: [Secrets]

* Use Team-Viewer for better lag free experience.
