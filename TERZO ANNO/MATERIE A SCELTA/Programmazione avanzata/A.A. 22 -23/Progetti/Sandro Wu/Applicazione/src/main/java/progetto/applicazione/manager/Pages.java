package progetto.applicazione.manager;

import java.io.IOException;

import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import progetto.applicazione.App;
import progetto.applicazione.manager.component.Refreshable;

public enum Pages {

    Login("manager/login"),
    Manager("manager/manager");

    private final String fxml;
    private Object controller;

    private Pages(String fxml) {
        this.fxml = fxml;
    }

    public String getFXML() {
        return fxml;
    }

    public Object getController() {
        return controller;
    }

    public void setController(Object controller) {
        this.controller = controller;
    }

    public enum Component {
        Home("manager/component/home"),
        Subscription("manager/component/subscription"),
        Services("manager/component/services"),
        ActivityLog("manager/component/activitylog"),
        Invoices("manager/component/"),
        CostCenter("manager/component/costcenter"),
        AllServices("manager/component/allservices");

        private final String fxml;
        private Object controller;
        private Node node;

        private Component(String fxml) {
            this.fxml = fxml;
        }

        public Object getController() {
            return controller;
        }

        public Node getNode() {
            try {
                if (node == null) {
                    FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
                    node = fxmlLoader.load();
                    controller = fxmlLoader.getController();
                } else {
                    new Thread(new TaskWithAlert() {
                        protected Void call() {
                            ((Refreshable) controller).refresh();
                            return null;
                        };
                    }).start();
                }
                return node;
                // return FXMLLoader.load(App.class.getResource(fxml + ".fxml"));
            } catch (IOException e) {
                throw new RuntimeException("No fxml found: " + fxml);
            }
        }
    };

}
