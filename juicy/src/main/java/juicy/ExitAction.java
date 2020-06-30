package juicy;

import javax.swing.AbstractAction;
import java.awt.event.ActionEvent;

public class ExitAction extends AbstractAction {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    public ExitAction() {
    }
    public void actionPerformed(ActionEvent e) {
        javax.swing.JOptionPane.showMessageDialog(null, "ExitAction - actionPerformed");
        System.exit(0);
    }
}