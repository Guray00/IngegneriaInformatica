/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager.component;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

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
import javafx.scene.chart.PieChart;
import javafx.scene.chart.PieChart.Data;
import javafx.scene.control.DatePicker;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TitledPane;
import javafx.scene.control.cell.PropertyValueFactory;
import progetto.applicazione.http.Request;
import progetto.applicazione.manager.TaskWithAlert;
import progetto.applicazione.manager.UserSession;
import progetto.applicazione.manager.beans.CostlogView;

/**
 * FXML Controller class
 *
 * @author sandro
 */

public class CostcenterController implements Refreshable {

	private static Logger log = LogManager.getLogger();
	ObservableList<CostlogView> tableList = FXCollections.observableArrayList();
	ObservableList<CostlogView> tableShownList = FXCollections.observableArrayList();
	ObservableList<PieChart.Data> pieDataList = FXCollections.observableArrayList();

	private static final String Placeholder_NoRange = "No range selected";
	private static final String Placeholder_NoData = "No cost invoiced in selected range";

	@FXML
	private TableView<CostlogView> mainTable;

	@FXML
	private PieChart pieChart;

	@FXML
	private TitledPane chartPanel, tablePanel;

	@FXML
	private DatePicker startDate, endDate;

	public void initialize() throws IOException {
		pieChart.setStartAngle(180);
		pieChart.setData(pieDataList);
		pieDataList.add(new Data(Placeholder_NoRange, 1));

		startDate.setValue(LocalDate.now().minusMonths(2));
		endDate.setValue(LocalDate.now());

		setTable();

		Task<Void> initTableTask = initTableTask();
		Thread t = new Thread(initTableTask);
		t.start();
	}

	@Override
	public void refresh() {
		Task<Void> initTableTask = initTableTask();
		new Thread(initTableTask).start();
	}

	@FXML
	private void clearRange() {
		startDate.setValue(null);
		endDate.setValue(null);

		pieDataList.clear();
		pieDataList.setAll(new Data(Placeholder_NoRange, 1));

		tableShownList.clear();
		// tableShownList.addAll(tableList);
	}

	@FXML
	private void getRangeData() {
		if (startDate.getValue() == null || endDate.getValue() == null) {
			return;
		}
		Task<Void> task = new TaskWithAlert(log) {

			@Override
			protected Void call() throws Exception {
				Task<Void> initTableTask = initTableTask();
				Thread request = new Thread(initTableTask);

				request.start();
				request.join();
				calculatePieChart();

				return null;
			}

		};
		new Thread(task).start();
	}

	private void calculatePieChart() {
		Platform.runLater(new Runnable() {
			@Override
			public void run() {
				ObservableList<Data> data = getPieData(startDate.getValue(), endDate.getValue());

				pieDataList.clear();
				pieDataList.addAll(data);

				if (data.size() == 0) {
					pieDataList.setAll(new Data(Placeholder_NoData, 1));
				}

				List<CostlogView> range = filterCostRange(startDate.getValue(), endDate.getValue());
				tableShownList.clear();
				tableShownList.addAll(range);

			}
		});
	}

	private void setTable() {
		mainTable.getColumns().clear();

		ArrayList<TableColumn<CostlogView, ?>> colList = new ArrayList<>(List.of(
				createColumn("ID", "id", 60.0),
				createColumn("ResourceID", "resource_id", 80.0),
				createColumn("Resource", "resource_name", 150.0),
				createColumn("Start Date", "start_date", 250.0),
				createColumn("End Date", "end_date", 250.0),
				createColumn("Cost", "cost", 150.0)));

		mainTable.getColumns().addAll(colList);
		mainTable.setItems(tableShownList);
	}

	private TableColumn<CostlogView, ?> createColumn(String colName, String fieldName, Double width) {

		TableColumn<CostlogView, ?> col = new TableColumn<>(colName);
		col.setCellValueFactory(new PropertyValueFactory<>(fieldName));
		col.setPrefWidth(width);
		return col;
	}

	private Task<Void> initTableTask() {
		Task<Void> task = new TaskWithAlert(log) {

			@Override
			public Void call() throws Exception {

				tableList.clear();
				tableShownList.clear();

				if (startDate.getValue() == null || endDate.getValue() == null) {
					return null;
				}

				long start = convertDate(startDate.getValue()).getTime();
				long end = convertDate(endDate.getValue()).getTime();

				String path = "/user/costs?startTime=" + start + "&endTime=" + end;

				String respJson = Request.get(path, UserSession.getInstanceToken());
				/*
				 * { "result" : boolean, "data" : CostlogView[] | "error" : string }
				 */

				JsonObject response = JsonParser.parseString(respJson).getAsJsonObject();
				boolean gotData = response.get("result").getAsBoolean();

				if (gotData) {
					JsonElement data = response.get("data");
					CostlogView[] list = new Gson().fromJson(data, CostlogView[].class);

					tableList.addAll(list);
					tableShownList.addAll(list);
				} else {
					throw new Exception("Server gave error response: " + response.get("error").getAsString());
				}

				return null;
			}
		};

		return task;
	}

	private Date convertDate(LocalDate local) {
		return Date.from(local.atStartOfDay(ZoneId.systemDefault()).toInstant());
	}

	// Overload
	private ObservableList<Data> getPieData(LocalDate local_start, LocalDate local_end) {

		Date start = convertDate(local_start);
		Date end = convertDate(local_end);

		return getPieData(start, end);
	}

	// Overload
	private List<CostlogView> filterCostRange(LocalDate local_start, LocalDate local_end) {
		Date start = convertDate(local_start);
		Date end = convertDate(local_end);

		return filterCostRange(start, end);
	}

	private List<CostlogView> filterCostRange(Date start, Date end) {
		List<CostlogView> range = tableList.stream().filter(costlog -> {
			return start.compareTo(costlog.getStart_date()) <= 0
					&& end.compareTo(costlog.getEnd_date()) >= 0;
		}).collect(Collectors.toList());

		return range;
	}

	private ObservableList<Data> getPieData(Date start, Date end) {

		HashMap<Integer, Double> list_resourceid_cost = new HashMap<>();
		HashMap<Integer, String> list_resourceid_name = new HashMap<>();

		List<CostlogView> range = filterCostRange(start, end);

		range.forEach(costlog -> {
			Integer id = costlog.getResource_id();
			Double sum_cost = list_resourceid_cost.get(id);

			list_resourceid_cost.put(id, costlog.getCost() + (sum_cost == null ? 0 : sum_cost));
			list_resourceid_name.put(id, costlog.getResource_name());
		});

		ObservableList<PieChart.Data> pieData = FXCollections.observableArrayList();

		list_resourceid_cost.forEach((id, cost) -> {
			pieData.add(new PieChart.Data(
					String.format("(%s) %s - $%.2f ",
							id, list_resourceid_name.get(id), cost.doubleValue()),
					cost.doubleValue()));
		});

		return pieData;
	}
}
