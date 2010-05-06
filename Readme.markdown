Wireless Infidel
================

Wireless Infidel was motivated by a completely spurious wish to do some GTK in
Haskell. What better starting point than a small wireless manager?

This program resides as a status icon in your systray. A right click brings up
the network menu. You need to edit the source to make it point at your
networks, and have some pre-made wpa\_supplicant configuration files.

Installation
------------

The usual Cabal process:

1. cabal build
2. cabal install

Then launch the binary as root.
