module Main where


import Graphics.UI.Gtk
import System.Cmd
import System.Exit


main :: IO ()
main = do
    initGUI

    appMenu <- menuNew
    menuItems <- items
    mapM_ (\(x, i) -> menuAttach appMenu x 0 1 i (i + 1)) $ zip menuItems [0..]
    widgetShowAll appMenu

    status <- statusIconNewFromStock stockNetwork
    statusIconSetVisible status True
    on status statusIconPopupMenu $ \(Just m) t ->
        menuPopup appMenu (Just (m, t))

    mainGUI


items :: IO [MenuItem]
items = mapM bindAction
    [("First network", connect "network1"),
        ("Second network", connect "network2"),
        ("Quit", mainQuit)]
    where
        bindAction (lab, action) = do
            item <- menuItemNewWithLabel lab
            onActivateLeaf item action
            return item


connect :: String -> IO ()
connect network = do
    disconnectAll
    system $ "wpa_supplicant -B -c /root/" ++ network ++ " -i wlan0 -D wext"
    exitCode <- system "dhcpcd wlan0"
    case exitCode of
        ExitSuccess -> dial "Connection established."
        ExitFailure _ -> dial "Connection failed."
    return ()


disconnectAll :: IO ()
disconnectAll = do
    system "pkill dhcpcd"
    system "pkill wpa_supplicant"
    return ()


dial :: String -> IO ()
dial msg = do
    d <- messageDialogNew Nothing [] MessageInfo ButtonsOk msg
    dialogRun d
    widgetDestroy d
    return ()
