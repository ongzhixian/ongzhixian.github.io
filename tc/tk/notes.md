# Widgets

## Classes of widgets

Basic
    Button
    Checkbutton
    Radiobutton
    Combobox
    Label
    Frame
    Entry

More widgets
    Listbox
    Scrollbar
    Spinbox
    Text
    
    Sizegrip
    Progressbar
    Scale




Separator
Labelframe
Panedwindow
Notebook
Canvas
Treeview

## Creation

To create a widget, we need to provide:

1.  widget class, and 
2.  the pathname. 

The pathname is used to indicate the widget's parent (which must of course exist also), and hence its position in the window hierarchy. For example:

ttk::button .b
ttk::frame .f
ttk::entry .f.entry

This also creates a new object command with the same name as the widget's pathname, which will let us communicate with the widget. 

So the above code would produce new Tcl commands named ".b", ".f", ".f.entry", and so on. 

You can then use that object command to communicate further with the widget, 
calling e.g. ".b invoke", or ".f.entry state disabled". 

Because of the obvious parallels with many object-oriented systems, we'll often refer to the object commands as objects,
 and calls on those objects (like the "invoke") as method calls. 
 
 For example, you'll see below the use of the "configure" and "cget" methods.