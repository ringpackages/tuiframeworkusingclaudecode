# ========================================
# Ring TUI Library - Terminal User Interface Framework
# Using RogueUtil for terminal manipulation
# ========================================

load "stdlibcore.ring"
load "rogueutil.ring"

# Global variables (needed for anonymous function handlers to access controls)
$statusBar = null
$txtName = null
$txtEmail = null
$chk1 = null
$chk2 = null
$editComments = null
$kernel = null

# Tree demo globals
$tree1 = null
$tree2 = null
$activeTree = 1

# Controls demo globals
$spinner1 = null
$spinner2 = null
$hscroll = null
$vscroll = null
$progress1 = null
$progress2 = null
$progress3 = null
$lblHValue = null
$lblVValue = null
$controlsEM = null

# ========================================
# Demo Application - Main Entry Point
# ========================================
func main

    prepareScreen()
    # Initialize kernel
    k = new Kernel()
    $kernel = k  # Store global reference for use in callbacks
    k.clear()
    k.enableMouse()  # Enable mouse support
    
    # Create event manager
    em = new EventManager(k)
    
    # Main menu loop
    exitApp = false
    
    while not exitApp
        # Draw main menu
        k.clear()
        k.setTermColor(WHITE, BLUE)  # White on blue
        
        # Fill screen with blue
        clearLine = copy(" ", 80)
        for row = 1 to 25
            k.printAt(1, row, clearLine)
        next
        
        # Draw menu box
        k.setTermColor(YELLOW, BLUE)  # Yellow on blue
        k.printAt(25, 3, "+------------------------------+")
        k.printAt(25, 4, "|     RING TUI LIBRARY DEMO    |")
        k.printAt(25, 5, "+------------------------------+")
        
        k.setTermColor(WHITE, BLUE)  # White on blue
        k.printAt(25, 7,  "|                              |")
        k.printAt(25, 8,  "|   1. Form Demo               |")
        k.printAt(25, 9,  "|   2. Grid/Table Demo         |")
        k.printAt(25, 10, "|   3. Menu Bar Demo           |")
        k.printAt(25, 11, "|   4. Window Manager Demo     |")
        k.printAt(25, 12, "|   5. Tree View Demo          |")
        k.printAt(25, 13, "|   6. Tab Control Demo        |")
        k.printAt(25, 14, "|   7. Controls Demo           |")
        k.printAt(25, 15, "|   8. Menu + Tabs Demo        |")
        k.printAt(25, 16, "|                              |")
        k.printAt(25, 17, "|   9. Exit                    |")
        k.printAt(25, 18, "|                              |")
        k.printAt(25, 19, "+------------------------------+")
        
        k.setTermColor(LIGHTCYAN, BLUE)  # Cyan on blue
        k.printAt(25, 21, "  Enter choice (1-9): ")
        
        k.setTermColor(WHITE, BLUE)
        choice = k.getKey()
        
        k.clear()
        
        if choice = 49  # ASCII '1'
            runFormDemo(k, em)
        but choice = 50  # ASCII '2'
            runGridDemo(k, em)
        but choice = 51  # ASCII '3'
            runMenuDemo(k, em)
        but choice = 52  # ASCII '4'
            runWindowDemo(k, em)
        but choice = 53  # ASCII '5'
            runTreeDemo(k, em)
        but choice = 54  # ASCII '6'
            runTabsDemo(k, em)
        but choice = 55  # ASCII '7'
            runControlsDemo(k, em)
        but choice = 56  # ASCII '8'
            runMenuTabsDemo(k, em)
        but choice = 57 or choice = 27  # ASCII '9' or ESC
            exitApp = true
        ok
    end
    
    # Cleanup
    k.clear()
    k.resetTermColor()
    k.setCursorVisible(1)
    k.enableEcho()
    k.gotoXY(0, 0)
    
    see nl + "Thank you for trying Ring TUI Library Demo!" + nl

func runGridDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Create main window
    win = new Window(k, 2, 2, 76, 23, "Grid/Table Demo - ESC: Back to Menu")
    
    # Create grid
    # Width calculation: border(2) + rowNum(4) + sep(1) + ID(5) + sep(1) + Name(15) + sep(1) + Email(22) + sep(1) + Age(4) + sep(1) + City(10) = 67
    grid = new Grid(k, 4, 4, 68, 16)
    grid.showHeaders = true
    grid.showRowNumbers = true
    grid.rowNumberWidth = 4
    grid.editable = true
    
    # Add columns (total content width should be grid width - 2 for borders - rowNumWidth - 1 for separator)
    # Available: 68 - 2 - 4 - 1 = 61, with 4 separators between 5 columns = 57 for data
    grid.addColumn("ID", 5)
    grid.addColumn("Name", 15)
    grid.addColumn("Email", 22)
    grid.addColumn("Age", 4)
    grid.addColumn("City", 10)
    
    # Add sample data
    grid.addRow(["001", "John Doe", "john@example.com", "28", "New York"])
    grid.addRow(["002", "Jane Smith", "jane@example.com", "34", "London"])
    grid.addRow(["003", "Bob Johnson", "bob@example.com", "45", "Paris"])
    grid.addRow(["004", "Alice Brown", "alice@example.com", "29", "Tokyo"])
    grid.addRow(["005", "Charlie Davis", "charlie@example.com", "52", "Sydney"])
    grid.addRow(["006", "Diana Wilson", "diana@example.com", "31", "Berlin"])
    grid.addRow(["007", "Eve Martinez", "eve@example.com", "27", "Madrid"])
    grid.addRow(["008", "Frank Anderson", "frank@example.com", "38", "Rome"])
    grid.addRow(["009", "Grace Lee", "grace@example.com", "42", "Seoul"])
    grid.addRow(["010", "Henry Taylor", "henry@example.com", "36", "Mumbai"])
    
    # Create info label
    lblInfo = new Label(k, 4, 21, 72, 1)
    lblInfo.setText("Arrows: Navigate | ENTER: Edit | ESC: Back")
    lblInfo.fgColor = LIGHTGREEN
    
    # Add controls to window
    win.addChild(grid)
    win.addChild(lblInfo)
    
    # Draw window (draws all children automatically)
    win.draw()
    
    # Status bar (outside window)
    $statusBar = new Label(k, 2, 25, 76, 1)
    $statusBar.setText($kernel.width("Grid Demo - Click cells or use arrows to navigate, press ENTER to edit", 76))
    $statusBar.fgColor = BLACK
    $statusBar.bgColor = GREY
    $statusBar.draw()
    
    em.registerWidget(grid)
    em.setFocus(grid)
    
    # Run event loop
    em.run()
    
    # Cleanup - just clear widgets, don't exit
    em.unregisterWidget(grid)
    em.setFocus(null)

func runFormDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Create main window
    win = new Window(k, 2, 2, 76, 23, "TUI Library Demo - ESC: Back to Menu")
    
    # Create labels
    lbl1 = new Label(k, 4, 4, 30, 1)
    lbl1.setText("Name:")
    
    lbl2 = new Label(k, 4, 6, 30, 1)
    lbl2.setText("Email:")
   
    # Create text boxes (use global variables so button handlers can access them)
    $txtName = new TextBox(k, 12, 4, 30, 1)
    $txtName.setText("John Doe")
    $txtName.cursorPos = len($txtName.text)
    
    $txtEmail = new TextBox(k, 12, 6, 30, 1)
    $txtEmail.setText("john@example.com")
    $txtEmail.cursorPos = len($txtEmail.text)

    # Create checkboxes (use global variables)
    $chk1 = new CheckBox(k, 4, 8, 30, 1)
    $chk1.setText("Subscribe to newsletter")
    
    $chk2 = new CheckBox(k, 4, 9, 30, 1)
    $chk2.setText("Accept terms and conditions")
    $chk2.checked = true
    
    # Create list box
    lbl3 = new Label(k, 45, 4, 30, 1)
    lbl3.setText("Select Country:")
    
    lstCountries = new ListBox(k, 45, 5, 30, 8)
    lstCountries.addItem("United States")
    lstCountries.addItem("United Kingdom")
    lstCountries.addItem("Canada")
    lstCountries.addItem("Australia")
    lstCountries.addItem("Germany")
    lstCountries.addItem("France")
    lstCountries.addItem("Japan")
    lstCountries.selectedIndex = 1
    
    # Create combo box
    lbl4 = new Label(k, 4, 11, 30, 1)
    lbl4.setText("Preferred Language:")
    
    cmbLanguage = new ComboBox(k, 4, 12, 30, 1)
    cmbLanguage.addItem("English")
    cmbLanguage.addItem("Spanish")
    cmbLanguage.addItem("French")
    cmbLanguage.addItem("German")
    cmbLanguage.addItem("Chinese")
    
    # Create multi-line edit box (use global variable)
    lbl5 = new Label(k, 45, 14, 30, 1)
    lbl5.setText("Comments:")
    
    $editComments = new EditBox(k, 45, 15, 30, 5)
    $editComments.setText("Enter your comments here..." + nl + "Multiple lines supported!")
    
    # Create buttons
    btnSubmit = new Button(k, 4, 16, 12, 1)
    btnSubmit.setText("Submit")
    btnSubmit.onClick = func {
        $statusBar.setText($kernel.width("Form submitted! Name: " + $txtName.text + ", Email: " + $txtEmail.text, 76))
        $statusBar.draw()
    }
    
    btnCancel = new Button(k, 18, 16, 12, 1)
    btnCancel.setText("Cancel")
    btnCancel.onClick = func {
        $statusBar.setText($kernel.width("Form cancelled!", 76))
        $statusBar.draw()
    }
    
    btnReset = new Button(k, 32, 16, 12, 1)
    btnReset.setText("Reset")
    btnReset.onClick = func {
        $txtName.setText("")
        $txtName.cursorPos = 0
        $txtName.draw()
        $txtEmail.setText("")
        $txtEmail.cursorPos = 0
        $txtEmail.draw()
        $chk1.setChecked(false)
        $chk1.draw()
        $chk2.setChecked(false)
        $chk2.draw()
        $editComments.setText("")
        $editComments.draw()
        $statusBar.setText($kernel.width("Form reset!", 76))
        $statusBar.draw()
    }
    
    # Create info label
    lblInfo = new Label(k, 4, 14, 38, 1)
    lblInfo.setText("TAB: Focus | Arrows, Arrows interact")
    lblInfo.fgColor = LIGHTGREEN
    
    # Demonstrate Rectangle class - Bottom section
    rect1 = new Rectangle(k, 4, 18, 22, 5)
    rect1.setBorderStyle("double")
    rect1.fgColor = LIGHTMAGENTA
    
    rectLabel1 = new Label(k, 6, 19, 18, 1)
    rectLabel1.setText("Rectangle Examples:")
    rectLabel1.fgColor = WHITE
    
    rect1a = new Rectangle(k, 6, 20, 6, 2)
    rect1a.setBorderStyle("single")
    rect1a.fgColor = LIGHTCYAN
    
    rect1b = new Rectangle(k, 13, 20, 6, 2)
    rect1b.setBorderStyle("double")
    rect1b.fgColor = YELLOW
    
    rect1c = new Rectangle(k, 20, 20, 5, 2)
    rect1c.setBorderStyle("single")
    rect1c.setFilled(true, 176)
    rect1c.fgColor = LIGHTGREEN
    
    # Add all controls to window
    win.addChild(lbl1)
    win.addChild(lbl2)
    win.addChild($txtName)
    win.addChild($txtEmail)
    win.addChild($chk1)
    win.addChild($chk2)
    win.addChild(lbl3)
    win.addChild(lstCountries)
    win.addChild(lbl4)
    win.addChild(cmbLanguage)
    win.addChild(lbl5)
    win.addChild($editComments)
    win.addChild(btnSubmit)
    win.addChild(btnCancel)
    win.addChild(btnReset)
    win.addChild(lblInfo)
    win.addChild(rect1)
    win.addChild(rectLabel1)
    win.addChild(rect1a)
    win.addChild(rect1b)
    win.addChild(rect1c)
    
    # Draw window (draws all children automatically)
    win.draw()
    
    # Set initial focus
    em.setFocus($txtName)
    
    # Status bar (outside window)
    $statusBar = new Label(k, 2, 25, 76, 1)
    $statusBar.setText($kernel.width("Ready - TAB: Navigate fields | Arrows: Interact | ESC: Back", 76))
    $statusBar.fgColor = BLACK
    $statusBar.bgColor = GREY
    $statusBar.draw()
    
    em.registerWidget($txtName)
    em.registerWidget($txtEmail)
    em.registerWidget($chk1)
    em.registerWidget($chk2)
    em.registerWidget(lstCountries)
    em.registerWidget(cmbLanguage)
    em.registerWidget($editComments)
    em.registerWidget(btnSubmit)
    em.registerWidget(btnCancel)
    em.registerWidget(btnReset)

    # Run event loop
    em.run()
    
    # Cleanup - unregister widgets, don't exit
    em.unregisterWidget($txtName)
    em.unregisterWidget($txtEmail)
    em.unregisterWidget($chk1)
    em.unregisterWidget($chk2)
    em.unregisterWidget(lstCountries)
    em.unregisterWidget(cmbLanguage)
    em.unregisterWidget($editComments)
    em.unregisterWidget(btnSubmit)
    em.unregisterWidget(btnCancel)
    em.unregisterWidget(btnReset)
    em.setFocus(null)

