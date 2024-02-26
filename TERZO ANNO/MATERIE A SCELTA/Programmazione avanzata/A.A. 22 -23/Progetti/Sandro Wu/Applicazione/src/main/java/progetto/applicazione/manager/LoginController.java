/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager;

import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.text.Text;
import progetto.applicazione.App;
import progetto.applicazione.InitDB;
import progetto.applicazione.exception.InitDBException;
import progetto.applicazione.exception.UnauthorizedException;
import progetto.applicazione.http.LoginResponse;
import progetto.applicazione.http.Request;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class LoginController {
	private static Logger log = LogManager.getLogger();

	@FXML
	private Button loginButton, initDBButton;

	@FXML
	private Pane formPane;

	@FXML
	private StackPane loadingPane;

	@FXML
	private Text loadingText;

	@FXML
	private TextField username;

	@FXML
	private PasswordField password;

	/**
	 * Initializes the controller class.
	 */
	public void initialize() {
		loadingPane.setVisible(false);
	}

	@FXML
	private void authenticate() {

		// try {
		// App.setRoot(Pages.Manager.getFXML());
		// return;
		// } catch (IOException e1) {
		// if (true)
		// return;
		// }

		loadingText.setText("Authenticating...");
		loadingPane.setVisible(true);
		formPane.setDisable(true);

		Task<Void> authTask = authTask();
		new Thread(authTask).start();
	}

	@FXML
	private void initializeDB() {
		loadingText.setText("Initializing the db...");
		loadingPane.setVisible(true);
		formPane.setDisable(true);

		Task<Void> initDBTask = initDBTask();
		new Thread(initDBTask).start();

	}

	private Task<Void> authTask() {
		Task<Void> task = new TaskWithAlert(log) {

			@Override
			public Void call() throws Exception {

				try {

					JsonObject json = new JsonObject();
					json.addProperty("user", username.getText());
					json.addProperty("pass", password.getText());

					String respJson = Request.post("/user/login", json.toString());

					JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
					boolean logged = response.get("result").getAsBoolean();

					if (logged) {
						LoginResponse resp = new Gson().fromJson(respJson, LoginResponse.class);
						UserSession.setInstance(username.getText(), resp.getToken(), resp.getExpiration());
						App.setRoot(Pages.Manager.getFXML());
					} else {
						throw new Exception("Wrong credentials");
					}

				} catch (UnauthorizedException e) {
					throw new Exception("Wrong credentials");

				} catch (IOException e) {
					// connection failed
					log.error(e);
					throw new Exception("Connection to server failed");
				} finally {
					formPane.setDisable(false);
					loadingPane.setVisible(false);
				}

				return null;
			}
		};

		return task;
	}

	private Task<Void> initDBTask() {
		Task<Void> task = new TaskWithAlert(log) {
			@Override
			public Void call() throws Exception {

				try {
					initDBButton.setDisable(true);
					InitDB.initialize();
				} catch (InitDBException e) {
					initDBButton.setDisable(false);
					log.error("Failed initialize DB: " + e);
					throw new Exception("Failed initialize DB " + e);
				} finally {
					formPane.setDisable(false);
					loadingPane.setVisible(false);
				}

				return null;
			}
		};

		task.setOnSucceeded(e -> {
			log.info("[Success] DB created and populated");

			Alert a = new Alert(AlertType.INFORMATION);
			a.setContentText("DB created and populated");
			a.showAndWait();
		});

		return task;

	}
}
