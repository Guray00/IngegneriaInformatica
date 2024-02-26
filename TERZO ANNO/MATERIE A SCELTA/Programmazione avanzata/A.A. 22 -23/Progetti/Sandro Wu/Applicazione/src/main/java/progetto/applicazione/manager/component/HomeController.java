/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/javafx/FXMLController.java to edit this template
 */
package progetto.applicazione.manager.component;

import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * FXML Controller class
 *
 * @author sandro
 */
public class HomeController implements Refreshable {
	private static final Logger log = LogManager.getLogger();

	public void initialize() throws IOException {
		log.info("init home");
	}

	@Override
	public void refresh() {

	}

}
