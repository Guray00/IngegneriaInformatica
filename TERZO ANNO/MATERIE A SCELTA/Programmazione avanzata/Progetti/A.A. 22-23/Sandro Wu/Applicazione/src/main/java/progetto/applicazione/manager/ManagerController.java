/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager;

import java.io.IOException;
import java.util.Date;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javafx.fxml.FXML;
import javafx.scene.Node;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.layout.BorderPane;
import progetto.applicazione.App;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class ManagerController {
	private static final Logger log = LogManager.getLogger();

	@FXML
	private BorderPane mainBody;

	@FXML
	private BorderPane windowBody;

	public void initialize() throws IOException {
		Pages.Manager.setController(this);
		setBody(Pages.Component.Home.getNode());
	}

	public void setBody(Node body) {
		mainBody.setCenter(body);
	}

	public static boolean checkSession() {
		UserSession user = UserSession.getInstance();
		if (user == null || user.getToken() == null || new Date().after(user.getExpiration())) {
			return false;
		}
		return true;
	}

	public static void logout() {
		UserSession.setInstance(null, null, null);
		try {
			App.setRoot(Pages.Login.getFXML());
		} catch (IOException e) {
			throw new RuntimeException("Could not return to login page");
		}
	}

	public static void alertTokenExpired() {
		log.warn("token expired");

		Alert a = new Alert(AlertType.WARNING);
		a.setContentText("It seems the session is expired, please retry to login");
		a.showAndWait();
	}
}
