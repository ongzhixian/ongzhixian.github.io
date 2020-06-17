# Widgets 2 (7 more widgets)

Listbox     -- list of single-line text items, usually length
            tk::listbox .l -height 10

Scrollbar   -- helps the user to see all parts of another widget, 
                whose content is larger than what can be shown in available screen space.
            ttk::scrollbar .s -orient vertical -command ".l yview" 
            .l configure -yscrollcommand ".s set"

SizeGrip    -- the little box at the bottom right corner of the window that allows you to resize it.
            grid [ttk::sizegrip .sz] -column 999 -row 999 -sticky se

Text        --  provides users with an area so that they can enter multiple lines of text. 
            Text widgets are part of the classic Tk widgets,
            tk::text .t -width 40 -height 10

Progressbar -- give feedback to the user about the progress of a lengthy operation
            ttk::progressbar .p -orient horizontal -length 200 -mode determinate

Scale       -- users to choose a numeric value through direct manipulation.
            ttk::scale .s -orient horizontal -length 200 -from 1.0 -to 100.0

Spinbox     --  choose numbers 
            tk::spinbox .s -from 1.0 -to 100.0 -textvariable spinval


## Details


