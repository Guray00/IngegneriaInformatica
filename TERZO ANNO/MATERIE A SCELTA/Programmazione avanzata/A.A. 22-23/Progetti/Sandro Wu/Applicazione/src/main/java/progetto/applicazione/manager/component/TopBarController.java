/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.applicazione.manager.component;

import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.layout.StackPane;
import javafx.scene.text.Text;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import progetto.applicazione.manager.ManagerController;
import progetto.applicazione.manager.UserSession;

/**
 *
 * @author sandro
 */
public class TopBarController {
    private static final Logger log = LogManager.getLogger();

    @FXML
    protected StackPane topbar;

    @FXML
    protected Text usernameText;

    @FXML
    public void initialize() {
        // TO REMOVE
        // UserSession.setInstance("test", "pass", new Date(0));

        usernameText.setText("unknown");

        if (ManagerController.checkSession()) {
            UserSession user = UserSession.getInstance();
            String username = user.getUsername();
            usernameText.setText(username);
        } else {
            log.warn("Session not valid");
            ManagerController.alertTokenExpired();
            ManagerController.logout();
        }

        // UserSession.setInstance("test", "invalidtoken", new Date(0));
    }

    @FXML
    void logoutAction() {

        Alert a = new Alert(AlertType.CONFIRMATION);
        a.setContentText("Are you sure to logout from this account?");
        a.showAndWait();

        if (a.getResult() == ButtonType.OK) {
            ManagerController.logout();
        }
    }

}
