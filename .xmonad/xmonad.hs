--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.ManageHook
import XMonad.Util.EZConfig
import XMonad.Util.Hacks as Hacks
import XMonad.Util.Loggers
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified Data.List as L

------------------------------------------------------------------------
-- VARIABLES
------------------------------------------------------------------------

myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2

myModMask       = mod4Mask

myNormalBorderColor  = "#5e81ac"
myFocusedBorderColor = "#88c0d0"

------------------------------------------------------------------------
-- WORKSPACES
------------------------------------------------------------------------
-- This adds a feature of clickable workspaces
-- install the xdotool package for the functionality

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . map xmobarEscape
               $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]
  
  
------------------------------------------------------------------------
-- XMOBAR CONFIG   \(ws:l:t:_)   -> [ws]
------------------------------------------------------------------------
-- This takes output for the workspaces and give it to xmobar in the UnsafeXMonadLog call in xmobarrc
-- defaulf config found in xmonad man pages with minor exclutions
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = yellow " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = yellow . wrap " " "" . xmobarBorder "Top" "#ebcb8b" 2
    , ppHidden          = purple . wrap " " ""
    , ppHiddenNoWindows = lowBlue . wrap " " ""
    , ppOrder           = \(ws:l:t:_)   -> [ws]
    }
  where
    lowBlue, yellow, red, purple :: String -> String
    yellow   = xmobarColor "#ebcb8b" ""
    purple   = xmobarColor "#b48ead" ""
    red      = xmobarColor "#ff5555" ""
    lowBlue = xmobarColor "#4c566a" ""


------------------------------------------------------------------------
-- KEY BINDINGS
------------------------------------------------------------------------

myAditionalKeys =

    -- apps
  [ ("M-<Return>", spawn myTerminal)
  , ("M-d", spawn "rofi -show drun")
  , ("M-S-d", spawn "rofi -show run")
  , ("M-p", spawn "passmenu -p pass")
  , ("M-w", spawn "firefox")
  , ("M-S-w", spawn "firefox --private-window")
  , ("M-S-f", spawn "pcmanfm")
  , ("M-s", spawn "spotify")
  , ("M-q", kill)


  -- spotify controls
  , ("M-<F9>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
  , ("M-<F11>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
  , ("M-<F12>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")

  -- volume controls
  , ("M-<Print>", spawn "amixer set Master toggle")
  , ("M-<Scroll_lock>", spawn "amixer set Master 5%-")
  , ("M-<Pause>", spawn "amixer set Master 5%+")

  -- window controls
  , ("M-j", windows W.focusDown)
  , ("M-k", windows W.focusUp)
  , ("M-h", windows W.focusMaster)
  , ("M-S-j", windows W.swapDown)
  , ("M-S-k", windows W.swapUp)
  , ("M-S-h", windows W.swapMaster)
  , ("M-C-h", sendMessage Shrink)
  , ("M-C-l", sendMessage Expand)
  , ("M-C-j", sendMessage ShrinkSlave)
  , ("M-C-k", sendMessage ExpandSlave)
  , ("M-comma", sendMessage $ IncMasterN 1)
  , ("M-period", sendMessage $ IncMasterN (-1))
  , ("M-<Space>", withFocused $ windows . W.sink)


  -- kill / restart xmonad
  , ("M-S-q", io exitSuccess)
  , ("M-S-r", spawn "killall xmobar; xmonad --recompile; xmonad --restart")

  ]


myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $
 [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- MOUSE BINDINGS
------------------------------------------------------------------------
-- Its the default, I havent changed much

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
myLayout = avoidStruts $ spacingWithEdge 8 $ (tiled ||| Mirror tiled ||| Full)
-- avoidstruts makes the windows and panel seperate, else thwy will overlap eachother
-- should also use '$ docks ' command in main
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- WINDOW BEHAVIOUR
------------------------------------------------------------------------
-- How xmonad manages windows, popups
myManageHook = composeAll
    [ className =? "confirm"         --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , className =? "file_progress"   --> doFloat
    , isDialog --> doCenterFloat
    , className =? "download"        --> doFloat
    , className =? "error"           --> doFloat
    , className =? "Gimp"            --> doFloat
    , className =? "notification"    --> doFloat
    , className =? "pinentry-gtk-2"  --> doFloat
    , className =? "splash"          --> doFloat
    , className =? "toolbar"         --> doFloat
    , className =? "MPlayer"        --> doFloat
    , insertPosition Master Newer
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- AUTOSTART
------------------------------------------------------------------------

myStartupHook = do
          spawnOnce "nitrogen --restore &"
          spawnOnce "picom &"
          spawnOnce "nm-applet &"
          spawnOnce "volumeicon &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x2E3440 --height 30 --iconspacing 4 &"


------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------

main = do
     xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
     xmonad $ ewmh $ docks $ withEasySB (statusBarProp "/home/abhinav/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    } `additionalKeysP` myAditionalKeys


