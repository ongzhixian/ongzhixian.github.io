package juicy;

import java.awt.*;
import javax.swing.*;
import javax.swing.plaf.metal.*;
import java.awt.event.*;

import javax.swing.border.CompoundBorder;
import javax.swing.border.EmptyBorder;
import javax.swing.border.LineBorder;
import javax.swing.border.BevelBorder;

public class SwingExample implements ActionListener {

    private JMenuBar createMenuBar() {
        JMenuBar menuBar;
        JMenu menu, submenu;
        JMenuItem menuItem;
        JRadioButtonMenuItem rbMenuItem;
        JCheckBoxMenuItem cbMenuItem;

        //Create the menu bar.
        menuBar = new JMenuBar();

        //Build the first menu.        
        // menu = new JMenu("Another Menu");
        // menu.setMnemonic(KeyEvent.VK_N);
        // menu.getAccessibleContext().setAccessibleDescription(
        //         "This menu does nothing");
        menuBar.add(GetOptionsMenu());

        
        //Build second menu in the menu bar.
        menu = new JMenu("File");
        menu.setMnemonic(KeyEvent.VK_F);
        menu.getAccessibleContext().setAccessibleDescription("File menu");
        menuBar.add(menu);

        //a group of JMenuItems
        menuItem = new JMenuItem("A text-only menu item",
                                 KeyEvent.VK_T);
        //menuItem.setMnemonic(KeyEvent.VK_T); //used constructor instead
        menuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_1, ActionEvent.ALT_MASK));
        menuItem.getAccessibleContext().setAccessibleDescription(
                "This doesn't really do anything");
        menu.add(menuItem);

        // ImageIcon icon = createImageIcon("images/middle.gif");
        // menuItem = new JMenuItem("Both text and icon", icon);
        // menuItem.setMnemonic(KeyEvent.VK_B);
        // menu.add(menuItem);

        // menuItem = new JMenuItem(icon);
        // menuItem.setMnemonic(KeyEvent.VK_D);
        // menu.add(menuItem);

        //a group of radio button menu items
        menu.addSeparator();
        ButtonGroup group = new ButtonGroup();

        rbMenuItem = new JRadioButtonMenuItem("A radio button menu item");
        rbMenuItem.setSelected(true);
        rbMenuItem.setMnemonic(KeyEvent.VK_R);
        group.add(rbMenuItem);
        menu.add(rbMenuItem);

        rbMenuItem = new JRadioButtonMenuItem("Another one");
        rbMenuItem.setMnemonic(KeyEvent.VK_O);
        group.add(rbMenuItem);
        menu.add(rbMenuItem);

        //a group of check box menu items
        menu.addSeparator();
        cbMenuItem = new JCheckBoxMenuItem("A check box menu item");
        cbMenuItem.setMnemonic(KeyEvent.VK_C);
        menu.add(cbMenuItem);

        cbMenuItem = new JCheckBoxMenuItem("Another one");
        cbMenuItem.setMnemonic(KeyEvent.VK_H);
        menu.add(cbMenuItem);

        //a submenu
        menu.addSeparator();
        submenu = new JMenu("A submenu");
        submenu.setMnemonic(KeyEvent.VK_S);

        menuItem = new JMenuItem("An item in the submenu");
        menuItem.setAccelerator(KeyStroke.getKeyStroke(
                KeyEvent.VK_2, ActionEvent.ALT_MASK));
        submenu.add(menuItem);

        menuItem = new JMenuItem("Another item");
        submenu.add(menuItem);
        menu.add(submenu);



        return menuBar;
    }

    private JMenu GetOptionsMenu() {
        JMenu menu = new JMenu("Application");
        menu.setMnemonic(KeyEvent.VK_A);
        menu.getAccessibleContext().setAccessibleDescription("Application menu");

        JMenuItem exitMenuItem = new JMenuItem("Exit", KeyEvent.VK_T);
        exitMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, ActionEvent.ALT_MASK));
        exitMenuItem.getAccessibleContext().setAccessibleDescription("Exit application");
        menu.add(exitMenuItem);

        exitMenuItem.addActionListener(new ExitAction());
        // exitMenuItem.addActionListener(new java.awt.event.ActionListener() {
        //     public void actionPerformed(java.awt.event.ActionEvent evt) {
        //         //jMenuItem1ActionPerformed(evt);

        //         javax.swing.JOptionPane.showMessageDialog(null, "foo");
        //         System.exit(0);
        //     }
        // });

        return menu;
    }

    public Container createContentPane() {
        //Create the content-pane-to-be.
        JPanel contentPane = new JPanel(new BorderLayout());
        contentPane.setOpaque(true);

        //Create a scrolled text area.
        JTextArea output;
        JScrollPane scrollPane;
        
        output = new JTextArea(5, 30);
        output.setEditable(true);
        scrollPane = new JScrollPane(output);

        //Add the text area to the content pane.
        contentPane.add(scrollPane, BorderLayout.CENTER);

        return contentPane;
    }

    public void Run() {

        //Set the look and feel.
        initLookAndFeel();

        //Make sure we have nice window decorations.
        JFrame.setDefaultLookAndFeelDecorated(true);
        
        final JFrame f = new JFrame("Sample app");  // creating instance of JFrame
        f.setSize(400, 500);                        // 400 width, 500 height
        f.setLayout(new BorderLayout());            // using BorderLayout
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        f.setJMenuBar(this.createMenuBar());

        // Add some content

        JLabel yellowLabel = new JLabel();
        yellowLabel.setOpaque(true);
        yellowLabel.setBackground(new Color(248, 213, 131));
        yellowLabel.setPreferredSize(new Dimension(200, 180));
        f.getContentPane().add(createContentPane(), BorderLayout.CENTER);


        
        JLabel statusLabel = new JLabel();
        statusLabel.setOpaque(true);
        statusLabel.setBackground(new Color(100, 213, 131));
        statusLabel.setText("gummy");
        yellowLabel.setPreferredSize(new Dimension(200, 180));
        f.getContentPane().add(statusLabel, BorderLayout.SOUTH);


        // final JButton b = new JButton("click");// creating instance of JButton
        // b.setBounds(130, 100, 100, 40);// x axis, y axis, width, height
        // b.addActionListener(this);

        // f.add(b);// adding button in JFrame

        
        

        // JPanel statusBar = new JPanel(new FlowLayout(FlowLayout.LEFT));
        // statusBar.setBorder(new CompoundBorder(new LineBorder(Color.DARK_GRAY), new EmptyBorder(4, 4, 4, 4)));
        // final JLabel status = new JLabel();
        // status.setText("Gummy");
        // statusBar.add(status);
        // f.add(statusBar, BorderLayout.SOUTH);

        // JPanel statusPanel = new JPanel();
        // statusPanel.setBorder(new BevelBorder(BevelBorder.LOWERED));
        // f.add(statusPanel, BorderLayout.SOUTH);
        // statusPanel.setPreferredSize(new Dimension(f.getWidth(), 16));
        // statusPanel.setLayout(new BoxLayout(statusPanel, BoxLayout.X_AXIS));
        // JLabel statusLabel = new JLabel("status");
        // statusLabel.setHorizontalAlignment(SwingConstants.LEFT);
        // statusPanel.add(statusLabel);

        // f.setContentPane(createContentPane());
        // // f.getContentPane().add(statusPanel);
        

        
        f.pack();
        f.setVisible(true);// making the frame visible

        // JFrame frame = new JFrame("JFrame Example");
        // JPanel panel = new JPanel();
        // //panel.setLayout(new FlowLayout());
        // JLabel label = new JLabel("JFrame By Example");
        // JButton button = new JButton();
        // button.setText("Button");
        // panel.add(label);
        // panel.add(button);
        // frame.add(panel);
        // frame.setSize(200, 300);
        // frame.setLocationRelativeTo(null);
        // frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // frame.setVisible(true);
    }

    private void initLookAndFeel() {
        final String lookAndFeel = UIManager.getCrossPlatformLookAndFeelClassName();

        try {
            UIManager.setLookAndFeel(lookAndFeel);

            MetalLookAndFeel.setCurrentTheme(new OceanTheme());

            
        }             
        catch (ClassNotFoundException e) {
            //StringBuilder sb = new StringBuilder();
            
            System.err.println("Couldn't find class for specified look and feel:" + lookAndFeel);
            System.err.println("Did you include the L&F library in the class path?");
            System.err.println("Using the default look and feel.");
        } 
        catch (UnsupportedLookAndFeelException e) {
            System.err.println("Can't use the specified look and feel ("+ lookAndFeel + ") on this platform.");
            System.err.println("Using the default look and feel.");
        } 
        
        catch (Exception e) {
            System.err.println("Couldn't get specified look and feel (" + lookAndFeel + "), for some reason.");
            System.err.println("Using the default look and feel.");
            e.printStackTrace();
        }
    }

    public void actionPerformed(final ActionEvent e) {
        //numClicks++;
        //text.setText("Button Clicked " + numClicks + " times");
        System.out.println("OK, action performed.");

        System.exit(0);
    }

}