# dotfiles
If you are really new to xmonad. Your would be really struggling to make your basic setup
Packages you need to configure like my setup
1. xmonad
2. xmobar
3. nitrogen
4. picom
5. trayer
#trayer is the package that shows up at top containg notificatios, volume and wifi toggles

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

For terminal customistaion I use starhip

I have also provided the fonts that i use, you can download it manually also...just copy the fonts in the fonts folder to
~/.local/share/fonts and you are good to go...

To setup nitrogen, I use wallpapers of distrotube https://gitlab.com/dwt1/wallpapers 

So yeah thats it...in short after xmonad installation 
install these packages
2. xmobar
3. nitrogen
4. picom
5. trayer
6. rofi
7. nm-applet
8. volumeicon
9. lxappearance
10. papirus-icon-theme
11. starship

Copy the configs to respective folders...and thats it