func runMenuDemo(k, em)
    # Set the default background color for this demo (blue)
    k.setDefaultColors(15, 1)  # White on blue
    k.clearScreenWidgets()     # Clear any widgets from previous demo
    
    # Create status bar first (will be updated by menu actions)
    # Using $statusBar as a global variable so menu handlers can access it
    $statusBar = new Label(k, 1, 25, 78, 1)
    $statusBar.fgColor = BLACK
    $statusBar.bgColor = GREY
    $statusBar.setText($kernel.width("Menu Demo - Click menus or press F2 to activate | ESC to exit", 78))
    
    # Create content labels for the demo screen text
    # These will be registered with kernel for automatic redrawing when menus close
    lblTitle = new Label(k, 30, 10, 20, 1)
    lblTitle.setText("MENU BAR DEMO")
    lblTitle.fgColor = WHITE
    lblTitle.bgColor = BLUE
    
    lblHelp1 = new Label(k, 20, 12, 40, 1)
    lblHelp1.setText("Click on menu items or press F2")
    lblHelp1.fgColor = WHITE
    lblHelp1.bgColor = BLUE
    
    lblHelp2 = new Label(k, 20, 13, 40, 1)
    lblHelp2.setText("Use arrow keys to navigate menus")
    lblHelp2.fgColor = WHITE
    lblHelp2.bgColor = BLUE
    
    lblHelp3 = new Label(k, 20, 14, 45, 1)
    lblHelp3.setText("Press Enter to select, Escape to close")
    lblHelp3.fgColor = WHITE
    lblHelp3.bgColor = BLUE
    
    lblFeatures = new Label(k, 20, 16, 30, 1)
    lblFeatures.setText("Features demonstrated:")
    lblFeatures.fgColor = WHITE
    lblFeatures.bgColor = BLUE
    
    lblF1 = new Label(k, 22, 17, 40, 1)
    lblF1.setText("- Normal menu items with shortcuts")
    lblF1.fgColor = WHITE
    lblF1.bgColor = BLUE
    
    lblF2 = new Label(k, 22, 18, 35, 1)
    lblF2.setText("- Checkbox items (View menu)")
    lblF2.fgColor = WHITE
    lblF2.bgColor = BLUE
    
    lblF3 = new Label(k, 22, 19, 45, 1)
    lblF3.setText("- Nested submenus (Format > Font > Size)")
    lblF3.fgColor = WHITE
    lblF3.bgColor = BLUE
    
    lblF4 = new Label(k, 22, 20, 40, 1)
    lblF4.setText("- Separators between item groups")
    lblF4.fgColor = WHITE
    lblF4.bgColor = BLUE
    
    # Register all labels with the kernel for automatic redrawing
    k.registerScreenWidget(lblTitle)
    k.registerScreenWidget(lblHelp1)
    k.registerScreenWidget(lblHelp2)
    k.registerScreenWidget(lblHelp3)
    k.registerScreenWidget(lblFeatures)
    k.registerScreenWidget(lblF1)
    k.registerScreenWidget(lblF2)
    k.registerScreenWidget(lblF3)
    k.registerScreenWidget(lblF4)
    k.registerScreenWidget($statusBar)
    
    # Create menu bar
    menuBar = new MenuBar(k, 1, 1, 80)
    
    # ===== FILE MENU =====
    fileMenu = menuBar.createMenu("File")
    
    fileMenu.addNormalItem("New", func item {
        $statusBar.setText($kernel.width("File > New clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+N")
    
    fileMenu.addNormalItem("Open...", func item {
        $statusBar.setText($kernel.width("File > Open clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+O")
    
    fileMenu.addNormalItem("Save", func item {
        $statusBar.setText($kernel.width("File > Save clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+S")
    
    fileMenu.addNormalItem("Save As...", func item {
        $statusBar.setText($kernel.width("File > Save As clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+Shift+S")
    
    fileMenu.addSeparator()
    
    # Recent Files submenu
    recentMenu = new Menu(k)
    recentMenu.addNormalItem("document1.txt", func item {
        $statusBar.setText($kernel.width("Opening document1.txt...", 78))
        $statusBar.draw()
    })
    recentMenu.addNormalItem("document2.txt", func item {
        $statusBar.setText($kernel.width("Opening document2.txt...", 78))
        $statusBar.draw()
    })
    recentMenu.addNormalItem("project.ring", func item {
        $statusBar.setText($kernel.width("Opening project.ring...", 78))
        $statusBar.draw()
    })
    recentMenu.addSeparator()
    recentMenu.addNormalItem("Clear Recent", func item {
        $statusBar.setText($kernel.width("Recent files cleared", 78))
        $statusBar.draw()
    })
    
    fileMenu.addSubmenu("Recent Files", recentMenu)
    
    fileMenu.addSeparator()
    
    fileMenu.addNormalItem("Exit", func item {
        $statusBar.setText($kernel.width("Exiting application...", 78))
        $statusBar.draw()
    }).setShortcut("Alt+F4")
    
    # ===== EDIT MENU =====
    editMenu = menuBar.createMenu("Edit")
    
    editMenu.addNormalItem("Undo", func item {
        $statusBar.setText($kernel.width("Edit > Undo clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+Z")
    
    editMenu.addNormalItem("Redo", func item {
        $statusBar.setText($kernel.width("Edit > Redo clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+Y")
    
    editMenu.addSeparator()
    
    editMenu.addNormalItem("Cut", func item {
        $statusBar.setText($kernel.width("Edit > Cut clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+X")
    
    editMenu.addNormalItem("Copy", func item {
        $statusBar.setText($kernel.width("Edit > Copy clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+C")
    
    editMenu.addNormalItem("Paste", func item {
        $statusBar.setText($kernel.width("Edit > Paste clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+V")
    
    editMenu.addSeparator()
    
    editMenu.addNormalItem("Select All", func item {
        $statusBar.setText($kernel.width("Edit > Select All clicked", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+A")
    
    # ===== VIEW MENU =====
    viewMenu = menuBar.createMenu("View")
    
    viewMenu.addCheckboxItem("Show Toolbar", true, func item {
        if item.checked
            $statusBar.setText($kernel.width("Toolbar is now visible", 78))
        else
            $statusBar.setText($kernel.width("Toolbar is now hidden", 78))
        ok
        $statusBar.draw()
    })
    
    viewMenu.addCheckboxItem("Show Status Bar", true, func item {
        if item.checked
            $statusBar.setText($kernel.width("Status bar is now visible", 78))
        else
            $statusBar.setText($kernel.width("Status bar is now hidden", 78))
        ok
        $statusBar.draw()
    })
    
    viewMenu.addCheckboxItem("Show Line Numbers", false, func item {
        if item.checked
            $statusBar.setText($kernel.width("Line numbers enabled", 78))
        else
            $statusBar.setText($kernel.width("Line numbers disabled", 78))
        ok
        $statusBar.draw()
    })
    
    viewMenu.addSeparator()
    
    # Zoom submenu
    zoomMenu = new Menu(k)
    zoomMenu.addNormalItem("Zoom In", func item {
        $statusBar.setText($kernel.width("Zooming in...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl++")
    zoomMenu.addNormalItem("Zoom Out", func item {
        $statusBar.setText($kernel.width("Zooming out...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+-")
    zoomMenu.addNormalItem("Reset Zoom", func item {
        $statusBar.setText($kernel.width("Zoom reset to 100%", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+0")
    
    viewMenu.addSubmenu("Zoom", zoomMenu)
    
    viewMenu.addSeparator()
    
    viewMenu.addNormalItem("Full Screen", func item {
        $statusBar.setText($kernel.width("Toggling full screen mode...", 78))
        $statusBar.draw()
    }).setShortcut("F11")
    
    # ===== FORMAT MENU =====
    formatMenu = menuBar.createMenu("Format")
    
    # Font submenu with nested submenu
    fontMenu = new Menu(k)
    fontMenu.addNormalItem("Arial", func item {
        $statusBar.setText($kernel.width("Font changed to Arial", 78))
        $statusBar.draw()
    })
    fontMenu.addNormalItem("Times New Roman", func item {
        $statusBar.setText($kernel.width("Font changed to Times New Roman", 78))
        $statusBar.draw()
    })
    fontMenu.addNormalItem("Courier New", func item {
        $statusBar.setText($kernel.width("Font changed to Courier New", 78))
        $statusBar.draw()
    })
    fontMenu.addSeparator()
    
    # Font size nested submenu
    fontSizeMenu = new Menu(k)
    fontSizeMenu.addNormalItem("10 pt", func item {
        $statusBar.setText($kernel.width("Font size: 10 pt", 78))
        $statusBar.draw()
    })
    fontSizeMenu.addNormalItem("12 pt", func item {
        $statusBar.setText($kernel.width("Font size: 12 pt", 78))
        $statusBar.draw()
    })
    fontSizeMenu.addNormalItem("14 pt", func item {
        $statusBar.setText($kernel.width("Font size: 14 pt", 78))
        $statusBar.draw()
    })
    fontSizeMenu.addNormalItem("16 pt", func item {
        $statusBar.setText($kernel.width("Font size: 16 pt", 78))
        $statusBar.draw()
    })
    fontSizeMenu.addNormalItem("18 pt", func item {
        $statusBar.setText($kernel.width("Font size: 18 pt", 78))
        $statusBar.draw()
    })
    
    fontMenu.addSubmenu("Size", fontSizeMenu)
    
    formatMenu.addSubmenu("Font", fontMenu)
    
    formatMenu.addSeparator()
    
    formatMenu.addCheckboxItem("Bold", false, func item {
        if item.checked
            $statusBar.setText($kernel.width("Bold enabled", 78))
        else
            $statusBar.setText($kernel.width("Bold disabled", 78))
        ok
        $statusBar.draw()
    }).setShortcut("Ctrl+B")
    
    formatMenu.addCheckboxItem("Italic", false, func item {
        if item.checked
            $statusBar.setText($kernel.width("Italic enabled", 78))
        else
            $statusBar.setText($kernel.width("Italic disabled", 78))
        ok
        $statusBar.draw()
    }).setShortcut("Ctrl+I")
    
    formatMenu.addCheckboxItem("Underline", false, func item {
        if item.checked
            $statusBar.setText($kernel.width("Underline enabled", 78))
        else
            $statusBar.setText($kernel.width("Underline disabled", 78))
        ok
        $statusBar.draw()
    }).setShortcut("Ctrl+U")
    
    # ===== HELP MENU =====
    helpMenu = menuBar.createMenu("Help")
    
    helpMenu.addNormalItem("View Help", func item {
        $statusBar.setText($kernel.width("Opening help...", 78))
        $statusBar.draw()
    }).setShortcut("F1")
    
    helpMenu.addNormalItem("Keyboard Shortcuts", func item {
        $statusBar.setText($kernel.width("Showing keyboard shortcuts...", 78))
        $statusBar.draw()
    })
    
    helpMenu.addSeparator()
    
    helpMenu.addNormalItem("Check for Updates", func item {
        $statusBar.setText($kernel.width("Checking for updates...", 78))
        $statusBar.draw()
    })
    
    helpMenu.addSeparator()
    
    helpMenu.addNormalItem("About", func item {
        $statusBar.setText($kernel.width("Ring TUI Library v1.0 - Menu Demo", 78))
        $statusBar.draw()
    })
    
    # Draw initial screen
    drawMenuDemoScreen(k, menuBar)
    
    # Configure EventManager for menu-based UI
    em.clearWidgets()
    em.setMenuBar(menuBar)
    em.setStatusBar($statusBar)
    
    # Run event loop - EventManager handles everything!
    em.run()
    
    # Cleanup
    em.setMenuBar(null)
    em.setStatusBar(null)
    k.clearScreenWidgets()  # Important: clear registered widgets to prevent slowdown

func drawMenuDemoScreen(k, menuBar)
    # Clear and redraw the main screen
    k.setTermColor(WHITE, BLUE)  # White on blue
    
    # Clear main area (below menu bar, above status bar)
    clearLine = copy(" ", 80)
    for row = 2 to 24
        k.printAt(1, row, clearLine)
    next
    
    # Redraw menu bar
    menuBar.draw()
    
    # Redraw all registered screen widgets (labels)
    for widget in k.screenWidgets
        if widget.visible
            widget.draw()
        ok
    next
    
    k.resetTermColor()
    
    k.resetTermColor()

func runWindowDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Create window manager
    wm = new WindowManager(k)
    
    # Set desktop colors and pattern
    wm.setDesktopColors(8, 1)  # Gray on blue
    wm.setDesktopPattern(" ")  # Light shade pattern
    
    # Add a desktop widget (title bar at top)
    desktopTitle = new Label(k, 1, 1, 80, 1)
    desktopTitle.setText(k.width("  TUI Desktop - Press ESC to exit | F12 to cycle windows", 80))
    desktopTitle.fgColor = WHITE
    desktopTitle.bgColor = BLACK
    wm.addDesktopWidget(desktopTitle)
    
    # Add a taskbar at bottom
    taskbar = new Label(k, 1, 25, 80, 1)
    taskbar.setText(k.width("  [Start]  Information | User Form | Select Country | Status", 80))
    taskbar.fgColor = BLACK
    taskbar.bgColor = GREY
    wm.addDesktopWidget(taskbar)
    
    # ===== Window 1: Information Window =====
    win1 = new ManagedWindow(k, 3, 3, 38, 14, "Information")
    win1.contentBgColor = BLACK
    
    lbl1 = new Label(k, 0, 0, 34, 1)
    lbl1.setText("Window Manager Demo")
    lbl1.fgColor = YELLOW
    win1.addChild(lbl1, 1, 0)
    
    lbl2 = new Label(k, 0, 0, 34, 1)
    lbl2.setText("Features:")
    lbl2.fgColor = LIGHTCYAN
    win1.addChild(lbl2, 1, 2)
    
    lbl3 = new Label(k, 0, 0, 34, 1)
    lbl3.setText("- Drag title bar to move")
    lbl3.fgColor = WHITE
    win1.addChild(lbl3, 1, 3)
    
    lbl4 = new Label(k, 0, 0, 34, 1)
    lbl4.setText("- Drag =# corner to resize")
    lbl4.fgColor = WHITE
    win1.addChild(lbl4, 1, 4)
    
    lbl5 = new Label(k, 0, 0, 34, 1)
    lbl5.setText("- Click [_] to minimize")
    lbl5.fgColor = WHITE
    win1.addChild(lbl5, 1, 5)
    
    lbl6 = new Label(k, 0, 0, 34, 1)
    lbl6.setText("- Click [O] to maximize")
    lbl6.fgColor = WHITE
    win1.addChild(lbl6, 1, 6)
    
    lbl7 = new Label(k, 0, 0, 34, 1)
    lbl7.setText("- Click [X] to close")
    lbl7.fgColor = WHITE
    win1.addChild(lbl7, 1, 7)
    
    lbl8 = new Label(k, 0, 0, 34, 1)
    lbl8.setText("- Press F12 to cycle windows")
    lbl8.fgColor = LIGHTGREEN
    win1.addChild(lbl8, 1, 9)
    
    # ===== Window 2: Form Window with Controls =====
    win2 = new ManagedWindow(k, 20, 7, 42, 15, "User Form")
    win2.contentBgColor = BLACK
    win2.activeTitleBgColor = GREEN  # Green title bar
    
    # Name field
    lblName = new Label(k, 0, 0, 10, 1)
    lblName.setText("Name:")
    lblName.fgColor = GREY
    win2.addChild(lblName, 1, 0)
    
    txtName = new TextBox(k, 0, 0, 28, 1)
    txtName.setText("John Doe")
    win2.addChild(txtName, 10, 0)
    
    # Email field
    lblEmail = new Label(k, 0, 0, 10, 1)
    lblEmail.setText("Email:")
    lblEmail.fgColor = GREY
    win2.addChild(lblEmail, 1, 2)
    
    txtEmail = new TextBox(k, 0, 0, 28, 1)
    txtEmail.setText("john@example.com")
    win2.addChild(txtEmail, 10, 2)
    
    # Checkboxes
    chk1 = new CheckBox(k, 0, 0, 25, 1)
    chk1.text = "Subscribe to news"
    chk1.checked = true
    win2.addChild(chk1, 1, 4)
    
    chk2 = new CheckBox(k, 0, 0, 20, 1)
    chk2.text = "Remember me"
    win2.addChild(chk2, 1, 5)
    
    # Buttons
    btnOK = new Button(k, 0, 0, 12, 3)
    btnOK.text = "[ OK ]"
    btnOK.fgColor = WHITE
    btnOK.bgColor = GREEN
    win2.addChild(btnOK, 5, 8)
    
    btnCancel = new Button(k, 0, 0, 12, 3)
    btnCancel.text = "[Cancel]"
    btnCancel.fgColor = WHITE
    btnCancel.bgColor = RED
    win2.addChild(btnCancel, 20, 8)
    
    # ===== Window 3: List Window =====
    win3 = new ManagedWindow(k, 45, 4, 32, 14, "Select Country")
    win3.contentBgColor = BLACK
    win3.activeTitleBgColor = MAGENTA  # Purple title bar
    
    lblSelect = new Label(k, 0, 0, 28, 1)
    lblSelect.setText("Choose your country:")
    lblSelect.fgColor = LIGHTCYAN
    win3.addChild(lblSelect, 1, 0)
    
    lstCountry = new ListBox(k, 0, 0, 28, 8)
    lstCountry.addItem("United States")
    lstCountry.addItem("United Kingdom")
    lstCountry.addItem("Germany")
    lstCountry.addItem("France")
    lstCountry.addItem("Japan")
    lstCountry.addItem("Australia")
    lstCountry.addItem("Canada")
    lstCountry.addItem("Brazil")
    lstCountry.addItem("India")
    lstCountry.addItem("China")
    win3.addChild(lstCountry, 1, 2)
    
    # ===== Window 4: Progress/Info Window =====
    win4 = new ManagedWindow(k, 8, 13, 40, 9, "Status")
    win4.contentBgColor = BLACK
    win4.activeTitleBgColor = CYAN  # Cyan title bar
    
    lblStatus = new Label(k, 0, 0, 36, 1)
    lblStatus.setText("System Status:")
    lblStatus.fgColor = YELLOW
    win4.addChild(lblStatus, 1, 0)
    
    lblCPU = new Label(k, 0, 0, 36, 1)
    lblCPU.setText("CPU: 45%")
    lblCPU.fgColor = LIGHTGREEN
    win4.addChild(lblCPU, 1, 2)
    
    lblMem = new Label(k, 0, 0, 36, 1)
    lblMem.setText("Memory: 2.4 GB / 8 GB")
    lblMem.fgColor = LIGHTGREEN
    win4.addChild(lblMem, 1, 3)
    
    lblDisk = new Label(k, 0, 0, 36, 1)
    lblDisk.setText("Disk: 120 GB / 500 GB")
    lblDisk.fgColor = LIGHTGREEN
    win4.addChild(lblDisk, 1, 4)
    
    lblNet = new Label(k, 0, 0, 36, 1)
    lblNet.setText("Network: Connected")
    lblNet.fgColor = LIGHTCYAN
    win4.addChild(lblNet, 1, 5)
    
    # Add windows to manager
    wm.addWindow(win1)
    wm.addWindow(win2)
    wm.addWindow(win3)
    wm.addWindow(win4)
    
    # Run the window manager
    wm.run()
    
    # Cleanup - just return to main menu

func runTreeDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Create main window
    win = new Window(k, 2, 2, 76, 23, "Tree View Demo - ESC: Back to Menu")
    
    # Create info labels
    lblTitle = new Label(k, 4, 4, 70, 1)
    lblTitle.setText("File System Explorer (Tree View)")
    lblTitle.fgColor = YELLOW
    
    lblHelp = new Label(k, 4, 21, 70, 1)
    lblHelp.setText("Arrow Keys: Navigate | +/-/Enter/Space: Expand/Collapse | ESC: Back")
    lblHelp.fgColor = LIGHTGREEN
    
    # Create tree view
    tree = new TreeView(k, 4, 6, 35, 14)
    
    # Build a file system tree
    rootC = tree.addRootText("C:")
    
    # Program Files
    progFiles = rootC.addChildText("Program Files")
    app1 = progFiles.addChildText("Microsoft Office")
    app1.addChildText("Word.exe")
    app1.addChildText("Excel.exe")
    app1.addChildText("PowerPoint.exe")
    app2 = progFiles.addChildText("Ring")
    app2.addChildText("ring.exe")
    app2.addChildText("ring2exe.exe")
    app2.addChildText("ringpm.exe")
    libs = app2.addChildText("lib")
    libs.addChildText("stdlib.ring")
    libs.addChildText("guilib.ring")
    
    # Users
    users = rootC.addChildText("Users")
    user1 = users.addChildText("Mahmoud")
    docs = user1.addChildText("Documents")
    docs.addChildText("report.docx")
    docs.addChildText("budget.xlsx")
    pics = user1.addChildText("Pictures")
    pics.addChildText("photo1.jpg")
    pics.addChildText("photo2.png")
    desktop = user1.addChildText("Desktop")
    desktop.addChildText("shortcut.lnk")
    
    # Windows
    winDir = rootC.addChildText("Windows")
    sys32 = winDir.addChildText("System32")
    sys32.addChildText("cmd.exe")
    sys32.addChildText("notepad.exe")
    winDir.addChildText("explorer.exe")
    
    # Second root - D: drive
    rootD = tree.addRootText("D:")
    projects = rootD.addChildText("Projects")
    proj1 = projects.addChildText("TUI Library")
    proj1.addChildText("tui.ring")
    proj1.addChildText("demo.ring")
    proj1.addChildText("README.md")
    proj2 = projects.addChildText("Web App")
    proj2.addChildText("index.html")
    proj2.addChildText("style.css")
    proj2.addChildText("app.js")
    
    # Expand some nodes by default
    rootC.expand()
    progFiles.expand()
    
    tree.updateVisibleNodes()
    
    # Create second tree for demonstration
    lblTree2 = new Label(k, 42, 4, 30, 1)
    lblTree2.setText("Organization Chart")
    lblTree2.fgColor = YELLOW
    
    tree2 = new TreeView(k, 42, 6, 32, 14)
    
    # Build organization tree
    ceo = tree2.addRootText("CEO - John Smith")
    
    cto = ceo.addChildText("CTO - Jane Doe")
    dev = cto.addChildText("Dev Manager")
    dev.addChildText("Senior Dev")
    dev.addChildText("Junior Dev")
    dev.addChildText("Intern")
    qa = cto.addChildText("QA Manager")
    qa.addChildText("QA Engineer")
    qa.addChildText("Test Analyst")
    
    cfo = ceo.addChildText("CFO - Bob Wilson")
    cfo.addChildText("Accountant")
    cfo.addChildText("Financial Analyst")
    
    coo = ceo.addChildText("COO - Alice Brown")
    hr = coo.addChildText("HR Manager")
    hr.addChildText("Recruiter")
    ops = coo.addChildText("Operations")
    ops.addChildText("Support Lead")
    ops.addChildText("Support Agent")
    
    ceo.expand()
    cto.expand()
    
    tree2.updateVisibleNodes()
    
    # Add all controls to window
    win.addChild(lblTitle)
    win.addChild(lblHelp)
    win.addChild(tree)
    win.addChild(lblTree2)
    win.addChild(tree2)
    
    # Draw window (draws all children automatically)
    win.draw()
    
    # Status bar (outside window)
    $statusBar = new Label(k, 2, 25, 76, 1)
    $statusBar.setText($kernel.width("Tree View Demo - Arrows: Navigate | F4: Switch trees | ESC: Back", 76))
    $statusBar.fgColor = BLACK
    $statusBar.bgColor = GREY
    $statusBar.draw()
    
    # Use global variables for event handlers
    $tree1 = tree
    $tree2 = tree2
    $activeTree = 1
    
    # Focus on first tree
    $tree1.focused = true
    
    # Register trees with EventManager for mouse handling
    em.registerWidget($tree1)
    em.registerWidget($tree2)
    em.setFocus($tree1)
    
    # Set up keyboard handler for tree-specific navigation
    em.setOnKeyboard(func evt {
        nKey = evt.key
        
        # F4 to switch between trees
        if nKey = KEY_F4
            if $activeTree = 1
                $activeTree = 2
                $tree1.focused = false
                $tree2.focused = true
                $statusBar.setText($kernel.width("Organization Chart tree active", 76))
            else
                $activeTree = 1
                $tree1.focused = true
                $tree2.focused = false
                $statusBar.setText($kernel.width("File System tree active", 76))
            ok
            $statusBar.draw()
            $tree1.draw()
            $tree2.draw()
            return true
        ok
        
        # Pass keyboard to active tree
        if $activeTree = 1
            $tree1.handleEvent(evt)
            node = $tree1.getSelectedNode()
            if node != null
                $statusBar.setText($kernel.width("Selected: " + node.text, 76))
                $statusBar.draw()
            ok
        else
            $tree2.handleEvent(evt)
            node = $tree2.getSelectedNode()
            if node != null
                $statusBar.setText($kernel.width("Selected: " + node.text, 76))
                $statusBar.draw()
            ok
        ok
        
        return true
    })
    
    # Set up mouse handler for tree clicking
    em.setOnMouse(func evt {
        # Check which tree was clicked
        if $tree1.handleEvent(evt)
            if $activeTree != 1
                $activeTree = 1
                $tree1.focused = true
                $tree2.focused = false
                $tree2.draw()
            ok
            node = $tree1.getSelectedNode()
            if node != null
                $statusBar.setText($kernel.width("Selected: " + node.text, 76))
                $statusBar.draw()
            ok
            return true
        ok
        
        if $tree2.handleEvent(evt)
            if $activeTree != 2
                $activeTree = 2
                $tree1.focused = false
                $tree2.focused = true
                $tree1.draw()
            ok
            node = $tree2.getSelectedNode()
            if node != null
                $statusBar.setText($kernel.width("Selected: " + node.text, 76))
                $statusBar.draw()
            ok
            return true
        ok
        
        return false
    })
    
    # Run event loop
    em.run()
    
    # Cleanup
    em.setOnKeyboard(null)
    em.setOnMouse(null)
    em.unregisterWidget($tree1)
    em.unregisterWidget($tree2)
    em.setFocus(null)

func runTabsDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Clear screen with black background to remove any artifacts
    k.setTermColor(WHITE, BLACK)  # White on black
    k.clear()
    
    # Fill the entire screen with black to ensure no garbage
    clearLine = copy(" ", 80)
    for row = 1 to 25
        k.printAt(1, row, clearLine)
    next
    
    # Create main window
    win = new Window(k, 2, 2, 76, 23, "Tab Control Demo - ESC: Back to Menu")
    win.draw()
    
    # Create tab control
    tabs = new TabControl(k, 4, 4, 70, 16)
    
    # === Page 1: General Settings ===
    page1 = tabs.addPage("General")
    
    lblGeneral = new Label(k, 0, 0, 60, 1)
    lblGeneral.setText("General Settings")
    lblGeneral.fgColor = YELLOW
    page1.addChild(lblGeneral, 1, 0)
    
    lblUser = new Label(k, 0, 0, 15, 1)
    lblUser.setText("Username:")
    lblUser.fgColor = GREY
    page1.addChild(lblUser, 1, 2)
    
    txtUser = new TextBox(k, 0, 0, 30, 1)
    txtUser.setText("Admin")
    page1.addChild(txtUser, 15, 2)
    
    lblLang = new Label(k, 0, 0, 15, 1)
    lblLang.setText("Language:")
    lblLang.fgColor = GREY
    page1.addChild(lblLang, 1, 4)
    
    cmbLang = new ComboBox(k, 0, 0, 30, 1)
    cmbLang.addItem("English")
    cmbLang.addItem("Spanish")
    cmbLang.addItem("French")
    cmbLang.addItem("German")
    cmbLang.addItem("Arabic")
    page1.addChild(cmbLang, 15, 4)
    
    chkAuto = new CheckBox(k, 0, 0, 30, 1)
    chkAuto.text = "Auto-save enabled"
    chkAuto.checked = true
    page1.addChild(chkAuto, 1, 6)
    
    chkNotify = new CheckBox(k, 0, 0, 30, 1)
    chkNotify.text = "Show notifications"
    chkNotify.checked = true
    page1.addChild(chkNotify, 1, 7)
    
    # === Page 2: Appearance ===
    page2 = tabs.addPage("Appearance")
    
    lblAppear = new Label(k, 0, 0, 60, 1)
    lblAppear.setText("Appearance Settings")
    lblAppear.fgColor = YELLOW
    page2.addChild(lblAppear, 1, 0)
    
    lblTheme = new Label(k, 0, 0, 15, 1)
    lblTheme.setText("Theme:")
    lblTheme.fgColor = GREY
    page2.addChild(lblTheme, 1, 2)
    
    lstTheme = new ListBox(k, 0, 0, 25, 6)
    lstTheme.addItem("Classic Blue")
    lstTheme.addItem("Dark Mode")
    lstTheme.addItem("Light Mode")
    lstTheme.addItem("High Contrast")
    lstTheme.addItem("Custom")
    lstTheme.selectedIndex = 1
    page2.addChild(lstTheme, 15, 2)
    
    chkBold = new CheckBox(k, 0, 0, 25, 1)
    chkBold.text = "Bold text"
    page2.addChild(chkBold, 1, 9)
    
    chkLarge = new CheckBox(k, 0, 0, 25, 1)
    chkLarge.text = "Large fonts"
    page2.addChild(chkLarge, 1, 10)
    
    # === Page 3: Network ===
    page3 = tabs.addPage("Network")
    
    lblNetwork = new Label(k, 0, 0, 60, 1)
    lblNetwork.setText("Network Configuration")
    lblNetwork.fgColor = YELLOW
    page3.addChild(lblNetwork, 1, 0)
    
    lblHost = new Label(k, 0, 0, 15, 1)
    lblHost.setText("Host:")
    lblHost.fgColor = GREY
    page3.addChild(lblHost, 1, 2)
    
    txtHost = new TextBox(k, 0, 0, 35, 1)
    txtHost.setText("localhost")
    page3.addChild(txtHost, 15, 2)
    
    lblPort = new Label(k, 0, 0, 15, 1)
    lblPort.setText("Port:")
    lblPort.fgColor = GREY
    page3.addChild(lblPort, 1, 4)
    
    txtPort = new TextBox(k, 0, 0, 10, 1)
    txtPort.setText("8080")
    page3.addChild(txtPort, 15, 4)
    
    chkSSL = new CheckBox(k, 0, 0, 25, 1)
    chkSSL.text = "Use SSL/TLS"
    chkSSL.checked = true
    page3.addChild(chkSSL, 1, 6)
    
    chkProxy = new CheckBox(k, 0, 0, 25, 1)
    chkProxy.text = "Use proxy server"
    page3.addChild(chkProxy, 1, 7)
    
    btnTest = new Button(k, 0, 0, 18, 1)
    btnTest.text = "Test Connection"
    page3.addChild(btnTest, 1, 10)
    
    # === Page 4: About ===
    page4 = tabs.addPage("About")
    
    lblAbout = new Label(k, 0, 0, 60, 1)
    lblAbout.setText("About This Application")
    lblAbout.fgColor = YELLOW
    page4.addChild(lblAbout, 1, 0)
    
    lblAppName = new Label(k, 0, 0, 60, 1)
    lblAppName.setText("Ring TUI Library Demo")
    lblAppName.fgColor = LIGHTCYAN
    page4.addChild(lblAppName, 1, 2)
    
    lblVersion = new Label(k, 0, 0, 60, 1)
    lblVersion.setText("Version: 1.0.0")
    lblVersion.fgColor = GREY
    page4.addChild(lblVersion, 1, 4)
    
    lblAuthor = new Label(k, 0, 0, 60, 1)
    lblAuthor.setText("A comprehensive TUI framework for Ring")
    lblAuthor.fgColor = GREY
    page4.addChild(lblAuthor, 1, 6)
    
    lblFeatures = new Label(k, 0, 0, 60, 1)
    lblFeatures.setText("Features:")
    lblFeatures.fgColor = LIGHTGREEN
    page4.addChild(lblFeatures, 1, 8)
    
    lblF1 = new Label(k, 0, 0, 55, 1)
    lblF1.setText("- Windows, Buttons, TextBoxes, CheckBoxes")
    lblF1.fgColor = WHITE
    page4.addChild(lblF1, 3, 9)
    
    lblF2 = new Label(k, 0, 0, 55, 1)
    lblF2.setText("- ListBox, ComboBox, Grid, Menu")
    lblF2.fgColor = WHITE
    page4.addChild(lblF2, 3, 10)
    
    lblF3 = new Label(k, 0, 0, 55, 1)
    lblF3.setText("- TreeView, TabControl, and more!")
    lblF3.fgColor = WHITE
    page4.addChild(lblF3, 3, 11)
    
    # Draw the tab control (this will draw only active page children)
    tabs.draw()
    
    # Create info label (draw after tabs)
    lblHelp = new Label(k, 4, 21, 70, 1)
    lblHelp.setText("F3: Switch tabs | TAB: Navigate controls | Click to focus | ESC: Back")
    lblHelp.fgColor = LIGHTGREEN
    lblHelp.draw()
    
    # Status bar
    statusBar = new Label(k, 2, 25, 76, 1)
    statusBar.setText(k.width("Tab Control Demo - Active Tab: General", 76))
    statusBar.fgColor = BLACK
    statusBar.bgColor = GREY
    statusBar.draw()
    
    # Configure EventManager for tab-based UI
    em.clearWidgets()
    em.setTabControl(tabs)
    em.setStatusBar(statusBar)
    
    # Run event loop - EventManager handles everything!
    em.run()
    
    # Cleanup
    em.setTabControl(null)
    em.setStatusBar(null)

func runControlsDemo(k, em)
    # Clear any leftover screen widgets from previous demos
    k.clearScreenWidgets()
    
    # Create main window
    win = new Window(k, 2, 2, 76, 23, "Controls Demo - ESC: Back to Menu")
    
    # === Progress Bars Section ===
    lblProgress = new Label(k, 4, 4, 25, 1)
    lblProgress.setText("Progress Bars:")
    lblProgress.fgColor = YELLOW
    
    # Progress bar 1 - with percentage
    lblProg1 = new Label(k, 4, 6, 15, 1)
    lblProg1.setText("Download:")
    lblProg1.fgColor = GREY
    
    progress1 = new ProgressBar(k, 20, 6, 40, 1)
    progress1.setValue(75)
    progress1.barFgColor = LIGHTGREEN  # Green
    
    # Progress bar 2 - different color
    lblProg2 = new Label(k, 4, 8, 15, 1)
    lblProg2.setText("Upload:")
    lblProg2.fgColor = GREY
    
    progress2 = new ProgressBar(k, 20, 8, 40, 1)
    progress2.setValue(30)
    progress2.barFgColor = LIGHTCYAN  # Cyan
    
    # Progress bar 3 - no percentage
    lblProg3 = new Label(k, 4, 10, 15, 1)
    lblProg3.setText("Processing:")
    lblProg3.fgColor = GREY
    
    progress3 = new ProgressBar(k, 20, 10, 40, 1)
    progress3.setValue(50)
    progress3.showPercentage = false
    progress3.barFgColor = YELLOW  # Yellow
    
    # === Spinners Section ===
    lblSpinners = new Label(k, 4, 12, 25, 1)
    lblSpinners.setText("Spinners:")
    lblSpinners.fgColor = YELLOW
    
    lblSpin1 = new Label(k, 4, 14, 15, 1)
    lblSpin1.setText("Quantity:")
    lblSpin1.fgColor = GREY
    
    spinner1 = new Spinner(k, 20, 14, 15, 1)
    spinner1.setValue(10)
    spinner1.setRange(0, 100)
    spinner1.step = 1
    
    lblSpin2 = new Label(k, 40, 14, 15, 1)
    lblSpin2.setText("Percent:")
    lblSpin2.fgColor = GREY
    
    spinner2 = new Spinner(k, 56, 14, 15, 1)
    spinner2.setValue(50)
    spinner2.setRange(0, 100)
    spinner2.step = 5
    
    # === Scroll Bars Section ===
    lblScrolls = new Label(k, 4, 16, 25, 1)
    lblScrolls.setText("Scroll Bars:")
    lblScrolls.fgColor = YELLOW
    
    # Horizontal scroll bar
    lblHScroll = new Label(k, 4, 18, 15, 1)
    lblHScroll.setText("Horizontal:")
    lblHScroll.fgColor = GREY
    
    hscroll = new HScrollBar(k, 20, 18, 30, 1)
    hscroll.setValue(25)
    
    lblHValue = new Label(k, 52, 18, 10, 1)
    lblHValue.setText($kernel.width("Val: 25", 10))
    lblHValue.fgColor = WHITE
    
    # Vertical scroll bar
    lblVScroll = new Label(k, 4, 20, 15, 1)
    lblVScroll.setText("Vertical:")
    lblVScroll.fgColor = GREY
    
    vscroll = new VScrollBar(k, 74, 4, 1, 18)
    vscroll.setValue(50)
    
    lblVValue = new Label(k, 63, 20, 10, 1)
    lblVValue.setText($kernel.width("Val: 50", 10))
    lblVValue.fgColor = WHITE
    
    # Info label
    lblInfo = new Label(k, 4, 22, 70, 1)
    lblInfo.setText("TAB: Navigate | Arrows/Click: Adjust | ENTER: Edit spinner | ESC: Back")
    lblInfo.fgColor = LIGHTGREEN
    
    # Add all controls to window
    win.addChild(lblProgress)
    win.addChild(lblProg1)
    win.addChild(progress1)
    win.addChild(lblProg2)
    win.addChild(progress2)
    win.addChild(lblProg3)
    win.addChild(progress3)
    win.addChild(lblSpinners)
    win.addChild(lblSpin1)
    win.addChild(spinner1)
    win.addChild(lblSpin2)
    win.addChild(spinner2)
    win.addChild(lblScrolls)
    win.addChild(lblHScroll)
    win.addChild(hscroll)
    win.addChild(lblHValue)
    win.addChild(lblVScroll)
    win.addChild(vscroll)
    win.addChild(lblVValue)
    win.addChild(lblInfo)
    
    # Draw window (draws all children automatically)
    win.draw()
    
    # Status bar (outside window)
    $statusBar = new Label(k, 2, 25, 76, 1)
    $statusBar.setText($kernel.width("Controls Demo - TAB: Navigate controls", 76))
    $statusBar.fgColor = BLACK
    $statusBar.bgColor = GREY
    $statusBar.draw()
    
    # Register widgets for focus navigation
    em.registerWidget(spinner1)
    em.registerWidget(spinner2)
    em.registerWidget(hscroll)
    em.registerWidget(vscroll)
    
    em.setFocus(spinner1)
    
    # Use global variables for event handlers
    $spinner1 = spinner1
    $spinner2 = spinner2
    $hscroll = hscroll
    $vscroll = vscroll
    $progress1 = progress1
    $progress2 = progress2
    $progress3 = progress3
    $lblHValue = lblHValue
    $lblVValue = lblVValue
    $controlsEM = em
    
    # Set up keyboard handler
    em.setOnKeyboard(func evt {
        nKey = evt.key
        
        # TAB to switch focus (handled by default, but update status)
        if nKey = 9
            $controlsEM.focusNext()
            $statusBar.setText($kernel.width("Focused: " + getFocusedControlName($controlsEM.focusedWidget), 76))
            $statusBar.draw()
            return true
        ok
        
        # Pass to focused widget
        if $controlsEM.focusedWidget != null
            $controlsEM.focusedWidget.handleEvent(evt)
            updateControlsDisplay($lblHValue, $lblVValue, $hscroll, $vscroll, $spinner1, $spinner2, $progress1)
        ok
        
        return true
    })
    
    # Set up mouse handler
    em.setOnMouse(func evt {
        # Check each control
        if $spinner1.handleEvent(evt)
            $controlsEM.setFocus($spinner1)
        but $spinner2.handleEvent(evt)
            $controlsEM.setFocus($spinner2)
        but $hscroll.handleEvent(evt)
            $controlsEM.setFocus($hscroll)
        but $vscroll.handleEvent(evt)
            $controlsEM.setFocus($vscroll)
        ok
        
        updateControlsDisplay($lblHValue, $lblVValue, $hscroll, $vscroll, $spinner1, $spinner2, $progress1)
        return true
    })
    
    # Set up timer for animation (every 20 iterations = ~200ms)
    em.setOnTimer(func {
        # Animate progress1
        newVal = $progress1.getValue() + 2
        if newVal > 100
            newVal = 0
        ok
        $progress1.setValue(newVal)
        $progress1.draw()
        
        # Animate progress3
        newVal3 = $progress3.getValue() + 3
        if newVal3 > 100
            newVal3 = 0
        ok
        $progress3.setValue(newVal3)
        $progress3.draw()
        
        # Link spinner1 to progress2
        $progress2.setValue($spinner1.getValue())
        $progress2.draw()
    }, 20)
    
    # Run event loop
    em.run()
    
    # Cleanup
    em.setOnKeyboard(null)
    em.setOnMouse(null)
    em.setOnTimer(null, 0)
    em.unregisterWidget(spinner1)
    em.unregisterWidget(spinner2)
    em.unregisterWidget(hscroll)
    em.unregisterWidget(vscroll)
    em.setFocus(null)

func runMenuTabsDemo(k, em)
    # Clear screen
    k.setTermColor(WHITE, BLACK)
    k.clear()
    
    clearLine = copy(" ", 80)
    for row = 1 to 25
        k.printAt(1, row, clearLine)
    next
    
    # Set the default background color for this demo (black)
    k.setDefaultColors(15, 0)  # White on black
    
    # Clear any previously registered screen widgets
    k.clearScreenWidgets()
    
    # ========================================
    # Create Menu Bar at the top
    # ========================================
    menuBar = new MenuBar(k, 1, 1, 80)
    
    # ===== FILE MENU =====
    fileMenu = menuBar.createMenu("File")
    
    fileMenu.addNormalItem("New", func item {
        $statusBar.setText($kernel.width("Creating new document...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+N")
    
    fileMenu.addNormalItem("Open", func item {
        $statusBar.setText($kernel.width("Opening file...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+O")
    
    fileMenu.addNormalItem("Save", func item {
        $statusBar.setText($kernel.width("Saving file...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+S")
    
    fileMenu.addSeparator()
    
    fileMenu.addNormalItem("Exit", func item {
        $statusBar.setText($kernel.width("Use ESC to exit demo", 78))
        $statusBar.draw()
    }).setShortcut("Alt+F4")
    
    # ===== EDIT MENU =====
    editMenu = menuBar.createMenu("Edit")
    
    editMenu.addNormalItem("Undo", func item {
        $statusBar.setText($kernel.width("Undo last action", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+Z")
    
    editMenu.addNormalItem("Redo", func item {
        $statusBar.setText($kernel.width("Redo action", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+Y")
    
    editMenu.addSeparator()
    
    editMenu.addNormalItem("Cut", func item {
        $statusBar.setText($kernel.width("Cut to clipboard", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+X")
    
    editMenu.addNormalItem("Copy", func item {
        $statusBar.setText($kernel.width("Copy to clipboard", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+C")
    
    editMenu.addNormalItem("Paste", func item {
        $statusBar.setText($kernel.width("Paste from clipboard", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+V")
    
    # ===== VIEW MENU =====
    viewMenu = menuBar.createMenu("View")
    
    viewMenu.addCheckboxItem("Toolbar", true, func item {
        if item.checked
            $statusBar.setText($kernel.width("Toolbar shown", 78))
        else
            $statusBar.setText($kernel.width("Toolbar hidden", 78))
        ok
        $statusBar.draw()
    })
    
    viewMenu.addCheckboxItem("Status Bar", true, func item {
        if item.checked
            $statusBar.setText($kernel.width("Status bar shown", 78))
        else
            $statusBar.setText($kernel.width("Status bar hidden", 78))
        ok
        $statusBar.draw()
    })
    
    viewMenu.addSeparator()
    
    # Zoom submenu
    zoomMenu = new Menu(k)
    zoomMenu.addNormalItem("Zoom In", func item {
        $statusBar.setText($kernel.width("Zooming in...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl++")
    zoomMenu.addNormalItem("Zoom Out", func item {
        $statusBar.setText($kernel.width("Zooming out...", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+-")
    zoomMenu.addNormalItem("100%", func item {
        $statusBar.setText($kernel.width("Zoom reset to 100%", 78))
        $statusBar.draw()
    }).setShortcut("Ctrl+0")
    
    viewMenu.addSubmenu("Zoom", zoomMenu)
    
    # ===== SETTINGS MENU =====
    settingsMenu = menuBar.createMenu("Settings")
    
    settingsMenu.addNormalItem("Preferences", func item {
        $statusBar.setText($kernel.width("Opening preferences... (See tabs below!)", 78))
        $statusBar.draw()
    })
    
    settingsMenu.addNormalItem("Keyboard Shortcuts", func item {
        $statusBar.setText($kernel.width("Showing keyboard shortcuts...", 78))
        $statusBar.draw()
    })
    
    # ===== HELP MENU =====
    helpMenu = menuBar.createMenu("Help")
    
    helpMenu.addNormalItem("Documentation", func item {
        $statusBar.setText($kernel.width("Opening documentation...", 78))
        $statusBar.draw()
    }).setShortcut("F1")
    
    helpMenu.addSeparator()
    
    helpMenu.addNormalItem("About", func item {
        $statusBar.setText($kernel.width("Ring TUI Library - Menu + Tabs Demo", 78))
        $statusBar.draw()
    })
    
    menuBar.draw()
    
    # ========================================
    # Create Tab Control below the menu bar
    # ========================================
    tabs = new TabControl(k, 2, 3, 76, 18)
    
    # === Page 1: General Settings ===
    page1 = tabs.addPage("General")
    
    lblGeneral = new Label(k, 0, 0, 60, 1)
    lblGeneral.setText("General Settings")
    lblGeneral.fgColor = YELLOW
    page1.addChild(lblGeneral, 1, 0)
    
    lblUser = new Label(k, 0, 0, 15, 1)
    lblUser.setText("Username:")
    lblUser.fgColor = GREY
    page1.addChild(lblUser, 1, 2)
    
    txtUser = new TextBox(k, 0, 0, 30, 1)
    txtUser.setText("Admin")
    page1.addChild(txtUser, 15, 2)
    
    lblLang = new Label(k, 0, 0, 15, 1)
    lblLang.setText("Language:")
    lblLang.fgColor = GREY
    page1.addChild(lblLang, 1, 4)
    
    cmbLang = new ComboBox(k, 0, 0, 30, 1)
    cmbLang.addItem("English")
    cmbLang.addItem("Spanish")
    cmbLang.addItem("French")
    cmbLang.addItem("German")
    cmbLang.addItem("Arabic")
    page1.addChild(cmbLang, 15, 4)
    
    chkAuto = new CheckBox(k, 0, 0, 30, 1)
    chkAuto.text = "Auto-save enabled"
    chkAuto.checked = true
    page1.addChild(chkAuto, 1, 6)
    
    chkNotify = new CheckBox(k, 0, 0, 30, 1)
    chkNotify.text = "Show notifications"
    chkNotify.checked = true
    page1.addChild(chkNotify, 1, 7)
    
    lblInfo1 = new Label(k, 0, 0, 65, 1)
    lblInfo1.setText("Configure your general application settings here.")
    lblInfo1.fgColor = LIGHTGREEN
    page1.addChild(lblInfo1, 1, 10)
    
    # === Page 2: Appearance ===
    page2 = tabs.addPage("Appearance")
    
    lblAppear = new Label(k, 0, 0, 60, 1)
    lblAppear.setText("Appearance Settings")
    lblAppear.fgColor = YELLOW
    page2.addChild(lblAppear, 1, 0)
    
    lblTheme = new Label(k, 0, 0, 15, 1)
    lblTheme.setText("Theme:")
    lblTheme.fgColor = GREY
    page2.addChild(lblTheme, 1, 2)
    
    lstTheme = new ListBox(k, 0, 0, 25, 6)
    lstTheme.addItem("Classic Blue")
    lstTheme.addItem("Dark Mode")
    lstTheme.addItem("Light Mode")
    lstTheme.addItem("High Contrast")
    lstTheme.addItem("Custom")
    lstTheme.selectedIndex = 2
    page2.addChild(lstTheme, 15, 2)
    
    chkBold = new CheckBox(k, 0, 0, 25, 1)
    chkBold.text = "Bold text"
    page2.addChild(chkBold, 1, 9)
    
    chkLarge = new CheckBox(k, 0, 0, 25, 1)
    chkLarge.text = "Large fonts"
    page2.addChild(chkLarge, 1, 10)
    
    lblInfo2 = new Label(k, 0, 0, 65, 1)
    lblInfo2.setText("Customize the look and feel of your application.")
    lblInfo2.fgColor = LIGHTGREEN
    page2.addChild(lblInfo2, 1, 12)
    
    # === Page 3: Network ===
    page3 = tabs.addPage("Network")
    
    lblNetwork = new Label(k, 0, 0, 60, 1)
    lblNetwork.setText("Network Configuration")
    lblNetwork.fgColor = YELLOW
    page3.addChild(lblNetwork, 1, 0)
    
    lblHost = new Label(k, 0, 0, 15, 1)
    lblHost.setText("Host:")
    lblHost.fgColor = GREY
    page3.addChild(lblHost, 1, 2)
    
    txtHost = new TextBox(k, 0, 0, 35, 1)
    txtHost.setText("localhost")
    page3.addChild(txtHost, 15, 2)
    
    lblPort = new Label(k, 0, 0, 15, 1)
    lblPort.setText("Port:")
    lblPort.fgColor = GREY
    page3.addChild(lblPort, 1, 4)
    
    txtPort = new TextBox(k, 0, 0, 10, 1)
    txtPort.setText("8080")
    page3.addChild(txtPort, 15, 4)
    
    chkSSL = new CheckBox(k, 0, 0, 25, 1)
    chkSSL.text = "Use SSL/TLS"
    chkSSL.checked = true
    page3.addChild(chkSSL, 1, 6)
    
    chkProxy = new CheckBox(k, 0, 0, 25, 1)
    chkProxy.text = "Use proxy server"
    page3.addChild(chkProxy, 1, 7)
    
    btnTest = new Button(k, 0, 0, 18, 1)
    btnTest.text = "Test Connection"
    page3.addChild(btnTest, 1, 10)
    
    lblInfo3 = new Label(k, 0, 0, 65, 1)
    lblInfo3.setText("Configure network and connection settings.")
    lblInfo3.fgColor = LIGHTGREEN
    page3.addChild(lblInfo3, 1, 12)
    
    # === Page 4: About ===
    page4 = tabs.addPage("About")
    
    lblAbout = new Label(k, 0, 0, 60, 1)
    lblAbout.setText("About This Application")
    lblAbout.fgColor = YELLOW
    page4.addChild(lblAbout, 1, 0)
    
    lblAppName = new Label(k, 0, 0, 60, 1)
    lblAppName.setText("Ring TUI Library - Combined Demo")
    lblAppName.fgColor = LIGHTCYAN
    page4.addChild(lblAppName, 1, 2)
    
    lblVersion = new Label(k, 0, 0, 60, 1)
    lblVersion.setText("Version: 1.0.0")
    lblVersion.fgColor = GREY
    page4.addChild(lblVersion, 1, 4)
    
    lblDesc = new Label(k, 0, 0, 60, 1)
    lblDesc.setText("This demo shows Menu Bar and Tab Control together")
    lblDesc.fgColor = GREY
    page4.addChild(lblDesc, 1, 6)
    
    lblFeatures = new Label(k, 0, 0, 60, 1)
    lblFeatures.setText("Features demonstrated:")
    lblFeatures.fgColor = LIGHTGREEN
    page4.addChild(lblFeatures, 1, 8)
    
    lblF1 = new Label(k, 0, 0, 55, 1)
    lblF1.setText("- Menu bar with submenus and checkboxes")
    lblF1.fgColor = WHITE
    page4.addChild(lblF1, 3, 9)
    
    lblF2 = new Label(k, 0, 0, 55, 1)
    lblF2.setText("- Tab control with multiple pages")
    lblF2.fgColor = WHITE
    page4.addChild(lblF2, 3, 10)
    
    lblF3 = new Label(k, 0, 0, 55, 1)
    lblF3.setText("- Various controls on each tab page")
    lblF3.fgColor = WHITE
    page4.addChild(lblF3, 3, 11)
    
    # Register tabs with kernel for smart redrawing when menus close
    k.registerScreenWidget(tabs)
    
    # Draw tabs
    tabs.draw()
    
    # ========================================
    # Create Help label and Status Bar
    # ========================================
    lblHelp = new Label(k, 2, 22, 76, 1)
    lblHelp.setText("F2/Click: Menu | F3: Switch Tabs | TAB: Navigate | ESC: Exit")
    lblHelp.fgColor = LIGHTGREEN
    lblHelp.draw()
    
    # Register lblHelp with kernel for smart redrawing
    k.registerScreenWidget(lblHelp)
    
    statusBar = new Label(k, 1, 25, 80, 1)
    statusBar.setText(k.width("Menu + Tabs Demo - Click on controls to interact with them", 80))
    statusBar.fgColor = BLACK
    statusBar.bgColor = GREY
    statusBar.draw()
    
    # Configure EventManager for menu + tabs UI
    em.clearWidgets()
    em.setMenuBar(menuBar)
    em.setTabControl(tabs)
    em.setStatusBar(statusBar)
    
    # Run event loop - EventManager handles everything!
    em.run()
    
    # Cleanup
    em.setMenuBar(null)
    em.setTabControl(null)
    em.setStatusBar(null)
    k.clearScreenWidgets()  # Important: clear registered widgets to prevent slowdown

func drawMenuTabsDemoScreen(k, menuBar, tabs, lblHelp)
    # This function is no longer needed with the new EventManager
    # Kept for backward compatibility
    menuBar.draw()
    tabs.draw()
    lblHelp.draw()
    k.resetTermColor()

func getFocusedControlName(widget)
    if widget = null
        return "None"
    ok
    
    cName = classname(widget)
    switch cName
        on "spinner"
            return "Spinner"
        on "hscrollbar"
            return "Horizontal ScrollBar"
        on "vscrollbar"
            return "Vertical ScrollBar"
        other
            return cName
    off
    return "Unknown"

func updateControlsDisplay(lblHValue, lblVValue, hscroll, vscroll, spinner1, spinner2, progress1)
    lblHValue.setText($kernel.width("Val: " + hscroll.getValue(), 10))
    lblHValue.draw()
    lblVValue.setText($kernel.width("Val: " + vscroll.getValue(), 10))
    lblVValue.draw()

func prepareScreen
	setColor(White)
	setBackgroundColor(Blue)
	cls()

func mygotoxy x,y
    gotoxy(x,y)

func mygetkey
    return getkey()

func myenablemouse
    return enablemouse()

func mydisablemouse
    return disablemouse()

func mygetmouseinfo
    # RogueUtil uses MouseInfo() function that needs buffer and key parameters
    return null  # Not used directly

# ========================================
# Kernel Class - Abstracts RogueUtil Functions
# ========================================
class Kernel

    # Terminal state

    rows = 0
    cols = 0
    mouseEnabled = false
    
    # Screen management - list of widgets to redraw when a region is cleared
    screenWidgets = []
    
    # Default background color for clearing regions (can be changed by each demo)
    defaultFgColor = WHITE   # White
    defaultBgColor = BLACK    # Black (default), change to 1 for blue background
    
    func init
        rows = trows()
        cols = tcols()
        hidecursor()
        echooff()  # Disable automatic echo of typed characters
        screenWidgets = []
        defaultFgColor = WHITE
        defaultBgColor = BLACK
        return self
        
    func getRows
        return trows()
        
    func getCols
        return tcols()
        
    func setDefaultColors(fg, bg)
        defaultFgColor = fg
        defaultBgColor = bg
        return self
        
    # ========================================
    # Screen Widget Management
    # ========================================
    
    func registerScreenWidget(widget)
        # Register a widget for automatic redrawing when regions are cleared
        add(screenWidgets, ref(widget))
        return self
        
    func unregisterScreenWidget(widget)
        # Remove a widget from screen management
        for i = 1 to len(screenWidgets)
            if screenWidgets[i] = widget
                del(screenWidgets, i)
                exit
            ok
        next
        return self
        
    func clearScreenWidgets
        screenWidgets = []
        return self
        
    func redrawRegion(rx, ry, rw, rh)
        # Redraw all registered widgets that intersect with the given region
        # This is called when a menu closes to restore the background
        for widget in screenWidgets
            if widget.visible
                if rectanglesIntersect(widget.x, widget.y, widget.width, widget.height, rx, ry, rw, rh)
                    widget.draw()
                ok
            ok
        next
        
    func clearRegion(rx, ry, rw, rh)
        # Clear a rectangular region with the default background color
        setTermColor(defaultFgColor, defaultBgColor)
        clearLine = copy(" ", rw)
        for row = ry to ry + rh - 1
            printAt(rx, row, clearLine)
        next
        resetTermColor()
        
    func rectanglesIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
        # Check if two rectangles intersect
        if x1 >= x2 + w2 or x2 >= x1 + w1
            return false
        ok
        if y1 >= y2 + h2 or y2 >= y1 + h1
            return false
        ok
        return true
        
    func gotoXY(x, y)
        mygotoxy(x, y)
        
    func clear
        cls()
        
    func setCursorVisible(visible)
        setCursorVisibility(visible)
        
    func setTermColor(fg, bg)
        setColor(fg)
        setBackgroundColor(bg)
        
    func resetTermColor
        resetColor()
        
    func getKey
        return mygetkey()
        
    func checkKeyHit
        return kbhit()
        
    func getChar
        return getch()
        
    func nbGetch
        return nb_getch()
        
    func printAt(x, y, text)
        printXY(x, y, text)
        
    func setTitle(title)
        setConsoleTitle(title)
        
    func enableMouse
        myenablemouse()
        mouseEnabled = true
        
    func disableMouse
        mydisablemouse()
        mouseEnabled = false
        
    func getMouseInfo
        # Mouse info requires buffer and key state
        # Return null for now as mouse handling is done differently
        return null
        
    func sleep(milliseconds)
        msleep(milliseconds)
        
    func waitForKey(msg)
        anykey(msg)
        
    func enableEcho
        echoon()
        
    func disableEcho
        echooff()
        
    func drawBox(x, y, w, h, ch)
        # Draw horizontal lines
        hLine = ""
        for i = 1 to w
            hLine = hLine + char(ch)
        next
        self.printAt(x, y, hLine)
        self.printAt(x, y + h - 1, hLine)
        
        # Draw vertical lines
        vChar = char(ch)
        for i = y + 1 to y + h - 2
            self.printAt(x, i, vChar)
            self.printAt(x + w - 1, i, vChar)
        next
        
    func drawRect(x, y, w, h)
        # Use simple ASCII characters for compatibility
        # + for corners, - for horizontal, | for vertical
        
        # Build top line: +----+
        topLine = "+"
        for i = 1 to w - 2
            topLine = topLine + "-"
        next
        topLine = topLine + "+"
        self.printAt(x, y, topLine)
        
        # Middle lines: |    |
        middleLine = "|" + copy(" ", w - 2) + "|"
        for i = y + 1 to y + h - 2
            self.printAt(x, i, middleLine)
        next
        
        # Bottom line: +----+
        bottomLine = "+"
        for i = 1 to w - 2
            bottomLine = bottomLine + "-"
        next
        bottomLine = bottomLine + "+"
        self.printAt(x, y + h - 1, bottomLine)
        
    func fillRect(x, y, w, h, ch)
        fillLine = ""
        for j = 1 to w
            fillLine = fillLine + char(ch)
        next
        for i = y to y + h - 1
            self.printAt(x, i, fillLine)
        next

    func width(text, size)
        # Returns a string of exactly 'size' characters
        # Pads with spaces if text is shorter, truncates if longer
        # Useful for fixed-width display to avoid visual interference
        textLen = len(text)
        if textLen = size
            return text
        but textLen < size
            # Pad with spaces on the right
            return text + copy(" ", size - textLen)
        else
            # Truncate to fit
            return left(text, size)
        ok

# ========================================
# Event Class - Event data structure
# ========================================
class Event

    type = ""      # "keyboard", "mouse", "timer"
    key = 0        # Key code
    char = ""      # Character
    x = 0          # Mouse X
    y = 0          # Mouse Y
    target = null  # Target widget
    data = null    # Additional data
    
    func init(eventType)
        type = eventType
        return self

# ========================================
# EventManager Class - Main event loop and registration
# ========================================
class EventManager

    kernel = null
    widgets = []
    focusedWidget = null
    running = false
    eventHandlers = []
    
    # High-level UI components
    menuBar = null          # Optional MenuBar
    tabControl = null       # Optional TabControl  
    statusBar = null        # Optional status bar Label
    
    # Tab control integration
    tabFocusedControl = null  # Currently focused control inside a tab
    
    # Custom event handlers (for demo-specific logic)
    onKeyboardHandler = null
    onMouseHandler = null
    onTimerHandler = null
    timerInterval = 0         # Timer interval in iterations (0 = disabled)
    timerCounter = 0
    
    func init(k)
        kernel = ref(k)
        return self
        
    func registerWidget(widget)
        add(widgets, ref(widget))
        
    func unregisterWidget(widget)
        index = find(widgets, widget)
        if index > 0
            del(widgets, index)
        ok
        
    func clearWidgets
        widgets = []
        focusedWidget = null
        tabFocusedControl = null
        
    func setOnKeyboard(handler)
        onKeyboardHandler = handler
        return self
        
    func setOnMouse(handler)
        onMouseHandler = handler
        return self
        
    func setOnTimer(handler, interval)
        onTimerHandler = handler
        timerInterval = interval
        timerCounter = 0
        return self
        
    func setMenuBar(mb)
        menuBar = mb
        return self
        
    func setTabControl(tc)
        tabControl = tc
        return self
        
    func setStatusBar(sb)
        statusBar = sb
        return self
        
    func setStatus(text)
        if statusBar != null
            statusBar.setText(kernel.width(text, statusBar.width))
            statusBar.draw()
        ok
    
    func setFocus(widget)
        if focusedWidget != null
            focusedWidget.focused = false
            focusedWidget.draw()
        ok
        focusedWidget = widget
        if widget != null
            widget.focused = true
            widget.draw()
            # Show cursor for text input controls
            if ismethod(widget, "showCursor")
                widget.showCursor()
            ok
        ok
        
    func setTabFocus(widget)
        # Set focus to a control inside a TabControl
        if tabFocusedControl != null
            tabFocusedControl.focused = false
            tabFocusedControl.draw()
        ok
        tabFocusedControl = widget
        if widget != null
            widget.focused = true
            widget.draw()
            # Show cursor for text input controls
            if ismethod(widget, "showCursor")
                widget.showCursor()
            ok
        ok
        
    func clearTabFocus
        if tabFocusedControl != null
            tabFocusedControl.focused = false
            tabFocusedControl.draw()
            tabFocusedControl = null
        ok
        
    func addEventListener(eventType, handler)
        add(eventHandlers, [eventType, handler])
        
    func fireEvent(event)
        for handler in eventHandlers
            if handler[1] = event.type
                funcPtr = handler[2]
                call funcPtr(event)
            ok
        next
        
    func run
        running = true
        nBuffer = 0
        nKey = 0
        
        while running
            nBuffer = kernel.checkKeyHit()
            nKey = 0
            eventHandled = false
            
            if nBuffer
                nKey = kernel.getKey()
                
                # Create keyboard event
                evt = new Event("keyboard")
                evt.key = nKey
                evt.char = char(nKey)
                evt.target = focusedWidget
                
                # Handle ESC key
                if nKey = 27 or nKey = KEY_ESCAPE
                    eventHandled = handleEscapeKey()
                ok
                
                # Handle F2 for menu bar
                if not eventHandled and nKey = KEY_F2 and menuBar != null
                    handleMenuBarActivation()
                    eventHandled = true
                ok
                
                # Handle F3 key for switching tab pages (only if tabControl is set)
                if not eventHandled and nKey = KEY_F3 and tabControl != null
                    eventHandled = handleTabPageSwitch()
                ok
                
                # Call custom keyboard handler if set
                if not eventHandled and onKeyboardHandler != null
                    eventHandled = call onKeyboardHandler(evt)
                ok
                
                # Handle TAB key for focus navigation between controls
                if not eventHandled and nKey = 9
                    eventHandled = handleTabFocusNavigation()
                ok
                
                # If we have a TabControl with a focused control inside, send keys there
                if not eventHandled and tabControl != null and tabFocusedControl != null
                    tabFocusedControl.handleEvent(evt)
                    tabFocusedControl.draw()
                    eventHandled = true
                ok
                
                # Send to focused widget if not handled
                if not eventHandled and focusedWidget != null
                    focusedWidget.handleEvent(evt)
                    
                    # Check if widget has a pending mouse click (e.g., Grid after edit mode)
                    handlePendingMouseClick()
                ok
                
                # Fire to listeners
                fireEvent(evt)
            ok
            
            # Check for mouse events if enabled
            if kernel.mouseEnabled
                aMouse = MouseInfo(nBuffer, nKey)
                
                if aMouse[MOUSEINFO_ACTIVE]
                    mouseX = aMouse[MOUSEINFO_X]
                    mouseY = aMouse[MOUSEINFO_Y]
                    mouseButton = aMouse[MOUSEINFO_BUTTONS]
                    
                    # Left mouse button click
                    if mouseButton = MOUSEINFO_LEFTBUTTON
                        # Call custom mouse handler first if set
                        mouseHandled = false
                        if onMouseHandler != null
                            mouseEvt = new Event("mouse")
                            mouseEvt.x = mouseX
                            mouseEvt.y = mouseY
                            mouseEvt.data = true
                            mouseHandled = call onMouseHandler(mouseEvt)
                        ok
                        
                        if not mouseHandled
                            handleMouseClick(mouseX, mouseY, aMouse)
                        ok
                    ok
                ok
            ok
            
            # Call timer handler if set
            if onTimerHandler != null and timerInterval > 0
                timerCounter++
                if timerCounter >= timerInterval
                    timerCounter = 0
                    call onTimerHandler()
                ok
            ok
            
            # Ensure cursor is visible for focused text controls after all drawing
            if tabFocusedControl != null and ismethod(tabFocusedControl, "showCursor")
                tabFocusedControl.showCursor()
            but focusedWidget != null and ismethod(focusedWidget, "showCursor")
                focusedWidget.showCursor()
            ok
            
            # Small delay to prevent CPU overuse
            kernel.sleep(1)
        end
        
    func handleEscapeKey
        # Handle ESC key press
        
        # If we have a focused control in a tab, unfocus it first
        if tabControl != null and tabFocusedControl != null
            clearTabFocus()
            setStatus("Control unfocused - Click to focus another")
            return true
        ok
        
        # Default: stop running
        running = false
        return true
        
    func handleMenuBarActivation
        # Activate the menu bar
        menuBar.activate()
        menuBar.openMenu(1)
        menuBar.runMenuLoop()
        # Menu bar handles its own cleanup via kernel.redrawRegion
        
    func handleTabPageSwitch
        # Handle F3 key - switch tab pages
        if tabControl != null
            tabControl.nextPage()
            tabControl.draw()
            page = tabControl.getActivePage()
            if page != null and statusBar != null
                setStatus("Active Tab: " + page.title)
            ok
            # Clear any focused control when switching tabs
            clearTabFocus()
            return true
        ok
        return false
        
    func handleTabFocusNavigation
        # Handle TAB key - navigate between controls
        
        # If we have a TabControl, navigate between controls in the active page
        if tabControl != null
            page = tabControl.getActivePage()
            if page != null and len(page.children) > 0
                # Find next focusable control in tab page
                nextTabPageControl()
                return true
            ok
        ok
        
        # Otherwise, focus next widget in the main widget list
        focusNext()
        return true
        
    func nextTabPageControl
        # Navigate to next control in active tab page
        page = tabControl.getActivePage()
        if page = null or len(page.children) = 0
            return
        ok
        
        # Find current focused index
        currentIdx = 0
        for i = 1 to len(page.children)
            if page.children[i].focused
                currentIdx = i
                exit
            ok
        next
        
        # Count focusable children
        focusableCount = 0
        for child in page.children
            if child.focusable and child.visible
                focusableCount++
            ok
        next
        
        # If no focusable children, do nothing
        if focusableCount = 0
            return
        ok
        
        # Clear current focus
        if currentIdx > 0
            page.children[currentIdx].focused = false
            page.children[currentIdx].draw()
        ok
        
        # Find next focusable control (skip non-focusable ones like Label)
        nextIdx = currentIdx
        attempts = 0
        while attempts < len(page.children)
            nextIdx++
            if nextIdx > len(page.children)
                nextIdx = 1
            ok
            
            # Check if this child is focusable
            if page.children[nextIdx].focusable and page.children[nextIdx].visible
                exit
            ok
            
            attempts++
        end
        
        # Set focus to next focusable control
        setTabFocus(page.children[nextIdx])
        
        if statusBar != null
            ctrlName = classname(page.children[nextIdx])
            setStatus("Focused: " + ctrlName + " - Use keyboard to interact")
        ok
        
    func handlePendingMouseClick
        # Check if focused widget has a pending mouse click
        if focusedWidget = null
            return
        ok
        
        if not ismethod(focusedWidget, "hasPendingMouseClick")
            return
        ok
        
        if not focusedWidget.hasPendingMouseClick()
            return
        ok
        
        clickInfo = focusedWidget.getPendingMouseClick()
        if clickInfo = null
            return
        ok
        
        mouseX = clickInfo[1]
        mouseY = clickInfo[2]
        mouseData = clickInfo[3]
        
        # Find widget at click location
        clickedWidget = findWidgetAt(mouseX, mouseY)
        if clickedWidget != null
            if clickedWidget != focusedWidget
                setFocus(clickedWidget)
            ok
            
            mouseEvt = new Event("mouse")
            mouseEvt.x = mouseX
            mouseEvt.y = mouseY
            mouseEvt.data = mouseData
            mouseEvt.target = clickedWidget
            clickedWidget.handleEvent(mouseEvt)
        ok
        
    func handleMouseClick(mouseX, mouseY, mouseData)
        # Check if click is on menu bar
        if menuBar != null
            if menuBar.handleMouse(mouseX, mouseY, true)
                # Menu was activated and handled
                return
            ok
        ok
        
        # Check if click is on tab control
        if tabControl != null
            # Check if clicking on tab headers
            if mouseY = tabControl.y
                evt = new Event("mouse")
                evt.x = mouseX
                evt.y = mouseY
                evt.data = true
                if tabControl.handleEvent(evt)
                    clearTabFocus()  # Unfocus any control when switching tabs
                    page = tabControl.getActivePage()
                    if page != null and statusBar != null
                        setStatus("Active Tab: " + page.title)
                    ok
                    return
                ok
            ok
            
            # Check if clicking inside tab content area
            if mouseX > tabControl.x and mouseX < tabControl.x + tabControl.width - 1
                if mouseY > tabControl.y + 1 and mouseY < tabControl.y + tabControl.height - 1
                    handleTabContentClick(mouseX, mouseY, mouseData)
                    return
                ok
            ok
        ok
        
        # Find widget under mouse cursor
        clickedWidget = findWidgetAt(mouseX, mouseY)
        if clickedWidget != null
            if clickedWidget != focusedWidget
                setFocus(clickedWidget)
            ok
            
            evt = new Event("mouse")
            evt.x = mouseX
            evt.y = mouseY
            evt.data = mouseData
            evt.target = clickedWidget
            clickedWidget.handleEvent(evt)
        ok
        
    func handleTabContentClick(mouseX, mouseY, mouseData)
        # Handle click inside tab control content area
        page = tabControl.getActivePage()
        if page = null
            return
        ok
        
        # Find clicked control (reverse order for z-order)
        clickedControl = null
        for i = len(page.children) to 1 step -1
            child = page.children[i]
            if child.visible
                if mouseX >= child.x and mouseX < child.x + child.width
                    if mouseY >= child.y and mouseY < child.y + child.height
                        clickedControl = child
                        exit
                    ok
                ok
            ok
        next
        
        if clickedControl != null
            # Set focus to this control
            setTabFocus(clickedControl)
            
            # Pass mouse event to control
            childEvt = new Event("mouse")
            childEvt.x = mouseX
            childEvt.y = mouseY
            childEvt.data = true
            clickedControl.handleEvent(childEvt)
            clickedControl.draw()
            
            # Show cursor for text controls
            if ismethod(clickedControl, "showCursor")
                clickedControl.showCursor()
            ok
            
            # Update status
            if statusBar != null
                ctrlName = classname(clickedControl)
                setStatus("Focused: " + ctrlName + " - Use keyboard to interact")
            ok
        ok
        
    func stop
        running = false
        
    func focusNext
        if len(widgets) = 0
            return
        ok
        
        # Count focusable widgets
        focusableCount = 0
        for widget in widgets
            if widget.focusable and widget.visible
                focusableCount++
            ok
        next
        
        # If no focusable widgets, do nothing
        if focusableCount = 0
            return
        ok
        
        # Find first focusable widget if none focused
        if focusedWidget = null
            for widget in widgets
                if widget.focusable and widget.visible
                    setFocus(widget)
                    return
                ok
            next
            return
        ok
        
        # Find current index and next focusable widget
        currentIndex = find(widgets, focusedWidget)
        if currentIndex = 0
            currentIndex = 1
        ok
        
        # Search for next focusable widget
        nextIndex = currentIndex
        attempts = 0
        while attempts < len(widgets)
            nextIndex++
            if nextIndex > len(widgets)
                nextIndex = 1
            ok
            
            if widgets[nextIndex].focusable and widgets[nextIndex].visible
                setFocus(widgets[nextIndex])
                return
            ok
            
            attempts++
        end
        
    func findWidgetAt(mx, my)
        # Find which widget is at the given mouse coordinates
        for widget in widgets
            if isPointInWidget(widget, mx, my)
                return widget
            ok
        next
        return null
        
    func isPointInWidget(widget, mx, my)
        # Check if point (mx, my) is inside widget bounds
        if mx >= widget.x and mx < widget.x + widget.width
            if my >= widget.y and my < widget.y + widget.height
                return true
            ok
        ok
        return false
        
    # Helper method to draw all widgets
    func drawAll
        for widget in widgets
            if widget.visible
                widget.draw()
            ok
        next
        if menuBar != null
            menuBar.draw()
        ok
        if tabControl != null
            tabControl.draw()
        ok
        if statusBar != null
            statusBar.draw()
        ok

# ========================================
# Base Widget Class
# ========================================
class Widget

    x = 0
    y = 0
    width = 10
    height = 1
    text = ""
    visible = true
    enabled = true
    focused = false
    focusable = true      # Whether this widget can receive focus (Labels set this to false)
    kernel = null
    fgColor = WHITE  
    bgColor = BLUE   
    
    func init(k, px, py, w, h)
        kernel = ref(k)
        x = px
        y = py
        width = w
        height = h
        return self
        
    func draw
        # Override in subclasses
        
    func handleEvent(event)
        # Override in subclasses
        
    func setText(t)
        text = t
        # Don't auto-draw - let parent control handle drawing
        
    func show
        visible = true
        draw()
        
    func hide
        visible = false

# ========================================
# Frame Class - Container with background that can redraw intersecting widgets
# ========================================
class Frame from Widget

    children = []           # List of child widgets
    bgChar = " "           # Background character
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        children = []
        return self
        
    func addChild(widget)
        add(children, ref(widget))
        return self
        
    func removeChild(widget)
        for i = 1 to len(children)
            if children[i] = widget
                del(children, i)
                exit
            ok
        next
        return self
        
    func clearChildren
        children = []
        return self
        
    func draw
        if not visible
            return
        ok
        
        # Draw background
        kernel.setTermColor(fgColor, bgColor)
        bgLine = copy(bgChar, width)
        for row = y to y + height - 1
            kernel.printAt(x, row, bgLine)
        next
        
        # Draw all children
        for child in children
            if child.visible
                child.draw()
            ok
        next
        
        kernel.resetTermColor()
        
    func drawBackground
        # Draw only the background (not children)
        if not visible
            return
        ok
        
        kernel.setTermColor(fgColor, bgColor)
        bgLine = copy(bgChar, width)
        for row = y to y + height - 1
            kernel.printAt(x, row, bgLine)
        next
        kernel.resetTermColor()
        
    func redrawRegion(rx, ry, rw, rh)
        # Redraw the background for a specific region, then redraw any children that intersect
        if not visible
            return
        ok
        
        # First, draw background for the region (clipped to frame bounds)
        startX = max(rx, x)
        startY = max(ry, y)
        endX = min(rx + rw, x + width)
        endY = min(ry + rh, y + height)
        
        if startX < endX and startY < endY
            kernel.setTermColor(fgColor, bgColor)
            regionWidth = endX - startX
            bgLine = copy(bgChar, regionWidth)
            for row = startY to endY - 1
                kernel.printAt(startX, row, bgLine)
            next
        ok
        
        # Then redraw children that intersect with the region
        for child in children
            if child.visible and rectanglesIntersect(child.x, child.y, child.width, child.height, rx, ry, rw, rh)
                child.draw()
            ok
        next
        
        kernel.resetTermColor()
        
    func getIntersectingWidgets(rx, ry, rw, rh)
        # Return a list of widgets that intersect with the given rectangle
        result = []
        for child in children
            if child.visible and rectanglesIntersect(child.x, child.y, child.width, child.height, rx, ry, rw, rh)
                add(result, ref(child))
            ok
        next
        return result
        
    func rectanglesIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
        # Check if two rectangles intersect
        if x1 >= x2 + w2 or x2 >= x1 + w1
            return false
        ok
        if y1 >= y2 + h2 or y2 >= y1 + h1
            return false
        ok
        return true

# ========================================
# Window Class
# ========================================
class Window from Frame

    title = ""
    borderColor = LIGHTCYAN  # Cyan
    
    func init(k, px, py, w, h, t)
        super.init(k, px, py, w, h)
        title = t
        return self
        
    func draw
        if not visible
            return
        ok
        
        # Draw border
        kernel.setTermColor(borderColor, bgColor)
        kernel.drawRect(x, y, width, height)
        
        # Draw title
        if len(title) > 0
            titleText = " " + title + " "
            if len(titleText) < width - 2
                kernel.printAt(x + 2, y, titleText)
            ok
        ok
        
        # Draw content area background
        kernel.setTermColor(fgColor, bgColor)
        for row = y + 1 to y + height - 2
            kernel.printAt(x + 1, row, copy(" ", width - 2))
        next
        
        # Draw all children
        for child in children
            if child.visible
                child.draw()
            ok
        next
        
        kernel.resetTermColor()

# ========================================
# Label Class
# ========================================
class Label from Widget
    
    focusable = false     # Labels cannot receive focus
    
    func draw
        if not visible
            return
        ok
        
        kernel.setTermColor(fgColor, bgColor)
        displayText = text
        
        if len(displayText) > width
            displayText = substr(displayText, 1, width)
        ok
        
        kernel.printAt(x, y, displayText)
        kernel.resetTermColor()

# ========================================
# Button Class
# ========================================
class Button from Widget

    onClick = null
    pressed = false
    normalFgColor = BLACK      # Black text
    normalBgColor = GREY      # Light gray background
    focusedFgColor = WHITE    # White text
    focusedBgColor = LIGHTBLUE     # Light blue background
    pressedFgColor = WHITE    # White text
    pressedBgColor = BLUE     # Blue background
    
    func draw
        if not visible
            return
        ok
        
        # Determine colors based on state
        fg = normalFgColor
        bg = normalBgColor
        
        if focused and pressed
            fg = pressedFgColor
            bg = pressedBgColor
        but focused
            fg = focusedFgColor
            bg = focusedBgColor
        ok
        
        if not enabled
            fg = DARKGREY
            bg = BLACK
        ok
        
        kernel.setTermColor(fg, bg)
        
        # Center the text in the button
        displayText = text
        if len(displayText) > width - 4
            displayText = substr(displayText, 1, width - 4)
        ok
        
        padding = (width - len(displayText)) / 2
        paddedText = copy(" ", floor(padding)) + displayText + copy(" ", ceil(padding))
        
        # Ensure exact width
        if len(paddedText) < width
            paddedText = paddedText + copy(" ", width - len(paddedText))
        but len(paddedText) > width
            paddedText = substr(paddedText, 1, width)
        ok
        
        kernel.printAt(x, y, paddedText)
        kernel.resetTermColor()
        
    func handleEvent(event)
        if not enabled
            return
        ok
        
        if event.type = "keyboard"
            # Enter or Space key (check both ASCII and RogueUtil constants)
            if event.key = 13 or event.key = 32 or event.key = KEY_ENTER or event.key = KEY_SPACE
                if not pressed
                    # Button press
                    pressed = true
                    draw()
                    kernel.sleep(100)  # Visual feedback
                    pressed = false
                    draw()
                    
                    # Call onClick handler if defined
                    if onClick != null
                        call onClick()
                    ok
                ok
            ok
        ok
        
        if event.type = "mouse"
            mouseX = event.x
            mouseY = event.y
            
            # Check if click is within button bounds
            if mouseX >= x and mouseX < x + width and mouseY = y
                # Mouse click on button
                if not pressed
                    pressed = true
                    draw()
                    kernel.sleep(150)  # Visual feedback + prevent double-click
                    pressed = false
                    draw()
                    
                    # Call onClick handler if defined
                    if onClick != null
                        call onClick()
                    ok
                    return true
                ok
            ok
        ok
        
        return false
        
    func setOnClick(handler)
        onClick = handler

# ========================================
# EditBox Class (multi-line text editor)
# ========================================
class EditBox from Widget

    lines = []
    cursorX = 0  # Column position in current line
    cursorY = 0  # Line number
    scrollY = 0  # Vertical scroll offset
    maxLength = 1000  # Max chars per line
    enterMovesDown = true  # If true, Enter moves to next line; if false, creates new line
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        lines = [""]
        return self
        
    func setText(t)
        # Split text into lines
        lines = split(t, nl)
        if len(lines) = 0
            lines = [""]
        ok
        cursorX = 0
        cursorY = 0
        scrollY = 0
        # Don't auto-draw - let parent control handle drawing
        
    func getText
        result = ""
        for i = 1 to len(lines)
            result = result + lines[i]
            if i < len(lines)
                result = result + nl
            ok
        next
        return result
        
    func draw
        if not visible
            return
        ok
        
        # Draw border
        if focused
            kernel.setTermColor(YELLOW, BLACK)  # Yellow when focused
        else
            kernel.setTermColor(GREY, BLACK)   # Gray when not focused
        ok
        
        kernel.drawRect(x, y, width, height)
        
        # Draw text content
        visibleLines = height - 2
        for i = 1 to visibleLines
            drawLineAt(i)
        next
        
        # Show cursor if focused
        if focused
            showCursor()
        else
            kernel.setCursorVisible(0)
        ok
        
        kernel.resetTermColor()
        
    func drawLineAt(visibleLineNum)
        # Draw a single line at the given visible line number (1-based)
        if visibleLineNum < 1 or visibleLineNum > height - 2
            return
        ok
        
        kernel.setTermColor(WHITE, BLACK)
        
        lineIndex = scrollY + visibleLineNum
        displayText = ""
        
        if lineIndex <= len(lines)
            displayText = lines[lineIndex]
            if len(displayText) > width - 4
                displayText = substr(displayText, 1, width - 4)
            else
                displayText = displayText + copy(" ", width - 4 - len(displayText))
            ok
        else
            displayText = copy(" ", width - 4)
        ok
        
        kernel.printAt(x + 2, y + visibleLineNum, displayText)
        kernel.resetTermColor()
        
    func drawLineAtIndex(lineIndex)
        # Draw a line by its index in the lines array (0-based)
        visibleLines = height - 2
        
        # Check if line is visible
        if lineIndex < scrollY or lineIndex >= scrollY + visibleLines
            return  # Line not visible
        ok
        
        visibleLineNum = lineIndex - scrollY + 1
        drawLineAt(visibleLineNum)
        
    func showCursor
        # Position and show the cursor
        visibleLines = height - 2
        visibleCursorY = cursorY - scrollY
        if visibleCursorY >= 0 and visibleCursorY < visibleLines
            kernel.gotoXY(x + 2 + cursorX, y + 1 + visibleCursorY)
            kernel.setCursorVisible(1)
        ok
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            oldScrollY = scrollY
            
            # Backspace
            if key = 8
                if cursorX > 0
                    # Delete character in current line
                    currentLine = lines[cursorY + 1]
                    lines[cursorY + 1] = substr(currentLine, 1, cursorX - 1) + substr(currentLine, cursorX + 1)
                    cursorX--
                    drawLineAtIndex(cursorY)  # Only redraw current line
                    showCursor()
                but cursorY > 0
                    # Join with previous line - needs full redraw
                    prevLine = lines[cursorY]
                    currentLine = lines[cursorY + 1]
                    cursorX = len(prevLine)
                    lines[cursorY] = prevLine + currentLine
                    del(lines, cursorY + 1)
                    cursorY--
                    adjustScroll()
                    draw()
                ok
                return true
            ok
            
            # Delete
            if key = KEY_DELETE
                currentLine = lines[cursorY + 1]
                if cursorX < len(currentLine)
                    lines[cursorY + 1] = substr(currentLine, 1, cursorX) + substr(currentLine, cursorX + 2)
                    drawLineAtIndex(cursorY)  # Only redraw current line
                    showCursor()
                but cursorY < len(lines) - 1
                    # Join with next line - needs full redraw
                    nextLine = lines[cursorY + 2]
                    lines[cursorY + 1] = currentLine + nextLine
                    del(lines, cursorY + 2)
                    draw()
                ok
                return true
            ok
            
            # Enter/Return - move to next line or create new line
            if key = 13 or key = KEY_ENTER
                if enterMovesDown
                    # Move to next line (create if doesn't exist)
                    if cursorY < len(lines) - 1
                        cursorY++
                        cursorX = 0
                    else
                        # Add new empty line at end
                        add(lines, "")
                        cursorY++
                        cursorX = 0
                    ok
                    adjustScroll()
                    if scrollY != oldScrollY
                        draw()
                    else
                        showCursor()
                    ok
                else
                    # Create new line and split current line - needs full redraw
                    currentLine = lines[cursorY + 1]
                    leftPart = substr(currentLine, 1, cursorX)
                    rightPart = substr(currentLine, cursorX + 1)
                    lines[cursorY + 1] = leftPart
                    insert(lines, cursorY + 2, rightPart)
                    cursorY++
                    cursorX = 0
                    adjustScroll()
                    draw()
                ok
                return true
            ok
            
            # Up arrow
            if key = KEY_UP and cursorY > 0
                cursorY--
                # Adjust cursorX if new line is shorter
                if cursorX > len(lines[cursorY + 1])
                    cursorX = len(lines[cursorY + 1])
                ok
                adjustScroll()
                if scrollY != oldScrollY
                    draw()
                else
                    showCursor()  # Just move cursor, no redraw needed
                ok
                return true
            ok
            
            # Down arrow
            if key = KEY_DOWN
                if cursorY < len(lines) - 1
                    cursorY++
                    # Adjust cursorX if new line is shorter
                    if cursorX > len(lines[cursorY + 1])
                        cursorX = len(lines[cursorY + 1])
                    ok
                else
                    # At last line, add new line and move to it
                    add(lines, "")
                    cursorY++
                    cursorX = 0
                ok
                adjustScroll()
                if scrollY != oldScrollY
                    draw()
                else
                    showCursor()  # Just move cursor, no redraw needed
                ok
                return true
            ok
            
            # Left arrow
            if key = KEY_LEFT
                if cursorX > 0
                    cursorX--
                    showCursor()  # Just move cursor, no redraw needed
                but cursorY > 0
                    # Move to end of previous line
                    cursorY--
                    cursorX = len(lines[cursorY + 1])
                    adjustScroll()
                    if scrollY != oldScrollY
                        draw()
                    else
                        showCursor()
                    ok
                ok
                return true
            ok
            
            # Right arrow
            if key = KEY_RIGHT
                currentLine = lines[cursorY + 1]
                if cursorX < len(currentLine)
                    cursorX++
                    showCursor()  # Just move cursor, no redraw needed
                else
                    # At end of line
                    if cursorY < len(lines) - 1
                        # Move to beginning of next line
                        cursorY++
                        cursorX = 0
                    else
                        # At end of last line, add new line
                        add(lines, "")
                        cursorY++
                        cursorX = 0
                    ok
                    adjustScroll()
                    if scrollY != oldScrollY
                        draw()
                    else
                        showCursor()
                    ok
                ok
                return true
            ok
            
            # Home key
            if key = KEY_HOME
                cursorX = 0
                showCursor()  # Just move cursor, no redraw needed
                return true
            ok
            
            # End key
            if key = KEY_END
                cursorX = len(lines[cursorY + 1])
                showCursor()  # Just move cursor, no redraw needed
                return true
            ok
            
            # Regular character
            if key >= 32 and key <= 126
                currentLine = lines[cursorY + 1]
                if len(currentLine) < maxLength
                    lines[cursorY + 1] = substr(currentLine, 1, cursorX) + char(key) + substr(currentLine, cursorX + 1)
                    cursorX++
                    drawLineAtIndex(cursorY)  # Only redraw current line
                    showCursor()
                ok
                return true
            ok
        ok
        
        if event.type = "mouse"
            # Click to position cursor
            mouseX = event.x
            mouseY = event.y
            
            # Calculate position within edit box
            relativeX = mouseX - x - 2  # Account for border (2 chars)
            relativeY = mouseY - y - 1  # Account for border (1 line)
            
            # Calculate actual line based on scroll
            clickedLine = scrollY + relativeY
            
            visibleLines = height - 2
            
            # Check if click is within bounds
            if relativeY >= 0 and relativeY < visibleLines
                # Move to clicked line
                if clickedLine >= 0 and clickedLine < len(lines)
                    cursorY = clickedLine
                    
                    # Position cursor at clicked column
                    currentLine = lines[cursorY + 1]
                    if relativeX >= 0
                        if relativeX <= len(currentLine)
                            cursorX = relativeX
                        else
                            cursorX = len(currentLine)
                        ok
                    else
                        cursorX = 0
                    ok
                    
                    # Just show cursor at new position, no redraw needed
                    focused = true
                    showCursor()
                    return true
                ok
            ok
        ok
        
        return false
        
    func adjustScroll
        visibleLines = height - 2
        
        # Scroll down if cursor is below visible area
        if cursorY >= scrollY + visibleLines
            scrollY = cursorY - visibleLines + 1
        ok
        
        # Scroll up if cursor is above visible area
        if cursorY < scrollY
            scrollY = cursorY
        ok
    
    func setEnterMode(movesDown)
        # Set whether Enter key moves to next line (true) or creates new line (false)
        enterMovesDown = movesDown

# ========================================
# Rectangle Class - Draw rectangles with various styles
# ========================================
class Rectangle from Widget

    focusable = false     # Rectangles cannot receive focus (display only)
    borderStyle = "single"  # "single", "double", "thick", "none"
    filled = false
    fillChar = 32  # Space by default
    cornerChar = 0  # 0 means use default corners for border style
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        return self
        
    func draw
        if not visible
            return
        ok
        
        kernel.setTermColor(fgColor, bgColor)
        
        if borderStyle = "none"
            # Just fill the area if filled
            if filled
                fillLine = ""
                for col = 1 to width
                    fillLine = fillLine + char(fillChar)
                next
                for row = y to y + height - 1
                    kernel.printAt(x, row, fillLine)
                next
            ok
        else
            # Draw border based on style
            drawBorder()
            
            # Fill interior if needed
            if filled
                fillLine = ""
                for col = 1 to width - 2
                    fillLine = fillLine + char(fillChar)
                next
                for row = y + 1 to y + height - 2
                    kernel.printAt(x + 1, row, fillLine)
                next
            ok
        ok
        
        kernel.resetTermColor()
        
    func drawBorder
        # Use simple ASCII characters for compatibility
        # All styles use the same simple characters now
        topLeftChar = "+"
        topRightChar = "+"
        bottomLeftChar = "+"
        bottomRightChar = "+"
        horizontalChar = "-"
        verticalChar = "|"
        
        # For "thick" style, use different characters
        if borderStyle = "thick"
            topLeftChar = "#"
            topRightChar = "#"
            bottomLeftChar = "#"
            bottomRightChar = "#"
            horizontalChar = "#"
            verticalChar = "#"
        ok
        
        # Build and draw top line
        topLine = topLeftChar
        for i = 1 to width - 2
            topLine = topLine + horizontalChar
        next
        topLine = topLine + topRightChar
        kernel.printAt(x, y, topLine)
        
        # Draw middle lines (just the vertical borders)
        for row = y + 1 to y + height - 2
            kernel.printAt(x, row, verticalChar)
            kernel.printAt(x + width - 1, row, verticalChar)
        next
        
        # Build and draw bottom line
        bottomLine = bottomLeftChar
        for i = 1 to width - 2
            bottomLine = bottomLine + horizontalChar
        next
        bottomLine = bottomLine + bottomRightChar
        kernel.printAt(x, y + height - 1, bottomLine)
        
    func setBorderStyle(style)
        # Set border style: "single", "double", "thick", "none"
        borderStyle = style
        draw()
        
    func setFilled(isFilled, ch)
        filled = isFilled
        if ch != null
            fillChar = ch
        ok
        draw()
        
    func setCornerChar(ch)
        cornerChar = ch
        draw()

# ========================================
# ManagedWindow Class - Movable/Resizable Window with Controls
# ========================================
class ManagedWindow from Widget

    title = ""
    children = []              # Child widgets
    childRelX = []             # Relative X positions
    childRelY = []             # Relative Y positions
    
    # Window state
    isMaximized = false
    isMinimized = false
    isDragging = false
    isResizing = false
    dragOffsetX = 0
    dragOffsetY = 0
    resizeEdge = ""            # "right", "bottom", "corner"
    
    # Saved state for restore
    savedX = 0
    savedY = 0
    savedWidth = 0
    savedHeight = 0
    
    # Minimum size
    minWidth = 20
    minHeight = 6
    
    # Window controls (buttons in title bar)
    showMinimize = true
    showMaximize = true
    showClose = true
    
    # Colors
    titleFgColor = WHITE          # White
    titleBgColor = BLUE           # Blue
    activeTitleBgColor = BLUE     # Blue when active
    inactiveTitleBgColor = DARKGREY   # Dark gray when inactive
    borderFgColor = GREY          # Light gray
    borderBgColor = BLACK          # Black
    contentBgColor = BLACK         # Black background for content
    
    # Callbacks
    onClose = null
    onMinimize = null
    onMaximize = null
    onRestore = null
    onMove = null
    onResize = null
    
    # Active state
    isActive = false
    
    # Parent window manager
    windowManager = null
    
    func init(k, px, py, w, h, t)
        super.init(k, px, py, w, h)
        title = t
        savedX = px
        savedY = py
        savedWidth = w
        savedHeight = h
        children = []
        childRelX = []
        childRelY = []
        return self
        
    func setTitle(t)
        title = t
        return self
        
    func setActive(active)
        isActive = active
        return self
        
    func addChild(widget, relX, relY)
        # Add child with position relative to window content area
        add(children, ref(widget))
        add(childRelX, relX)
        add(childRelY, relY)
        # Set initial position
        widget.x = x + 1 + relX
        widget.y = y + 2 + relY
        return self
        
    func removeChild(widget)
        for i = 1 to len(children)
            if children[i] = widget
                del(children, i)
                del(childRelX, i)
                del(childRelY, i)
                exit
            ok
        next
        return self
        
    func updateChildPositions
        # Update all children to their correct absolute positions
        contentX = x + 1
        contentY = y + 2
        
        for i = 1 to len(children)
            children[i].x = contentX + childRelX[i]
            children[i].y = contentY + childRelY[i]
        next
        
    func draw
        if not visible
            return
        ok
        
        if isMinimized
            drawMinimized()
            return
        ok
        
        # Draw window border and background
        drawBorder()
        
        # Draw title bar
        drawTitleBar()
        
        # Draw content area background
        drawContentArea()
        
        # Update child positions and draw them
        updateChildPositions()
        drawChildren()
        
        kernel.resetTermColor()
        
    func drawBorder
        kernel.setTermColor(borderFgColor, borderBgColor)
        
        # Top border
        topLine = "+"
        for i = 1 to width - 2
            topLine = topLine + "-"
        next
        topLine = topLine + "+"
        kernel.printAt(x, y, topLine)
        
        # Side borders
        for row = y + 1 to y + height - 2
            kernel.printAt(x, row, "|")
            kernel.printAt(x + width - 1, row, "|")
        next
        
        # Bottom border with resize corner hint
        bottomLine = "+"
        for i = 1 to width - 3
            bottomLine = bottomLine + "-"
        next
        bottomLine = bottomLine + "=#"  # Resize corner indicator
        kernel.printAt(x, y + height - 1, bottomLine)
        
    func drawTitleBar
        # Title bar background
        if isActive
            kernel.setTermColor(titleFgColor, activeTitleBgColor)
        else
            kernel.setTermColor(titleFgColor, inactiveTitleBgColor)
        ok
        
        # Build title bar content
        titleBarWidth = width - 2
        
        # Window control buttons (right side): [_] [O] [X]
        controlsWidth = 0
        controls = ""
        if showMinimize
            controls = controls + "[_]"
            controlsWidth = controlsWidth + 3
        ok
        if showMaximize
            if isMaximized
                controls = controls + "[o]"  # Restore button
            else
                controls = controls + "[O]"  # Maximize button
            ok
            controlsWidth = controlsWidth + 3
        ok
        if showClose
            controls = controls + "[X]"
            controlsWidth = controlsWidth + 3
        ok
        
        # Calculate title display
        availableWidth = titleBarWidth - controlsWidth - 1
        displayTitle = " " + title
        if len(displayTitle) > availableWidth
            displayTitle = substr(displayTitle, 1, availableWidth - 3) + "..."
        ok
        
        # Pad title
        padding = titleBarWidth - len(displayTitle) - controlsWidth
        if padding < 0
            padding = 0
        ok
        
        titleBar = displayTitle + copy(" ", padding) + controls
        
        # Ensure exact width
        if len(titleBar) < titleBarWidth
            titleBar = titleBar + copy(" ", titleBarWidth - len(titleBar))
        ok
        if len(titleBar) > titleBarWidth
            titleBar = substr(titleBar, 1, titleBarWidth)
        ok
        
        kernel.printAt(x + 1, y + 1, titleBar)
        
    func drawContentArea
        kernel.setTermColor(WHITE, contentBgColor)
        
        # Fill content area
        contentLine = copy(" ", width - 2)
        for row = y + 2 to y + height - 2
            kernel.printAt(x + 1, row, contentLine)
        next
        
    func drawChildren
        # Content area bounds
        contentLeft = x + 1
        contentTop = y + 2
        contentRight = x + width - 1
        contentBottom = y + height - 2
        contentWidth = width - 2
        contentHeight = height - 3
        
        for i = 1 to len(children)
            child = children[i]
            
            # Check if child Y position is within content area
            if child.y < contentTop or child.y > contentBottom
                child.visible = false
                loop
            ok
            
            # Check if child X position starts within content area
            if child.x < contentLeft or child.x >= contentRight
                child.visible = false
                loop
            ok
            
            # Save original dimensions
            originalWidth = child.width
            originalHeight = child.height
            
            # Calculate how much of the child fits in the content area (width)
            availableWidth = contentRight - child.x
            if child.x + child.width > contentRight
                child.width = availableWidth
            ok
            
            # Calculate how much of the child fits in the content area (height)
            availableHeight = contentBottom - child.y + 1
            if child.y + child.height > contentBottom + 1
                child.height = availableHeight
            ok
            
            # Only draw if there's space
            if child.width > 0 and child.height > 0
                child.visible = true
                child.draw()
            else
                child.visible = false
            ok
            
            # Restore original dimensions
            child.width = originalWidth
            child.height = originalHeight
        next
        
    func drawMinimized
        # Draw minimized window (just title bar)
        kernel.setTermColor(titleFgColor, inactiveTitleBgColor)
        
        minWidth = len(title) + 12
        if minWidth < 20
            minWidth = 20
        ok
        
        minBar = "[" + title
        if len(minBar) > minWidth - 8
            minBar = substr(minBar, 1, minWidth - 11) + "..."
        ok
        minBar = minBar + copy(" ", minWidth - len(minBar) - 5) + "][O]"
        
        kernel.printAt(x, y, minBar)
        
    func handleEvent(event)
        if not visible
            return false
        ok
        
        if event.type = "mouse"
            return handleMouse(event.x, event.y, event.data)
        ok
        
        if event.type = "keyboard"
            return handleKeyboard(event.key)
        ok
        
        return false
        
    func handleMouse(mx, my, clicking)
        if not visible
            return false
        ok
        
        if isMinimized
            return handleMinimizedMouse(mx, my, clicking)
        ok
        
        # Check if click is within window bounds
        if mx < x or mx >= x + width or my < y or my >= y + height
            return false
        ok
        
        # Note: WindowManager handles bringing window to front
        
        # Check title bar clicks (y + 1 is title bar row)
        if my = y + 1 and clicking
            return handleTitleBarClick(mx)
        ok
        
        # Check resize corner (bottom-right)
        if my = y + height - 1 and mx >= x + width - 2 and clicking
            startResize("corner")
            return true
        ok
        
        # Check right edge for resize
        if mx = x + width - 1 and my > y + 1 and my < y + height - 1 and clicking
            startResize("right")
            return true
        ok
        
        # Check bottom edge for resize
        if my = y + height - 1 and mx > x and mx < x + width - 2 and clicking
            startResize("bottom")
            return true
        ok
        
        # Content area bounds
        contentLeft = x + 1
        contentTop = y + 2
        contentRight = x + width - 1
        contentBottom = y + height - 2
        
        # Check if click is in content area
        if mx < contentLeft or mx >= contentRight or my < contentTop or my > contentBottom
            return true  # Click on border, consume but don't pass to children
        ok
        
        # Update child positions first (important after resize!)
        updateChildPositions()
        
        # Unfocus all children first
        for child in children
            if child.focused
                child.focused = false
                
                # Save and clip dimensions before drawing
                originalWidth = child.width
                originalHeight = child.height
                
                availableWidth = contentRight - child.x
                if availableWidth > 0 and child.width > availableWidth
                    child.width = availableWidth
                ok
                
                availableHeight = contentBottom - child.y + 1
                if availableHeight > 0 and child.height > availableHeight
                    child.height = availableHeight
                ok
                
                # Draw with clipped dimensions
                if child.width > 0 and child.height > 0
                    child.draw()
                ok
                
                # Restore original dimensions
                child.width = originalWidth
                child.height = originalHeight
            ok
        next
        
        # Pass to children (reverse order for z-order)
        for i = len(children) to 1 step -1
            child = children[i]
            if child.visible
                # Check if click is within THIS child's bounds
                if mx >= child.x and mx < child.x + child.width and my >= child.y and my < child.y + child.height
                    # Also check if the click point is within content area
                    if mx >= contentLeft and mx < contentRight and my >= contentTop and my <= contentBottom
                        # Focus this child
                        child.focused = true
                        
                        # Save original dimensions and clip BEFORE handleEvent
                        # This ensures any draw() calls within handleEvent use clipped dimensions
                        originalWidth = child.width
                        originalHeight = child.height
                        
                        # Clip width
                        availableWidth = contentRight - child.x
                        if availableWidth > 0 and child.width > availableWidth
                            child.width = availableWidth
                        ok
                        
                        # Clip height
                        availableHeight = contentBottom - child.y + 1
                        if availableHeight > 0 and child.height > availableHeight
                            child.height = availableHeight
                        ok
                        
                        # Create and pass the event (child may draw itself)
                        childEvent = new Event("mouse")
                        childEvent.x = mx
                        childEvent.y = my
                        childEvent.data = clicking
                        child.handleEvent(childEvent)
                        
                        # Restore original dimensions
                        child.width = originalWidth
                        child.height = originalHeight
                        
                        # Show cursor for text input controls
                        if ismethod(child, "showCursor")
                            child.showCursor()
                        ok
                        
                        return true
                    ok
                ok
            ok
        next
        
        return true  # Consume click within window
        
    func drawChildClipped(child, contentLeft, contentTop, contentRight, contentBottom)
        # Draw a child with proper clipping to content area
        # contentRight is the X position of the right border (exclusive)
        # contentBottom is the Y position of the bottom border (exclusive for content)
        
        if child.y < contentTop or child.y > contentBottom
            return
        ok
        if child.x < contentLeft or child.x >= contentRight
            return
        ok
        
        # Save original dimensions
        originalWidth = child.width
        originalHeight = child.height
        
        # Clip width - contentRight is exclusive (the border column)
        availableWidth = contentRight - child.x
        if availableWidth < 1
            return
        ok
        if child.width > availableWidth
            child.width = availableWidth
        ok
        
        # Clip height - contentBottom is the last valid content row
        availableHeight = contentBottom - child.y + 1
        if availableHeight < 1
            return
        ok
        if child.height > availableHeight
            child.height = availableHeight
        ok
        
        # Draw if there's space
        if child.width > 0 and child.height > 0
            child.draw()
        ok
        
        # Restore original dimensions
        child.width = originalWidth
        child.height = originalHeight
        
    func handleTitleBarClick(mx)
        # Calculate button positions (from right)
        btnX = x + width - 2
        
        if showClose
            if mx >= btnX - 2 and mx <= btnX
                close()
                return true
            ok
            btnX = btnX - 3
        ok
        
        if showMaximize
            if mx >= btnX - 2 and mx <= btnX
                if isMaximized
                    restore()
                else
                    maximize()
                ok
                return true
            ok
            btnX = btnX - 3
        ok
        
        if showMinimize
            if mx >= btnX - 2 and mx <= btnX
                minimize()
                return true
            ok
            btnX = btnX - 3
        ok
        
        # Click on title area - start dragging
        startDrag(mx, y + 1)
        return true
        
    func handleMinimizedMouse(mx, my, clicking)
        # Check if click is on minimized bar
        minWidth = len(title) + 12
        if minWidth < 20
            minWidth = 20
        ok
        
        if my = y and mx >= x and mx < x + minWidth and clicking
            # Check restore button [O]
            if mx >= x + minWidth - 4 and mx <= x + minWidth - 2
                restore()
                return true
            ok
            # Click anywhere else - also restore
            restore()
            return true
        ok
        
        return false
        
    func handleKeyboard(key)
        # Content area bounds for clipping
        contentRight = x + width - 1
        contentBottom = y + height - 2
        
        # Handle Tab key for navigating between children
        if key = 9 and len(children) > 0  # Tab key
            focusNextChild()
            return true
        ok
        
        # Pass keyboard to children
        for child in children
            if child.focused
                # Save and clip dimensions before event handling
                originalWidth = child.width
                originalHeight = child.height
                
                availableWidth = contentRight - child.x
                if availableWidth > 0 and child.width > availableWidth
                    child.width = availableWidth
                ok
                
                availableHeight = contentBottom - child.y + 1
                if availableHeight > 0 and child.height > availableHeight
                    child.height = availableHeight
                ok
                
                # Handle the event (child may draw itself)
                childEvent = new Event("keyboard")
                childEvent.key = key
                handled = child.handleEvent(childEvent)
                
                # Restore original dimensions
                child.width = originalWidth
                child.height = originalHeight
                
                if handled
                    return true
                ok
            ok
        next
        
        return false
        
    func focusNextChild
        # Navigate to next focusable child control using Tab
        if len(children) = 0
            return
        ok
        
        # Count focusable children
        focusableCount = 0
        for child in children
            if child.focusable and child.visible
                focusableCount++
            ok
        next
        
        # If no focusable children, do nothing
        if focusableCount = 0
            return
        ok
        
        # Content area bounds for clipping when drawing
        contentLeft = x + 1
        contentTop = y + 2
        contentRight = x + width - 1
        contentBottom = y + height - 2
        
        # Find current focused index
        currentIdx = 0
        for i = 1 to len(children)
            if children[i].focused
                currentIdx = i
                exit
            ok
        next
        
        # Unfocus current child
        if currentIdx > 0
            children[currentIdx].focused = false
            drawChildClipped(children[currentIdx], contentLeft, contentTop, contentRight, contentBottom)
        ok
        
        # Find next focusable child (skip non-focusable ones like Label)
        nextIdx = currentIdx
        attempts = 0
        while attempts < len(children)
            nextIdx++
            if nextIdx > len(children)
                nextIdx = 1
            ok
            
            # Check if this child is focusable
            if children[nextIdx].focusable and children[nextIdx].visible
                exit
            ok
            
            attempts++
        end
        
        # Focus next focusable child
        children[nextIdx].focused = true
        drawChildClipped(children[nextIdx], contentLeft, contentTop, contentRight, contentBottom)
        
        # Show cursor if it's a text control
        if ismethod(children[nextIdx], "showCursor")
            children[nextIdx].showCursor()
        ok
        
    func startDrag(mx, my)
        if isMaximized
            return  # Can't drag maximized window
        ok
        isDragging = true
        dragOffsetX = mx - x
        dragOffsetY = my - y
        
    func updateDrag(mx, my)
        if not isDragging
            return
        ok
        
        newX = mx - dragOffsetX
        newY = my - dragOffsetY
        
        # Keep window on screen
        if newX < 1
            newX = 1
        ok
        if newY < 1
            newY = 1
        ok
        if newX + width > kernel.getCols()
            newX = kernel.getCols() - width
        ok
        if newY + height > kernel.getRows()
            newY = kernel.getRows() - height
        ok
        
        x = newX
        y = newY
        
        if onMove != null
            call onMove(self)
        ok
        
    func stopDrag
        isDragging = false
        
    func startResize(edge)
        if isMaximized
            return  # Can't resize maximized window
        ok
        isResizing = true
        resizeEdge = edge
        
    func updateResize(mx, my)
        if not isResizing
            return
        ok
        
        newWidth = width
        newHeight = height
        
        if resizeEdge = "right" or resizeEdge = "corner"
            newWidth = mx - x + 1
        ok
        
        if resizeEdge = "bottom" or resizeEdge = "corner"
            newHeight = my - y + 1
        ok
        
        # Enforce minimum size
        if newWidth < minWidth
            newWidth = minWidth
        ok
        if newHeight < minHeight
            newHeight = minHeight
        ok
        
        # Keep on screen
        if x + newWidth > kernel.getCols()
            newWidth = kernel.getCols() - x
        ok
        if y + newHeight > kernel.getRows()
            newHeight = kernel.getRows() - y
        ok
        
        width = newWidth
        height = newHeight
        
        if onResize != null
            call onResize(self)
        ok
        
    func stopResize
        isResizing = false
        
    func minimize
        if isMinimized
            return
        ok
        
        # Save old bounds for redraw
        oldX = x
        oldY = y
        oldW = width
        oldH = height
        wasMax = isMaximized
        
        # Save current state if not maximized
        if not isMaximized
            savedX = x
            savedY = y
            savedWidth = width
            savedHeight = height
        ok
        
        isMinimized = true
        isMaximized = false  # Clear maximized state when minimizing
        
        # Request redraw of old area from window manager
        if windowManager != null
            windowManager.redrawRegion(oldX, oldY, oldW, oldH)
        ok
        
        if onMinimize != null
            call onMinimize(self)
        ok
        
    func maximize
        if isMaximized
            return
        ok
        
        # Save current state
        if not isMinimized
            savedX = x
            savedY = y
            savedWidth = width
            savedHeight = height
        ok
        
        isMinimized = false
        isMaximized = true
        
        # Fill screen (leave room for edges)
        x = 1
        y = 1
        width = kernel.getCols() - 1
        height = kernel.getRows() - 1
        
        if onMaximize != null
            call onMaximize(self)
        ok
        
    func restore
        isMinimized = false
        isMaximized = false
        
        x = savedX
        y = savedY
        width = savedWidth
        height = savedHeight
        
        # Request a full redraw from window manager
        if windowManager != null
            windowManager.requestFullRedraw()
        ok
        
        if onRestore != null
            call onRestore(self)
        ok
        
    func close
        visible = false
        
        if onClose != null
            call onClose(self)
        ok
        
        if windowManager != null
            windowManager.removeWindow(self)
            windowManager.requestFullRedraw()
        ok
        
    func setOnClose(handler)
        onClose = handler
        return self
        
    func setOnMinimize(handler)
        onMinimize = handler
        return self
        
    func setOnMaximize(handler)
        onMaximize = handler
        return self
        
    func setOnRestore(handler)
        onRestore = handler
        return self
        
    func setOnMove(handler)
        onMove = handler
        return self
        
    func setOnResize(handler)
        onResize = handler
        return self
        
    func getContentX
        return x + 1
        
    func getContentY
        return y + 2
        
    func getContentWidth
        return width - 2
        
    func getContentHeight
        return height - 3

# ========================================
# WindowManager Class - Manages multiple windows
# ========================================
class WindowManager

    kernel = null
    windows = []               # List of windows (z-order: last = top)
    activeWindowIndex = 0      # Index of active window (0 = none)
    running = false
    
    # Flag to request a full redraw in the next loop iteration
    pendingFullRedraw = false
    
    # Desktop colors and pattern
    desktopBgColor = BLUE         # Blue desktop
    desktopFgColor = GREY
    desktopPattern = ""        # Optional pattern character (e.g., "░" or "▒")
    
    # Desktop widgets (drawn before windows)
    desktopWidgets = []
    
    # Callbacks
    onExit = null
    
    func init(k)
        kernel = ref(k)
        windows = []
        desktopWidgets = []
        return self
        
    func requestFullRedraw
        pendingFullRedraw = true
        
    func setDesktopPattern(pattern)
        desktopPattern = pattern
        return self
        
    func setDesktopColors(fg, bg)
        desktopFgColor = fg
        desktopBgColor = bg
        return self
        
    func addDesktopWidget(widget)
        add(desktopWidgets, ref(widget))
        return self
        
    func removeDesktopWidget(widget)
        idx = find(desktopWidgets, widget)
        if idx > 0
            del(desktopWidgets, idx)
        ok
        return self
        
    func addWindow(win)
        win.windowManager = ref(self)
        win.isActive = false
        add(windows, ref(win))
        activeWindowIndex = len(windows)
        windows[activeWindowIndex].isActive = true
        return self
        
    func removeWindow(win)
        # Find and remove the window
        idx = find(windows, win)
        if idx > 0
            del(windows, idx)
            
            # Update active window index
            if idx = activeWindowIndex
                if len(windows) > 0
                    activeWindowIndex = len(windows)
                    windows[activeWindowIndex].isActive = true
                else
                    activeWindowIndex = 0
                ok
            but idx < activeWindowIndex
                activeWindowIndex = activeWindowIndex - 1
            ok
        ok
        return self
        
    func bringToFront(winIndex)
        if winIndex < 1 or winIndex > len(windows)
            return self
        ok
        
        if winIndex = activeWindowIndex
            return self  # Already at front
        ok
        
        # Deactivate current active window
        if activeWindowIndex > 0 and activeWindowIndex <= len(windows)
            windows[activeWindowIndex].isActive = false
        ok
        
        # Move window to end (top of z-order)
        if winIndex < len(windows)
            tempWin = windows[winIndex]
            del(windows, winIndex)
            add(windows, ref(tempWin))
        ok
        
        # Activate the window
        activeWindowIndex = len(windows)
        windows[activeWindowIndex].isActive = true
        
        return self
        
    func cycleWindows
        # Cycle to next window
        if len(windows) < 2
            return
        ok
        
        # Deactivate current
        if activeWindowIndex > 0 and activeWindowIndex <= len(windows)
            windows[activeWindowIndex].isActive = false
        ok
        
        # Move top window to bottom
        tempWin = windows[len(windows)]
        del(windows, len(windows))
        insert(windows, 1, ref(tempWin))
        
        # Activate new top window
        activeWindowIndex = len(windows)
        if activeWindowIndex > 0
            windows[activeWindowIndex].isActive = true
        ok
        
    func getActiveWindow
        if activeWindowIndex > 0 and activeWindowIndex <= len(windows)
            return windows[activeWindowIndex]
        ok
        return null
        
    func drawDesktop
        kernel.setTermColor(desktopFgColor, desktopBgColor)
        
        # Fill screen with pattern or solid color
        if len(desktopPattern) > 0
            clearLine = ""
            for i = 1 to kernel.getCols()
                clearLine = clearLine + desktopPattern
            next
        else
            clearLine = copy(" ", kernel.getCols())
        ok
        
        for row = 1 to kernel.getRows()
            kernel.printAt(1, row, clearLine)
        next
        
    func drawDesktopWidgets
        # Draw all desktop widgets
        for widget in desktopWidgets
            if widget.visible
                widget.draw()
            ok
        next
        
    func drawAll
        drawDesktop()
        drawDesktopWidgets()
        
        # Draw windows bottom to top
        # Use local variable for count to avoid any reference issues
        windowCount = len(windows)
        for i = 1 to windowCount
            win = windows[i]
            if win.visible
                win.draw()
            ok
        next
        
        kernel.resetTermColor()
        
    func clearRegion(rx, ry, rw, rh)
        # Clear a rectangular region with desktop background
        kernel.setTermColor(desktopFgColor, desktopBgColor)
        
        if len(desktopPattern) > 0
            clearLine = ""
            for i = 1 to rw
                clearLine = clearLine + desktopPattern
            next
        else
            clearLine = copy(" ", rw)
        ok
        
        for row = ry to ry + rh - 1
            if row >= 1 and row <= kernel.getRows()
                kernel.printAt(rx, row, clearLine)
            ok
        next
        kernel.resetTermColor()
        
    func redrawRegion(rx, ry, rw, rh)
        # Redraw all windows that intersect with the given region
        # First clear the region with desktop background
        clearRegion(rx, ry, rw, rh)
        
        # Draw desktop widgets that intersect with the region
        for widget in desktopWidgets
            if widget.visible
                if rectanglesIntersect(widget.x, widget.y, widget.width, widget.height, rx, ry, rw, rh)
                    widget.draw()
                ok
            ok
        next
        
        # Draw windows bottom to top, but only if they intersect
        for i = 1 to len(windows)
            win = windows[i]
            if win.visible and not win.isMinimized
                if rectanglesIntersect(win.x, win.y, win.width, win.height, rx, ry, rw, rh)
                    win.draw()
                ok
            ok
        next
        
        kernel.resetTermColor()
        
    func rectanglesIntersect(x1, y1, w1, h1, x2, y2, w2, h2)
        # Check if two rectangles intersect
        if x1 >= x2 + w2 or x2 >= x1 + w1
            return false
        ok
        if y1 >= y2 + h2 or y2 >= y1 + h1
            return false
        ok
        return true
        
    func redrawWindowAndBelow(winIndex)
        # Redraw a window and all windows below it that might be affected
        if winIndex < 1 or winIndex > len(windows)
            return
        ok
        
        win = windows[winIndex]
        
        # Clear and redraw the region where this window is
        redrawRegion(win.x, win.y, win.width, win.height)
        
    func run
        running = true
        nBuffer = 0
        nKey = 0
        lastClickTime = 0
        
        # Initial draw
        drawAll()
        
        while running
            needFullRedraw = false
            nBuffer = kernel.checkKeyHit()
            nKey = 0
            
            if nBuffer
                nKey = kernel.getKey()
                
                # Global keys
                if nKey = 27 or nKey = KEY_ESCAPE
                    # ESC - exit window manager
                    running = false
                    loop
                ok
                
                # F12 to cycle windows
                if nKey = KEY_F12
                    cycleWindows()
                    needFullRedraw = true
                ok
                
                # Pass to active window (including Tab key for control navigation)
                activeWin = getActiveWindow()
                if activeWin != null and nKey != KEY_F12
                    evt = new Event("keyboard")
                    evt.key = nKey
                    activeWin.handleEvent(evt)
                    # Don't redraw entire window - the child's handleEvent already redraws itself
                    # Only show cursor for text controls
                    showFocusedChildCursor(activeWin)
                ok
            ok
            
            # Handle mouse
            if kernel.mouseEnabled
                aMouse = MouseInfo(nBuffer, nKey)
                
                if aMouse[MOUSEINFO_ACTIVE]
                    mouseX = aMouse[MOUSEINFO_X]
                    mouseY = aMouse[MOUSEINFO_Y]
                    mouseButton = aMouse[MOUSEINFO_BUTTONS]
                    
                    # Handle dragging/resizing for active window
                    activeWin = getActiveWindow()
                    if activeWin != null
                        if activeWin.isDragging
                            if mouseButton = MOUSEINFO_LEFTBUTTON
                                # Save old position for smart redraw
                                oldX = activeWin.x
                                oldY = activeWin.y
                                oldW = activeWin.width
                                oldH = activeWin.height
                                
                                activeWin.updateDrag(mouseX, mouseY)
                                
                                # Check if position changed
                                if oldX != activeWin.x or oldY != activeWin.y
                                    # Redraw old position (what was underneath)
                                    redrawRegion(oldX, oldY, oldW, oldH)
                                    # Draw window at new position
                                    activeWin.draw()
                                ok
                            else
                                activeWin.stopDrag()
                                activeWin.draw()
                            ok
                        ok
                        
                        if activeWin.isResizing
                            if mouseButton = MOUSEINFO_LEFTBUTTON
                                # Save old size for smart redraw
                                oldX = activeWin.x
                                oldY = activeWin.y
                                oldW = activeWin.width
                                oldH = activeWin.height
                                
                                activeWin.updateResize(mouseX, mouseY)
                                
                                # Check if size changed
                                if oldW != activeWin.width or oldH != activeWin.height
                                    # Redraw the larger of old/new area
                                    maxW = max(oldW, activeWin.width)
                                    maxH = max(oldH, activeWin.height)
                                    redrawRegion(oldX, oldY, maxW, maxH)
                                    # Draw window with new size
                                    activeWin.draw()
                                ok
                            else
                                activeWin.stopResize()
                                activeWin.draw()
                            ok
                        ok
                    ok
                    
                    # Handle clicks - find window under cursor (top to bottom)
                    if mouseButton = MOUSEINFO_LEFTBUTTON and (activeWin = null or (not activeWin.isDragging and not activeWin.isResizing))
                        for i = len(windows) to 1 step -1
                            win = windows[i]
                            if win.visible
                                # Check if click is within window bounds
                                if mouseX >= win.x and mouseX < win.x + win.width and mouseY >= win.y and mouseY < win.y + win.height
                                    # Bring clicked window to front if not already
                                    if i != activeWindowIndex
                                        bringToFront(i)
                                        needFullRedraw = true
                                    ok
                                    
                                    # Handle the click
                                    evt = new Event("mouse")
                                    evt.x = mouseX
                                    evt.y = mouseY
                                    evt.data = true
                                    win.handleEvent(evt)
                                    
                                    # Only redraw if no full redraw is pending
                                    if not needFullRedraw and not pendingFullRedraw
                                        win.draw()
                                    ok
                                    
                                    exit
                                ok
                            ok
                        next
                    ok
                ok
            ok
            
            if needFullRedraw or pendingFullRedraw
                drawAll()
                pendingFullRedraw = false
            ok
            
            # Ensure cursor is visible for focused text controls after all drawing
            activeWin = getActiveWindow()
            if activeWin != null
                showFocusedChildCursor(activeWin)
            ok
            
            kernel.sleep(1)
        end
        
    func showFocusedChildCursor(win)
        # Find and show cursor for focused text control in window
        for child in win.children
            if child.focused and ismethod(child, "showCursor")
                child.showCursor()
                return
            ok
        next
        
    func stop
        running = false
        
    func setOnExit(handler)
        onExit = handler
        return self

# ========================================
# Grid/Table Class - Professional data grid with editing
# ========================================
class Grid from Widget

    columns = []           # Column definitions: [[name, width], ...]
    rows = []             # Data rows: [[cell1, cell2, ...], ...]
    currentRow = 0        # Current selected row (0-based)
    currentCol = 0        # Current selected column (0-based)
    scrollY = 0           # Vertical scroll offset
    scrollX = 0           # Horizontal scroll offset
    showHeaders = true    # Show column headers
    showRowNumbers = true # Show row numbers
    editable = true       # Allow editing cells
    editing = false       # Currently in edit mode
    editText = ""         # Text being edited
    editCursorPos = 0     # Cursor position in edit mode
    rowNumberWidth = 4    # Width of row number column
    gridFgColor = WHITE      # Grid lines color
    gridBgColor = BLACK       # Grid background
    headerFgColor = BLACK     # Header text color
    headerBgColor = GREY     # Header background
    selectedFgColor = BLACK   # Selected cell text
    selectedBgColor = LIGHTCYAN  # Selected cell background (cyan)
    editFgColor = BLACK       # Edit mode text
    editBgColor = YELLOW      # Edit mode background (yellow)
    # Pending mouse click info (for click-away during edit)
    pendingMouseClick = false
    lastClickX = 0
    lastClickY = 0
    lastClickData = null
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        return self
        
    func addColumn(name, width)
        add(columns, [name, width])
        
    func addRow(rowData)
        add(rows, rowData)
        
    func setCell(row, col, value)
        # row and col are 0-based indices
        # Ring arrays are 1-based, so we add 1
        if row >= 0 and row < len(rows)
            rowIndex = row + 1
            # Ensure row has enough columns
            while len(rows[rowIndex]) <= col
                add(rows[rowIndex], "")
            end
            colIndex = col + 1
            if colIndex >= 1 and colIndex <= len(rows[rowIndex])
                rows[rowIndex][colIndex] = value
            ok
        ok
        
    func getCell(row, col)
        # row and col are 0-based indices
        # Ring arrays are 1-based, so we add 1
        if row >= 0 and row < len(rows)
            rowIndex = row + 1
            colIndex = col + 1
            if colIndex >= 1 and colIndex <= len(rows[rowIndex])
                return rows[rowIndex][colIndex]
            ok
        ok
        return ""
        
    func clearData
        rows = []
        currentRow = 0
        currentCol = 0
        scrollY = 0
        scrollX = 0
        
    func draw
        if not visible
            return
        ok
        
        kernel.setTermColor(gridFgColor, gridBgColor)
        
        # Calculate visible area
        visibleHeight = height - 2  # Minus borders
        if showHeaders
            visibleHeight = visibleHeight - 1  # One line for headers
        ok
        
        # Draw border
        kernel.drawRect(x, y, width, height)
        
        # Draw headers if enabled
        currentY = y + 1
        if showHeaders
            drawHeaders(currentY)
            currentY++
            # Draw separator line between headers and data
            drawHeaderSeparator(currentY)
            currentY++
            visibleHeight = visibleHeight - 1  # Account for separator line
        ok
        
        # Draw rows
        drawRows(currentY, visibleHeight)
        
        kernel.resetTermColor()
        
    func drawHeaderSeparator(py)
        # Draw a separator line between headers and data
        kernel.setTermColor(gridFgColor, gridBgColor)
        
        separatorLine = "|"
        
        if showRowNumbers
            separatorLine = separatorLine + copy("-", rowNumberWidth) + "+"
        ok
        
        for i = 1 to len(columns)
            colWidth = columns[i][2]
            separatorLine = separatorLine + copy("-", colWidth)
            if i < len(columns)
                separatorLine = separatorLine + "+"
            ok
        next
        
        # Pad to fill width-1 (leave space for right border from drawRect)
        currentLen = len(separatorLine)
        targetLen = width - 1  # -1 because drawRect already has right border |
        if currentLen < targetLen
            separatorLine = separatorLine + copy("-", targetLen - currentLen)
        ok
        
        kernel.printAt(x, py, separatorLine)
        
    func drawHeaders(py)
        # Draw header content (borders are handled by drawRect)
        currentX = x + 1
        
        # Row number column header
        if showRowNumbers
            kernel.setTermColor(headerFgColor, headerBgColor)
            headerText = "#"
            headerText = headerText + copy(" ", rowNumberWidth - len(headerText))
            kernel.printAt(currentX, py, headerText)
            currentX = currentX + rowNumberWidth
            
            # Separator after row numbers
            kernel.setTermColor(gridFgColor, gridBgColor)
            kernel.printAt(currentX, py, "|")
            currentX++
        ok
        
        # Column headers
        for i = 1 to len(columns)
            colName = columns[i][1]
            colWidth = columns[i][2]
            
            # Truncate or pad header text
            kernel.setTermColor(headerFgColor, headerBgColor)
            if len(colName) > colWidth
                colName = substr(colName, 1, colWidth)
            else
                colName = colName + copy(" ", colWidth - len(colName))
            ok
            
            kernel.printAt(currentX, py, colName)
            currentX = currentX + colWidth
            
            # Column separator (not after last column - drawRect handles right border)
            if i < len(columns)
                kernel.setTermColor(gridFgColor, gridBgColor)
                kernel.printAt(currentX, py, "|")
                currentX++
            ok
        next
        
    func drawRows(startY, visibleHeight)
        if len(rows) = 0
            return
        ok
        
        for i = 1 to visibleHeight
            rowIndex = scrollY + i - 1
            if rowIndex >= len(rows)
                exit
            ok
            
            currentY = startY + i - 1
            currentX = x + 1
            
            # Draw row number if enabled
            if showRowNumbers
                if rowIndex = currentRow and not editing
                    kernel.setTermColor(selectedFgColor, selectedBgColor)
                else
                    kernel.setTermColor(gridFgColor, gridBgColor)
                ok
                
                rowNumText = "" + (rowIndex + 1)
                rowNumText = copy(" ", rowNumberWidth - len(rowNumText)) + rowNumText
                kernel.printAt(currentX, currentY, rowNumText)
                currentX = currentX + rowNumberWidth
                
                # Add separator after row numbers
                kernel.setTermColor(gridFgColor, gridBgColor)
                kernel.printAt(currentX, currentY, "|")
                currentX++
            ok
            
            # Draw cells
            for colIndex = 0 to len(columns) - 1
                colWidth = columns[colIndex + 1][2]
                cellValue = ""
                
                if colIndex < len(rows[rowIndex + 1])
                    cellValue = rows[rowIndex + 1][colIndex + 1]
                ok
                
                # Determine cell colors
                if rowIndex = currentRow and colIndex = currentCol
                    if editing
                        kernel.setTermColor(editFgColor, editBgColor)
                        cellValue = editText
                    else
                        kernel.setTermColor(selectedFgColor, selectedBgColor)
                    ok
                else
                    kernel.setTermColor(gridFgColor, gridBgColor)
                ok
                
                # Format cell text
                if len(cellValue) > colWidth
                    cellValue = substr(cellValue, 1, colWidth)
                else
                    cellValue = cellValue + copy(" ", colWidth - len(cellValue))
                ok
                
                kernel.printAt(currentX, currentY, cellValue)
                currentX = currentX + colWidth
                
                # Draw column separator (not after last column - drawRect handles right border)
                if colIndex < len(columns) - 1
                    kernel.setTermColor(gridFgColor, gridBgColor)
                    kernel.printAt(currentX, currentY, "|")
                    currentX++
                ok
            next
        next
        
    func drawEditCell
        # Draw only the cell being edited (to reduce flicker)
        if not editing
            return
        ok
        
        # Calculate visible row position
        visibleRow = currentRow - scrollY
        if visibleRow < 0
            return
        ok
        
        visibleHeight = height - 2
        if showHeaders
            visibleHeight--
        ok
        
        if visibleRow >= visibleHeight
            return
        ok
        
        # Calculate Y position
        # Start after top border
        currentY = y + 1
        if showHeaders
            currentY = currentY + 2  # +1 for header row, +1 for separator line
        ok
        currentY = currentY + visibleRow
        
        # Calculate X position of current column
        currentX = x + 1
        if showRowNumbers
            currentX = currentX + rowNumberWidth + 1  # +1 for separator
        ok
        
        for i = 0 to currentCol - 1
            currentX = currentX + columns[i + 1][2] + 1  # +1 for separator
        next
        
        # Get column width
        colWidth = columns[currentCol + 1][2]
        
        # Draw cell with edit colors
        kernel.setTermColor(editFgColor, editBgColor)
        
        # Format edit text
        displayText = editText
        if len(displayText) > colWidth
            displayText = substr(displayText, 1, colWidth)
        else
            displayText = displayText + copy(" ", colWidth - len(displayText))
        ok
        
        kernel.printAt(currentX, currentY, displayText)
        
        # Position cursor
        cursorX = currentX + editCursorPos
        if editCursorPos > colWidth
            cursorX = currentX + colWidth
        ok
        kernel.gotoXY(cursorX, currentY)
        kernel.setCursorVisible(1)
        
        kernel.resetTermColor()
        
    func drawCell(row, col)
        # Draw only a single cell (to reduce flicker during navigation)
        # row and col are 0-based indices
        
        # Check if cell is visible
        visibleRow = row - scrollY
        if visibleRow < 0
            return
        ok
        
        visibleHeight = height - 2
        if showHeaders
            visibleHeight = visibleHeight - 2  # -1 for header, -1 for separator
        ok
        
        if visibleRow >= visibleHeight
            return
        ok
        
        # Calculate Y position
        currentY = y + 1
        if showHeaders
            currentY = currentY + 2  # +1 for header row, +1 for separator line
        ok
        currentY = currentY + visibleRow
        
        # Calculate X position of the column
        currentX = x + 1
        if showRowNumbers
            currentX = currentX + rowNumberWidth + 1  # +1 for separator
        ok
        
        for i = 0 to col - 1
            currentX = currentX + columns[i + 1][2] + 1  # +1 for separator
        next
        
        # Get column width and cell value
        colWidth = columns[col + 1][2]
        cellValue = ""
        
        if col < len(rows[row + 1])
            cellValue = rows[row + 1][col + 1]
        ok
        
        # Determine cell colors
        if row = currentRow and col = currentCol
            if editing
                kernel.setTermColor(editFgColor, editBgColor)
                cellValue = editText
            else
                kernel.setTermColor(selectedFgColor, selectedBgColor)
            ok
        else
            kernel.setTermColor(gridFgColor, gridBgColor)
        ok
        
        # Format cell text
        if len(cellValue) > colWidth
            cellValue = substr(cellValue, 1, colWidth)
        else
            cellValue = cellValue + copy(" ", colWidth - len(cellValue))
        ok
        
        kernel.printAt(currentX, currentY, cellValue)
        kernel.resetTermColor()

    func drawRowNumber(row)
        # Draw only the row number for a specific row
        # row is 0-based index
        
        if not showRowNumbers
            return
        ok
        
        # Check if row is visible
        visibleRow = row - scrollY
        if visibleRow < 0
            return
        ok
        
        visibleHeight = height - 2
        if showHeaders
            visibleHeight = visibleHeight - 2
        ok
        
        if visibleRow >= visibleHeight
            return
        ok
        
        # Calculate Y position
        currentY = y + 1
        if showHeaders
            currentY = currentY + 2
        ok
        currentY = currentY + visibleRow
        
        # Calculate X position (row numbers start at x + 1)
        currentX = x + 1
        
        # Determine colors - highlight if this is the current row
        if row = currentRow and not editing
            kernel.setTermColor(selectedFgColor, selectedBgColor)
        else
            kernel.setTermColor(gridFgColor, gridBgColor)
        ok
        
        # Format and draw row number
        rowNumText = "" + (row + 1)
        rowNumText = copy(" ", rowNumberWidth - len(rowNumText)) + rowNumText
        kernel.printAt(currentX, currentY, rowNumText)
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            
            if not editing
                handleNavigationMode(key)
            ok
        ok
        
        if event.type = "mouse"
            if not editing
                handleMouseClick(event.x, event.y)
            ok
        ok
        
    func hasPendingMouseClick
        return pendingMouseClick
        
    func getPendingMouseClick
        if pendingMouseClick
            pendingMouseClick = false
            return [lastClickX, lastClickY, lastClickData]
        ok
        return null
        
    func startEditing
        # Get current cell value using proper 0-based indices
        editText = getCell(currentRow, currentCol)
        editCursorPos = len(editText)
        editing = true
        
        # Calculate edit cell bounds for mouse detection
        editCellX = x + 1
        if showRowNumbers
            editCellX = editCellX + rowNumberWidth + 1  # +1 for separator
        ok
        for i = 0 to currentCol - 1
            editCellX = editCellX + columns[i + 1][2] + 1  # +1 for separator
        next
        editCellWidth = columns[currentCol + 1][2]
        
        # Calculate Y position of edit cell
        # Start after top border
        editCellY = y + 1
        if showHeaders
            editCellY = editCellY + 2  # +1 for header row, +1 for separator line
        ok
        editCellY = editCellY + (currentRow - scrollY)
        
        # Initial draw of edit cell
        drawEditCell()
        
        # Dedicated edit loop
        nBuffer = 0
        nKey = 0
        
        while editing
            nBuffer = kernel.checkKeyHit()
            nKey = 0
            
            if nBuffer
                nKey = kernel.getKey()
                
                # Exit edit mode - save (check both ASCII 13 and KEY_ENTER constant)
                if nKey = 13 or nKey = KEY_ENTER
                    saveEdit()
                    editing = false
                    kernel.setCursorVisible(0)
                    # Only redraw the edited cell and row number instead of entire grid
                    drawCell(currentRow, currentCol)
                    drawRowNumber(currentRow)
                    exit
                ok
                
                # Exit edit mode - cancel (check both ASCII 27 and KEY_ESCAPE constant)
                if nKey = 27 or nKey = KEY_ESCAPE
                    editing = false
                    kernel.setCursorVisible(0)
                    # Only redraw the edited cell and row number instead of entire grid
                    drawCell(currentRow, currentCol)
                    drawRowNumber(currentRow)
                    exit
                ok
                
                # Get column width
                colWidth = columns[currentCol + 1][2]
                
                # Backspace
                if nKey = 8 and editCursorPos > 0
                    editText = substr(editText, 1, editCursorPos - 1) + substr(editText, editCursorPos + 1)
                    editCursorPos--
                    drawEditCell()
                ok
                
                # Delete
                if nKey = KEY_DELETE and editCursorPos < len(editText)
                    editText = substr(editText, 1, editCursorPos) + substr(editText, editCursorPos + 2)
                    drawEditCell()
                ok
                
                # Left arrow
                if nKey = KEY_LEFT and editCursorPos > 0
                    editCursorPos--
                    drawEditCell()
                ok
                
                # Right arrow
                if nKey = KEY_RIGHT and editCursorPos < len(editText)
                    editCursorPos++
                    drawEditCell()
                ok
                
                # Home key
                if nKey = KEY_HOME
                    editCursorPos = 0
                    drawEditCell()
                ok
                
                # End key
                if nKey = KEY_END
                    editCursorPos = len(editText)
                    drawEditCell()
                ok
                
                # Regular character - only printable ASCII
                if nKey >= 32 and nKey <= 126 and len(editText) < colWidth
                    editText = substr(editText, 1, editCursorPos) + char(nKey) + substr(editText, editCursorPos + 1)
                    editCursorPos++
                    drawEditCell()
                ok
            ok
            
            # Check for mouse events during editing
            if kernel.mouseEnabled
                aMouse = MouseInfo(nBuffer, nKey)
                
                if aMouse[MOUSEINFO_ACTIVE]
                    mouseX = aMouse[MOUSEINFO_X]
                    mouseY = aMouse[MOUSEINFO_Y]
                    mouseButton = aMouse[MOUSEINFO_BUTTONS]
                    
                    # Left mouse button click
                    if mouseButton = MOUSEINFO_LEFTBUTTON
                        # Check if click is inside the edit cell
                        if mouseX >= editCellX and mouseX < editCellX + editCellWidth and mouseY = editCellY
                            # Click inside edit cell - move cursor
                            relativeX = mouseX - editCellX
                            if relativeX >= 0 and relativeX <= len(editText)
                                editCursorPos = relativeX
                            but relativeX > len(editText)
                                editCursorPos = len(editText)
                            ok
                            drawEditCell()
                        else
                            # Click outside edit cell - save and exit edit mode
                            saveEdit()
                            editing = false
                            kernel.setCursorVisible(0)
                            # Only redraw the edited cell and row number instead of entire grid
                            drawCell(currentRow, currentCol)
                            drawRowNumber(currentRow)
                            
                            # Store the mouse event info to be processed by main loop
                            # We need to return the mouse coordinates so the main event loop can handle it
                            lastClickX = mouseX
                            lastClickY = mouseY
                            lastClickData = aMouse
                            pendingMouseClick = true
                            exit
                        ok
                    ok
                ok
            ok
            
            kernel.sleep(1)  # Small delay to prevent CPU overuse
        end
        
    func handleNavigationMode(key)
        # Enter edit mode
        if (key = 13 or key = KEY_ENTER) and editable  # Enter
            startEditing()
            return
        ok
        
        # Store old position for selective redraw
        oldRow = currentRow
        oldCol = currentCol
        oldScrollY = scrollY
        
        # Navigation
        if key = KEY_UP and currentRow > 0
            currentRow--
            adjustScrollY()
            if scrollY != oldScrollY
                # Scrolling occurred, need full redraw
                draw()
            else
                # No scroll, just redraw old and new cells + row numbers
                drawCell(oldRow, oldCol)
                drawRowNumber(oldRow)
                drawCell(currentRow, currentCol)
                drawRowNumber(currentRow)
            ok
        ok
        
        if key = KEY_DOWN and currentRow < len(rows) - 1
            currentRow++
            adjustScrollY()
            if scrollY != oldScrollY
                # Scrolling occurred, need full redraw
                draw()
            else
                # No scroll, just redraw old and new cells + row numbers
                drawCell(oldRow, oldCol)
                drawRowNumber(oldRow)
                drawCell(currentRow, currentCol)
                drawRowNumber(currentRow)
            ok
        ok
        
        if key = KEY_LEFT and currentCol > 0
            currentCol--
            # Same row, just redraw old and new cells
            drawCell(oldRow, oldCol)
            drawCell(currentRow, currentCol)
        ok
        
        if key = KEY_RIGHT and currentCol < len(columns) - 1
            currentCol++
            # Same row, just redraw old and new cells
            drawCell(oldRow, oldCol)
            drawCell(currentRow, currentCol)
        ok
        
        if key = KEY_HOME
            currentCol = 0
            # Same row, just redraw old and new cells
            drawCell(oldRow, oldCol)
            drawCell(currentRow, currentCol)
        ok
        
        if key = KEY_END
            currentCol = len(columns) - 1
            # Same row, just redraw old and new cells
            drawCell(oldRow, oldCol)
            drawCell(currentRow, currentCol)
        ok
        
        if key = KEY_PGUP
            visibleHeight = height - 2
            if showHeaders
                visibleHeight = visibleHeight - 2  # -1 for header, -1 for separator
            ok
            currentRow = currentRow - visibleHeight
            if currentRow < 0
                currentRow = 0
            ok
            adjustScrollY()
            draw()
        ok
        
        if key = KEY_PGDOWN
            visibleHeight = height - 2
            if showHeaders
                visibleHeight = visibleHeight - 2  # -1 for header, -1 for separator
            ok
            currentRow = currentRow + visibleHeight
            if currentRow >= len(rows)
                currentRow = len(rows) - 1
            ok
            adjustScrollY()
            draw()
        ok
        
    func handleMouseClick(mx, my)
        # Check if click is inside grid
        if mx < x or mx >= x + width or my < y or my >= y + height
            return false
        ok
        
        # Calculate starting Y for data rows
        dataStartY = y + 1  # After top border
        if showHeaders
            dataStartY = dataStartY + 2  # +1 for header row, +1 for separator line
        ok
        
        # Check if click is in data area
        if my < dataStartY
            return false  # Clicked on header, separator, or border
        ok
        
        # Calculate which row was clicked
        clickedRow = scrollY + (my - dataStartY)
        
        if clickedRow < 0 or clickedRow >= len(rows)
            return false
        ok
        
        # Calculate which column was clicked
        clickX = mx - x - 1
        if showRowNumbers
            clickX = clickX - rowNumberWidth - 1  # -1 for separator
        ok
        
        if clickX < 0
            return false
        ok
        
        clickedCol = -1
        currentX = 0
        for colIndex = 0 to len(columns) - 1
            colWidth = columns[colIndex + 1][2]
            if clickX >= currentX and clickX < currentX + colWidth
                clickedCol = colIndex
                exit
            ok
            currentX = currentX + colWidth + 1  # +1 for separator
        next
        
        if clickedCol < 0
            return false
        ok
        
        # Check if clicking on already selected cell
        if currentRow = clickedRow and currentCol = clickedCol
            # Click on already selected cell - start editing
            if editable
                kernel.sleep(150)  # Debounce delay
                startEditing()
            ok
        else
            # Different cell - select it
            oldRow = currentRow
            oldCol = currentCol
            currentRow = clickedRow
            currentCol = clickedCol
            # Redraw old and new cells
            drawCell(oldRow, oldCol)
            drawCell(currentRow, currentCol)
            # If row changed, also redraw row numbers
            if oldRow != currentRow
                drawRowNumber(oldRow)
                drawRowNumber(currentRow)
            ok
            kernel.sleep(150)  # Debounce delay to prevent rapid re-selection
        ok
        
        return true
        
    func saveEdit
        setCell(currentRow, currentCol, editText)
        
    func adjustScrollY
        visibleHeight = height - 2  # Minus top and bottom borders
        if showHeaders
            visibleHeight = visibleHeight - 2  # -1 for header row, -1 for separator line
        ok
        
        # Scroll down if current row is below visible area
        if currentRow >= scrollY + visibleHeight
            scrollY = currentRow - visibleHeight + 1
        ok
        
        # Scroll up if current row is above visible area
        if currentRow < scrollY
            scrollY = currentRow
        ok

# ========================================
# TextBox Class (single line input)
# ========================================
class TextBox from Widget

    maxLength = 50
    cursorPos = 0
    
    func draw
        if not visible
            return
        ok
        
        # Don't draw if width is too small
        if width < 3
            return
        ok
        
        # Draw border
        if focused
            kernel.setTermColor(YELLOW, BLACK)  # Yellow when focused
        else
            kernel.setTermColor(GREY, BLACK)   # Gray when not focused
        ok
        
        # Build the full display: [text...]
        innerWidth = width - 2
        if innerWidth < 1
            innerWidth = 1
        ok
        
        displayText = text
        if len(displayText) > innerWidth
            displayText = substr(displayText, 1, innerWidth)
        else
            displayText = displayText + copy(" ", innerWidth - len(displayText))
        ok
        
        # Print as single line to ensure clipping
        fullDisplay = "[" + displayText + "]"
        if len(fullDisplay) > width
            fullDisplay = substr(fullDisplay, 1, width)
        ok
        
        kernel.printAt(x, y, fullDisplay)
        
        # Show cursor if focused
        if focused
            showCursor()
        else
            kernel.setCursorVisible(0)
        ok
        
        kernel.resetTermColor()
        
    func showCursor
        # Position and show the cursor
        kernel.gotoXY(x + 1 + cursorPos, y)
        kernel.setCursorVisible(1)
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            
            # Backspace
            if key = 8 and len(text) > 0 and cursorPos > 0
                text = substr(text, 1, cursorPos - 1) + substr(text, cursorPos + 1)
                cursorPos--
                draw()
                return true
            ok
            
            # Delete
            if key = KEY_DELETE and cursorPos < len(text)
                text = substr(text, 1, cursorPos) + substr(text, cursorPos + 2)
                draw()
                return true
            ok
            
            # Left arrow
            if key = KEY_LEFT and cursorPos > 0
                cursorPos--
                showCursor()  # Just update cursor position, no full redraw
                return true
            ok
            
            # Right arrow
            if key = KEY_RIGHT and cursorPos < len(text)
                cursorPos++
                showCursor()  # Just update cursor position, no full redraw
                return true
            ok
            
            # Home key
            if key = KEY_HOME
                cursorPos = 0
                showCursor()  # Just update cursor position, no full redraw
                return true
            ok
            
            # End key
            if key = KEY_END
                cursorPos = len(text)
                showCursor()  # Just update cursor position, no full redraw
                return true
            ok
            
            # Regular character
            if key >= 32 and key <= 126 and len(text) < maxLength
                text = substr(text, 1, cursorPos) + char(key) + substr(text, cursorPos + 1)
                cursorPos++
                draw()
                return true
            ok
        ok
        
        if event.type = "mouse"
            mouseX = event.x
            mouseY = event.y
            
            # Check if click is within textbox bounds
            if mouseX >= x and mouseX < x + width and mouseY = y
                # Click to position cursor
                # Calculate position within text (accounting for border)
                relativeX = mouseX - x - 1
                
                if relativeX >= 0 and relativeX <= len(text)
                    cursorPos = relativeX
                else
                    cursorPos = len(text)
                ok
                
                # Set focus and show cursor immediately
                focused = true
                draw()
                showCursor()  # Ensure cursor is visible after draw
                return true
            ok
        ok
        
        return false

# ========================================
# CheckBox Class
# ========================================
class CheckBox from Widget

    checked = false
    
    func draw
        if not visible
            return
        ok
        
        if focused
            kernel.setTermColor(YELLOW, BLACK)
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        
        # Build the display text
        if checked
            displayText = "[X] " + text
        else
            displayText = "[ ] " + text
        ok
        
        # Clip to width
        if len(displayText) > width
            displayText = substr(displayText, 1, width)
        ok
        
        # Pad to width to clear any previous content
        if len(displayText) < width
            displayText = displayText + copy(" ", width - len(displayText))
        ok
        
        kernel.printAt(x, y, displayText)
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            if event.key = 32 or event.key = 13 or event.key = KEY_SPACE or event.key = KEY_ENTER  # Space or Enter
                checked = not checked
                draw()
                return true
            ok
        ok
        
        if event.type = "mouse"
            mx = event.x
            my = event.y
            # Check if click is within checkbox bounds
            if mx >= x and mx < x + width and my = y
                checked = not checked
                draw()
                kernel.sleep(150)  # Delay to prevent double-toggle
                return true
            ok
        ok
        
        return false
        
    func setChecked(val)
        checked = val
        # Don't auto-draw - let parent control handle drawing

# ========================================
# ListBox Class
# ========================================
class ListBox from Widget

    items = []
    selectedIndex = 0
    scrollOffset = 0      # Track scroll position separately
    
    func addItem(item)
        add(items, item)
        # Don't auto-draw - let parent control handle drawing
        
    func draw
        if not visible
            return
        ok
        
        # Don't draw if dimensions are too small
        if width < 3 or height < 3
            return
        ok
        
        # Draw border - manually to respect clipped dimensions
        if focused
            kernel.setTermColor(YELLOW, BLACK)  # Yellow when focused
        else
            kernel.setTermColor(GREY, BLACK)   # Gray when not focused
        ok
        
        # Top border
        topLine = "+" + copy("-", width - 2) + "+"
        kernel.printAt(x, y, topLine)
        
        # Side borders and content area
        for row = 1 to height - 2
            kernel.printAt(x, y + row, "|")
            kernel.printAt(x + width - 1, y + row, "|")
        next
        
        # Bottom border
        bottomLine = "+" + copy("-", width - 2) + "+"
        kernel.printAt(x, y + height - 1, bottomLine)
        
        # Draw items
        displayCount = height - 2
        
        # Update scroll offset to keep selected item visible
        adjustScrollOffset()
        
        for i = 1 to displayCount
            drawItemAtLine(i)
        next
        
        kernel.resetTermColor()
        
    func adjustScrollOffset
        displayCount = height - 2
        
        # Scroll down if selected item is below visible area
        if selectedIndex > scrollOffset + displayCount
            scrollOffset = selectedIndex - displayCount
        ok
        
        # Scroll up if selected item is above visible area
        if selectedIndex < scrollOffset + 1 and selectedIndex > 0
            scrollOffset = selectedIndex - 1
        ok
        
        # Ensure scrollOffset is valid
        if scrollOffset < 0
            scrollOffset = 0
        ok
        
    func drawItemAtLine(lineNum)
        # Draw a single item at the given line number (1-based, relative to content area)
        displayCount = height - 2
        
        if lineNum < 1 or lineNum > displayCount
            return
        ok
        
        itemIndex = scrollOffset + lineNum
        drawY = y + lineNum
        
        if itemIndex >= 1 and itemIndex <= len(items)
            if itemIndex = selectedIndex
                if focused
                    kernel.setTermColor(BLACK, GREY)  # Inverted when focused
                else
                    kernel.setTermColor(BLACK, CYAN)  # Dark cyan background when not focused
                ok
            else
                kernel.setTermColor(WHITE, BLACK)
            ok
            
            itemText = items[itemIndex]
            if len(itemText) > width - 4
                itemText = substr(itemText, 1, width - 4)
            else
                itemText = itemText + copy(" ", width - 4 - len(itemText))
            ok
            
            kernel.printAt(x + 2, drawY, itemText)
        else
            # Clear empty line
            kernel.setTermColor(WHITE, BLACK)
            kernel.printAt(x + 2, drawY, copy(" ", width - 4))
        ok
        
        kernel.resetTermColor()
        
    func drawItemAtIndex(itemIndex)
        # Draw a single item by its index in the items list
        displayCount = height - 2
        
        # Check if item is visible
        if itemIndex < scrollOffset + 1 or itemIndex > scrollOffset + displayCount
            return  # Item not visible
        ok
        
        lineNum = itemIndex - scrollOffset
        drawItemAtLine(lineNum)
        
    func handleEvent(event)
        if event.type = "keyboard"
            oldIndex = selectedIndex
            oldScrollOffset = scrollOffset
            
            # Up arrow
            if event.key = KEY_UP and selectedIndex > 1
                selectedIndex--
                adjustScrollOffset()
                if scrollOffset != oldScrollOffset
                    # Scrolling occurred, need full redraw
                    draw()
                else
                    # No scroll, just redraw old and new items
                    drawItemAtIndex(oldIndex)
                    drawItemAtIndex(selectedIndex)
                ok
                return true
            ok
            
            # Down arrow
            if event.key = KEY_DOWN and selectedIndex < len(items)
                selectedIndex++
                adjustScrollOffset()
                if scrollOffset != oldScrollOffset
                    # Scrolling occurred, need full redraw
                    draw()
                else
                    # No scroll, just redraw old and new items
                    drawItemAtIndex(oldIndex)
                    drawItemAtIndex(selectedIndex)
                ok
                return true
            ok
            
            # Home key
            if event.key = KEY_HOME and len(items) > 0
                selectedIndex = 1
                adjustScrollOffset()
                if scrollOffset != oldScrollOffset
                    draw()
                else
                    drawItemAtIndex(oldIndex)
                    drawItemAtIndex(selectedIndex)
                ok
                return true
            ok
            
            # End key
            if event.key = KEY_END and len(items) > 0
                selectedIndex = len(items)
                adjustScrollOffset()
                if scrollOffset != oldScrollOffset
                    draw()
                else
                    drawItemAtIndex(oldIndex)
                    drawItemAtIndex(selectedIndex)
                ok
                return true
            ok
            
            # Page Up
            if event.key = KEY_PGUP
                visibleLines = height - 2
                selectedIndex = selectedIndex - visibleLines
                if selectedIndex < 1
                    selectedIndex = 1
                ok
                adjustScrollOffset()
                draw()  # Page operations always do full redraw
                return true
            ok
            
            # Page Down
            if event.key = KEY_PGDOWN
                visibleLines = height - 2
                selectedIndex = selectedIndex + visibleLines
                if selectedIndex > len(items)
                    selectedIndex = len(items)
                ok
                adjustScrollOffset()
                draw()  # Page operations always do full redraw
                return true
            ok
        ok
        
        if event.type = "mouse"
            # Click to select item
            mouseX = event.x
            mouseY = event.y
            
            # Check if click is inside the listbox
            if mouseX < x or mouseX >= x + width or mouseY < y or mouseY >= y + height
                return false  # Click outside listbox
            ok
            
            displayCount = height - 2
            
            # Calculate which line was clicked
            # y is the top border, y+1 is first item, y+2 is second item, etc.
            clickedLine = mouseY - y
            
            # Lines 1 through displayCount contain items
            if clickedLine >= 1 and clickedLine <= displayCount
                clickedIndex = scrollOffset + clickedLine
                if clickedIndex >= 1 and clickedIndex <= len(items)
                    if clickedIndex != selectedIndex
                        oldIndex = selectedIndex
                        selectedIndex = clickedIndex
                        # No scroll change on click, just redraw old and new items
                        drawItemAtIndex(oldIndex)
                        drawItemAtIndex(selectedIndex)
                    ok
                    return true
                ok
            ok
        ok
        
        return false
        
    func getSelected
        if selectedIndex > 0 and selectedIndex <= len(items)
            return items[selectedIndex]
        ok
        return ""

# ========================================
# ComboBox Class
# ========================================
class ComboBox from Widget

    items = []
    selectedIndex = 1
    expanded = false
    
    func addItem(item)
        add(items, item)
        if selectedIndex = 0
            selectedIndex = 1
        ok
        # Don't auto-draw - let parent control handle drawing
        
    func draw
        if not visible
            return
        ok
        
        # Draw main box
        if focused
            kernel.setTermColor(YELLOW, BLACK)
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        
        # Don't draw if width is too small
        if width < 5
            return
        ok
        
        displayText = ""
        if selectedIndex > 0 and selectedIndex <= len(items)
            displayText = items[selectedIndex]
        ok
        
        # Calculate inner width (excluding brackets and dropdown arrow)
        innerWidth = width - 4
        if innerWidth < 1
            innerWidth = 1
        ok
        
        if len(displayText) > innerWidth
            displayText = substr(displayText, 1, innerWidth)
        else
            displayText = displayText + copy(" ", innerWidth - len(displayText))
        ok
        
        # Build full display and clip to width
        fullDisplay = "[" + displayText + " v]"
        if len(fullDisplay) > width
            fullDisplay = substr(fullDisplay, 1, width)
        ok
        
        kernel.printAt(x, y, fullDisplay)
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            # Up arrow
            if event.key = KEY_UP and selectedIndex > 1
                selectedIndex--
                draw()
                return true
            ok
            
            # Down arrow
            if event.key = KEY_DOWN and selectedIndex < len(items)
                selectedIndex++
                draw()
                return true
            ok
            
            # Home key
            if event.key = KEY_HOME and len(items) > 0
                selectedIndex = 1
                draw()
                return true
            ok
            
            # End key
            if event.key = KEY_END and len(items) > 0
                selectedIndex = len(items)
                draw()
                return true
            ok
            
            # Enter or Space to toggle dropdown (future enhancement)
            if event.key = 13 or event.key = 32 or event.key = KEY_ENTER or event.key = KEY_SPACE
                # Could implement dropdown expansion here
                return true
            ok
        ok
        
        if event.type = "mouse"
            mouseX = event.x
            mouseY = event.y
            
            # Check if click is within combobox bounds
            if mouseX >= x and mouseX < x + width and mouseY = y
                # Click to cycle through items
                if selectedIndex < len(items)
                    selectedIndex++
                else
                    selectedIndex = 1
                ok
                draw()
                kernel.sleep(150)  # Delay to prevent rapid cycling
                return true
            ok
        ok
        
        return false
        
    func getSelected
        if selectedIndex > 0 and selectedIndex <= len(items)
            return items[selectedIndex]
        ok
        return ""

# ========================================
# ProgressBar Class - Visual progress indicator
# ========================================
class ProgressBar from Widget

    focusable = false     # ProgressBars cannot receive focus (display only)
    minValue = 0
    maxValue = 100
    value = 0
    showPercentage = true
    fillChar = "="            # Fill character
    emptyChar = "-"           # Empty character
    barFgColor = LIGHTGREEN           # Green
    barBgColor = BLACK            # Black
    emptyFgColor = DARKGREY          # Dark gray
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        return self
        
    func setValue(v)
        if v < minValue
            value = minValue
        but v > maxValue
            value = maxValue
        else
            value = v
        ok
        
    func getValue
        return value
        
    func setRange(minV, maxV)
        minValue = minV
        maxValue = maxV
        if value < minValue
            value = minValue
        ok
        if value > maxValue
            value = maxValue
        ok
        
    func getPercentage
        if maxValue = minValue
            return 0
        ok
        return floor(((value - minValue) * 100) / (maxValue - minValue))
        
    func draw
        if not visible
            return
        ok
        
        # Don't draw if width is too small
        if width < 5
            return
        ok
        
        # Calculate fill width
        barWidth = width - 2  # Account for brackets
        if showPercentage
            barWidth = barWidth - 5  # Space for " 100%"
        ok
        if barWidth < 1
            barWidth = 1
        ok
        
        percentage = getPercentage()
        fillWidth = floor((barWidth * percentage) / 100)
        emptyWidth = barWidth - fillWidth
        
        # Build the full display string
        display = "["
        
        # Add filled portion
        if fillWidth > 0
            display = display + copy(fillChar, fillWidth)
        ok
        
        # Add empty portion
        if emptyWidth > 0
            display = display + copy(emptyChar, emptyWidth)
        ok
        
        display = display + "]"
        
        # Add percentage
        if showPercentage
            percText = "" + percentage + "%"
            percText = copy(" ", 4 - len(percText)) + percText
            display = display + percText
        ok
        
        # Clip to width
        if len(display) > width
            display = substr(display, 1, width)
        ok
        
        # Draw with colors - simplified to single print for clipping
        kernel.setTermColor(barFgColor, barBgColor)
        kernel.printAt(x, y, display)
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        # ProgressBar doesn't handle events directly
        return false

# ========================================
# Spinner Class - Numeric input with increment/decrement buttons
# ========================================
class Spinner from Widget

    minValue = 0
    maxValue = 100
    value = 0
    step = 1
    editing = false
    editText = ""
    editCursorPos = 0
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        if w < 7
            width = 7  # Minimum width: [<]XXX[>]
        ok
        return self
        
    func setValue(v)
        if v < minValue
            value = minValue
        but v > maxValue
            value = maxValue
        else
            value = v
        ok
        
    func getValue
        return value
        
    func setRange(minV, maxV)
        minValue = minV
        maxValue = maxV
        if value < minValue
            value = minValue
        ok
        if value > maxValue
            value = maxValue
        ok
        
    func increment
        if value + step <= maxValue
            value = value + step
        else
            value = maxValue
        ok
        
    func decrement
        if value - step >= minValue
            value = value - step
        else
            value = minValue
        ok
        
    func draw
        if not visible
            return
        ok
        
        # Don't draw if width is too small
        if width < 7
            return
        ok
        
        # Build the full display string
        valueWidth = width - 6  # Subtract buttons width
        if valueWidth < 1
            valueWidth = 1
        ok
        
        valueStr = "" + value
        if len(valueStr) > valueWidth
            valueStr = left(valueStr, valueWidth)
        ok
        
        # Center the value
        padding = valueWidth - len(valueStr)
        leftPad = floor(padding / 2)
        rightPad = padding - leftPad
        
        # Build display
        if editing
            displayValue = editText + copy(" ", valueWidth - len(editText))
        else
            displayValue = copy(" ", leftPad) + valueStr + copy(" ", rightPad)
        ok
        
        fullDisplay = "[-]" + displayValue + "[+]"
        
        # Clip to width
        if len(fullDisplay) > width
            fullDisplay = substr(fullDisplay, 1, width)
        ok
        
        # Draw with appropriate colors
        if focused
            kernel.setTermColor(YELLOW, BLACK)  # Yellow when focused
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        kernel.printAt(x, y, fullDisplay)
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            
            if editing
                return handleEditMode(key)
            ok
            
            # Left arrow or minus - decrement
            if key = KEY_LEFT or key = 45  # '-' key
                decrement()
                draw()
                return true
            ok
            
            # Right arrow or plus - increment
            if key = KEY_RIGHT or key = 43 or key = 61  # '+' or '=' key
                increment()
                draw()
                return true
            ok
            
            # Enter - start editing
            if key = 13 or key = KEY_ENTER
                startEditing()
                return true
            ok
            
            # Direct number input
            if key >= 48 and key <= 57  # 0-9
                startEditing()
                editText = char(key)
                editCursorPos = 1
                draw()
                return true
            ok
        ok
        
        if event.type = "mouse"
            return handleMouseClick(event.x, event.y)
        ok
        
        return false
        
    func handleEditMode(key)
        # Escape - cancel editing
        if key = 27 or key = KEY_ESCAPE
            editing = false
            draw()
            return true
        ok
        
        # Enter - confirm editing
        if key = 13 or key = KEY_ENTER
            confirmEdit()
            return true
        ok
        
        # Backspace
        if key = 8 and editCursorPos > 0
            editText = left(editText, editCursorPos - 1) + substr(editText, editCursorPos + 1)
            editCursorPos--
            draw()
            return true
        ok
        
        # Number keys only
        if key >= 48 and key <= 57  # 0-9
            valueWidth = width - 6
            if len(editText) < valueWidth
                editText = left(editText, editCursorPos) + char(key) + substr(editText, editCursorPos + 1)
                editCursorPos++
                draw()
            ok
            return true
        ok
        
        # Minus sign (only at beginning)
        if key = 45 and editCursorPos = 0 and substr(editText, 1, 1) != "-"
            editText = "-" + editText
            editCursorPos++
            draw()
            return true
        ok
        
        return false
        
    func startEditing
        editing = true
        editText = "" + value
        editCursorPos = len(editText)
        draw()
        
    func confirmEdit
        editing = false
        if editText = "" or editText = "-"
            # Empty or just minus - keep old value
        else
            newValue = number(editText)
            setValue(newValue)
        ok
        draw()
        
    func handleMouseClick(mx, my)
        if my != y
            return false
        ok
        
        # Check decrement button
        if mx >= x and mx < x + 3
            decrement()
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Check increment button
        if mx >= x + width - 3 and mx < x + width
            increment()
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Check value field - start editing
        if mx >= x + 3 and mx < x + width - 3
            if not editing
                startEditing()
            ok
            return true
        ok
        
        return false

# ========================================
# HScrollBar Class - Horizontal scroll bar
# ========================================
class HScrollBar from Widget

    minValue = 0
    maxValue = 100
    value = 0
    pageSize = 10         # Size of the visible "page"
    onChange = null       # Callback when value changes
    dragging = false
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, 1)  # Horizontal scrollbar is always 1 row high
        if w < 5
            width = 5  # Minimum: [<]=[>]
        ok
        return self
        
    func setValue(v)
        oldValue = value
        if v < minValue
            value = minValue
        but v > maxValue
            value = maxValue
        else
            value = v
        ok
        if value != oldValue and onChange != null
            call onChange(value)
        ok
        
    func getValue
        return value
        
    func setRange(minV, maxV)
        minValue = minV
        maxValue = maxV
        if value < minValue
            value = minValue
        ok
        if value > maxValue
            value = maxValue
        ok
        
    func setOnChange(handler)
        onChange = handler
        return self
        
    func draw
        if not visible
            return
        ok
        
        # Don't draw if width is too small
        if width < 5
            return
        ok
        
        # Build the full display string
        trackWidth = width - 2  # Minus arrow buttons
        if trackWidth < 1
            trackWidth = 1
        ok
        
        # Calculate thumb position
        if maxValue > minValue
            thumbPos = floor(((value - minValue) * (trackWidth - 1)) / (maxValue - minValue))
        else
            thumbPos = 0
        ok
        
        # Build track with thumb
        track = copy("-", trackWidth)
        if thumbPos >= 0 and thumbPos < trackWidth
            track = substr(track, 1, thumbPos) + "#" + substr(track, thumbPos + 2)
        ok
        
        fullDisplay = "<" + track + ">"
        
        # Clip to width
        if len(fullDisplay) > width
            fullDisplay = substr(fullDisplay, 1, width)
        ok
        
        # Draw with appropriate colors
        if focused
            kernel.setTermColor(YELLOW, BLACK)
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        kernel.printAt(x, y, fullDisplay)
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            
            if key = KEY_LEFT
                setValue(value - 1)
                draw()
                return true
            ok
            
            if key = KEY_RIGHT
                setValue(value + 1)
                draw()
                return true
            ok
            
            if key = KEY_HOME
                setValue(minValue)
                draw()
                return true
            ok
            
            if key = KEY_END
                setValue(maxValue)
                draw()
                return true
            ok
            
            if key = KEY_PGUP
                setValue(value - pageSize)
                draw()
                return true
            ok
            
            if key = KEY_PGDOWN
                setValue(value + pageSize)
                draw()
                return true
            ok
        ok
        
        if event.type = "mouse"
            return handleMouseClick(event.x, event.y)
        ok
        
        return false
        
    func handleMouseClick(mx, my)
        if my != y
            return false
        ok
        
        # Left arrow button
        if mx = x
            setValue(value - 1)
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Right arrow button
        if mx = x + width - 1
            setValue(value + 1)
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Track area - jump to position
        if mx > x and mx < x + width - 1
            trackWidth = width - 2
            clickPos = mx - x - 1
            if maxValue > minValue and trackWidth > 1
                # Calculate percentage based on click position
                percentage = (clickPos * 100) / (trackWidth - 1)
                if percentage > 100
                    percentage = 100
                ok
                if percentage < 0
                    percentage = 0
                ok
                newValue = minValue + floor((percentage * (maxValue - minValue)) / 100)
                setValue(newValue)
                draw()
            ok
            return true
        ok
        
        return false

# ========================================
# VScrollBar Class - Vertical scroll bar
# ========================================
class VScrollBar from Widget

    minValue = 0
    maxValue = 100
    value = 0
    pageSize = 10
    onChange = null
    
    func init(k, px, py, w, h)
        super.init(k, px, py, 1, h)  # Vertical scrollbar is always 1 column wide
        if h < 5
            height = 5
        ok
        return self
        
    func setValue(v)
        oldValue = value
        if v < minValue
            value = minValue
        but v > maxValue
            value = maxValue
        else
            value = v
        ok
        if value != oldValue and onChange != null
            call onChange(value)
        ok
        
    func getValue
        return value
        
    func setRange(minV, maxV)
        minValue = minV
        maxValue = maxV
        if value < minValue
            value = minValue
        ok
        if value > maxValue
            value = maxValue
        ok
        
    func setOnChange(handler)
        onChange = handler
        return self
        
    func draw
        if not visible
            return
        ok
        
        # Don't draw if height is too small
        if height < 3
            return
        ok
        
        # Calculate track height
        trackHeight = height - 2
        if trackHeight < 1
            trackHeight = 1
        ok
        
        # Calculate thumb position
        if maxValue > minValue
            thumbPos = floor(((value - minValue) * (trackHeight - 1)) / (maxValue - minValue))
        else
            thumbPos = 0
        ok
        
        # Draw up arrow button
        if focused
            kernel.setTermColor(YELLOW, BLACK)
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        kernel.printAt(x, y, "^")
        
        # Draw track with thumb
        for i = 1 to trackHeight
            if i - 1 = thumbPos
                if focused
                    kernel.setTermColor(WHITE, BLACK)
                else
                    kernel.setTermColor(GREY, BLACK)
                ok
                kernel.printAt(x, y + i, "#")
            else
                kernel.setTermColor(DARKGREY, BLACK)
                kernel.printAt(x, y + i, "|")
            ok
        next
        
        # Draw down arrow button
        if focused
            kernel.setTermColor(YELLOW, BLACK)
        else
            kernel.setTermColor(GREY, BLACK)
        ok
        kernel.printAt(x, y + height - 1, "v")
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            key = event.key
            
            if key = KEY_UP
                setValue(value - 1)
                draw()
                return true
            ok
            
            if key = KEY_DOWN
                setValue(value + 1)
                draw()
                return true
            ok
            
            if key = KEY_HOME
                setValue(minValue)
                draw()
                return true
            ok
            
            if key = KEY_END
                setValue(maxValue)
                draw()
                return true
            ok
            
            if key = KEY_PGUP
                setValue(value - pageSize)
                draw()
                return true
            ok
            
            if key = KEY_PGDOWN
                setValue(value + pageSize)
                draw()
                return true
            ok
        ok
        
        if event.type = "mouse"
            return handleMouseClick(event.x, event.y)
        ok
        
        return false
        
    func handleMouseClick(mx, my)
        if mx != x
            return false
        ok
        
        # Up arrow button
        if my = y
            setValue(value - 1)
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Down arrow button
        if my = y + height - 1
            setValue(value + 1)
            draw()
            kernel.sleep(100)
            return true
        ok
        
        # Track area - jump to position
        if my > y and my < y + height - 1
            trackHeight = height - 2
            clickPos = my - y - 1
            if maxValue > minValue and trackHeight > 1
                # Calculate percentage based on click position
                percentage = (clickPos * 100) / (trackHeight - 1)
                if percentage > 100
                    percentage = 100
                ok
                if percentage < 0
                    percentage = 0
                ok
                newValue = minValue + floor((percentage * (maxValue - minValue)) / 100)
                setValue(newValue)
                draw()
            ok
            return true
        ok
        
        return false

# ========================================
# TreeNode Class - Represents a node in TreeView
# ========================================
class TreeNode

    text = ""
    children = []
    expanded = false
    parent = null
    data = null          # Custom data associated with node
    level = 0            # Depth level in tree
    
    func init(txt)
        text = txt
        children = []
        return self
        
    func addChild(node)
        node.parent = self
        node.level = level + 1
        add(children, ref(node))
        return node
        
    func addChildText(txt)
        node = new TreeNode(txt)
        node.parent = self
        node.level = level + 1
        add(children, ref(node))
        return node
        
    func hasChildren
        return len(children) > 0
        
    func toggle
        expanded = not expanded
        
    func expand
        expanded = true
        
    func collapse
        expanded = false
        
    func expandAll
        expanded = true
        for i = 1 to len(children)
            children[i].expandAll()
        next
        
    func collapseAll
        expanded = false
        for i = 1 to len(children)
            children[i].collapseAll()
        next

# ========================================
# TreeView Class - Hierarchical tree control
# ========================================
class TreeView from Widget

    rootNodes = []
    visibleNodes = []      # Flattened list of visible nodes
    selectedIndex = 0      # Index in visibleNodes
    scrollY = 0            # Scroll offset
    
    # Colors
    nodeFgColor = WHITE       # White
    nodeBgColor = BLACK        # Black
    selectedFgColor = BLACK    # Black
    selectedBgColor = LIGHTCYAN   # Cyan
    expanderFgColor = YELLOW   # Yellow
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        rootNodes = []
        visibleNodes = []
        return self
        
    func addRootNode(node)
        node.level = 0
        add(rootNodes, ref(node))
        updateVisibleNodes()
        return node
        
    func addRootText(txt)
        node = new TreeNode(txt)
        node.level = 0
        add(rootNodes, ref(node))
        updateVisibleNodes()
        return node
        
    func updateVisibleNodes
        visibleNodes = []
        for i = 1 to len(rootNodes)
            addNodeToVisible(rootNodes[i])
        next
        
    func addNodeToVisible(node)
        add(visibleNodes, ref(node))
        if node.expanded and node.hasChildren()
            for i = 1 to len(node.children)
                addNodeToVisible(node.children[i])
            next
        ok
        
    func draw
        if not visible
            return
        ok
        
        # Draw border
        kernel.setTermColor(GREY, nodeBgColor)
        kernel.drawRect(x, y, width, height)
        
        # Calculate visible area
        visibleHeight = height - 2
        contentWidth = width - 2
        
        # Draw visible nodes
        for i = 1 to visibleHeight
            nodeIndex = scrollY + i
            drawY = y + i
            
            if nodeIndex <= len(visibleNodes)
                node = visibleNodes[nodeIndex]
                drawNode(node, drawY, contentWidth, nodeIndex = selectedIndex + 1)
            else
                # Clear empty line
                kernel.setTermColor(nodeFgColor, nodeBgColor)
                kernel.printAt(x + 1, drawY, copy(" ", contentWidth))
            ok
        next
        
        kernel.resetTermColor()
        
    func drawNode(node, drawY, contentWidth, isSelected)
        # Calculate indent based on level
        indent = node.level * 2
        
        # Current X position
        currentX = x + 1
        
        # Draw indent spaces
        if indent > 0
            kernel.setTermColor(nodeFgColor, nodeBgColor)
            kernel.printAt(currentX, drawY, copy(" ", indent))
            currentX = currentX + indent
        ok
        
        # Draw expander [+] or [-] or spaces
        kernel.setTermColor(expanderFgColor, nodeBgColor)
        if node.hasChildren()
            if node.expanded
                kernel.printAt(currentX, drawY, "[-]")
            else
                kernel.printAt(currentX, drawY, "[+]")
            ok
        else
            kernel.printAt(currentX, drawY, "   ")
        ok
        currentX = currentX + 3
        
        # Draw node text
        if isSelected
            kernel.setTermColor(selectedFgColor, selectedBgColor)
        else
            kernel.setTermColor(nodeFgColor, nodeBgColor)
        ok
        
        # Calculate available width for text
        availableWidth = contentWidth - indent - 3 - 1  # -1 for space before text
        nodeText = " " + node.text
        
        # Truncate or pad text
        if len(nodeText) > availableWidth
            nodeText = substr(nodeText, 1, availableWidth)
        else
            nodeText = nodeText + copy(" ", availableWidth - len(nodeText))
        ok
        
        kernel.printAt(currentX, drawY, nodeText)
        
    func drawNodeAtIndex(nodeIndex)
        # Draw a single node at the given index (0-based)
        # Only draws if the node is currently visible on screen
        visibleHeight = height - 2
        contentWidth = width - 2
        
        # Check if node is in visible range
        if nodeIndex < scrollY or nodeIndex >= scrollY + visibleHeight
            return
        ok
        
        # Calculate screen position
        screenRow = nodeIndex - scrollY + 1
        drawY = y + screenRow
        
        if nodeIndex < len(visibleNodes)
            node = visibleNodes[nodeIndex + 1]
            drawNodeAtIndex_internal(node, drawY, contentWidth, nodeIndex = selectedIndex)
        ok
        
        kernel.resetTermColor()
        
    func drawNodeAtIndex_internal(node, drawY, contentWidth, isSelected)
        # Internal function to draw a node (same as drawNode but separate to avoid confusion)
        # Calculate indent based on level
        indent = node.level * 2
        
        # Current X position
        currentX = x + 1
        
        # Draw indent spaces
        if indent > 0
            kernel.setTermColor(nodeFgColor, nodeBgColor)
            kernel.printAt(currentX, drawY, copy(" ", indent))
            currentX = currentX + indent
        ok
        
        # Draw expander [+] or [-] or spaces
        kernel.setTermColor(expanderFgColor, nodeBgColor)
        if node.hasChildren()
            if node.expanded
                kernel.printAt(currentX, drawY, "[-]")
            else
                kernel.printAt(currentX, drawY, "[+]")
            ok
        else
            kernel.printAt(currentX, drawY, "   ")
        ok
        currentX = currentX + 3
        
        # Draw node text
        if isSelected
            kernel.setTermColor(selectedFgColor, selectedBgColor)
        else
            kernel.setTermColor(nodeFgColor, nodeBgColor)
        ok
        
        # Calculate available width for text
        availableWidth = contentWidth - indent - 3 - 1  # -1 for space before text
        nodeText = " " + node.text
        
        # Truncate or pad text
        if len(nodeText) > availableWidth
            nodeText = substr(nodeText, 1, availableWidth)
        else
            nodeText = nodeText + copy(" ", availableWidth - len(nodeText))
        ok
        
        kernel.printAt(currentX, drawY, nodeText)
        
    func handleEvent(event)
        if event.type = "keyboard"
            return handleKeyboard(event.key)
        ok
        
        if event.type = "mouse"
            return handleMouse(event.x, event.y)
        ok
        
        return false
        
    func handleKeyboard(key)
        if len(visibleNodes) = 0
            return false
        ok
        
        # Up arrow
        if key = KEY_UP and selectedIndex > 0
            oldIndex = selectedIndex
            oldScrollY = scrollY
            selectedIndex--
            adjustScroll()
            if scrollY != oldScrollY
                # Scrolling occurred, need full redraw
                draw()
            else
                # No scroll, just redraw old and new nodes
                drawNodeAtIndex(oldIndex)
                drawNodeAtIndex(selectedIndex)
            ok
            return true
        ok
        
        # Down arrow
        if key = KEY_DOWN and selectedIndex < len(visibleNodes) - 1
            oldIndex = selectedIndex
            oldScrollY = scrollY
            selectedIndex++
            adjustScroll()
            if scrollY != oldScrollY
                # Scrolling occurred, need full redraw
                draw()
            else
                # No scroll, just redraw old and new nodes
                drawNodeAtIndex(oldIndex)
                drawNodeAtIndex(selectedIndex)
            ok
            return true
        ok
        
        # Left arrow - collapse or go to parent
        if key = KEY_LEFT
            node = visibleNodes[selectedIndex + 1]
            if node.expanded and node.hasChildren()
                node.collapse()
                updateVisibleNodes()
                draw()
            but node.parent != null
                # Find parent in visible nodes - just selection change, no structure change
                oldIndex = selectedIndex
                oldScrollY = scrollY
                for i = 1 to len(visibleNodes)
                    if visibleNodes[i] = node.parent
                        selectedIndex = i - 1
                        adjustScroll()
                        if scrollY != oldScrollY
                            draw()
                        else
                            drawNodeAtIndex(oldIndex)
                            drawNodeAtIndex(selectedIndex)
                        ok
                        exit
                    ok
                next
            ok
            return true
        ok
        
        # Right arrow - expand or go to first child
        if key = KEY_RIGHT
            node = visibleNodes[selectedIndex + 1]
            if node.hasChildren()
                if not node.expanded
                    node.expand()
                    updateVisibleNodes()
                    draw()
                else
                    # Go to first child - just selection change, no structure change
                    oldIndex = selectedIndex
                    oldScrollY = scrollY
                    selectedIndex++
                    adjustScroll()
                    if scrollY != oldScrollY
                        draw()
                    else
                        drawNodeAtIndex(oldIndex)
                        drawNodeAtIndex(selectedIndex)
                    ok
                ok
            ok
            return true
        ok
        
        # Enter or Space - toggle expand/collapse
        if key = 13 or key = 32 or key = KEY_ENTER or key = KEY_SPACE
            node = visibleNodes[selectedIndex + 1]
            if node.hasChildren()
                node.toggle()
                updateVisibleNodes()
                draw()
            ok
            return true
        ok
        
        # Home
        if key = KEY_HOME
            selectedIndex = 0
            adjustScroll()
            draw()
            return true
        ok
        
        # End
        if key = KEY_END
            selectedIndex = len(visibleNodes) - 1
            adjustScroll()
            draw()
            return true
        ok
        
        # Page Up
        if key = KEY_PGUP
            visibleHeight = height - 2
            selectedIndex = selectedIndex - visibleHeight
            if selectedIndex < 0
                selectedIndex = 0
            ok
            adjustScroll()
            draw()
            return true
        ok
        
        # Page Down
        if key = KEY_PGDOWN
            visibleHeight = height - 2
            selectedIndex = selectedIndex + visibleHeight
            if selectedIndex >= len(visibleNodes)
                selectedIndex = len(visibleNodes) - 1
            ok
            adjustScroll()
            draw()
            return true
        ok
        
        return false
        
    func handleMouse(mx, my)
        # Check if click is inside tree
        if mx < x + 1 or mx >= x + width - 1 or my < y + 1 or my >= y + height - 1
            return false
        ok
        
        # Calculate which node was clicked
        clickedLine = my - y
        clickedIndex = scrollY + clickedLine
        
        if clickedIndex < 1 or clickedIndex > len(visibleNodes)
            return false
        ok
        
        node = visibleNodes[clickedIndex]
        
        # Calculate click position relative to node
        indent = node.level * 2
        expanderStart = x + 1 + indent
        expanderEnd = expanderStart + 3
        
        # Check if clicked on expander [+] or [-]
        if mx >= expanderStart and mx < expanderEnd and node.hasChildren()
            node.toggle()
            updateVisibleNodes()
            # Adjust selectedIndex if needed
            if selectedIndex >= len(visibleNodes)
                selectedIndex = len(visibleNodes) - 1
            ok
            draw()
            kernel.sleep(150)  # Delay to prevent rapid toggling
            return true
        ok
        
        # Clicked on node text - select it
        oldIndex = selectedIndex
        selectedIndex = clickedIndex - 1
        # Only redraw the old and new selected nodes
        if oldIndex != selectedIndex
            drawNodeAtIndex(oldIndex)
            drawNodeAtIndex(selectedIndex)
        ok
        kernel.sleep(100)
        return true
        
    func adjustScroll
        visibleHeight = height - 2
        
        # Scroll down if selected is below visible area
        if selectedIndex >= scrollY + visibleHeight
            scrollY = selectedIndex - visibleHeight + 1
        ok
        
        # Scroll up if selected is above visible area
        if selectedIndex < scrollY
            scrollY = selectedIndex
        ok
        
    func getSelectedNode
        if selectedIndex >= 0 and selectedIndex < len(visibleNodes)
            return visibleNodes[selectedIndex + 1]
        ok
        return null
        
    func expandAll
        for node in rootNodes
            node.expandAll()
        next
        updateVisibleNodes()
        draw()
        
    func collapseAll
        for node in rootNodes
            node.collapseAll()
        next
        updateVisibleNodes()
        if selectedIndex >= len(visibleNodes)
            selectedIndex = len(visibleNodes) - 1
        ok
        draw()

# ========================================
# TabPage Class - Represents a single tab page
# ========================================
class TabPage

    title = ""
    children = []
    childRelX = []
    childRelY = []
    data = null
    
    func init(t)
        title = t
        children = []
        childRelX = []
        childRelY = []
        return self
        
    func addChild(widget, relX, relY)
        add(children, ref(widget))
        add(childRelX, relX)
        add(childRelY, relY)
        # Hide widget initially (will be shown when page is active)
        widget.visible = false
        return self
        
    func removeChild(widget)
        for i = 1 to len(children)
            if children[i] = widget
                del(children, i)
                del(childRelX, i)
                del(childRelY, i)
                exit
            ok
        next
        return self

# ========================================
# TabControl Class - Tabbed interface control
# ========================================
class TabControl from Widget

    pages = []
    activePageIndex = 1
    
    # Colors
    tabFgColor = BLACK         # Black
    tabBgColor = GREY         # Light gray
    activeTabFgColor = WHITE  # White
    activeTabBgColor = BLUE   # Blue
    contentFgColor = WHITE    # White
    contentBgColor = BLACK     # Black
    borderFgColor = GREY      # Light gray
    
    func init(k, px, py, w, h)
        super.init(k, px, py, w, h)
        pages = []
        return self
        
    func addPage(title)
        page = new TabPage(title)
        add(pages, ref(page))
        if len(pages) = 1
            activePageIndex = 1
        ok
        return page
        
    func removePage(index)
        if index >= 1 and index <= len(pages)
            del(pages, index)
            if activePageIndex > len(pages)
                activePageIndex = len(pages)
            ok
            if activePageIndex < 1 and len(pages) > 0
                activePageIndex = 1
            ok
        ok
        
    func setActivePage(index)
        if index >= 1 and index <= len(pages)
            activePageIndex = index
            draw()
        ok
        
    func nextPage
        if len(pages) = 0
            return
        ok
        activePageIndex++
        if activePageIndex > len(pages)
            activePageIndex = 1  # Wrap around
        ok
        draw()
        
    func previousPage
        if len(pages) = 0
            return
        ok
        activePageIndex--
        if activePageIndex < 1
            activePageIndex = len(pages)  # Wrap around
        ok
        draw()
        
    func getActivePage
        if activePageIndex >= 1 and activePageIndex <= len(pages)
            return pages[activePageIndex]
        ok
        return null
        
    func draw
        if not visible
            return
        ok
        
        # Draw tab bar
        drawTabs()
        
        # Draw content area border
        drawContentArea()
        
        # Draw active page children
        drawActivePageChildren()
        
        kernel.resetTermColor()
        
    func drawTabs
        kernel.setTermColor(tabFgColor, tabBgColor)
        
        # Draw tab bar background
        tabBarLine = copy(" ", width)
        kernel.printAt(x, y, tabBarLine)
        
        # Draw each tab
        currentX = x
        for i = 1 to len(pages)
            page = pages[i]
            tabText = " " + page.title + " "
            
            if i = activePageIndex
                kernel.setTermColor(activeTabFgColor, activeTabBgColor)
            else
                kernel.setTermColor(tabFgColor, tabBgColor)
            ok
            
            kernel.printAt(currentX, y, tabText)
            currentX = currentX + len(tabText)
            
            # Draw separator
            kernel.setTermColor(tabFgColor, tabBgColor)
            if currentX < x + width
                kernel.printAt(currentX, y, "|")
                currentX++
            ok
        next
        
        # Fill rest of tab bar
        if currentX < x + width
            kernel.setTermColor(tabFgColor, tabBgColor)
            kernel.printAt(currentX, y, copy(" ", x + width - currentX))
        ok
        
    func drawContentArea
        kernel.setTermColor(borderFgColor, contentBgColor)
        
        # Draw border around content area (below tabs)
        # Top line
        topLine = "+"
        for i = 1 to width - 2
            topLine = topLine + "-"
        next
        topLine = topLine + "+"
        kernel.printAt(x, y + 1, topLine)
        
        # Side borders and content fill
        contentLine = copy(" ", width - 2)
        for row = y + 2 to y + height - 2
            kernel.printAt(x, row, "|")
            kernel.setTermColor(contentFgColor, contentBgColor)
            kernel.printAt(x + 1, row, contentLine)
            kernel.setTermColor(borderFgColor, contentBgColor)
            kernel.printAt(x + width - 1, row, "|")
        next
        
        # Bottom line
        bottomLine = "+"
        for i = 1 to width - 2
            bottomLine = bottomLine + "-"
        next
        bottomLine = bottomLine + "+"
        kernel.printAt(x, y + height - 1, bottomLine)
        
    func drawActivePageChildren
        if activePageIndex < 1 or activePageIndex > len(pages)
            return
        ok
        
        # First, hide all children from all pages
        for p = 1 to len(pages)
            pg = pages[p]
            for c = 1 to len(pg.children)
                pg.children[c].visible = false
            next
        next
        
        page = pages[activePageIndex]
        
        # Content area starts at (x + 1, y + 2)
        contentX = x + 1
        contentY = y + 2
        contentWidth = width - 2
        contentHeight = height - 3
        
        # Update positions and draw children of active page
        for i = 1 to len(page.children)
            child = page.children[i]
            child.x = contentX + page.childRelX[i]
            child.y = contentY + page.childRelY[i]
            
            # Only draw if within content area
            if child.y >= contentY and child.y < contentY + contentHeight
                if child.x >= contentX and child.x < contentX + contentWidth
                    child.visible = true
                    child.draw()
                ok
            ok
        next
        
    func handleEvent(event)
        if event.type = "keyboard"
            return handleKeyboard(event.key)
        ok
        
        if event.type = "mouse"
            return handleMouse(event.x, event.y)
        ok
        
        return false
        
    func handleKeyboard(key)
        # Ctrl+Tab or Tab to switch tabs (simplified: just use left/right)
        # Left arrow - previous tab
        if key = KEY_LEFT and activePageIndex > 1
            activePageIndex--
            draw()
            return true
        ok
        
        # Right arrow - next tab
        if key = KEY_RIGHT and activePageIndex < len(pages)
            activePageIndex++
            draw()
            return true
        ok
        
        # Home - first tab
        if key = KEY_HOME and len(pages) > 0
            activePageIndex = 1
            draw()
            return true
        ok
        
        # End - last tab
        if key = KEY_END and len(pages) > 0
            activePageIndex = len(pages)
            draw()
            return true
        ok
        
        # Pass keyboard events to active page children
        page = getActivePage()
        if page != null
            for child in page.children
                if child.focused
                    childEvent = new Event("keyboard")
                    childEvent.key = key
                    if child.handleEvent(childEvent)
                        return true
                    ok
                ok
            next
        ok
        
        return false
        
    func handleMouse(mx, my)
        # Check if click is on tab bar
        if my = y
            return handleTabClick(mx)
        ok
        
        # Check if click is in content area
        if mx > x and mx < x + width - 1 and my > y + 1 and my < y + height - 1
            return handleContentClick(mx, my)
        ok
        
        return false
        
    func handleTabClick(mx)
        # Find which tab was clicked
        currentX = x
        for i = 1 to len(pages)
            page = pages[i]
            tabText = " " + page.title + " "
            tabEnd = currentX + len(tabText)
            
            if mx >= currentX and mx < tabEnd
                if i != activePageIndex
                    activePageIndex = i
                    draw()
                    kernel.sleep(100)
                ok
                return true
            ok
            
            currentX = tabEnd + 1  # +1 for separator
        next
        
        return false
        
    func handleContentClick(mx, my)
        page = getActivePage()
        if page = null
            return false
        ok
        
        # Pass click to children
        for i = len(page.children) to 1 step -1
            child = page.children[i]
            if child.visible
                childEvent = new Event("mouse")
                childEvent.x = mx
                childEvent.y = my
                childEvent.data = true
                if child.handleEvent(childEvent)
                    return true
                ok
            ok
        next
        
        return true  # Consume click in content area

# ========================================
# MenuItem Class - Represents a single menu item
# ========================================
class MenuItem

    text = ""              # Display text
    shortcut = ""          # Keyboard shortcut display (e.g., "Ctrl+S")
    itemType = "normal"    # "normal", "checkbox", "separator", "submenu"
    checked = false        # For checkbox items
    enabled = true         # Is item enabled?
    onClick = null         # Click handler function
    submenu = null         # Reference to submenu (Menu object) if itemType = "submenu"
    id = ""                # Optional identifier
    
    func init(txt, type)
        text = txt
        if type != null
            itemType = type
        ok
        return self
        
    func setText(t)
        text = t
        return self
        
    func setShortcut(s)
        shortcut = s
        return self
        
    func setChecked(val)
        checked = val
        return self
        
    func toggle
        if itemType = "checkbox"
            checked = not checked
        ok
        return self
        
    func setEnabled(val)
        enabled = val
        return self
        
    func setOnClick(handler)
        onClick = handler
        return self
        
    func setSubmenu(menu)
        submenu = menu
        itemType = "submenu"
        return self
        
    func setId(idStr)
        id = idStr
        return self
        
    func getDisplayWidth
        if itemType = "separator"
            return 0
        ok
        w = len(text)
        if itemType = "checkbox"
            w = w + 4  # For "[X] " or "[ ] "
        ok
        if itemType = "submenu"
            w = w + 2  # For " ►"
        ok
        if len(shortcut) > 0
            w = w + len(shortcut) + 2  # For "  shortcut"
        ok
        return w

# ========================================
# Menu Class - Dropdown/Popup menu with items
# ========================================
class Menu

    kernel = null
    items = []             # List of MenuItem objects
    x = 0                  # Position X
    y = 0                  # Position Y
    width = 0              # Calculated width
    height = 0             # Calculated height
    selectedIndex = 1      # Currently selected item (1-based)
    visible = false        # Is menu visible?
    parent = null          # Parent menu (for submenus)
    parentItem = null      # Parent MenuItem that opened this submenu
    activeSubmenu = null   # Currently open submenu
    title = ""             # Menu title (for menubar)
    
    # Colors
    normalFgColor = BLACK      # Black
    normalBgColor = GREY      # Light gray
    selectedFgColor = WHITE
    selectedBgColor = BLUE
    disabledFgColor = DARKGREY    # Dark gray
    shortcutFgColor = DARKGREY    # Dark gray for shortcuts
    borderFgColor = BLACK      # Black border
    
    func init(k)
        kernel = ref(k)
        return self
        
    func setTitle(t)
        title = t
        return self
        
    func addItem(item)
        add(items, item)
        calculateSize()
        return self
        
    func addNormalItem(text, handler)
        item = new MenuItem(text, "normal")
        item.setOnClick(handler)
        add(items, item)
        calculateSize()
        return ref(items[len(items)])
        
    func addCheckboxItem(text, checked, handler)
        item = new MenuItem(text, "checkbox")
        item.setChecked(checked)
        item.setOnClick(handler)
        add(items, item)
        calculateSize()
        return ref(items[len(items)])
        
    func addSeparator
        item = new MenuItem("", "separator")
        add(items, item)
        calculateSize()
        return ref(items[len(items)])
        
    func addSubmenu(text, submenu)
        item = new MenuItem(text, "submenu")
        item.setSubmenu(ref(submenu))
        submenu.parent = self
        submenu.parentItem = item
        add(items, item)
        calculateSize()
        return ref(items[len(items)])
        
    func calculateSize
        # Calculate menu width based on items
        maxWidth = 0
        for item in items
            w = item.getDisplayWidth()
            if w > maxWidth
                maxWidth = w
            ok
        next
        width = maxWidth + 4  # Add padding
        if width < 10
            width = 10
        ok
        
        # Calculate height
        height = len(items) + 2  # Items + top/bottom border
        
    func setPosition(px, py)
        x = px
        y = py
        return self
        
    func show(px, py)
        x = px
        y = py
        visible = true
        selectedIndex = 1
        # Skip to first non-separator item
        while selectedIndex <= len(items) and items[selectedIndex].itemType = "separator"
            selectedIndex++
        end
        draw()
        
    func hide
        if not visible
            return
        ok
        visible = false
        if activeSubmenu != null
            activeSubmenu.hide()
            activeSubmenu = null
        ok
        # Clear the menu area by drawing spaces
        clear()
        
    func clear
        # Clear the area where the menu was drawn
        # First clear the region with the default background color
        kernel.clearRegion(x, y, width, height)
        # Only redraw widgets if this is a top-level menu (no parent)
        # Submenus should not trigger widget redraw as parent menus are still visible
        if parent = null and len(kernel.screenWidgets) > 0
            kernel.redrawRegion(x, y, width, height)
        ok
        
    func draw
        if not visible
            return
        ok
        
        # Use simple ASCII characters for maximum compatibility
        # + for corners, - for horizontal, | for vertical
        
        kernel.setTermColor(borderFgColor, normalBgColor)
        
        # Build and draw top border: +----+
        topBorder = "+"
        for i = 1 to width - 2
            topBorder = topBorder + "-"
        next
        topBorder = topBorder + "+"
        kernel.printAt(x, y, topBorder)
        
        # Draw each item
        for i = 1 to len(items)
            item = items[i]
            drawItem(i, item)
        next
        
        # Build and draw bottom border: +----+
        bottomBorder = "+"
        for i = 1 to width - 2
            bottomBorder = bottomBorder + "-"
        next
        bottomBorder = bottomBorder + "+"
        kernel.printAt(x, y + len(items) + 1, bottomBorder)
        
        kernel.resetTermColor()
        
    func drawItem(index, item)
        py = y + index
        contentWidth = width - 2  # Minus left and right borders
        
        # Determine colors based on selection state
        if index = selectedIndex
            fg = selectedFgColor
            bg = selectedBgColor
        else
            if item.enabled
                fg = normalFgColor
            else
                fg = disabledFgColor
            ok
            bg = normalBgColor
        ok
        
        if item.itemType = "separator"
            # Draw separator line: +----+
            kernel.setTermColor(borderFgColor, normalBgColor)
            sepLine = "+"
            for i = 1 to width - 2
                sepLine = sepLine + "-"
            next
            sepLine = sepLine + "+"
            kernel.printAt(x, py, sepLine)
        else
            # Build the complete line: |content|
            
            # Start with left border
            kernel.setTermColor(borderFgColor, normalBgColor)
            kernel.printAt(x, py, "|")
            
            # Build content text
            displayText = ""
            
            # Checkbox prefix
            if item.itemType = "checkbox"
                if item.checked
                    displayText = "[X] "
                else
                    displayText = "[ ] "
                ok
            ok
            
            # Add item text
            displayText = displayText + item.text
            
            # Calculate remaining space
            textLen = len(displayText)
            
            # Handle submenu arrow or shortcut
            if item.itemType = "submenu"
                # Add arrow at end
                arrowText = " >"
                padding = contentWidth - textLen - len(arrowText)
                if padding > 0
                    displayText = displayText + copy(" ", padding) + arrowText
                else
                    displayText = displayText + arrowText
                ok
            but len(item.shortcut) > 0
                # Add shortcut at end
                padding = contentWidth - textLen - len(item.shortcut)
                if padding > 0
                    displayText = displayText + copy(" ", padding) + item.shortcut
                else
                    displayText = displayText + " " + item.shortcut
                ok
            else
                # Just pad to fill width
                if textLen < contentWidth
                    displayText = displayText + copy(" ", contentWidth - textLen)
                ok
            ok
            
            # Truncate if too long
            if len(displayText) > contentWidth
                displayText = substr(displayText, 1, contentWidth)
            ok
            
            # Ensure exact width by padding if needed
            if len(displayText) < contentWidth
                displayText = displayText + copy(" ", contentWidth - len(displayText))
            ok
            
            # Print content with proper colors
            kernel.setTermColor(fg, bg)
            kernel.printAt(x + 1, py, displayText)
            
            # Draw right border
            kernel.setTermColor(borderFgColor, normalBgColor)
            kernel.printAt(x + width - 1, py, "|")
        ok
        
    func handleKeyboard(key)
        if not visible
            return false
        ok
        
        # If submenu is active, let it handle keys first
        if activeSubmenu != null
            if activeSubmenu.handleKeyboard(key)
                return true
            ok
        ok
        
        # Up arrow
        if key = KEY_UP
            movePrevious()
            return true
        ok
        
        # Down arrow
        if key = KEY_DOWN
            moveNext()
            return true
        ok
        
        # Left arrow - close submenu or go to parent
        if key = KEY_LEFT
            if activeSubmenu != null
                activeSubmenu.hide()
                activeSubmenu = null
                draw()
                return true
            but parent != null
                # Close this menu and return to parent
                return false  # Let parent handle it
            ok
        ok
        
        # Right arrow - open submenu
        if key = KEY_RIGHT
            if selectedIndex >= 1 and selectedIndex <= len(items)
                item = items[selectedIndex]
                if item.itemType = "submenu" and item.enabled
                    openSubmenu(item)
                    return true
                ok
            ok
        ok
        
        # Enter or Space - activate item
        if key = 13 or key = KEY_ENTER or key = 32 or key = KEY_SPACE
            if selectedIndex >= 1 and selectedIndex <= len(items)
                item = items[selectedIndex]
                if item.enabled
                    if item.itemType = "submenu"
                        openSubmenu(item)
                    but item.itemType = "checkbox"
                        item.toggle()
                        draw()
                        if item.onClick != null
                            call item.onClick(item)
                        ok
                    but item.itemType = "normal"
                        if item.onClick != null
                            call item.onClick(item)
                        ok
                        return false  # Signal to close menu
                    ok
                ok
            ok
            return true
        ok
        
        # Escape - close menu
        if key = 27 or key = KEY_ESCAPE
            if activeSubmenu != null
                activeSubmenu.hide()
                activeSubmenu = null
                draw()
            else
                return false  # Signal to close this menu
            ok
            return true
        ok
        
        return false
        
    func handleMouse(mx, my, clicking)
        if not visible
            return false
        ok
        
        # Check if click is in active submenu first
        if activeSubmenu != null
            if activeSubmenu.handleMouse(mx, my, clicking)
                return true
            ok
        ok
        
        # Check if mouse is in this menu
        if mx >= x and mx < x + width and my > y and my < y + height - 1
            # Calculate which item was clicked
            itemIndex = my - y
            if itemIndex >= 1 and itemIndex <= len(items)
                item = items[itemIndex]
                
                if item.itemType != "separator"
                    # Hover - change selection
                    if selectedIndex != itemIndex
                        # Close any open submenu when moving to different item
                        if activeSubmenu != null
                            activeSubmenu.hide()
                            activeSubmenu = null
                        ok
                        selectedIndex = itemIndex
                        draw()
                        
                        # Auto-open submenu on hover
                        if item.itemType = "submenu" and item.enabled
                            openSubmenu(item)
                        ok
                    ok
                    
                    # Click
                    if clicking and item.enabled
                        if item.itemType = "submenu"
                            if activeSubmenu = null
                                openSubmenu(item)
                            ok
                        but item.itemType = "checkbox"
                            item.toggle()
                            draw()
                            if item.onClick != null
                                call item.onClick(item)
                            ok
                        but item.itemType = "normal"
                            if item.onClick != null
                                call item.onClick(item)
                            ok
                            return false  # Signal to close menu hierarchy
                        ok
                    ok
                ok
                return true
            ok
        ok
        
        return false
        
    func openSubmenu(item)
        if item.submenu != null
            # Close any existing submenu
            if activeSubmenu != null
                activeSubmenu.hide()
            ok
            
            # Position submenu to the right of this menu
            subX = x + width - 1
            subY = y + find(items, item)
            
            # Adjust if would go off screen
            if subX + item.submenu.width > kernel.getCols()
                subX = x - item.submenu.width + 1
            ok
            
            item.submenu.show(subX, subY)
            activeSubmenu = item.submenu
        ok
        
    func moveNext
        if len(items) = 0
            return
        ok
        
        startIndex = selectedIndex
        selectedIndex++
        
        # Skip separators
        while selectedIndex <= len(items) and items[selectedIndex].itemType = "separator"
            selectedIndex++
        end
        
        # Wrap around
        if selectedIndex > len(items)
            selectedIndex = 1
            while selectedIndex <= len(items) and items[selectedIndex].itemType = "separator"
                selectedIndex++
            end
        ok
        
        # If we went full circle, stay at start
        if selectedIndex > len(items)
            selectedIndex = startIndex
        ok
        
        draw()
        
    func movePrevious
        if len(items) = 0
            return
        ok
        
        startIndex = selectedIndex
        selectedIndex--
        
        # Skip separators
        while selectedIndex >= 1 and items[selectedIndex].itemType = "separator"
            selectedIndex--
        end
        
        # Wrap around
        if selectedIndex < 1
            selectedIndex = len(items)
            while selectedIndex >= 1 and items[selectedIndex].itemType = "separator"
                selectedIndex--
            end
        ok
        
        # If we went full circle, stay at start
        if selectedIndex < 1
            selectedIndex = startIndex
        ok
        
        draw()
        
    func getItemAt(index)
        if index >= 1 and index <= len(items)
            return items[index]
        ok
        return null
        
    func getItemById(idStr)
        for item in items
            if item.id = idStr
                return item
            ok
        next
        return null
        
    func getSelectedItem
        if selectedIndex >= 1 and selectedIndex <= len(items)
            return items[selectedIndex]
        ok
        return null
        
    func closeAllSubmenus
        if activeSubmenu != null
            activeSubmenu.closeAllSubmenus()
            activeSubmenu.hide()
            activeSubmenu = null
        ok
        
    func getDeepestActiveMenu
        # Returns the deepest active submenu in the chain
        if activeSubmenu != null
            return activeSubmenu.getDeepestActiveMenu()
        ok
        return self
        
    func moveNextDeep
        # Move to next item in the deepest active menu
        if activeSubmenu != null
            activeSubmenu.moveNextDeep()
        else
            moveNext()
        ok
        
    func movePreviousDeep
        # Move to previous item in the deepest active menu
        if activeSubmenu != null
            activeSubmenu.movePreviousDeep()
        else
            movePrevious()
        ok
        
    func activateSelectedDeep
        # Activate the selected item in the deepest active menu
        # Returns "close" if menu should close, "stay" otherwise
        if activeSubmenu != null
            return activeSubmenu.activateSelectedDeep()
        ok
        
        if selectedIndex >= 1 and selectedIndex <= len(items)
            item = items[selectedIndex]
            if item.enabled
                if item.itemType = "submenu"
                    openSubmenu(item)
                    return "stay"
                but item.itemType = "checkbox"
                    item.toggle()
                    draw()
                    if item.onClick != null
                        call item.onClick(item)
                    ok
                    return "stay"
                but item.itemType = "normal"
                    if item.onClick != null
                        call item.onClick(item)
                    ok
                    return "close"
                ok
            ok
        ok
        return "stay"
        
    func handleMouseDeep(mx, my, clicking)
        # Handle mouse in this menu or any submenu
        # Returns "close" to close hierarchy, "handled" if handled, "outside" if click was outside
        
        # First check submenus (deepest first)
        if activeSubmenu != null
            result = activeSubmenu.handleMouseDeep(mx, my, clicking)
            if result != "outside"
                return result
            ok
        ok
        
        # Check if mouse is in this menu (including borders)
        # Menu occupies: y (top border), y+1 to y+len(items) (items), y+len(items)+1 (bottom border)
        if mx >= x and mx < x + width and my >= y and my <= y + height - 1
            # Calculate which item (items start at y+1)
            itemIndex = my - y
            if itemIndex >= 1 and itemIndex <= len(items)
                item = items[itemIndex]
                
                if item.itemType != "separator"
                    # Update selection
                    if selectedIndex != itemIndex
                        # Close any open submenu when moving to different item
                        if activeSubmenu != null
                            activeSubmenu.closeAllSubmenus()
                            activeSubmenu.hide()
                            activeSubmenu = null
                        ok
                        selectedIndex = itemIndex
                        draw()
                        
                        # Auto-open submenu on hover
                        if item.itemType = "submenu" and item.enabled
                            openSubmenu(item)
                        ok
                    ok
                    
                    # Handle click
                    if clicking and item.enabled
                        if item.itemType = "submenu"
                            if activeSubmenu = null
                                openSubmenu(item)
                            ok
                            return "handled"
                        but item.itemType = "checkbox"
                            item.toggle()
                            draw()
                            if item.onClick != null
                                call item.onClick(item)
                            ok
                            return "handled"
                        but item.itemType = "normal"
                            if item.onClick != null
                                call item.onClick(item)
                            ok
                            return "close"
                        ok
                    ok
                ok
                return "handled"
            ok
            # Click on border area - still inside menu
            return "handled"
        ok
        
        return "outside"

# ========================================
# MenuBar Class - Horizontal menu bar at top of screen
# ========================================
class MenuBar from Widget

    menus = []             # List of Menu objects
    selectedIndex = 0      # Currently selected menu (0 = none, 1-based otherwise)
    activeMenu = null      # Currently open menu
    isActive = false       # Is menu bar active (has focus)?
    menuResult = null      # Result from menu interaction (selected item)
    
    # Colors
    normalFgColor = BLACK      # Black text
    normalBgColor = GREY      # Light gray background
    selectedFgColor = WHITE text
    selectedBgColor = BLUE background
    hotKeyFgColor = BLUE      # Blue for hotkey letters
    
    func init(k, px, py, w)
        super.init(k, px, py, w, 1)
        return self
        
    func addMenu(menu)
        add(menus, menu)
        return self
        
    func createMenu(title)
        menu = new Menu(kernel)
        menu.setTitle(title)
        add(menus, menu)
        # Return reference to the menu in the array so modifications affect the stored object
        return ref(menus[len(menus)])
        
    func draw
        if not visible
            return
        ok
        
        # Draw menu bar background
        kernel.setTermColor(normalFgColor, normalBgColor)
        bgLine = copy(" ", width)
        kernel.printAt(x, y, bgLine)
        
        # Draw menu titles
        currentX = x + 1
        for i = 1 to len(menus)
            menu = menus[i]
            titleText = " " + menu.title + " "
            
            # Determine colors
            if i = selectedIndex
                kernel.setTermColor(selectedFgColor, selectedBgColor)
            else
                kernel.setTermColor(normalFgColor, normalBgColor)
            ok
            
            kernel.printAt(currentX, y, titleText)
            currentX = currentX + len(titleText)
        next
        
        kernel.resetTermColor()
        
    func handleEvent(event)
        if event.type = "keyboard"
            return handleKeyboard(event.key)
        ok
        
        if event.type = "mouse"
            return handleMouse(event.x, event.y, true)
        ok
        
        return false
        
    func handleKeyboard(key)
        # F2 to activate menu bar
        if key = KEY_F2
            if not isActive
                activate()
                runMenuLoop()
            ok
            return true
        ok
        
        return false
        
    func handleMouse(mx, my, clicking)
        # Check if click is on menu bar
        if my = y and mx >= x and mx < x + width
            # Find which menu was clicked
            currentX = x + 1
            for i = 1 to len(menus)
                menu = menus[i]
                titleLen = len(menu.title) + 2
                
                if mx >= currentX and mx < currentX + titleLen
                    if clicking
                        # Open this menu
                        selectedIndex = i
                        isActive = true
                        draw()
                        openMenu(i)
                        runMenuLoop()
                    ok
                    return true
                ok
                currentX = currentX + titleLen
            next
            return true
        ok
        
        return false
        
    func activate
        isActive = true
        if selectedIndex = 0 and len(menus) > 0
            selectedIndex = 1
        ok
        draw()
        
    func deactivate
        isActive = false
        selectedIndex = 0
        if activeMenu != null
            activeMenu.hide()
            activeMenu = null
        ok
        draw()
        
    func openMenu(index)
        if index < 1 or index > len(menus)
            return
        ok
        
        menu = menus[index]
        
        # Calculate menu position (below the menu title)
        menuX = x + 1
        for i = 1 to index - 1
            menuX = menuX + len(menus[i].title) + 2
        next
        
        # Adjust if menu would go off screen
        if menuX + menu.width > kernel.getCols()
            menuX = kernel.getCols() - menu.width
        ok
        
        menu.show(menuX, y + 1)
        activeMenu = menu
        
    func closeMenu
        if activeMenu != null
            activeMenu.hide()
            activeMenu = null
        ok
        isActive = false
        selectedIndex = 0
        draw()
        
    func moveNext
        if len(menus) = 0
            return
        ok
        
        if activeMenu != null
            activeMenu.hide()
        ok
        
        selectedIndex++
        if selectedIndex > len(menus)
            selectedIndex = 1
        ok
        
        draw()
        openMenu(selectedIndex)
        
    func movePrevious
        if len(menus) = 0
            return
        ok
        
        if activeMenu != null
            activeMenu.hide()
        ok
        
        selectedIndex--
        if selectedIndex < 1
            selectedIndex = len(menus)
        ok
        
        draw()
        openMenu(selectedIndex)
        
    func isMenuActive
        return activeMenu != null or isActive
        
    func getActiveMenu
        return activeMenu
        
    func getMenuByTitle(title)
        for menu in menus
            if menu.title = title
                return menu
            ok
        next
        return null
        
    func closeDeepestSubmenu(menu)
        # Close only the deepest submenu in the hierarchy (one level)
        if menu.activeSubmenu = null
            return
        ok
        
        if menu.activeSubmenu.activeSubmenu = null
            # This menu's submenu is the deepest - close it
            menu.activeSubmenu.hide()
            menu.activeSubmenu = null
            menu.draw()
        else
            # Go deeper
            closeDeepestSubmenu(menu.activeSubmenu)
        ok
        
    func runMenuLoop
        # Dedicated loop for menu interaction
        # This prevents the main event loop from interfering
        
        nBuffer = 0
        nKey = 0
        menuRunning = true
        
        # Wait for mouse button to be released before processing new clicks
        # This prevents the click that opened the menu from immediately closing it
        kernel.sleep(100)
        
        # Flush any pending input
        while kernel.checkKeyHit()
            kernel.getKey()
        end
        
        while menuRunning
            nBuffer = kernel.checkKeyHit()
            nKey = 0
            
            if nBuffer
                nKey = kernel.getKey()
                
                # Escape - close menu
                if nKey = 27 or nKey = KEY_ESCAPE
                    if activeMenu != null and activeMenu.activeSubmenu != null
                        # Close submenu first
                        activeMenu.closeAllSubmenus()
                        activeMenu.draw()
                    but activeMenu != null
                        # Close the dropdown
                        closeMenu()
                        menuRunning = false
                    else
                        # Deactivate menu bar
                        deactivate()
                        menuRunning = false
                    ok
                ok
                
                # Left arrow - close one level of submenu or previous menu
                if nKey = KEY_LEFT
                    if activeMenu != null
                        # Get the deepest active menu
                        deepMenu = activeMenu.getDeepestActiveMenu()
                        
                        if deepMenu != activeMenu
                            # We're in a submenu - close just the deepest one
                            # Find the parent of the deepest menu and close its submenu
                            closeDeepestSubmenu(activeMenu)
                        else
                            # We're at the top level menu - move to previous menu
                            movePrevious()
                        ok
                    else
                        # No menu open - move to previous menu
                        movePrevious()
                    ok
                ok
                
                # Right arrow - next menu or open submenu
                if nKey = KEY_RIGHT
                    if activeMenu != null
                        # Get the deepest active menu in the hierarchy
                        deepMenu = activeMenu.getDeepestActiveMenu()
                        item = deepMenu.getSelectedItem()
                        if item != null and item.itemType = "submenu" and item.enabled
                            # Open the submenu of the currently selected item
                            deepMenu.openSubmenu(item)
                        else
                            # No submenu to open - move to next top-level menu
                            # First close all submenus and clear their areas
                            if activeMenu.activeSubmenu != null
                                activeMenu.closeAllSubmenus()
                            ok
                            moveNext()
                        ok
                    else
                        moveNext()
                    ok
                ok
                
                # Up arrow
                if nKey = KEY_UP
                    if activeMenu != null
                        activeMenu.movePreviousDeep()
                    ok
                ok
                
                # Down arrow
                if nKey = KEY_DOWN
                    if activeMenu != null
                        activeMenu.moveNextDeep()
                    but isActive and selectedIndex > 0
                        openMenu(selectedIndex)
                    ok
                ok
                
                # Enter or Space - activate item
                if nKey = 13 or nKey = KEY_ENTER or nKey = 32 or nKey = KEY_SPACE
                    if activeMenu != null
                        result = activeMenu.activateSelectedDeep()
                        if result = "close"
                            closeMenu()
                            menuRunning = false
                        ok
                    but isActive and selectedIndex > 0
                        openMenu(selectedIndex)
                    ok
                ok
            ok
            
            # Check for mouse events
            if kernel.mouseEnabled
                aMouse = MouseInfo(nBuffer, nKey)
                
                if aMouse[MOUSEINFO_ACTIVE]
                    mouseX = aMouse[MOUSEINFO_X]
                    mouseY = aMouse[MOUSEINFO_Y]
                    mouseButton = aMouse[MOUSEINFO_BUTTONS]
                    
                    if mouseButton = MOUSEINFO_LEFTBUTTON
                        # Check if click is on menu bar
                        if mouseY = y and mouseX >= x and mouseX < x + width
                            # Find which menu was clicked
                            currentX = x + 1
                            clickedMenu = 0
                            for i = 1 to len(menus)
                                menu = menus[i]
                                titleLen = len(menu.title) + 2
                                
                                if mouseX >= currentX and mouseX < currentX + titleLen
                                    clickedMenu = i
                                    exit
                                ok
                                currentX = currentX + titleLen
                            next
                            
                            if clickedMenu > 0
                                if clickedMenu = selectedIndex and activeMenu != null
                                    # Clicking on same menu - close it
                                    closeMenu()
                                    menuRunning = false
                                else
                                    # Switch to different menu
                                    if activeMenu != null
                                        activeMenu.hide()
                                    ok
                                    selectedIndex = clickedMenu
                                    draw()
                                    openMenu(selectedIndex)
                                    # Wait for mouse release when switching menus
                                    kernel.sleep(100)
                                ok
                            ok
                        # Check if click is in active menu or submenus
                        but activeMenu != null
                            result = activeMenu.handleMouseDeep(mouseX, mouseY, true)
                            if result = "close"
                                closeMenu()
                                menuRunning = false
                            but result = "outside"
                                # Clicked outside all menus - close
                                closeMenu()
                                menuRunning = false
                            ok
                        else
                            # Clicked outside - close
                            deactivate()
                            menuRunning = false
                        ok
                    ok
                ok
            ok
            
            kernel.sleep(1)
        end
