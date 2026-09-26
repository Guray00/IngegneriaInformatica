package progetto.applicazione.manager;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javafx.concurrent.Task;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import progetto.applicazione.exception.UnauthorizedException;

public abstract class TaskWithAlert extends Task<Void> {

    private static Logger log = LogManager.getLogger();
    private Logger externalLog = null;

    protected Logger getLogger() {
        return externalLog == null ? log : externalLog;
    }

    public TaskWithAlert(Logger logger) {
        this();
        externalLog = logger;
    }

    public TaskWithAlert() {
        setOnFailed(event -> {
            Logger log = getLogger();

            Throwable ex = this.getException();
            log.warn(ex);

            if (ex instanceof UnauthorizedException) {
                ManagerController.alertTokenExpired();
                ManagerController.logout();
            } else {
                Alert a = new Alert(AlertType.ERROR);
                a.setContentText(ex.getMessage());
                a.showAndWait();
            }
        });
    }

}
