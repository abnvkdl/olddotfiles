# dotfiles
If you are really new to xmonad. Your would be really struggling to make your basic setup,
My setup is just basic. You can use it for just an initial start.
I have also added the clickable workspaces feature in xmonad, To use that install xdotool.
Packages you need to configure like my setup

1. xmonad
2. xmobar
3. nitrogen
4. picom
5. trayer
#trayer is the package that shows up at top containg notificatios, volume and wifi toggles

#this step is completely optional
The autostart commands are done in xmonad, but I have set up my .xprofile to run a command
to launch the defalt mouse cursor at startup instead of the default cross shaped cursor in xmonad
#the .xprofile is located at home directory that basically just runs at the begining of each x sessions

THE BELOW IS BASICALLY JUST CUSTOMISATIONS. IF YOU JUST WANT THE BARE MINIMUM AND WANT TO CONFIGURE
THE REST YOURSELF, YOU CAN LEAVE

Incase you want rofi instead of dmenu, install rofi, I have provided the rofi config as well

Applets that I use in trayer
1. nm-applet   #network manager
2. volumeicon  #sound mixer, in debian this package is called volumeicon-alsa
#Incase you dont know what they do...they simply just put up volume and network icons which
#you can control using mouse

In case you want to apply a theme you should use a package called lxappearance
#lxappearance is just like gnome tweaks made for window managers

The basic trayer icons of nm-applet and volumeicon are boring. So you may need to apply and icon theme. I basically use
papirus. In that case you may need to download a package called papirus-icon-theme. Change the icons to papirus icons using 
lxappearance. 

For terminal customistaion I use starship

I have also provided the fonts that i use, you can download it manually also...just copy the fonts in the fonts folder to
~/.local/share/fonts and you are good to go...

To setup nitrogen, I use wallpapers of distrotube https://gitlab.com/dwt1/wallpapers 

So yeah thats it...in short after xmonad installation 
install these packages
1. xdotool               --for clickable workspaces feature
2. xmobar                --for panel
3. nitrogen              --wallpaer manager
4. picom                 --compositor, for transparency
5. trayer                --system tray
6. rofi                  --app launcher like dmenu
7. nm-applet             --network manager
8. volumeicon            --volume mixer
9. lxappearance          --to apply theme
10. papirus-icon-theme   --icon theme
11. starship             --terminal customisation

Copy the configs to respective folders...and thats it
