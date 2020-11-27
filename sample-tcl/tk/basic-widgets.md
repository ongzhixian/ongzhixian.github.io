# Basic widgets

Frame       -- ttk::frame .frame
Label       -- ttk::label .label -text {Full name:}
Button      -- ttk::button .button -text "Okay" -command "submitForm"
Checkbutton -- ttk::checkbutton .check -text "Use Metric" -command "metricChanged" 
	            -variable measuresystem -onvalue metric -offvalue imperial
Radiobutton --  choose between one of a number of mutually exclusive choices
                ttk::radiobutton .home -text "Home" -variable phone -value home
                ttk::radiobutton .office -text "Office" -variable phone -value office
                ttk::radiobutton .cell -text "Mobile" -variable phone -value cell
Entry       -- single line text field that they can use to type in a string value
            ttk::entry .name -textvariable username

Combobox    -- ttk::combobox .country -textvariable country
            .country configure -values [list USA Canada Australia]

# Details

Frame   -- a simple rectangle. Frames are primarily used as a container for other widgets
        ttk::frame .frame

        .frame configure -padding "5 10"
        A single number specifies the same padding all the way around, 
        A list of two numbers lets you specify the horizontal then the vertical padding, and 
        A list of four numbers lets you specify the left, top, right and bottom padding, in that order.

        .frame configure -borderwidth 2 -relief sunken
        relief can be: "flat" (default), "raised", "sunken", "solid", "ridge", or "groove".

Label   -- displays text or images
        ttk::label .label -text {Full name:}

        # Mapped display text to variable call resultContents
        .label configure -textvariable resultContents
        set resultContents "New value to display"

        image create photo imgobj -file "myimage.gif"
        .label configure -image imgobj

Button  -- display text or images, for interaction
        ttk::button .button -text "Okay" -command "submitForm"

        .button invoke

        .button state disabled            ;# set the disabled flag, disabling the button
        .button state !disabled           ;# clear the disabled flag
        .button instate disabled          ;# return 1 if the button is disabled, else 0
        .button instate !disabled         ;# return 1 if the button is not disabled, else 0
        .button instate !disabled {mycmd} ;# execute 'mycmd' if the button is not disabled

Checkbutton -- holds a binary value of some kind 
        ttk::checkbutton .check -text "Use Metric" -command "metricChanged" 
	    -variable measuresystem -onvalue metric -offvalue imperial

        .check instate alternate

Radiobutton -- choose between one of a number of mutually exclusive choices
        ttk::radiobutton .home      -text "Home"    -variable phone -value home
        ttk::radiobutton .office    -text "Office"  -variable phone -value office
        ttk::radiobutton .cell      -text "Mobile"  -variable phone -value cell


Entry   -- single line text field that they can use to type in a string value
        ttk::entry .name -textvariable username

        puts "current value is [.name get]"
        .name delete 0 end           ; # delete between two indices, 0-based
        .name insert 0 "your name"   ; # insert new text at a given index

Combobox    -- combines an entry with a list of choices available to the user
            ttk::combobox .country -textvariable country
            .country configure -values [list USA Canada Australia]
            
            bind .country <<ComboboxSelected>> { script }
