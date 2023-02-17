/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager.component;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import progetto.applicazione.http.Request;
import progetto.applicazione.manager.TaskWithAlert;
import progetto.applicazione.manager.UserSession;
import progetto.applicazione.manager.beans.ActivityView;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class ActivitylogController implements Refreshable {
	private static Logger log = LogManager.getLogger();
	ObservableList<ActivityView> ol = FXCollections.observableArrayList();

	@FXML
	private TableView<ActivityView> mainTable;

	public void initialize() throws IOException {

		// mainTable.setVisible(false);

		setTable();

		Task<Void> initTableTask = initTableTask();
		new Thread(initTableTask).start();
	}

	@Override
	public void refresh() {
		Task<Void> initTableTask = initTableTask();
		new Thread(initTableTask).start();
	}

	private void setTable() {
		mainTable.getColumns().clear();

		ArrayList<TableColumn<ActivityView, ?>> colList = new ArrayList<>(List.of(
				createColumn("ID", "id", 60.0),
				createColumn("Time", "time", 250.0),
				createColumn("Log", "action", 700.0)

		));

		mainTable.getColumns().addAll(colList);
		mainTable.setItems(ol);
	}

	private TableColumn<ActivityView, ?> createColumn(String colName, String fieldName, Double width) {

		TableColumn<ActivityView, ?> col = new TableColumn<>(colName);
		col.setCellValueFactory(new PropertyValueFactory<>(fieldName));
		col.setPrefWidth(width);
		return col;
	}

	private Task<Void> initTableTask() {
		Task<Void> task = new TaskWithAlert(log) {
			@Override
			public Void call() throws Exception {
				ol.clear();

				String respJson = Request.get("/user/activity", UserSession.getInstanceToken());
				/*
				 * { "result" : boolean, "data" : ActivityView[] | "error" : string }
				 */

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean gotData = response.get("result").getAsBoolean();

				if (gotData) {
					JsonElement data = response.get("data");
					ActivityView[] list = new Gson().fromJson(data, ActivityView[].class);

					ol.addAll(list);
				} else {
					throw new Exception("Server gave error response: " + response.get("error").getAsString());
				}

				return null;
			}
		};

		return task;
	}

}
