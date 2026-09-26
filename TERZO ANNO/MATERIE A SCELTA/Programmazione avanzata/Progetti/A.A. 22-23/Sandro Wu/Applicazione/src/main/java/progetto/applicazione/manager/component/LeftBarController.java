/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.applicazione.manager.component;

import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.Node;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.StackPane;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import progetto.applicazione.manager.ManagerController;
import progetto.applicazione.manager.Pages;

/**
 *
 * @author sandro
 */
public class LeftBarController {
    private static final Logger log = LogManager.getLogger();
    private static final String closedCssClass = "closed";

    @FXML
    protected StackPane linkCostcenter,
            linkAllservices,
            linkInvoices,
            linkActivitylog,
            linkSubscription,
            linkServices;

    @FXML
    protected BorderPane sidebar;

    @FXML
    protected StackPane toogleSideBar;

    @FXML
    public void initialize() {
        setLinks();
    }

    @FXML
    void toogleSideBar() {
        if (sidebar == null) {
            log.error("No sidebar component found");
            return;
        }

        ObservableList<String> classList = sidebar.getStyleClass();
        boolean wasClosed = classList.removeAll(closedCssClass);
        if (!wasClosed) {
            classList.add(closedCssClass);
        }
    }

    private void closeSideBar() {
        ObservableList<String> classList = sidebar.getStyleClass();
        classList.removeAll(closedCssClass);
        classList.add(closedCssClass);
    }

    private void setLinks() {

        linkInvoices.setManaged(false);
        linkInvoices.setVisible(false);
        linkInvoices.setDisable(true);

        linkCostcenter.setOnMouseClicked(e -> redirect(Pages.Component.CostCenter));
        linkAllservices.setOnMouseClicked(e -> redirect(Pages.Component.AllServices));
        linkInvoices.setOnMouseClicked(e -> redirect(Pages.Component.Invoices));
        linkActivitylog.setOnMouseClicked(e -> redirect(Pages.Component.ActivityLog));
        linkSubscription.setOnMouseClicked(e -> redirect(Pages.Component.Subscription));
        linkServices.setOnMouseClicked(e -> redirect(Pages.Component.Services));
    }

    private void redirect(Pages.Component component) {
        closeSideBar();
        redirect(component.getNode());
    }

    private void redirect(Node node) {
        ((ManagerController) Pages.Manager.getController()).setBody(node);
    }

}
