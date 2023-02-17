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
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.concurrent.Task;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.cell.PropertyValueFactory;
import progetto.applicazione.exception.HttpException;
import progetto.applicazione.exception.UnauthorizedException;
import progetto.applicazione.http.Request;
import progetto.applicazione.manager.TaskWithAlert;
import progetto.applicazione.manager.UserSession;
import progetto.applicazione.manager.beans.ResourceView;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class ServicesController implements Refreshable {

	private static Logger log = LogManager.getLogger();
	ObservableList<ResourceView> ol = FXCollections.observableArrayList();

	@FXML
	private ContextMenu resourceContextMenu;

	@FXML
	private TableView<ResourceView> mainTable;

	public void initialize() throws IOException {
		setTable();
		setContextMenu();

		Task<Void> initTableTask = initTableTask();
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

		MenuItem activate = new MenuItem("activate");
		MenuItem stop = new MenuItem("stop");
		MenuItem delete = new MenuItem("delete");

		items.addAll(activate, stop, delete);

		activate.setOnAction(e -> activateResource());
		stop.setOnAction(e -> stopResource());
		delete.setOnAction(e -> deleteResource());
	}

	private void deleteResource() {
		ResourceView resource = mainTable.getSelectionModel().getSelectedItem();
		log.info("deleting " + resource.getName());

		Alert a = new Alert(AlertType.CONFIRMATION);
		a.setContentText("Are you sure to delete this resource?");
		Optional<ButtonType> resp = a.showAndWait();
		if (resp.get() == ButtonType.CANCEL) {
			return;
		}

		Task<Void> task = new TaskWithAlert() {
			@Override
			public Void call() throws HttpException, UnauthorizedException {
				String path = "/resource" + "?id=" + resource.getId();
				String respJson = Request.delete(path, UserSession.getInstanceToken());

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean result = response.get("result").getAsBoolean();

				if (result) {
					ol.remove(resource);
				}

				return null;
			}
		};

		new Thread(task).start();
	}

	private void stopResource() {
		ResourceView resource = mainTable.getSelectionModel().getSelectedItem();
		log.info("stopping " + resource.getName());

		Task<Void> task = new TaskWithAlert() {
			@Override
			public Void call() throws HttpException, UnauthorizedException {
				String path = "/resource/stop" + "?id=" + resource.getId();
				String respJson = Request.post(path, "", UserSession.getInstanceToken());

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean result = response.get("result").getAsBoolean();

				if (result) {
					resource.setStatus(response.get("status").getAsString());
					// ol.remove(resource);
					// ol.add(resource);
					ol.set(ol.indexOf(resource), resource);
				}

				return null;
			}
		};

		new Thread(task).start();
	}

	private void activateResource() {
		ResourceView resource = mainTable.getSelectionModel().getSelectedItem();
		log.info("activating " + resource.getName());

		Task<Void> task = new TaskWithAlert() {
			@Override
			public Void call() throws HttpException, UnauthorizedException {
				String path = "/resource/activate" + "?id=" + resource.getId();
				String respJson = Request.post(path, "", UserSession.getInstanceToken());

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean result = response.get("result").getAsBoolean();

				if (result) {
					resource.setStatus(response.get("status").getAsString());
					ol.set(ol.indexOf(resource), resource);
				}

				return null;
			}
		};

		new Thread(task).start();
	}

	private void setTable() {
		mainTable.getColumns().clear();

		ArrayList<TableColumn<ResourceView, ?>> colList = new ArrayList<>(List.of(
				createColumn("ID", "id", 60.0),
				createColumn("Name", "name", 150.0),
				createColumn("Service", "service", 150.0),
				createColumn("Category", "category", 150.0),
				createColumn("Subscription", "subscription", 150.0),
				createColumn("Plan", "plan", 150.0),
				createColumn("Status", "status", 150.0)));

		mainTable.getColumns().addAll(colList);
		mainTable.setItems(ol);
	}

	private TableColumn<ResourceView, ?> createColumn(String colName, String fieldName, Double width) {

		TableColumn<ResourceView, ?> col = new TableColumn<>(colName);
		col.setCellValueFactory(new PropertyValueFactory<>(fieldName));
		col.setPrefWidth(width);
		return col;
	}

	private Task<Void> initTableTask() {
		Task<Void> task = new TaskWithAlert(log) {

			@Override
			public Void call() throws Exception {

				ol.clear();

				String respJson = Request.get("/resource/user", UserSession.getInstanceToken());
				/*
				 * { "result" : boolean, "data" : ResourceView[] | "error" : string }
				 */

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean gotData = response.get("result").getAsBoolean();

				if (gotData) {
					JsonElement data = response.get("data");
					ResourceView[] list = new Gson().fromJson(data, ResourceView[].class);

					ol.addAll(list);
				} else {
					throw new Exception("Server gave error response");
				}

				return null;
			}
		};

		return task;

	}
}
