package progetto.applicazione;

import java.io.IOException;
import java.util.Locale;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;
    private static String root;

    public static String getRoot() {
        return root;
    }

    @Override
    public void start(Stage stage) throws IOException {
        root = "manager/login";
        // root = "manager/manager";

        Locale.setDefault(new Locale("en"));

        scene = new Scene(loadFXML(root));
        stage.setScene(scene);
        stage.setResizable(false);
        stage.setTitle("Cloud Services Manager");
        stage.show();
    }

    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
        root = fxml;
    }

    private static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
        return fxmlLoader.load();
    }

    public static void main(String[] args) {
        launch();
    }

}