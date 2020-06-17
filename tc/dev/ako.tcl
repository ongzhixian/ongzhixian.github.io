package require Tk

grid [ttk::button .b -text "Hello" -command {button_pressed}]
puts [.b cget -text]
puts [.b cget -command]
.b configure -text Goodbye
puts [.b cget -text]
puts [.b configure -text]
#puts [.b configure]