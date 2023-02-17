/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager.component;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ButtonBar.ButtonData;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.Dialog;
import javafx.scene.control.Label;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.GridPane;
import progetto.applicazione.exception.HttpException;
import progetto.applicazione.exception.UnauthorizedException;
import progetto.applicazione.http.Request;
import progetto.applicazione.manager.TaskWithAlert;
import progetto.applicazione.manager.UserSession;
import progetto.applicazione.manager.beans.PlanView;
import progetto.applicazione.manager.beans.ServiceView;
import progetto.applicazione.manager.beans.SubscriptionView;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class AllservicesController implements Refreshable {

	private static Logger log = LogManager.getLogger();
	ObservableList<ServiceView> ol = FXCollections.observableArrayList();

	@FXML
	private ContextMenu resourceContextMenu;

	@FXML
	private TableView<ServiceView> mainTable;

	@FXML
	private GridPane dialogForm;

	@FXML
	private ChoiceBox<SubscriptionView> subscriptionChoiceBox;

	@FXML
	private ChoiceBox<PlanView> planChoiceBox;

	@FXML
	private Label selectedServiceLabel;

	@FXML
	private TextField resourceNameInput;

	public void initialize() throws IOException {

		setTable();
		setContextMenu();

		TaskWithAlert initTableTask = initTableTask();
		new Thread(initTableTask).start();

	}

	@Override
	public void refresh() {
		Task<Void> initTableTask = initTableTask();
		new Thread(initTableTask).start();
	}

	private void setContextMenu() {
		ObservableList<MenuItem> items = resourceContextMenu.getItems();
		items.clear();

		MenuItem create = new MenuItem("create");
		items.addAll(create);

		create.setOnAction(e -> {
			Platform.runLater(new Runnable() {
				@Override
				public void run() {

					Dialog<CreateResourceBody> d = createResourceDialog();
					while (true) {
						Optional<CreateResourceBody> response = d.showAndWait();
						if (response.isPresent()) {
							if (response.get().hasAllFields()) {
								createResource(response.get());
								break;
							} else {
								Alert a = new Alert(AlertType.WARNING);
								a.setContentText("Not all fields are filled");
								a.showAndWait();
							}
						} else {
							break;
						}
					}
				}
			});
			// task.setOnSucceeded(ev -> {
			// mainTable.setDisable(false);
			// });
			// mainTable.setDisable(true);
			// new Thread(task).start();
		});
	}

	private void setTable() {
		mainTable.getColumns().clear();

		ArrayList<TableColumn<ServiceView, ?>> colList = new ArrayList<>(List.of(
				createColumn("ID", "id", 60.0),
				createColumn("Name", "name", 300.0),
				createColumn("Category", "category", 200.0)));

		mainTable.getColumns().addAll(colList);
		mainTable.setItems(ol);
	}

	private TableColumn<ServiceView, ?> createColumn(String colName, String fieldName, Double width) {
		TableColumn<ServiceView, ?> col = new TableColumn<>(colName);
		col.setCellValueFactory(new PropertyValueFactory<>(fieldName));
		col.setPrefWidth(width);
		return col;
	}

	private TaskWithAlert initTableTask() {
		TaskWithAlert task = new TaskWithAlert(log) {

			@Override
			public Void call() throws Exception {

				ol.clear();

				String respJson = Request.get("/service/all", UserSession.getInstanceToken());
				/*
				 * { "result" : boolean, "data" : ServiceView[] | "error" : string }
				 */

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean gotData = response.get("result").getAsBoolean();

				if (gotData) {
					JsonElement data = response.get("data");
					ServiceView[] ll = new Gson().fromJson(data, ServiceView[].class);

					ol.addAll(ll);
				} else {
					throw new Exception("Could not retrieve data from server");
				}

				return null;
			}
		};

		return task;
	}

	private Dialog<CreateResourceBody> createResourceDialog() {
		Dialog<CreateResourceBody> dialog = new Dialog<>();
		dialog.setTitle("New Service");
		dialog.setHeaderText("Create a new resource");

		ButtonType okButton = new ButtonType("Create", ButtonData.OK_DONE);
		dialog.getDialogPane().getButtonTypes().addAll(
				okButton,
				ButtonType.CANCEL);

		dialog.getDialogPane().setContent(dialogForm);

		ServiceView service = mainTable.getSelectionModel().getSelectedItem();
		selectedServiceLabel.setText(service.toString());
		resourceNameInput.setText("");
		subscriptionChoiceBox.getItems().clear();
		planChoiceBox.getItems().clear();

		setUserSubscriptions();
		setServicePlans(service.getId());

		dialog.setResultConverter(dialogButton -> {
			if (dialogButton == okButton) {
				CreateResourceBody body = new CreateResourceBody(
						resourceNameInput.getText(),
						service.getId(),
						subscriptionChoiceBox.getSelectionModel().getSelectedItem().getId(),
						planChoiceBox.getSelectionModel().getSelectedItem().getName());

				return body;
			}
			return null;
		});

		return dialog;
	}

	private void setUserSubscriptions() {
		subscriptionChoiceBox.setDisable(true);
		subscriptionChoiceBox.getItems().clear();

		Task<Void> task = new TaskWithAlert(log) {

			@Override
			public Void call() throws HttpException, UnauthorizedException {
				try {
					String path = "/subscription/user";
					String respJson = Request.get(path, UserSession.getInstanceToken());

					JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
					boolean result = response.get("result").getAsBoolean();

					if (result) {
						JsonElement data = response.get("data");
						SubscriptionView[] list = new Gson().fromJson(data, SubscriptionView[].class);
						subscriptionChoiceBox.getItems().setAll(list);
					}

				} catch (HttpException e) {
					throw e;
				}
				return null;
			}
		};

		task.setOnSucceeded(e -> {
			subscriptionChoiceBox.setDisable(false);
			subscriptionChoiceBox.getSelectionModel().select(0);
		});

		subscriptionChoiceBox.getItems().add(null);
		new Thread(task).start();
	}

	private void setServicePlans(int service_id) {
		planChoiceBox.setDisable(true);
		planChoiceBox.getItems().clear();

		Task<Void> task = new TaskWithAlert(log) {

			@Override
			public Void call() throws HttpException, UnauthorizedException {
				try {
					String path = "/service/plans" + "?id=" + service_id;
					String respJson = Request.get(path, UserSession.getInstanceToken());

					JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
					boolean result = response.get("result").getAsBoolean();

					if (result) {
						JsonElement data = response.get("data");
						PlanView[] list = new Gson().fromJson(data, PlanView[].class);
						planChoiceBox.getItems().setAll(list);
					}

				} catch (HttpException e) {
					throw e;
				}
				return null;
			}
		};

		task.setOnSucceeded(e -> {
			planChoiceBox.setDisable(false);
			planChoiceBox.getSelectionModel().select(0);
		});

		planChoiceBox.getItems().add(null);
		new Thread(task).start();
	}

	private void createResource(CreateResourceBody body) {
		ServiceView service = mainTable.getSelectionModel().getSelectedItem();
		log.info("activating " + service.getName());

		Task<Void> task = new TaskWithAlert(log) {
			@Override
			public Void call() throws Exception {

				String path = "/resource/create";
				String respJson = Request.post(path, new Gson().toJson(body), UserSession.getInstanceToken());

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean result = response.get("result").getAsBoolean();

				if (!result) {
					throw new Exception("Failed creating resource");
				}

				return null;
			}
		};

		task.setOnSucceeded(event -> {
			log.info("Resource created");

			Alert a = new Alert(AlertType.INFORMATION);
			a.setContentText("New service created successfully");
			a.showAndWait();
		});

		new Thread(task).start();
	}

}

class CreateResourceBody {
	String name;
	Integer service_id;
	Integer subscription_id;
	String plan;

	public CreateResourceBody(String name, Integer service_id, Integer subscription_id, String plan) {
		this.name = name;
		this.service_id = service_id;
		this.subscription_id = subscription_id;
		this.plan = plan;
	}

	public boolean hasAllFields() {
		return name != null
				&& !name.trim().equals("")
				&& service_id != null
				&& subscription_id != null
				&& plan != null;
	}

}