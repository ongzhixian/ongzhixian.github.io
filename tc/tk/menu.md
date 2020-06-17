# Menus

To figure out which platform you're running on:

tk windowingsystem; 

## Start

option add *tearOff 0

Without it, each of your menus (on Windows and X11) will start with what looks like a dashed line and allows you to "tear off" the menu, so it appears in its own window. 
You really don't want that there.

## Example

toplevel .win
menu .win.menubar
.win configure -menu .win.menubar